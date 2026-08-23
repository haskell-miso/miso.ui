-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Switch
  ( -- ** Props
    SwitchProps (..)
  , defaultSwitchProps
    -- ** Views
  , switch_
  , switchInput_
    -- ** Samples
  , switchSample
  , switchCodeSample
  , switchPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
-- | Props for 'switch_'
data SwitchProps model action
  = SwitchProps
  { switchId :: Maybe MisoString
  , switchName :: MisoString
  , switchChecked :: Bool
  , switchDisabled :: Bool
  , switchClasses :: [MisoString]
    -- ^ Extra classes appended to the @input@ (e.g. @checked:bg-blue-500@)
  , switchLabelClasses :: [MisoString]
    -- ^ Extra classes appended to the wrapping @label@
  , switchAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: unchecked, enabled
defaultSwitchProps :: SwitchProps model action
defaultSwitchProps
  = SwitchProps
  { switchId = Nothing
  , switchName = "switch"
  , switchChecked = False
  , switchDisabled = False
  , switchClasses = []
  , switchLabelClasses = []
  , switchAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/switch/ Switch>: label-wrapped switch input.
-- The children render as the label text.
switch_
  :: SwitchProps model action
  -> [View context model action]
  -> View context model action
switch_ cfg kids =
  H.label_
  [ P.classes_ ("label" : switchLabelClasses cfg) ]
  ( switchInput_ cfg : kids )
-----------------------------------------------------------------------------
-- | The bare switch @input@, for custom layouts
switchInput_ :: SwitchProps model action -> View context model action
switchInput_ SwitchProps {..} = H.input_ $ concat
  [ [ P.classes_ ("input" : switchClasses)
    , P.type_ "checkbox"
    , P.role_ "switch"
    , P.name_ switchName
    ]
  , [ P.id_ i | Just i <- [switchId] ]
  , [ P.checked_ True | switchChecked ]
  , [ P.disabled_ | switchDisabled ]
  , switchAttrs
  ]
-----------------------------------------------------------------------------
switchSample :: View context model action
switchSample =
  H.div_
  [ P.class_ "inline-flex flex-col gap-y-6" ]
  [ switch_ defaultSwitchProps [ "Airplane Mode" ]
  , switch_ defaultSwitchProps
    { switchChecked = True
    , switchClasses = [ "checked:bg-blue-500", "dark:checked:bg-blue-600" ]
    }
    [ "Bluetooth" ]
  , H.label_
    [ P.class_ "label gap-6 leading-none border rounded-lg p-4 has-[input[type='checkbox']:checked]:border-blue-600" ]
    [ H.div_
      [ P.class_ "grid gap-1" ]
      [ H.h2_ [ P.class_ "font-medium text-sm" ] [ "Share across devices" ]
      , H.p_
        [ P.class_ "text-muted-foreground text-sm" ]
        [ "Focus is shared across devices, and turns off when you leave the app." ]
      ]
    , switchInput_ defaultSwitchProps
      { switchClasses = [ "checked:bg-blue-500", "dark:checked:bg-blue-600" ]
      }
    ]
  ]
-----------------------------------------------------------------------------
switchCodeSample :: View context model action
switchCodeSample =
  """
  -----------------------------------------------------------------------------
  module MySwitch (switchSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Switch
  -----------------------------------------------------------------------------
  switchSample :: View context model action
  switchSample =
    H.div_
    [ P.class_ "inline-flex flex-col gap-y-6" ]
    [ switch_ defaultSwitchProps [ "Airplane Mode" ]
    , switch_ defaultSwitchProps
      { switchChecked = True
      , switchClasses = [ "checked:bg-blue-500", "dark:checked:bg-blue-600" ]
      }
      [ "Bluetooth" ]
    , H.label_
      [ P.class_ "label gap-6 leading-none border rounded-lg p-4 has-[input[type='checkbox']:checked]:border-blue-600" ]
      [ H.div_
        [ P.class_ "grid gap-1" ]
        [ H.h2_ [ P.class_ "font-medium text-sm" ] [ "Share across devices" ]
        , H.p_
          [ P.class_ "text-muted-foreground text-sm" ]
          [ "Focus is shared across devices, and turns off when you leave the app." ]
        ]
      , switchInput_ defaultSwitchProps
        { switchClasses = [ "checked:bg-blue-500", "dark:checked:bg-blue-600" ]
        }
      ]
    ]
  """
-----------------------------------------------------------------------------
switchPropsApi :: View context model action
switchPropsApi =
  """
  -- | Props for 'switch_'
  data SwitchProps model action
    = SwitchProps
    { switchId :: Maybe MisoString
    , switchName :: MisoString
    , switchChecked :: Bool
    , switchDisabled :: Bool
    , switchClasses :: [MisoString]
      -- ^ Extra classes appended to the @input@ (e.g. @checked:bg-blue-500@)
    , switchLabelClasses :: [MisoString]
      -- ^ Extra classes appended to the wrapping @label@
    , switchAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: unchecked, enabled
  defaultSwitchProps :: SwitchProps model action
  defaultSwitchProps
    = SwitchProps
    { switchId = Nothing
    , switchName = "switch"
    , switchChecked = False
    , switchDisabled = False
    , switchClasses = []
    , switchLabelClasses = []
    , switchAttrs = []
    }
  """
-----------------------------------------------------------------------------
