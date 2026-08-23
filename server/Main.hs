-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
-----------------------------------------------------------------------------
module Main where
-----------------------------------------------------------------------------
import qualified Data.ByteString.Lazy.Char8 as BL8
-----------------------------------------------------------------------------
import           Client (app)
-----------------------------------------------------------------------------
import           Miso
import           Miso.Html hiding (title_)
import qualified Miso.Html as H
import           Miso.Html.Property
-----------------------------------------------------------------------------
main :: IO ()
main = do
  BL8.writeFile ("public/" <> "index.html") (toHtml indexHtml)
  putStrLn "Wrote to public/index.html..."
-----------------------------------------------------------------------------
indexHtml :: [View () m a]
indexHtml =
  [ doctype_
  , html_ [ lang_ "en", class_ "dark theme-claude" ]
    [ head_
      []
      [ meta_ [charset_ "utf-8"]
      , meta_
          [ content_ "width=device-width, initial-scale=1"
          , name_ "viewport"
          ]
      , H.title_ [] ["miso-ui"]
      , H.script_
          [ src_ "index.js", type_ "module"
          ] mempty
      , H.script_
          [ src_ "https://cdn.jsdelivr.net/npm/basecoat-css@0.3.6/dist/js/all.min.js"
          ] mempty
      , link_
          [rel_ "stylesheet", href_ "/assets/styles.css"]
      , meta_
          [ content_ "en"
          , textProp "http-equiv" "Content-Language"
          ]
      , meta_
          [ content_
              "A miso component library built on Tailwind, ShadCN and Basecoat CSS"
          , name_ "description"
          ]
      , meta_
          [ content_
              "components,component library,component system,miso, haskell, haskell-miso, UI,UI kit,shadcn,shadcn/ui,Tailwind CSS,Tailwind,CSS,HTML,monads,JS,JavaScript,vanilla JS,vanilla JavaScript"
          , name_ "keywords"
          ]
      , link_
          [ href_ "/assets/favicon.ico"
          , type_ "image/x-icon"
          , rel_ "icon"
          ]
      , link_
          [ href_ "/assets/apple-touch-icon.png"
          , textProp "sizes" "180x180"
          , rel_ "apple-touch-icon"
          ]
      , meta_ [content_ "website", textProp "property" "og:type"]
      , meta_
          [ content_ "https://miso-ui.haskell-miso.org"
          , textProp "property" "og:url"
          ]
      , meta_
          [ content_ "Haskell miso | miso-ui "
          , textProp "property" "og:title"
          ]
      , meta_
          [ content_
              "A miso component library built on Tailwind, ShadCN and Basecoat CSS"
          , textProp "property" "og:description"
          ]
      , meta_
          [ content_
              "https://miso-ui.haskell-miso.org/assets/social-screenshot.png"
          , textProp "property" "og:image"
          ]
      , meta_
          [content_ "miso-ui", textProp "property" "og:sitename"]
      , meta_ [content_ "en_US", textProp "property" "og:locale"]
      , meta_ [content_ "dmjio", textProp "property" "og:author"]
      , meta_
          [ content_ "summary_large_image"
          , name_ "twitter:card"
          ]
      , meta_
          [ content_ "https://miso-ui.haskell-miso.org"
          , name_ "twitter:url"
          ]
      , meta_
          [content_ "miso-ui", name_ "twitter:title"]
      , meta_
          [ content_
              "A collection of all the components available in miso-ui"
          , name_ "twitter:description"
          ]
      , meta_
          [ content_
              "https://miso-ui.haskell-miso.org/assets/social-screenshot.png"
          , name_ "twitter:image"
          ]
      , meta_
          [content_ "@dmjio", name_ "twitter:creator"]
      , script_
          [ src_
              "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/highlight.min.js"
          ]
          mempty
      , link_
          [ href_
              "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/styles/dark.min.css"
          , rel_ "stylesheet"
          ]
      , script_
          [ src_
              "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/languages/haskell.min.js"
          ]
          mempty
      ]
    , script_ []
      """
      (() => {
           try {
             const stored = localStorage.getItem('themeMode');
             if (stored ? stored === 'dark'
                        : matchMedia('(prefers-color-scheme: dark)').matches) {
               document.documentElement.classList.add('dark');
             }
           } catch (_) {}
           const apply = dark => {
             document.documentElement.classList.toggle('dark', dark);
             try { localStorage.setItem('themeMode', dark ? 'dark' : 'light'); } catch (_) {}
           };
           document.addEventListener('basecoat:theme', (event) => {
             const mode = event.detail?.mode;
             apply(mode === 'dark' ? true
                  : mode === 'light' ? false
                  : !document.documentElement.classList.contains('dark'));
           });
      })();
      """
    , style_ [] """
        body {
          overflow-x: hidden;
          max-width: 100%;
        }
      """
     , body_ [] [ mount_ app ]
     , div_ [ class_ "toaster", id_ "toaster" ] []
   ]
 ]
-----------------------------------------------------------------------------
