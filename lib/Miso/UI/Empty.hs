-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Empty
  ( -- ** Props
    EmptyProps (..)
  , defaultEmptyProps
    -- ** Views
  , empty_
    -- ** Samples
  , emptySample
  , emptyCodeSample
  , emptyPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
import qualified Miso.Svg           as S
import qualified Miso.Svg.Property  as SP
-----------------------------------------------------------------------------
import           Miso.UI.Button
import           Miso.UI.Icons
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props for 'empty_'. Icon, title and description nest other views.
data EmptyProps context props model action
  = EmptyProps
  { emptyIcon :: Maybe (View context props model action)
    -- ^ Icon shown in the header medallion
  , emptyTitle :: Maybe (View context props model action)
  , emptyDescription :: Maybe (View context props model action)
  , emptyFooter :: [View context props model action]
    -- ^ Content under the actions (e.g. a \"learn more\" link)
  , emptyClasses :: [MisoString]
  , emptyAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: bare empty state
defaultEmptyProps :: EmptyProps context props model action
defaultEmptyProps
  = EmptyProps
  { emptyIcon = Nothing
  , emptyTitle = Nothing
  , emptyDescription = Nothing
  , emptyFooter = []
  , emptyClasses = []
  , emptyAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/empty/ Empty> state, driven by 'EmptyProps'.
-- Children render as the action row.
empty_
  :: EmptyProps context props model action
  -> [View context props model action]
  -> View context props model action
empty_ EmptyProps {..} kids =
  H.div_
    ( P.classes_
      ( [ "flex", "min-w-0", "flex-1", "flex-col", "items-center", "justify-center"
        , "gap-6", "rounded-lg", "border-dashed", "p-6", "text-center", "text-balance"
        , "md:p-12", "text-neutral-800", "dark:text-neutral-300"
        ] ++ emptyClasses
      )
    : emptyAttrs
    )
    $ concat
    [ [ H.header_
        [ P.class_ "flex max-w-sm flex-col items-center gap-2 text-center" ]
        $ concat
        [ [ H.div_
            [ P.class_ "mb-2 [&_svg]:pointer-events-none [&_svg]:shrink-0 bg-muted text-foreground flex size-10 shrink-0 items-center justify-center rounded-lg [&_svg:not([class*='size-'])]:size-6" ]
            [ i ]
          | Just i <- [emptyIcon]
          ]
        , [ H.h3_ [ P.class_ "text-lg font-medium tracking-tight" ] [ t ]
          | Just t <- [emptyTitle]
          ]
        , [ H.p_
            [ P.class_ "text-muted-foreground [&>a:hover]:text-primary text-sm/relaxed [&>a]:underline [&>a]:underline-offset-4" ]
            [ d ]
          | Just d <- [emptyDescription]
          ]
        ]
      ]
    , [ H.section_
        [ P.class_ "flex w-full max-w-sm min-w-0 flex-col items-center gap-4 text-sm text-balance" ]
        [ H.div_ [ P.class_ "flex gap-2" ] kids ]
      | not (null kids)
      ]
    , emptyFooter
    ]
-----------------------------------------------------------------------------
emptySample :: View context props model action
emptySample =
  empty_ defaultEmptyProps
    { emptyIcon = Just folderIcon
    , emptyTitle = Just "No Projects Yet"
    , emptyDescription = Just
        "You haven't created any projects yet. Get started by creating your first project."
    , emptyFooter =
      [ H.a_
        [ P.class_ "inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4 shrink-0 [&_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive underline-offset-4 hover:underline h-8 rounded-md gap-1.5 px-3 has-[>svg]:px-2.5 text-muted-foreground"
        , P.href_ "#"
        ]
        [ "Learn More"
        , arrowUpRightIcon
        ]
      ]
    }
    [ button_ defaultButtonProps [ "Create Project" ]
    , button_ defaultButtonProps { buttonVariant = Outline } [ "Import Project" ]
    ]
  where
    folderIcon = lucide_ []
      [ S.path_ [ SP.d_ "M10 10.5 8 13l2 2.5" ]
      , S.path_ [ SP.d_ "m14 10.5 2 2.5-2 2.5" ]
      , S.path_
        [ SP.d_ "M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2z"
        ]
      ]
    arrowUpRightIcon = lucide_ []
      [ S.path_ [ SP.d_ "M7 7h10v10" ]
      , S.path_ [ SP.d_ "M7 17 17 7" ]
      ]
-----------------------------------------------------------------------------
emptyCodeSample :: View context props model action
emptyCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyEmpty (emptySample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import qualified Miso.Svg           as S
  import qualified Miso.Svg.Property  as SP
  import           Miso.UI.Button
  import           Miso.UI.Icons
  import           Miso.UI.Types
  import           Miso.UI.Empty
  -----------------------------------------------------------------------------
  emptySample :: View context props model action
  emptySample =
    empty_ defaultEmptyProps
      { emptyIcon = Just folderIcon
      , emptyTitle = Just "No Projects Yet"
      , emptyDescription = Just
          "You haven't created any projects yet. Get started by creating your first project."
      , emptyFooter =
        [ H.a_
          [ P.class_ "inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4 shrink-0 [&_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive underline-offset-4 hover:underline h-8 rounded-md gap-1.5 px-3 has-[>svg]:px-2.5 text-muted-foreground"
          , P.href_ "#"
          ]
          [ "Learn More"
          , arrowUpRightIcon
          ]
        ]
      }
      [ button_ defaultButtonProps [ "Create Project" ]
      , button_ defaultButtonProps { buttonVariant = Outline } [ "Import Project" ]
      ]
    where
      folderIcon = lucide_ []
        [ S.path_ [ SP.d_ "M10 10.5 8 13l2 2.5" ]
        , S.path_ [ SP.d_ "m14 10.5 2 2.5-2 2.5" ]
        , S.path_
          [ SP.d_ "M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2z"
          ]
        ]
      arrowUpRightIcon = lucide_ []
        [ S.path_ [ SP.d_ "M7 7h10v10" ]
        , S.path_ [ SP.d_ "M7 17 17 7" ]
        ]
  """
-----------------------------------------------------------------------------
emptyPropsApi :: View context props model action
emptyPropsApi =
  """
  -- | Props for 'empty_'. Icon, title and description nest other views.
  data EmptyProps context props model action
    = EmptyProps
    { emptyIcon :: Maybe (View context props model action)
      -- ^ Icon shown in the header medallion
    , emptyTitle :: Maybe (View context props model action)
    , emptyDescription :: Maybe (View context props model action)
    , emptyFooter :: [View context props model action]
      -- ^ Content under the actions (e.g. a \\"learn more\\" link)
    , emptyClasses :: [MisoString]
    , emptyAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: bare empty state
  defaultEmptyProps :: EmptyProps context props model action
  defaultEmptyProps
    = EmptyProps
    { emptyIcon = Nothing
    , emptyTitle = Nothing
    , emptyDescription = Nothing
    , emptyFooter = []
    , emptyClasses = []
    , emptyAttrs = []
    }
  """
-----------------------------------------------------------------------------
