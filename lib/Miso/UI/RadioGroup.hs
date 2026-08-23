-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.RadioGroup
  ( -- ** Props
    RadioGroupProps (..)
  , defaultRadioGroupProps
  , RadioProps (..)
  , defaultRadioProps
    -- ** Views
  , radioGroup_
  , radio_
  , radioInput_
    -- ** Samples
  , radioGroupUsage
  , radioGroupSample
  , radioGroupCodeSample
  , radioGroupPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
-- | Props for 'radioGroup_'
data RadioGroupProps model action
  = RadioGroupProps
  { radioGroupClasses :: [MisoString]
    -- ^ Extra classes appended to the @fieldset@
  , radioGroupAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultRadioGroupProps :: RadioGroupProps model action
defaultRadioGroupProps
  = RadioGroupProps
  { radioGroupClasses = []
  , radioGroupAttrs = []
  }
-----------------------------------------------------------------------------
-- | Props for a single 'radio_' inside a group
data RadioProps model action
  = RadioProps
  { radioName :: MisoString
    -- ^ Groups radios together (required)
  , radioValue :: MisoString
  , radioChecked :: Bool
  , radioDisabled :: Bool
  , radioClasses :: [MisoString]
    -- ^ Extra classes appended to the @input@
  , radioLabelClasses :: [MisoString]
    -- ^ Extra classes appended to the wrapping @label@
  , radioAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: unchecked, enabled
defaultRadioProps :: RadioProps model action
defaultRadioProps
  = RadioProps
  { radioName = "radio-group"
  , radioValue = ""
  , radioChecked = False
  , radioDisabled = False
  , radioClasses = []
  , radioLabelClasses = []
  , radioAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/radio-group/ Radio Group>: fieldset of 'radio_'
radioGroup_
  :: RadioGroupProps model action
  -> [View context model action]
  -> View context model action
radioGroup_ RadioGroupProps {..} kids =
  H.fieldset_
    ( P.classes_ ("grid" : "gap-3" : radioGroupClasses)
    : radioGroupAttrs
    ) kids
-----------------------------------------------------------------------------
-- | Label-wrapped radio input; children render as the label text
radio_
  :: RadioProps model action
  -> [View context model action]
  -> View context model action
radio_ cfg kids =
  H.label_
  [ P.classes_ ("label" : radioLabelClasses cfg) ]
  ( radioInput_ cfg : kids )
-----------------------------------------------------------------------------
-- | The bare radio @input@, for custom layouts
radioInput_ :: RadioProps model action -> View context model action
radioInput_ RadioProps {..} = H.input_ $ concat
  [ [ P.classes_ ("input" : radioClasses)
    , P.type_ "radio"
    , P.name_ radioName
    , P.value_ radioValue
    ]
  , [ P.checked_ True | radioChecked ]
  , [ P.disabled_ | radioDisabled ]
  , radioAttrs
  ]
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
radioGroupUsage :: View context model action
radioGroupUsage =
  radioGroup_ defaultRadioGroupProps
  [ radio_ defaultRadioProps { radioName = "my-group", radioValue = "default" }
    [ "Default" ]
  , radio_ defaultRadioProps
    { radioName = "my-group"
    , radioValue = "comfortable"
    , radioChecked = True
    }
    [ "Comfortable" ]
  , radio_ defaultRadioProps
    { radioName = "my-group"
    , radioValue = "compact"
    , radioDisabled = True
    }
    [ "Compact" ]
  ]
-----------------------------------------------------------------------------
radioGroupSample :: View context model action
radioGroupSample =
  H.div_
  [ P.class_ "flex flex-col gap-y-6" ]
  [ radioGroup_ defaultRadioGroupProps
    [ radio_ defaultRadioProps { radioName = "demo-radio-group", radioValue = "default" }
      [ "Default" ]
    , radio_ defaultRadioProps
      { radioName = "demo-radio-group"
      , radioValue = "comfortable"
      , radioChecked = True
      }
      [ "Comfortable" ]
    , radio_ defaultRadioProps { radioName = "demo-radio-group", radioValue = "compact" }
      [ "Compact" ]
    ]
  , radioGroup_ defaultRadioGroupProps { radioGroupClasses = [ "max-w-sm" ] }
    [ plan "Starter Plan"
        "Perfect for small businesses getting started with our platform"
    , plan "Pro Plan"
        "Advanced features for growing businesses with higher demands"
    ]
  ]
  where
    plan name description =
      radio_ defaultRadioProps
        { radioName = "demo-radio-group-styled"
        , radioValue = "no"
        , radioClasses =
          [ "checked:bg-green-600"
          , "checked:border-green-600"
          , "dark:checked:bg-input/30"
          , "checked:before:bg-background"
          , "dark:checked:before:bg-primary"
          ]
        , radioLabelClasses =
          [ "gap-3", "items-start", "hover:bg-accent/50", "rounded-lg", "border", "p-4"
          , "has-[input[type='radio']:checked]:border-green-600"
          , "has-[input[type='radio']:checked]:bg-green-50"
          , "dark:has-[input[type='radio']:checked]:border-green-900"
          , "dark:has-[input[type='radio']:checked]:bg-green-950"
          ]
        }
        [ H.div_
          [ P.class_ "grid gap-1 font-normal" ]
          [ H.h2_ [ P.class_ "font-medium" ] [ name ]
          , H.p_ [ P.class_ "text-muted-foreground leading-snug" ] [ description ]
          ]
        ]
-----------------------------------------------------------------------------
radioGroupCodeSample :: View context model action
radioGroupCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyRadioGroup (radioGroupUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.RadioGroup
  -----------------------------------------------------------------------------
  radioGroupUsage :: View context model action
  radioGroupUsage =
    radioGroup_ defaultRadioGroupProps
    [ radio_ defaultRadioProps { radioName = "my-group", radioValue = "default" }
      [ "Default" ]
    , radio_ defaultRadioProps
      { radioName = "my-group"
      , radioValue = "comfortable"
      , radioChecked = True
      }
      [ "Comfortable" ]
    , radio_ defaultRadioProps
      { radioName = "my-group"
      , radioValue = "compact"
      , radioDisabled = True
      }
      [ "Compact" ]
    ]
  """
-----------------------------------------------------------------------------
radioGroupPropsApi :: View context model action
radioGroupPropsApi =
  """
  -- | Props for 'radioGroup_'
  data RadioGroupProps model action
    = RadioGroupProps
    { radioGroupClasses :: [MisoString]
      -- ^ Extra classes appended to the @fieldset@
    , radioGroupAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultRadioGroupProps :: RadioGroupProps model action
  defaultRadioGroupProps
    = RadioGroupProps
    { radioGroupClasses = []
    , radioGroupAttrs = []
    }
  -----------------------------------------------------------------------------
  -- | Props for a single 'radio_' inside a group
  data RadioProps model action
    = RadioProps
    { radioName :: MisoString
      -- ^ Groups radios together (required)
    , radioValue :: MisoString
    , radioChecked :: Bool
    , radioDisabled :: Bool
    , radioClasses :: [MisoString]
      -- ^ Extra classes appended to the @input@
    , radioLabelClasses :: [MisoString]
      -- ^ Extra classes appended to the wrapping @label@
    , radioAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: unchecked, enabled
  defaultRadioProps :: RadioProps model action
  defaultRadioProps
    = RadioProps
    { radioName = "radio-group"
    , radioValue = ""
    , radioChecked = False
    , radioDisabled = False
    , radioClasses = []
    , radioLabelClasses = []
    , radioAttrs = []
    }
  """
-----------------------------------------------------------------------------
