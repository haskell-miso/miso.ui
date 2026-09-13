-----------------------------------------------------------------------------
-- | Keeps the generated documentation strings in lib/Miso/UI/*.hs in sync
-- with the actual module source, so the kitchen sink can't drift:
--
-- * @fooCodeSample@ — the "Code" tab. Regenerated from the verbatim source
--   of @fooUsage@ (a compact, compiled usage example) when the module
--   defines one, otherwise from @fooSample@ (the full preview source).
--
-- * @fooPropsApi@ — the "Props API" panel. Regenerated from the verbatim
--   source of every @data ...Props@ declaration and @default...Props@
--   smart constructor in the module (including their haddock comments).
--
-- Usage:
--
-- > runghc scripts/sync-samples.hs          # rewrite in place
-- > runghc scripts/sync-samples.hs --check  # exit 1 if any is out of sync
-----------------------------------------------------------------------------
module Main (main) where
-----------------------------------------------------------------------------
import           Control.Monad (forM, unless, when)
import           Data.Char (isAlpha, isAlphaNum, toUpper)
import           Data.List (isPrefixOf, isSuffixOf, intercalate)
import           Data.Maybe (catMaybes, fromMaybe)
import           System.Directory (listDirectory)
import           System.Environment (getArgs)
import           System.Exit (exitFailure)
-----------------------------------------------------------------------------
libDir :: FilePath
libDir = "lib/Miso/UI"
-----------------------------------------------------------------------------
divider :: String
divider = replicate 77 '-'
-----------------------------------------------------------------------------
main :: IO ()
main = do
  args <- getArgs
  let checkOnly = "--check" `elem` args
  files <- listDirectory libDir
  results <- forM [ f | f <- files, ".hs" `isSuffixOf` f ] $ \f -> do
    let path = libDir <> "/" <> f
    src <- readFile path
    length src `seq` pure ()
    case sync (lines src) of
      Nothing -> pure Nothing
      Just synced
        | synced == lines src -> pure Nothing
        | checkOnly -> pure (Just (path, Nothing))
        | otherwise -> pure (Just (path, Just (unlines synced)))
  let stale = catMaybes results
  mapM_ write stale
  if checkOnly
    then do
      mapM_ (\(p, _) -> putStrLn ("OUT OF SYNC: " <> p)) stale
      unless (null stale) exitFailure
      putStrLn "All code samples match their previews."
    else
      when (null stale) (putStrLn "All code samples already in sync.")
  where
    write (path, Just contents) = do
      writeFile path contents
      putStrLn ("Synced: " <> path)
    write (_, Nothing) = pure ()
-----------------------------------------------------------------------------
-- | Regenerates the code sample and props api blocks of one module
sync :: [String] -> Maybe [String]
sync ls = do
  codeName <- findCodeSampleName ls
  let base = take (length codeName - length "CodeSample") codeName
      withCode = fromMaybe ls (syncCodeSample codeName ls)
  pure (updatePropsApi base withCode)
-----------------------------------------------------------------------------
-- | Regenerates @fooCodeSample@ from @fooUsage@ \/ @fooSample@, if present
syncCodeSample :: String -> [String] -> Maybe [String]
syncCodeSample codeName ls = do
  sampleName <- findSourceName ls
  let block = generated sampleName codeName ls
  pure (replaceBlock codeName block ls)
-----------------------------------------------------------------------------
-- | The definition the code sample is generated from: a compact @fooUsage@
-- if the module defines one, otherwise the full @fooSample@
findSourceName :: [String] -> Maybe String
findSourceName ls =
  case (defsWithSuffix "Usage", defsWithSuffix "Sample") of
    (w : _, _) -> Just w
    ([], w : _) -> Just w
    _ -> Nothing
  where
    defsWithSuffix suffix =
      [ w
      | l <- ls
      , let w = takeWhile isIdent l
      , w == takeWhile (/= ' ') l
      , suffix `isSuffixOf` w
      , not ("CodeSample" `isSuffixOf` w)
      , isDefOf w l
      ]
-----------------------------------------------------------------------------
-- | First top-level @fooCodeSample@ definition
findCodeSampleName :: [String] -> Maybe String
findCodeSampleName ls =
  case [ w
       | l <- ls
       , let w = takeWhile isIdent l
       , w == takeWhile (/= ' ') l
       , "CodeSample" `isSuffixOf` w
       , isDefOf w l
       ] of
    (w : _) -> Just w
    [] -> Nothing
-----------------------------------------------------------------------------
isIdent :: Char -> Bool
isIdent c = isAlphaNum c || c `elem` "_'"
-----------------------------------------------------------------------------
-- | Line starting the signature or definition of the given name
isDefOf :: String -> String -> Bool
isDefOf name l = l == name || (name <> " ") `isPrefixOf` l
-----------------------------------------------------------------------------
isDivider :: String -> Bool
isDivider l = length l > 10 && all (== '-') l
-----------------------------------------------------------------------------
-- | miso's SSR ('toHtml') renders text nodes without escaping, so text that
-- the HTML parser would treat as a tag ('<' followed by a letter or '/')
-- corrupts the prerendered page and breaks hydration. Refuse to embed it.
ssrSafe :: String -> [String] -> [String]
ssrSafe what ls' =
  case [ l | l <- ls', unsafe l ] of
    [] -> ls'
    (bad : _) -> error $ unlines
      [ "SSR-unsafe text in " <> what <> " (miso toHtml does not escape '<'):"
      , "  " <> bad
      , "Reword it so no '<' is followed by a letter or '/'."
      ]
  where
    unsafe l = or
      [ isTagStart c2
      | ('<', c2) <- zip l (drop 1 l)
      ]
    isTagStart c = c == '/' || isAlpha c
-----------------------------------------------------------------------------
-- | The freshly generated code sample block
generated :: String -> String -> [String] -> [String]
generated sampleName codeName ls = concat
  [ [ codeName <> " :: View context props model action"
    , codeName <> " ="
    , "  \"\"\""
    , indent divider
    , indent ("module My" <> capName <> " (" <> sampleName <> ") where")
    , indent divider
    ]
  , map (indent . escape) (ssrSafe codeName (importBlock ls))
  , [ indent divider ]
  , map (indent . escape) (ssrSafe codeName (defBlock sampleName ls))
  , [ "  \"\"\"" ]
  ]
  where
    capName =
      case stripSuffixes sampleName of
        (c : rest) -> toUpper c : rest
        [] -> ""
    stripSuffixes w
      | "Usage" `isSuffixOf` w = take (length w - length "Usage") w
      | "Sample" `isSuffixOf` w = take (length w - length "Sample") w
      | otherwise = w
-----------------------------------------------------------------------------
indent :: String -> String
indent "" = ""
indent l = "  " <> l
-----------------------------------------------------------------------------
-- | Backslashes must be escaped; lone quotes are fine inside multiline
-- strings, but a literal @\"\"\"@ would terminate the string early
escape :: String -> String
escape [] = []
escape ('"' : '"' : '"' : rest) = "\\\"\\\"\\\"" <> escape rest
escape ('\\' : rest) = "\\\\" <> escape rest
escape (c : rest) = c : escape rest
-----------------------------------------------------------------------------
-- | All import lines of the module, plus an import of the module itself
-- (the sample's definitions live there from a user's point of view).
-- Imports quoted inside sample strings are indented, so only column-0
-- imports match.
importBlock :: [String] -> [String]
importBlock ls =
  [ l | l <- ls, "import " `isPrefixOf` l ] <> selfImport ls
-----------------------------------------------------------------------------
selfImport :: [String] -> [String]
selfImport ls =
  [ "import           " <> name
  | l <- take 1 [ l | l <- ls, "module Miso.UI." `isPrefixOf` l ]
  , let name = takeWhile (/= ' ') (drop (length "module ") l)
  ]
-----------------------------------------------------------------------------
-- | The verbatim source of a definition: signature through the next divider
defBlock :: String -> [String] -> [String]
defBlock name ls =
  takeWhile (not . isDivider)
    (dropWhile (not . isDefOf name) ls)
-----------------------------------------------------------------------------
-- | Replaces an existing block: from its signature up to (excluding) the
-- next column-0 divider line. String contents are always indented, so a
-- column-0 divider reliably terminates the block.
replaceBlock :: String -> [String] -> [String] -> [String]
replaceBlock name block ls = before <> block <> after
  where
    (before, rest) = break (isDefOf name) ls
    after = dropWhile (not . isDivider) (drop 1 rest)
-----------------------------------------------------------------------------
-- | Regenerates (or creates) the @fooPropsApi@ block from the module's
-- @data ...Props@ \/ @default...Props@ sections, and keeps it exported
updatePropsApi :: String -> [String] -> [String]
updatePropsApi base ls
  | null sections = ls
  | any (isDefOf propsName) ls = replaceBlock propsName block ls
  | otherwise = insertExport (appendBlock block ls)
  where
    propsName = base <> "PropsApi"
    sections = propsSections ls
    block = concat
      [ [ propsName <> " :: View context props model action"
        , propsName <> " ="
        , "  \"\"\""
        ]
      , map (indent . escape)
          (ssrSafe propsName (intercalate [divider] sections))
      , [ "  \"\"\"" ]
      ]
    -- export the props api right after the code sample export
    insertExport ls' =
      let codeExport = "  , " <> base <> "CodeSample"
          propsExport = "  , " <> propsName
      in if any ((== propsExport)) ls'
           then ls'
           else concatMap
             (\l -> if l == codeExport then [l, propsExport] else [l]) ls'
    appendBlock b ls' = ls' <> b <> [divider]
-----------------------------------------------------------------------------
-- | Divider-delimited sections declaring props records or their defaults
propsSections :: [String] -> [[String]]
propsSections ls =
  [ chunk
  | chunk <- chunks ls
  , any propsDecl chunk
  ]
  where
    chunks [] = []
    chunks xs =
      case break isDivider xs of
        (chunk, rest) ->
          [ chunk | not (null chunk) ] <> chunks (drop 1 rest)
    -- column-0 declarations only, so generated strings never match
    propsDecl l =
      case words l of
        ("data" : name : _) ->
          "data " `isPrefixOf` l && "Props" `isSuffixOf` name
        (name : _) ->
          "default" `isPrefixOf` name
            && "Props" `isSuffixOf` name
            && isDefOf name l
        _ -> False
-----------------------------------------------------------------------------
