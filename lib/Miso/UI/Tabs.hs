-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Tabs
  ( -- ** Props
    TabsProps (..)
  , defaultTabsProps
  , TabButtonProps (..)
  , defaultTabButtonProps
  , TabPanelProps (..)
  , defaultTabPanelProps
    -- ** Views
  , tabs_
  , tabList_
  , tabButton_
  , tab_
    -- ** Samples
  , tabsUsage
  , tabsSample
  , tabsCodeSample
  , tabsPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
-- | Props for 'tabs_'
data TabsProps model action
  = TabsProps
  { tabsId :: MisoString
    -- ^ id of the tabs root (basecoat JS keys off it; required)
  , tabsClasses :: [MisoString]
    -- ^ Extra classes appended to @div.tabs@
  , tabsAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultTabsProps :: TabsProps model action
defaultTabsProps
  = TabsProps
  { tabsId = "tabs"
  , tabsClasses = [ "w-full" ]
  , tabsAttrs = []
  }
-----------------------------------------------------------------------------
-- | Props for 'tabButton_'
data TabButtonProps model action
  = TabButtonProps
  { tabButtonId :: MisoString
    -- ^ id of this tab button (matched by the panel's @aria-labelledby@)
  , tabButtonControls :: MisoString
    -- ^ id of the controlled panel
  , tabButtonSelected :: Bool
  , tabButtonDisabled :: Bool
  , tabButtonAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: unselected tab
defaultTabButtonProps :: TabButtonProps model action
defaultTabButtonProps
  = TabButtonProps
  { tabButtonId = ""
  , tabButtonControls = ""
  , tabButtonSelected = False
  , tabButtonDisabled = False
  , tabButtonAttrs = []
  }
-----------------------------------------------------------------------------
-- | Props for 'tab_' (a tab panel)
data TabPanelProps model action
  = TabPanelProps
  { tabPanelId :: MisoString
    -- ^ id of the panel (matched by the button's @aria-controls@)
  , tabPanelLabelledBy :: MisoString
    -- ^ id of the button labelling this panel
  , tabPanelSelected :: Bool
  , tabPanelAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: hidden panel
defaultTabPanelProps :: TabPanelProps model action
defaultTabPanelProps
  = TabPanelProps
  { tabPanelId = ""
  , tabPanelLabelledBy = ""
  , tabPanelSelected = False
  , tabPanelAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/tabs/ Tabs>, driven by 'TabsProps'
tabs_
  :: TabsProps model action
  -> [View context props model action]
  -> View context props model action
tabs_ TabsProps {..} kids =
  H.div_
    ( P.classes_ ("tabs" : tabsClasses)
    : P.id_ tabsId
    : tabsAttrs
    ) kids
-----------------------------------------------------------------------------
tabList_
  :: [Attribute model action]
  -> [View context props model action]
  -> View context props model action
tabList_ attrs kids =
  H.nav_
    ( P.class_ "w-full"
    : P.role_ "tablist"
    : P.aria_ "orientation" "horizontal"
    : attrs
    ) kids
-----------------------------------------------------------------------------
tabButton_
  :: TabButtonProps model action
  -> [View context props model action]
  -> View context props model action
tabButton_ TabButtonProps {..} kids =
  H.button_
    ( concat
      [ [ P.role_ "tab"
        , P.type_ "button"
        , P.id_ tabButtonId
        , P.aria_ "controls" tabButtonControls
        , P.aria_ "selected" (if tabButtonSelected then "true" else "false")
        , P.tabindex_ "0"
        ]
      , [ P.disabled_ | tabButtonDisabled ]
      , tabButtonAttrs
      ]
    ) kids
-----------------------------------------------------------------------------
tab_
  :: TabPanelProps model action
  -> [View context props model action]
  -> View context props model action
tab_ TabPanelProps {..} kids =
  H.div_
    ( concat
      [ [ P.role_ "tabpanel"
        , P.id_ tabPanelId
        , P.aria_ "labelledby" tabPanelLabelledBy
        , P.aria_ "selected" (if tabPanelSelected then "true" else "false")
        , P.tabindex_ (if tabPanelSelected then "0" else "-1")
        , P.hidden_ (not tabPanelSelected)
        ]
      , tabPanelAttrs
      ]
    ) kids
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
tabsUsage :: View context props model action
tabsUsage =
  tabs_ defaultTabsProps { tabsId = "my-tabs" }
  [ tabList_ []
    [ tabButton_ defaultTabButtonProps
      { tabButtonId = "my-tabs-tab-1"
      , tabButtonControls = "my-tabs-panel-1"
      , tabButtonSelected = True
      }
      [ "Account" ]
    , tabButton_ defaultTabButtonProps
      { tabButtonId = "my-tabs-tab-2"
      , tabButtonControls = "my-tabs-panel-2"
      }
      [ "Password" ]
    ]
  , tab_ defaultTabPanelProps
    { tabPanelId = "my-tabs-panel-1"
    , tabPanelLabelledBy = "my-tabs-tab-1"
    , tabPanelSelected = True
    }
    [ "Account panel" ]
  , tab_ defaultTabPanelProps
    { tabPanelId = "my-tabs-panel-2"
    , tabPanelLabelledBy = "my-tabs-tab-2"
    }
    [ "Password panel" ]
  ]
-----------------------------------------------------------------------------
tabsSample :: View context props model action
tabsSample =
  H.div_
  [ P.class_ "flex flex-col gap-6" ]
  [ tabs_ defaultTabsProps
    { tabsId = "demo-tabs-with-panels-tabs"
    , tabsClasses = [ "max-w-[300px]" ]
    }
    [ tabList_ []
      [ tabButton_ defaultTabButtonProps
        { tabButtonId = "demo-tabs-with-panels-tab-tabs-1"
        , tabButtonControls = "demo-tabs-with-panels-panel-tabs-1"
        , tabButtonSelected = True
        }
        [ "Account" ]
      , tabButton_ defaultTabButtonProps
        { tabButtonId = "demo-tabs-with-panels-tab-tabs-2"
        , tabButtonControls = "demo-tabs-with-panels-panel-tabs-2"
        }
        [ "Password" ]
      ]
    , tab_ defaultTabPanelProps
      { tabPanelId = "demo-tabs-with-panels-panel-tabs-1"
      , tabPanelLabelledBy = "demo-tabs-with-panels-tab-tabs-1"
      , tabPanelSelected = True
      }
      [ panelCard "Account"
          "Make changes to your account here. Click save when you're done."
          "Save changes"
          [ ("demo-tabs-account-name", "Name", "text", Just "Pedro Duarte")
          , ("demo-tabs-account-username", "Username", "text", Just "@peduarte")
          ]
      ]
    , tab_ defaultTabPanelProps
      { tabPanelId = "demo-tabs-with-panels-panel-tabs-2"
      , tabPanelLabelledBy = "demo-tabs-with-panels-tab-tabs-2"
      }
      [ panelCard "Password"
          "Change your password here. After saving, you'll be logged out."
          "Save Password"
          [ ("demo-tabs-password-current", "Current password", "password", Nothing)
          , ("demo-tabs-password-new", "New password", "password", Nothing)
          ]
      ]
    ]
  , tabs_ defaultTabsProps
    { tabsId = "demo-tabs-without-panels"
    , tabsClasses = []
    }
    [ tabList_ []
      [ tabButton_ defaultTabButtonProps
        { tabButtonId = "demo-tabs-without-panels-tab-1"
        , tabButtonControls = "demo-tabs-without-panels-panel-1"
        , tabButtonSelected = True
        }
        [ "Home" ]
      , tabButton_ defaultTabButtonProps
        { tabButtonId = "demo-tabs-without-panels-tab-2"
        , tabButtonControls = "demo-tabs-without-panels-panel-2"
        }
        [ "Settings" ]
      ]
    ]
  , tabs_ defaultTabsProps
    { tabsId = "demo-tabs-disabled"
    , tabsClasses = []
    }
    [ tabList_ []
      [ tabButton_ defaultTabButtonProps
        { tabButtonId = "demo-tabs-disabled-tab-1"
        , tabButtonControls = "demo-tabs-disabled-panel-1"
        , tabButtonSelected = True
        }
        [ "Home" ]
      , tabButton_ defaultTabButtonProps
        { tabButtonId = "demo-tabs-disabled-tab-2"
        , tabButtonControls = "demo-tabs-disabled-panel-2"
        , tabButtonDisabled = True
        }
        [ "Disabled" ]
      ]
    ]
  ]
  where
    panelCard title description buttonLabel fields =
      H.div_
      [ P.class_ "card" ]
      [ H.header_ []
        [ H.h2_ [] [ text title ]
        , H.p_ [] [ text description ]
        ]
      , H.section_ []
        [ H.form_
          [ P.class_ "form grid gap-6" ]
          [ H.div_
            [ P.class_ "grid gap-3" ]
            [ H.label_ [ P.for_ fieldId ] [ text labelText ]
            , H.input_
              ( concat
                [ [ P.id_ fieldId, P.type_ ty ]
                , [ P.value_ v | Just v <- [val] ]
                ]
              )
            ]
          | (fieldId, labelText, ty, val) <- fields
          ]
        ]
      , H.footer_ []
        [ H.button_ [ P.class_ "btn", P.type_ "button" ] [ text buttonLabel ]
        ]
      ]
-----------------------------------------------------------------------------
tabsCodeSample :: View context props model action
tabsCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyTabs (tabsUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Tabs
  -----------------------------------------------------------------------------
  tabsUsage :: View context props model action
  tabsUsage =
    tabs_ defaultTabsProps { tabsId = "my-tabs" }
    [ tabList_ []
      [ tabButton_ defaultTabButtonProps
        { tabButtonId = "my-tabs-tab-1"
        , tabButtonControls = "my-tabs-panel-1"
        , tabButtonSelected = True
        }
        [ "Account" ]
      , tabButton_ defaultTabButtonProps
        { tabButtonId = "my-tabs-tab-2"
        , tabButtonControls = "my-tabs-panel-2"
        }
        [ "Password" ]
      ]
    , tab_ defaultTabPanelProps
      { tabPanelId = "my-tabs-panel-1"
      , tabPanelLabelledBy = "my-tabs-tab-1"
      , tabPanelSelected = True
      }
      [ "Account panel" ]
    , tab_ defaultTabPanelProps
      { tabPanelId = "my-tabs-panel-2"
      , tabPanelLabelledBy = "my-tabs-tab-2"
      }
      [ "Password panel" ]
    ]
  """
-----------------------------------------------------------------------------
tabsPropsApi :: View context props model action
tabsPropsApi =
  """
  -- | Props for 'tabs_'
  data TabsProps model action
    = TabsProps
    { tabsId :: MisoString
      -- ^ id of the tabs root (basecoat JS keys off it; required)
    , tabsClasses :: [MisoString]
      -- ^ Extra classes appended to @div.tabs@
    , tabsAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultTabsProps :: TabsProps model action
  defaultTabsProps
    = TabsProps
    { tabsId = "tabs"
    , tabsClasses = [ "w-full" ]
    , tabsAttrs = []
    }
  -----------------------------------------------------------------------------
  -- | Props for 'tabButton_'
  data TabButtonProps model action
    = TabButtonProps
    { tabButtonId :: MisoString
      -- ^ id of this tab button (matched by the panel's @aria-labelledby@)
    , tabButtonControls :: MisoString
      -- ^ id of the controlled panel
    , tabButtonSelected :: Bool
    , tabButtonDisabled :: Bool
    , tabButtonAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: unselected tab
  defaultTabButtonProps :: TabButtonProps model action
  defaultTabButtonProps
    = TabButtonProps
    { tabButtonId = ""
    , tabButtonControls = ""
    , tabButtonSelected = False
    , tabButtonDisabled = False
    , tabButtonAttrs = []
    }
  -----------------------------------------------------------------------------
  -- | Props for 'tab_' (a tab panel)
  data TabPanelProps model action
    = TabPanelProps
    { tabPanelId :: MisoString
      -- ^ id of the panel (matched by the button's @aria-controls@)
    , tabPanelLabelledBy :: MisoString
      -- ^ id of the button labelling this panel
    , tabPanelSelected :: Bool
    , tabPanelAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: hidden panel
  defaultTabPanelProps :: TabPanelProps model action
  defaultTabPanelProps
    = TabPanelProps
    { tabPanelId = ""
    , tabPanelLabelledBy = ""
    , tabPanelSelected = False
    , tabPanelAttrs = []
    }
  """
-----------------------------------------------------------------------------
