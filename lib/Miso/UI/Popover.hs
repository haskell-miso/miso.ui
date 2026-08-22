-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Popover
  ( -- ** Props
    PopoverProps (..)
  , defaultPopoverProps
    -- ** Views
  , popover_
    -- ** Samples
  , popoverSample
  , popoverCodeSample
  , popoverPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Input
import           Miso.UI.Label
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props for 'popover_'
data PopoverProps model action
  = PopoverProps
  { popoverId :: MisoString
    -- ^ Base id; trigger\/popover ids are derived from it (required)
  , popoverTrigger :: [View model action]
    -- ^ Content of the trigger button (nests other views)
  , popoverTriggerClasses :: [MisoString]
    -- ^ Classes of the trigger button (defaults to @btn-outline@)
  , popoverClasses :: [MisoString]
    -- ^ Extra classes for the popover (e.g. @w-80@)
  , popoverSide :: Side
    -- ^ Placement side (@data-side@)
  , popoverAlign :: Align
    -- ^ Placement alignment (@data-align@)
  , popoverAttrs :: [Attribute action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: outline trigger, bottom placement
defaultPopoverProps :: PopoverProps model action
defaultPopoverProps
  = PopoverProps
  { popoverId = "popover"
  , popoverTrigger = []
  , popoverTriggerClasses = [ "btn-outline" ]
  , popoverClasses = [ "w-80" ]
  , popoverSide = BottomSide
  , popoverAlign = CenterAlign
  , popoverAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/popover/ Popover>, driven by 'PopoverProps'.
-- Children render inside the popover.
popover_
  :: PopoverProps model action
  -> [View model action]
  -> View model action
popover_ cfg kids =
  H.div_
  ( P.class_ "popover"
  : P.id_ (popoverId cfg)
  : popoverAttrs cfg
  )
  [ H.button_
    [ P.classes_ (popoverTriggerClasses cfg)
    , P.aria_ "controls" (popoverId cfg <> "-popover")
    , P.aria_ "expanded" "false"
    , P.type_ "button"
    , P.id_ (popoverId cfg <> "-trigger")
    ]
    (popoverTrigger cfg)
  , H.div_
    ( concat
      [ [ P.classes_ (popoverClasses cfg)
        , P.aria_ "hidden" "true"
        , P.data_ "popover" ""
        , P.id_ (popoverId cfg <> "-popover")
        ]
      , [ P.data_ "side" (sideText (popoverSide cfg)) | popoverSide cfg /= BottomSide ]
      , [ P.data_ "align" (alignText (popoverAlign cfg)) | popoverAlign cfg /= CenterAlign ]
      ]
    ) kids
  ]
-----------------------------------------------------------------------------
popoverSample :: View model action
popoverSample =
  popover_ defaultPopoverProps
    { popoverId = "demo-popover"
    , popoverTrigger = [ "Open popover" ]
    }
    [ H.div_
      [ P.class_ "grid gap-4" ]
      [ H.header_
        [ P.class_ "grid gap-1.5" ]
        [ H.h4_ [ P.class_ "leading-none font-medium" ] [ "Dimensions" ]
        , H.p_ [ P.class_ "text-muted-foreground text-sm" ]
          [ "Set the dimensions for the layer." ]
        ]
      , H.form_
        [ P.class_ "form grid gap-2" ]
        [ dimension "demo-popover-width" "Width" "100%"
        , dimension "demo-popover-max-width" "Max. width" "300px"
        , dimension "demo-popover-height" "Height" "25px"
        , dimension "demo-popover-max-height" "Max. height" "none"
        ]
      ]
    ]
  where
    dimension fieldId labelText val =
      H.div_
      [ P.class_ "grid grid-cols-3 items-center gap-4" ]
      [ label_ defaultLabelProps { labelFor = Just fieldId } [ text labelText ]
      , input_ defaultInputProps
        { inputId = Just fieldId
        , inputValue = Just val
        , inputClasses = [ "col-span-2", "h-8" ]
        }
      ]
-----------------------------------------------------------------------------
popoverCodeSample :: View model action
popoverCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyPopover (popoverSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Input
  import           Miso.UI.Label
  import           Miso.UI.Types
  import           Miso.UI.Popover
  -----------------------------------------------------------------------------
  popoverSample :: View model action
  popoverSample =
    popover_ defaultPopoverProps
      { popoverId = "demo-popover"
      , popoverTrigger = [ "Open popover" ]
      }
      [ H.div_
        [ P.class_ "grid gap-4" ]
        [ H.header_
          [ P.class_ "grid gap-1.5" ]
          [ H.h4_ [ P.class_ "leading-none font-medium" ] [ "Dimensions" ]
          , H.p_ [ P.class_ "text-muted-foreground text-sm" ]
            [ "Set the dimensions for the layer." ]
          ]
        , H.form_
          [ P.class_ "form grid gap-2" ]
          [ dimension "demo-popover-width" "Width" "100%"
          , dimension "demo-popover-max-width" "Max. width" "300px"
          , dimension "demo-popover-height" "Height" "25px"
          , dimension "demo-popover-max-height" "Max. height" "none"
          ]
        ]
      ]
    where
      dimension fieldId labelText val =
        H.div_
        [ P.class_ "grid grid-cols-3 items-center gap-4" ]
        [ label_ defaultLabelProps { labelFor = Just fieldId } [ text labelText ]
        , input_ defaultInputProps
          { inputId = Just fieldId
          , inputValue = Just val
          , inputClasses = [ "col-span-2", "h-8" ]
          }
        ]
  """
-----------------------------------------------------------------------------
popoverPropsApi :: View model action
popoverPropsApi =
  """
  -- | Props for 'popover_'
  data PopoverProps model action
    = PopoverProps
    { popoverId :: MisoString
      -- ^ Base id; trigger\\/popover ids are derived from it (required)
    , popoverTrigger :: [View model action]
      -- ^ Content of the trigger button (nests other views)
    , popoverTriggerClasses :: [MisoString]
      -- ^ Classes of the trigger button (defaults to @btn-outline@)
    , popoverClasses :: [MisoString]
      -- ^ Extra classes for the popover (e.g. @w-80@)
    , popoverSide :: Side
      -- ^ Placement side (@data-side@)
    , popoverAlign :: Align
      -- ^ Placement alignment (@data-align@)
    , popoverAttrs :: [Attribute action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: outline trigger, bottom placement
  defaultPopoverProps :: PopoverProps model action
  defaultPopoverProps
    = PopoverProps
    { popoverId = "popover"
    , popoverTrigger = []
    , popoverTriggerClasses = [ "btn-outline" ]
    , popoverClasses = [ "w-80" ]
    , popoverSide = BottomSide
    , popoverAlign = CenterAlign
    , popoverAttrs = []
    }
  """
-----------------------------------------------------------------------------
