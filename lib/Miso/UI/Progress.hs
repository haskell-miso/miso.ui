-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Progress
  ( -- ** Props
    ProgressProps (..)
  , defaultProgressProps
    -- ** Views
  , progress_
    -- ** Samples
  , progressSample
  , progressCodeSample
  , progressPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.CSS as CSS
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
import qualified Miso.String as MS
-----------------------------------------------------------------------------
-- | Props for 'progress_'
data ProgressProps action
  = ProgressProps
  { progressValue :: Int
    -- ^ Percentage complete (0-100)
  , progressClasses :: [MisoString]
    -- ^ Extra classes appended to the track
  , progressAttrs :: [Attribute action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: empty bar
defaultProgressProps :: ProgressProps action
defaultProgressProps
  = ProgressProps
  { progressValue = 0
  , progressClasses = []
  , progressAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/progress/ Progress>, driven by 'ProgressProps'
progress_ :: ProgressProps action -> View model action
progress_ ProgressProps {..} =
  H.div_
    ( concat
      [ [ P.classes_
          ( [ "bg-primary/20", "relative", "h-2", "w-full", "overflow-hidden", "rounded-full" ]
            ++ progressClasses
          )
        , P.role_ "progressbar"
        , P.aria_ "valuemin" "0"
        , P.aria_ "valuemax" "100"
        , P.aria_ "valuenow" (MS.ms progressValue)
        ]
      , progressAttrs
      ]
    )
    [ H.div_
      [ CSS.style_ [ "width" =: (MS.ms progressValue <> "%") ]
      , P.class_ "bg-primary h-full w-full flex-1 transition-all"
      ]
      []
    ]
-----------------------------------------------------------------------------
progressSample :: View model action
progressSample =
  H.div_
  [ P.class_ "flex flex-col gap-4 max-w-sm" ]
  [ progress_ defaultProgressProps { progressValue = 13 }
  , progress_ defaultProgressProps { progressValue = 66 }
  ]
-----------------------------------------------------------------------------
progressCodeSample :: View model action
progressCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyProgress (progressSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.CSS as CSS
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import qualified Miso.String as MS
  import           Miso.UI.Progress
  -----------------------------------------------------------------------------
  progressSample :: View model action
  progressSample =
    H.div_
    [ P.class_ "flex flex-col gap-4 max-w-sm" ]
    [ progress_ defaultProgressProps { progressValue = 13 }
    , progress_ defaultProgressProps { progressValue = 66 }
    ]
  """
-----------------------------------------------------------------------------
progressPropsApi :: View model action
progressPropsApi =
  """
  -- | Props for 'progress_'
  data ProgressProps action
    = ProgressProps
    { progressValue :: Int
      -- ^ Percentage complete (0-100)
    , progressClasses :: [MisoString]
      -- ^ Extra classes appended to the track
    , progressAttrs :: [Attribute action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: empty bar
  defaultProgressProps :: ProgressProps action
  defaultProgressProps
    = ProgressProps
    { progressValue = 0
    , progressClasses = []
    , progressAttrs = []
    }
  """
-----------------------------------------------------------------------------
