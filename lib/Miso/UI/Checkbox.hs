-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Checkbox
  ( -- ** Props
    CheckboxProps (..)
  , defaultCheckboxProps
    -- ** Views
  , checkbox_
  , checkboxInput_
    -- ** Samples
  , checkboxUsage
  , checkboxSample
  , checkboxCodeSample
  , checkboxPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Label
-----------------------------------------------------------------------------
-- | Props for 'checkbox_'
data CheckboxProps model action
  = CheckboxProps
  { checkboxId :: Maybe MisoString
  , checkboxName :: Maybe MisoString
  , checkboxValue :: Maybe MisoString
  , checkboxChecked :: Bool
  , checkboxDisabled :: Bool
  , checkboxClasses :: [MisoString]
    -- ^ Extra classes appended to the @input@
  , checkboxLabelClasses :: [MisoString]
    -- ^ Extra classes appended to the wrapping @label@
  , checkboxAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: unchecked, enabled
defaultCheckboxProps :: CheckboxProps model action
defaultCheckboxProps
  = CheckboxProps
  { checkboxId = Nothing
  , checkboxName = Nothing
  , checkboxValue = Nothing
  , checkboxChecked = False
  , checkboxDisabled = False
  , checkboxClasses = []
  , checkboxLabelClasses = []
  , checkboxAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/checkbox/ Checkbox>: label-wrapped checkbox.
-- The children render as the label text.
checkbox_
  :: CheckboxProps model action
  -> [View context props model action]
  -> View context props model action
checkbox_ cfg kids =
  H.label_
  [ P.classes_ ("label" : "gap-3" : checkboxLabelClasses cfg) ]
  ( checkboxInput_ cfg : kids )
-----------------------------------------------------------------------------
-- | The bare checkbox @input@, for custom layouts
checkboxInput_ :: CheckboxProps model action -> View context props model action
checkboxInput_ CheckboxProps {..} = H.input_ $ concat
  [ [ P.classes_ ("input" : checkboxClasses)
    , P.type_ "checkbox"
    ]
  , [ P.id_ i | Just i <- [checkboxId] ]
  , [ P.name_ n | Just n <- [checkboxName] ]
  , [ P.value_ v | Just v <- [checkboxValue] ]
  , [ P.checked_ True | checkboxChecked ]
  , [ P.disabled_ | checkboxDisabled ]
  , checkboxAttrs
  ]
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
checkboxUsage :: View context props model action
checkboxUsage =
  H.div_
  [ P.class_ "flex flex-col gap-6" ]
  [ checkbox_ defaultCheckboxProps [ "Accept terms and conditions" ]
  , checkbox_ defaultCheckboxProps { checkboxChecked = True } [ "Checked" ]
  , checkbox_ defaultCheckboxProps { checkboxDisabled = True } [ "Disabled" ]
  ]
-----------------------------------------------------------------------------
checkboxSample :: View context props model action
checkboxSample =
  H.div_
  [ P.class_ "flex flex-col gap-6 max-w-lg" ]
  [ checkbox_ defaultCheckboxProps [ "Accept terms and conditions" ]
  , H.div_
    [ P.class_ "flex items-start gap-3" ]
    [ checkboxInput_ defaultCheckboxProps
      { checkboxId = Just "demo-checkbox-label-and-description" }
    , H.div_
      [ P.class_ "grid gap-2" ]
      [ label_ defaultLabelProps { labelFor = Just "demo-checkbox-label-and-description" }
        [ "Accept terms and conditions" ]
      , H.p_
        [ P.class_ "text-muted-foreground text-sm" ]
        [ "By clicking this checkbox, you agree to the terms and conditions." ]
      ]
    ]
  , checkbox_ defaultCheckboxProps { checkboxDisabled = True }
    [ "Enable notifications" ]
  , H.label_
    [ P.class_ "flex items-start gap-3 border p-3 hover:bg-accent/50 rounded-lg has-[input[type='checkbox']:checked]:border-blue-600 has-[input[type='checkbox']:checked]:bg-blue-50 dark:has-[input[type='checkbox']:checked]:border-blue-900 dark:has-[input[type='checkbox']:checked]:bg-blue-950" ]
    [ checkboxInput_ defaultCheckboxProps
      { checkboxChecked = True
      , checkboxClasses =
        [ "checked:bg-blue-600"
        , "checked:border-blue-600"
        , "dark:checked:bg-blue-700"
        , "dark:checked:border-blue-700"
        , "checked:after:bg-white"
        ]
      }
    , H.div_
      [ P.class_ "grid gap-2" ]
      [ H.h2_ [ P.class_ "text-sm leading-none font-medium" ] [ "Enable notifications" ]
      , H.p_
        [ P.class_ "text-muted-foreground text-sm" ]
        [ "You can enable or disable notifications at any time." ]
      ]
    ]
  ]
-----------------------------------------------------------------------------
checkboxCodeSample :: View context props model action
checkboxCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyCheckbox (checkboxUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Label
  import           Miso.UI.Checkbox
  -----------------------------------------------------------------------------
  checkboxUsage :: View context props model action
  checkboxUsage =
    H.div_
    [ P.class_ "flex flex-col gap-6" ]
    [ checkbox_ defaultCheckboxProps [ "Accept terms and conditions" ]
    , checkbox_ defaultCheckboxProps { checkboxChecked = True } [ "Checked" ]
    , checkbox_ defaultCheckboxProps { checkboxDisabled = True } [ "Disabled" ]
    ]
  """
-----------------------------------------------------------------------------
checkboxPropsApi :: View context props model action
checkboxPropsApi =
  """
  -- | Props for 'checkbox_'
  data CheckboxProps model action
    = CheckboxProps
    { checkboxId :: Maybe MisoString
    , checkboxName :: Maybe MisoString
    , checkboxValue :: Maybe MisoString
    , checkboxChecked :: Bool
    , checkboxDisabled :: Bool
    , checkboxClasses :: [MisoString]
      -- ^ Extra classes appended to the @input@
    , checkboxLabelClasses :: [MisoString]
      -- ^ Extra classes appended to the wrapping @label@
    , checkboxAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: unchecked, enabled
  defaultCheckboxProps :: CheckboxProps model action
  defaultCheckboxProps
    = CheckboxProps
    { checkboxId = Nothing
    , checkboxName = Nothing
    , checkboxValue = Nothing
    , checkboxChecked = False
    , checkboxDisabled = False
    , checkboxClasses = []
    , checkboxLabelClasses = []
    , checkboxAttrs = []
    }
  """
-----------------------------------------------------------------------------
