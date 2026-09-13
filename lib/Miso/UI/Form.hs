-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Form
  ( -- ** Props
    FormProps (..)
  , defaultFormProps
  , FieldProps (..)
  , defaultFieldProps
    -- ** Views
  , form_
  , field_
    -- ** Samples
  , formUsage
  , formSample
  , formCodeSample
  , formPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Button
import           Miso.UI.Checkbox
import           Miso.UI.Input
import           Miso.UI.Label
import           Miso.UI.RadioGroup
import           Miso.UI.Switch
import           Miso.UI.Textarea
-----------------------------------------------------------------------------
-- | Props for 'form_'
data FormProps model action
  = FormProps
  { formClasses :: [MisoString]
    -- ^ Extra classes appended to @form.form@ (e.g. @grid gap-6@)
  , formAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: vertical form grid
defaultFormProps :: FormProps model action
defaultFormProps
  = FormProps
  { formClasses = [ "grid", "gap-6" ]
  , formAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/form/ Form>, driven by 'FormProps'
form_
  :: FormProps model action
  -> [View context props model action]
  -> View context props model action
form_ FormProps {..} kids =
  H.form_
    ( P.classes_ ("form" : formClasses)
    : formAttrs
    ) kids
-----------------------------------------------------------------------------
-- | Props for 'field_': label + control + description stack
data FieldProps context props model action
  = FieldProps
  { fieldId :: Maybe MisoString
    -- ^ id of the labelled control (@for@ on the label)
  , fieldLabel :: Maybe (View context props model action)
  , fieldDescription :: Maybe (View context props model action)
  , fieldClasses :: [MisoString]
  , fieldAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultFieldProps :: FieldProps context props model action
defaultFieldProps
  = FieldProps
  { fieldId = Nothing
  , fieldLabel = Nothing
  , fieldDescription = Nothing
  , fieldClasses = []
  , fieldAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/field/ Field>: labelled control with
-- optional description. Children are the control(s).
field_
  :: FieldProps context props model action
  -> [View context props model action]
  -> View context props model action
field_ FieldProps {..} kids =
  H.div_
    ( P.classes_ ("grid" : "gap-2" : fieldClasses)
    : fieldAttrs
    )
    $ concat
    [ [ label_ defaultLabelProps { labelFor = fieldId } [ l ] | Just l <- [fieldLabel] ]
    , kids
    , [ H.p_ [ P.class_ "text-muted-foreground text-sm" ] [ d ]
      | Just d <- [fieldDescription]
      ]
    ]
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
formUsage :: View context props model action
formUsage =
  form_ defaultFormProps
  [ field_ defaultFieldProps
    { fieldId = Just "username"
    , fieldLabel = Just "Username"
    , fieldDescription = Just "This is your public display name."
    }
    [ input_ defaultInputProps
      { inputId = Just "username"
      , inputPlaceholder = Just "dmjio"
      }
    ]
  , field_ defaultFieldProps
    { fieldId = Just "bio"
    , fieldLabel = Just "Bio"
    }
    [ textarea_ defaultTextareaProps
      { textareaId = Just "bio"
      , textareaRows = Just "3"
      }
    ]
  , button_ defaultButtonProps
    { buttonAttrs = [ P.type_ "submit" ] }
    [ "Submit" ]
  ]
-----------------------------------------------------------------------------
formSample :: View context props model action
formSample =
  form_ defaultFormProps { formClasses = [ "grid", "w-full", "max-w-sm", "gap-6" ] }
  [ field_ defaultFieldProps
    { fieldId = Just "demo-form-text"
    , fieldLabel = Just "Username"
    , fieldDescription = Just "This is your public display name."
    }
    [ input_ defaultInputProps
      { inputId = Just "demo-form-text"
      , inputPlaceholder = Just "dmjio"
      }
    ]
  , field_ defaultFieldProps
    { fieldId = Just "demo-form-select"
    , fieldLabel = Just "Email"
    , fieldDescription = Just "You can manage email addresses in your email settings."
    }
    [ H.select_
      [ P.id_ "demo-form-select" ]
      [ H.option_ [ P.value_ "bob@example.com" ] [ "m@example.com" ]
      , H.option_ [ P.value_ "alice@example.com" ] [ "m@google.com" ]
      , H.option_ [ P.value_ "john@example.com" ] [ "m@support.com" ]
      ]
    ]
  , field_ defaultFieldProps
    { fieldId = Just "demo-form-textarea"
    , fieldLabel = Just "Bio"
    , fieldDescription = Just "You can @mention other users and organizations."
    }
    [ textarea_ defaultTextareaProps
      { textareaId = Just "demo-form-textarea"
      , textareaPlaceholder = Just "I like to..."
      , textareaRows = Just "3"
      }
    ]
  , H.div_
    [ P.class_ "flex flex-col gap-3" ]
    [ label_ defaultLabelProps { labelFor = Just "demo-form-radio" }
      [ "Notify me about..." ]
    , radioGroup_ defaultRadioGroupProps { radioGroupAttrs = [ P.id_ "demo-form-radio" ] }
      [ radio_ defaultRadioProps
        { radioName = "demo-form-radio"
        , radioValue = "1"
        , radioLabelClasses = [ "font-normal" ]
        }
        [ "All new messages" ]
      , radio_ defaultRadioProps
        { radioName = "demo-form-radio"
        , radioValue = "2"
        , radioLabelClasses = [ "font-normal" ]
        }
        [ "Direct messages and mentions" ]
      , radio_ defaultRadioProps
        { radioName = "demo-form-radio"
        , radioValue = "3"
        , radioLabelClasses = [ "font-normal" ]
        }
        [ "Nothing" ]
      ]
    ]
  , H.div_
    [ P.class_ "flex flex-row items-start gap-3 rounded-md border p-4 shadow-xs" ]
    [ checkboxInput_ defaultCheckboxProps { checkboxId = Just "demo-form-checkbox" }
    , H.div_
      [ P.class_ "flex flex-col gap-1" ]
      [ label_ defaultLabelProps
        { labelFor = Just "demo-form-checkbox"
        , labelClasses = [ "leading-snug" ]
        }
        [ "Use different settings for my mobile devices" ]
      , H.p_
        [ P.class_ "text-muted-foreground text-sm leading-snug" ]
        [ "You can manage your mobile notifications in the mobile settings page." ]
      ]
    ]
  , H.section_
    [ P.class_ "grid gap-4" ]
    [ H.h3_ [ P.class_ "text-lg font-medium" ] [ "Email Notifications" ]
    , marketingRow False
    , marketingRow True
    ]
  , button_ defaultButtonProps
    { buttonAttrs = [ P.type_ "submit" ] }
    [ "Submit" ]
  ]
  where
    marketingRow disabled =
      H.div_
      [ P.class_ "gap-2 flex flex-row items-start justify-between rounded-lg border p-4 shadow-xs" ]
      [ H.div_
        [ P.classes_ ("flex" : "flex-col" : "gap-0.5" : [ "opacity-60" | disabled ]) ]
        [ label_ defaultLabelProps
          { labelFor = Just switchId
          , labelClasses = [ "leading-normal" ]
          }
          [ "Marketing emails" ]
        , H.p_
          [ P.class_ "text-muted-foreground text-sm" ]
          [ "Receive emails about new products, features, and more." ]
        ]
      , switchInput_ defaultSwitchProps
        { switchId = Just switchId
        , switchDisabled = disabled
        }
      ]
      where
        switchId = if disabled then "demo-form-switch-disabled" else "demo-form-switch"
-----------------------------------------------------------------------------
formCodeSample :: View context props model action
formCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyForm (formUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Button
  import           Miso.UI.Checkbox
  import           Miso.UI.Input
  import           Miso.UI.Label
  import           Miso.UI.RadioGroup
  import           Miso.UI.Switch
  import           Miso.UI.Textarea
  import           Miso.UI.Form
  -----------------------------------------------------------------------------
  formUsage :: View context props model action
  formUsage =
    form_ defaultFormProps
    [ field_ defaultFieldProps
      { fieldId = Just "username"
      , fieldLabel = Just "Username"
      , fieldDescription = Just "This is your public display name."
      }
      [ input_ defaultInputProps
        { inputId = Just "username"
        , inputPlaceholder = Just "dmjio"
        }
      ]
    , field_ defaultFieldProps
      { fieldId = Just "bio"
      , fieldLabel = Just "Bio"
      }
      [ textarea_ defaultTextareaProps
        { textareaId = Just "bio"
        , textareaRows = Just "3"
        }
      ]
    , button_ defaultButtonProps
      { buttonAttrs = [ P.type_ "submit" ] }
      [ "Submit" ]
    ]
  """
-----------------------------------------------------------------------------
formPropsApi :: View context props model action
formPropsApi =
  """
  -- | Props for 'form_'
  data FormProps model action
    = FormProps
    { formClasses :: [MisoString]
      -- ^ Extra classes appended to @form.form@ (e.g. @grid gap-6@)
    , formAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: vertical form grid
  defaultFormProps :: FormProps model action
  defaultFormProps
    = FormProps
    { formClasses = [ "grid", "gap-6" ]
    , formAttrs = []
    }
  -----------------------------------------------------------------------------
  -- | Props for 'field_': label + control + description stack
  data FieldProps context props model action
    = FieldProps
    { fieldId :: Maybe MisoString
      -- ^ id of the labelled control (@for@ on the label)
    , fieldLabel :: Maybe (View context props model action)
    , fieldDescription :: Maybe (View context props model action)
    , fieldClasses :: [MisoString]
    , fieldAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultFieldProps :: FieldProps context props model action
  defaultFieldProps
    = FieldProps
    { fieldId = Nothing
    , fieldLabel = Nothing
    , fieldDescription = Nothing
    , fieldClasses = []
    , fieldAttrs = []
    }
  """
-----------------------------------------------------------------------------
