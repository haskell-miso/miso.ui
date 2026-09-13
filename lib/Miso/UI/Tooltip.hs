-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Tooltip
  ( -- ** Props
    TooltipProps (..)
  , defaultTooltipProps
    -- ** Views
  , tooltip_
  , tooltipAttrs_
    -- ** Samples
  , tooltipSample
  , tooltipCodeSample
  , tooltipPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Button
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props for 'tooltip_'
data TooltipProps model action
  = TooltipProps
  { tooltipText :: MisoString
    -- ^ Tooltip content (@data-tooltip@)
  , tooltipSide :: Side
    -- ^ Placement (@data-side@); 'TopSide' by default
  , tooltipButton :: ButtonProps model action
    -- ^ Props for the trigger button rendered by 'tooltip_'
  }
-----------------------------------------------------------------------------
-- | Smart constructor: tooltip on top of an outline button
defaultTooltipProps :: TooltipProps model action
defaultTooltipProps
  = TooltipProps
  { tooltipText = ""
  , tooltipSide = TopSide
  , tooltipButton = defaultButtonProps { buttonVariant = Outline }
  }
-----------------------------------------------------------------------------
-- | The basecoat tooltip attributes, for attaching to any element
tooltipAttrs_ :: MisoString -> Side -> [Attribute model action]
tooltipAttrs_ tip side = concat
  [ [ P.data_ "tooltip" tip ]
  , [ P.data_ "side" (sideText side) | side /= TopSide ]
  ]
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/tooltip/ Tooltip>: button with a tooltip.
-- For tooltips on arbitrary elements use 'tooltipAttrs_'.
tooltip_
  :: TooltipProps model action
  -> [View context props model action]
  -> View context props model action
tooltip_ TooltipProps {..} kids =
  button_ tooltipButton
    { buttonAttrs = tooltipAttrs_ tooltipText tooltipSide ++ buttonAttrs tooltipButton
    } kids
-----------------------------------------------------------------------------
tooltipSample :: View context props model action
tooltipSample =
  H.div_
  [ P.class_ "flex flex-wrap items-center gap-4" ]
  [ tooltip_ defaultTooltipProps { tooltipText = "Top tooltip" } [ "Top" ]
  , tooltip_ defaultTooltipProps { tooltipText = "Right tooltip", tooltipSide = RightSide } [ "Right" ]
  , tooltip_ defaultTooltipProps { tooltipText = "Bottom tooltip", tooltipSide = BottomSide } [ "Bottom" ]
  , tooltip_ defaultTooltipProps { tooltipText = "Left tooltip", tooltipSide = LeftSide } [ "Left" ]
  ]
-----------------------------------------------------------------------------
tooltipCodeSample :: View context props model action
tooltipCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyTooltip (tooltipSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Button
  import           Miso.UI.Types
  import           Miso.UI.Tooltip
  -----------------------------------------------------------------------------
  tooltipSample :: View context props model action
  tooltipSample =
    H.div_
    [ P.class_ "flex flex-wrap items-center gap-4" ]
    [ tooltip_ defaultTooltipProps { tooltipText = "Top tooltip" } [ "Top" ]
    , tooltip_ defaultTooltipProps { tooltipText = "Right tooltip", tooltipSide = RightSide } [ "Right" ]
    , tooltip_ defaultTooltipProps { tooltipText = "Bottom tooltip", tooltipSide = BottomSide } [ "Bottom" ]
    , tooltip_ defaultTooltipProps { tooltipText = "Left tooltip", tooltipSide = LeftSide } [ "Left" ]
    ]
  """
-----------------------------------------------------------------------------
tooltipPropsApi :: View context props model action
tooltipPropsApi =
  """
  -- | Props for 'tooltip_'
  data TooltipProps model action
    = TooltipProps
    { tooltipText :: MisoString
      -- ^ Tooltip content (@data-tooltip@)
    , tooltipSide :: Side
      -- ^ Placement (@data-side@); 'TopSide' by default
    , tooltipButton :: ButtonProps model action
      -- ^ Props for the trigger button rendered by 'tooltip_'
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: tooltip on top of an outline button
  defaultTooltipProps :: TooltipProps model action
  defaultTooltipProps
    = TooltipProps
    { tooltipText = ""
    , tooltipSide = TopSide
    , tooltipButton = defaultButtonProps { buttonVariant = Outline }
    }
  """
-----------------------------------------------------------------------------
