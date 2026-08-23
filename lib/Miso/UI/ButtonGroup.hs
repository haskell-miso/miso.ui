-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.ButtonGroup
  ( -- ** Props
    ButtonGroupProps (..)
  , defaultButtonGroupProps
    -- ** Views
  , buttonGroup_
    -- ** Samples
  , buttonGroupUsage
  , buttonGroupSample
  , buttonGroupCodeSample
  , buttonGroupPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Button
import           Miso.UI.DropDownMenu
import           Miso.UI.Icons
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props for 'buttonGroup_'
data ButtonGroupProps model action
  = ButtonGroupProps
  { buttonGroupClasses :: [MisoString]
    -- ^ Extra classes appended to @div.button-group@
  , buttonGroupAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultButtonGroupProps :: ButtonGroupProps model action
defaultButtonGroupProps
  = ButtonGroupProps
  { buttonGroupClasses = []
  , buttonGroupAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/button-group/ Button Group>: attached
-- row of buttons (children are typically 'Miso.UI.Button.button_' views)
buttonGroup_
  :: ButtonGroupProps model action
  -> [View context model action]
  -> View context model action
buttonGroup_ ButtonGroupProps {..} kids =
  H.div_
    ( P.classes_ ("button-group" : buttonGroupClasses)
    : P.role_ "group"
    : buttonGroupAttrs
    ) kids
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
buttonGroupUsage :: View context model action
buttonGroupUsage =
  buttonGroup_ defaultButtonGroupProps
  [ button_ defaultButtonProps { buttonVariant = Outline } [ "Archive" ]
  , button_ defaultButtonProps { buttonVariant = Outline } [ "Report" ]
  , button_ defaultButtonProps { buttonVariant = Outline, buttonIcon = True }
    [ dotsIcon [] ]
  ]
-----------------------------------------------------------------------------
buttonGroupSample :: View context model action
buttonGroupSample =
  H.div_
  [ P.class_ "flex w-fit items-stretch gap-2" ]
  [ button_ defaultButtonProps
    { buttonIcon = True
    , buttonVariant = Outline
    , buttonAttrs = [ P.aria_ "label" "Go Back" ]
    }
    [ arrowLeftIcon [] ]
  , buttonGroup_ defaultButtonGroupProps
    [ button_ defaultButtonProps { buttonVariant = Outline } [ "Archive" ]
    , button_ defaultButtonProps { buttonVariant = Outline } [ "Report" ]
    ]
  , buttonGroup_ defaultButtonGroupProps
    [ button_ defaultButtonProps { buttonVariant = Outline } [ "Snooze" ]
    , dropdownMenu_ defaultDropdownMenuProps
      { dropdownMenuId = "dropdown-menu-button-group"
      , dropdownMenuTriggerClasses = [ "btn-icon-outline" ]
      , dropdownMenuTrigger = [ dotsIcon [] ]
      , dropdownMenuAlign = EndAlign
      }
      [ menuItem_ [] [ "Mark as Read" ]
      , menuItem_ [] [ "Archive" ]
      , menuSeparator_
      , menuItem_ [] [ "Snooze" ]
      , menuItem_ [] [ "Add to Calendar" ]
      , menuItem_ [] [ "Add to List" ]
      , menuSeparator_
      , menuItem_
        [ P.class_ "text-destructive hover:bg-destructive/10 dark:hover:bg-destructive/20 focus:bg-destructive/10 dark:focus:bg-destructive/20 focus:text-destructive [&_svg]:!text-destructive" ]
        [ trashIcon [], "Trash" ]
      ]
    ]
  ]
-----------------------------------------------------------------------------
buttonGroupCodeSample :: View context model action
buttonGroupCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyButtonGroup (buttonGroupUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Button
  import           Miso.UI.DropDownMenu
  import           Miso.UI.Icons
  import           Miso.UI.Types
  import           Miso.UI.ButtonGroup
  -----------------------------------------------------------------------------
  buttonGroupUsage :: View context model action
  buttonGroupUsage =
    buttonGroup_ defaultButtonGroupProps
    [ button_ defaultButtonProps { buttonVariant = Outline } [ "Archive" ]
    , button_ defaultButtonProps { buttonVariant = Outline } [ "Report" ]
    , button_ defaultButtonProps { buttonVariant = Outline, buttonIcon = True }
      [ dotsIcon [] ]
    ]
  """
-----------------------------------------------------------------------------
buttonGroupPropsApi :: View context model action
buttonGroupPropsApi =
  """
  -- | Props for 'buttonGroup_'
  data ButtonGroupProps model action
    = ButtonGroupProps
    { buttonGroupClasses :: [MisoString]
      -- ^ Extra classes appended to @div.button-group@
    , buttonGroupAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultButtonGroupProps :: ButtonGroupProps model action
  defaultButtonGroupProps
    = ButtonGroupProps
    { buttonGroupClasses = []
    , buttonGroupAttrs = []
    }
  """
-----------------------------------------------------------------------------
