-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Spinner
  ( -- ** Props
    SpinnerProps (..)
  , defaultSpinnerProps
    -- ** Views
  , spinner_
    -- ** Samples
  , spinnerUsage
  , spinnerSample
  , spinnerCodeSample
  , spinnerPropsApi
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
import           Miso.UI.Progress
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props for 'spinner_'
data SpinnerProps model action
  = SpinnerProps
  { spinnerLabel :: MisoString
    -- ^ @aria-label@ for screen readers
  , spinnerClasses :: [MisoString]
    -- ^ Extra classes (e.g. @size-4@)
  , spinnerAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultSpinnerProps :: SpinnerProps model action
defaultSpinnerProps
  = SpinnerProps
  { spinnerLabel = "Loading"
  , spinnerClasses = [ "size-4" ]
  , spinnerAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/spinner/ Spinner>, driven by 'SpinnerProps'
spinner_ :: SpinnerProps model action -> View context props model action
spinner_ SpinnerProps {..} = lucide_
  ( [ P.classes_ ("animate-spin" : spinnerClasses)
    , P.aria_ "label" spinnerLabel
    , P.role_ "status"
    ] ++ spinnerAttrs
  )
  [ S.path_ [ SP.d_ "M21 12a9 9 0 1 1-6.219-8.56" ]
  ]
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
spinnerUsage :: View context props model action
spinnerUsage =
  H.div_
  [ P.class_ "flex items-center gap-4" ]
  [ spinner_ defaultSpinnerProps
  , spinner_ defaultSpinnerProps { spinnerClasses = [ "size-6" ] }
  , spinner_ defaultSpinnerProps
    { spinnerClasses = [ "size-8", "text-muted-foreground" ] }
  ]
-----------------------------------------------------------------------------
spinnerSample :: View context props model action
spinnerSample =
  H.article_
  [ P.class_ "group/item flex items-center border text-sm rounded-md transition-colors [a]:hover:bg-accent/50 [a]:transition-colors duration-100 flex-wrap outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] border-border p-4 gap-4"
  ]
  [ H.div_
    [ P.class_ "flex shrink-0 items-center justify-center gap-2 self-start [&_svg]:pointer-events-none size-8 border rounded-md bg-muted [&_svg:not([class*='size-'])]:size-4"
    ]
    [ spinner_ defaultSpinnerProps
      { spinnerClasses = [ "size-4", "text-muted-foreground" ]
      }
    ]
  , H.div_
    [ P.class_ "flex flex-1 flex-col gap-1" ]
    [ H.h3_
      [ P.class_ "flex w-fit items-center gap-2 text-sm leading-snug font-medium" ]
      [ "Downloading..." ]
    , H.p_
      [ P.class_ "text-muted-foreground line-clamp-2 text-sm leading-normal font-normal text-balance [&>a:hover]:text-primary [&>a]:underline [&>a]:underline-offset-4" ]
      [ "129 MB / 1000 MB" ]
    ]
  , button_ defaultButtonProps
      { buttonVariant = Outline
      , buttonSize = Small
      , buttonClasses = [ "self-start" ]
      }
      [ "Cancel" ]
  , H.footer_
    [ P.class_ "flex basis-full items-center justify-between gap-2" ]
    [ progress_ defaultProgressProps { progressValue = 13 }
    ]
  ]
-----------------------------------------------------------------------------
spinnerCodeSample :: View context props model action
spinnerCodeSample =
  """
  -----------------------------------------------------------------------------
  module MySpinner (spinnerUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import qualified Miso.Svg           as S
  import qualified Miso.Svg.Property  as SP
  import           Miso.UI.Button
  import           Miso.UI.Icons
  import           Miso.UI.Progress
  import           Miso.UI.Types
  import           Miso.UI.Spinner
  -----------------------------------------------------------------------------
  spinnerUsage :: View context props model action
  spinnerUsage =
    H.div_
    [ P.class_ "flex items-center gap-4" ]
    [ spinner_ defaultSpinnerProps
    , spinner_ defaultSpinnerProps { spinnerClasses = [ "size-6" ] }
    , spinner_ defaultSpinnerProps
      { spinnerClasses = [ "size-8", "text-muted-foreground" ] }
    ]
  """
-----------------------------------------------------------------------------
spinnerPropsApi :: View context props model action
spinnerPropsApi =
  """
  -- | Props for 'spinner_'
  data SpinnerProps model action
    = SpinnerProps
    { spinnerLabel :: MisoString
      -- ^ @aria-label@ for screen readers
    , spinnerClasses :: [MisoString]
      -- ^ Extra classes (e.g. @size-4@)
    , spinnerAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultSpinnerProps :: SpinnerProps model action
  defaultSpinnerProps
    = SpinnerProps
    { spinnerLabel = "Loading"
    , spinnerClasses = [ "size-4" ]
    , spinnerAttrs = []
    }
  """
-----------------------------------------------------------------------------
