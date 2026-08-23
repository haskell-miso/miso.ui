-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.DropDownMenu
  ( -- ** Props
    DropdownMenuProps (..)
  , defaultDropdownMenuProps
    -- ** Views
  , dropdownMenu_
  , menuItem_
  , menuCheckboxItem_
  , menuRadioItem_
  , menuGroup_
  , menuSeparator_
  , menuShortcut_
    -- ** Samples
  , dropdownMenuUsage
  , dropdownMenuSample
  , dropdownMenuCodeSample
  , dropdownMenuPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Icons
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props for 'dropdownMenu_'
data DropdownMenuProps context model action
  = DropdownMenuProps
  { dropdownMenuId :: MisoString
    -- ^ Base id; trigger\/popover\/menu ids are derived from it (required)
  , dropdownMenuTrigger :: [View context model action]
    -- ^ Content of the trigger button (nests other views)
  , dropdownMenuTriggerClasses :: [MisoString]
    -- ^ Classes of the trigger button (defaults to @btn-outline@)
  , dropdownMenuAlign :: Align
    -- ^ Popover alignment (@data-align@)
  , dropdownMenuPopoverClasses :: [MisoString]
    -- ^ Extra classes for the popover (e.g. @min-w-56@)
  , dropdownMenuAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: outline trigger button, no alignment override
defaultDropdownMenuProps :: DropdownMenuProps context model action
defaultDropdownMenuProps
  = DropdownMenuProps
  { dropdownMenuId = "dropdown-menu"
  , dropdownMenuTrigger = []
  , dropdownMenuTriggerClasses = [ "btn-outline" ]
  , dropdownMenuAlign = CenterAlign
  , dropdownMenuPopoverClasses = [ "min-w-56" ]
  , dropdownMenuAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/dropdown-menu/ Dropdown Menu>.
-- Children are 'menuItem_' \/ 'menuGroup_' \/ 'menuSeparator_' views.
dropdownMenu_
  :: DropdownMenuProps context model action
  -> [View context model action]
  -> View context model action
dropdownMenu_ cfg kids =
  H.div_
  ( P.class_ "dropdown-menu"
  : P.id_ (dropdownMenuId cfg)
  : dropdownMenuAttrs cfg
  )
  [ H.button_
    [ P.classes_ (dropdownMenuTriggerClasses cfg)
    , P.aria_ "expanded" "false"
    , P.aria_ "controls" (dropdownMenuId cfg <> "-menu")
    , P.aria_ "haspopup" "menu"
    , P.id_ (dropdownMenuId cfg <> "-trigger")
    , P.type_ "button"
    ]
    (dropdownMenuTrigger cfg)
  , H.div_
    ( concat
      [ [ P.classes_ (dropdownMenuPopoverClasses cfg)
        , P.aria_ "hidden" "true"
        , P.data_ "popover" ""
        , P.id_ (dropdownMenuId cfg <> "-popover")
        ]
      , [ P.data_ "align" (alignText (dropdownMenuAlign cfg))
        | dropdownMenuAlign cfg /= CenterAlign
        ]
      ]
    )
    [ H.div_
      [ P.aria_ "labelledby" (dropdownMenuId cfg <> "-trigger")
      , P.id_ (dropdownMenuId cfg <> "-menu")
      , P.role_ "menu"
      ]
      kids
    ]
  ]
-----------------------------------------------------------------------------
menuItem_
  :: [Attribute model action]
  -> [View context model action]
  -> View context model action
menuItem_ attrs kids = H.div_ (P.role_ "menuitem" : attrs) kids
-----------------------------------------------------------------------------
-- | Checkable menu item; the 'Bool' is the checked state
menuCheckboxItem_
  :: Bool
  -> [Attribute model action]
  -> [View context model action]
  -> View context model action
menuCheckboxItem_ checked attrs kids =
  H.div_
    ( P.class_ "group"
    : P.aria_ "checked" (if checked then "true" else "false")
    : P.role_ "menuitemcheckbox"
    : attrs
    )
    ( checkIcon
      [ P.aria_ "hidden" "true"
      , P.class_ "invisible group-aria-checked:visible"
      ]
    : kids
    )
-----------------------------------------------------------------------------
-- | Radio menu item; the 'Bool' is the selected state
menuRadioItem_
  :: Bool
  -> [Attribute model action]
  -> [View context model action]
  -> View context model action
menuRadioItem_ checked attrs kids =
  H.div_
    ( P.class_ "group"
    : P.aria_ "checked" (if checked then "true" else "false")
    : P.role_ "menuitemradio"
    : attrs
    )
    ( H.div_
      [ P.class_ "size-4 flex items-center justify-center" ]
      [ H.div_
        [ P.aria_ "hidden" "true"
        , P.class_ "size-2 rounded-full bg-foreground invisible group-aria-checked:visible"
        ]
        []
      ]
    : kids
    )
-----------------------------------------------------------------------------
-- | Labelled group of menu items
menuGroup_
  :: MisoString
  -- ^ heading id
  -> MisoString
  -- ^ heading text
  -> [View context model action]
  -> View context model action
menuGroup_ headingId heading kids =
  H.div_
  [ P.aria_ "labelledby" headingId
  , P.role_ "group"
  ]
  ( H.div_ [ P.id_ headingId, P.role_ "heading" ] [ text heading ]
  : kids
  )
-----------------------------------------------------------------------------
menuSeparator_ :: View context model action
menuSeparator_ = H.hr_ [ P.role_ "separator" ]
-----------------------------------------------------------------------------
-- | Right-aligned keyboard shortcut inside a menu item
menuShortcut_ :: MisoString -> View context model action
menuShortcut_ s =
  H.span_
  [ P.class_ "text-muted-foreground ml-auto text-xs tracking-widest" ]
  [ text s ]
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
dropdownMenuUsage :: View context model action
dropdownMenuUsage =
  dropdownMenu_ defaultDropdownMenuProps
  { dropdownMenuId = "my-dropdown"
  , dropdownMenuTrigger = [ "Open" ]
  }
  [ menuGroup_ "my-account-options" "My Account"
    [ menuItem_ [] [ "Profile", menuShortcut_ "⇧⌘P" ]
    , menuItem_ [] [ "Billing", menuShortcut_ "⌘B" ]
    ]
  , menuSeparator_
  , menuItem_ [] [ "GitHub" ]
  , menuItem_ [ P.aria_ "disabled" "true" ] [ "API" ]
  , menuSeparator_
  , menuCheckboxItem_ True [] [ "Status Bar" ]
  , menuRadioItem_ True [] [ "Activity Bar" ]
  ]
-----------------------------------------------------------------------------
dropdownMenuSample :: View context model action
dropdownMenuSample =
  H.div_
  [ P.class_ "flex flex-wrap items-start gap-4" ]
  [ dropdownMenu_ defaultDropdownMenuProps
    { dropdownMenuId = "dropdown-menu-default"
    , dropdownMenuTrigger = [ "Open" ]
    }
    [ menuGroup_ "account-options" "My Account"
      [ menuItem_ [] [ "Profile", menuShortcut_ "⇧⌘P" ]
      , menuItem_ [] [ "Billing", menuShortcut_ "⌘B" ]
      , menuItem_ [] [ "Settings", menuShortcut_ "⌘S" ]
      , menuItem_ [] [ "Keyboard shortcuts", menuShortcut_ "⌘K" ]
      ]
    , menuSeparator_
    , menuItem_ [] [ "GitHub" ]
    , menuItem_ [] [ "Support" ]
    , menuItem_ [ P.aria_ "disabled" "true" ] [ "API" ]
    , menuSeparator_
    , menuItem_ [] [ "Logout", menuShortcut_ "⇧⌘P" ]
    ]
  , dropdownMenu_ defaultDropdownMenuProps
    { dropdownMenuId = "dropdown-menu-checkboxes"
    , dropdownMenuTrigger = [ "Checkboxes" ]
    }
    [ menuGroup_ "appearance-options" "Appearance"
      [ menuCheckboxItem_ True [] [ "Status Bar", menuShortcut_ "⇧⌘P" ]
      , menuCheckboxItem_ False [ P.aria_ "disabled" "true" ]
        [ "Activity Bar", menuShortcut_ "⌘B" ]
      , menuCheckboxItem_ False [] [ "Panel", menuShortcut_ "⌘S" ]
      ]
    ]
  , dropdownMenu_ defaultDropdownMenuProps
    { dropdownMenuId = "dropdown-menu-radio-group"
    , dropdownMenuTrigger = [ "Radio Group" ]
    }
    [ menuGroup_ "position-options" "Panel Position"
      [ menuSeparator_
      , menuRadioItem_ False [] [ "Status Bar", menuShortcut_ "⇧⌘P" ]
      , menuRadioItem_ True [] [ "Activity Bar", menuShortcut_ "⌘B" ]
      , menuRadioItem_ False [] [ "Panel", menuShortcut_ "⌘S" ]
      ]
    ]
  , dropdownMenu_ defaultDropdownMenuProps
    { dropdownMenuId = "dropdown-menu-profile"
    , dropdownMenuTriggerClasses =
      [ "btn-outline", "h-12", "justify-start", "px-2", "md:max-w-[200px]" ]
    , dropdownMenuTrigger =
      [ H.img_
        [ P.class_ "size-8 shrink-0 rounded-full"
        , P.src_ "https://github.com/dmjio.png"
        , P.alt_ "@dmjio"
        ]
      , H.div_
        [ P.class_ "grid flex-1 text-left text-sm leading-tight" ]
        [ H.span_ [ P.class_ "truncate font-medium" ] [ "dmjio" ]
        , H.span_ [ P.class_ "text-muted-foreground truncate text-xs" ]
          [ "dmjio@example.com" ]
        ]
      , chevronsUpDownIcon [ P.class_ "text-muted-foreground ml-auto" ]
      ]
    }
    [ H.div_
      [ P.class_ "flex items-center gap-2 px-1 py-1.5 text-left text-sm" ]
      [ H.img_
        [ P.class_ "size-8 shrink-0 rounded-full"
        , P.src_ "https://github.com/dmjio.png"
        , P.alt_ "@dmjio"
        ]
      , H.div_
        [ P.class_ "grid flex-1 text-left text-sm leading-tight" ]
        [ H.span_ [ P.class_ "truncate font-medium" ] [ "dmjio" ]
        , H.span_ [ P.class_ "text-muted-foreground truncate text-xs" ]
          [ "dmjio@example.com" ]
        ]
      ]
    , menuSeparator_
    , menuItem_ [] [ "Upgrade to Pro" ]
    , menuSeparator_
    , menuItem_ [] [ "Account" ]
    , menuItem_ [] [ "Billing" ]
    , menuItem_ [] [ "Notifications" ]
    , menuSeparator_
    , menuItem_ [] [ "Signout" ]
    ]
  , dropdownMenu_ defaultDropdownMenuProps
    { dropdownMenuId = "dropdown-menu-dots"
    , dropdownMenuTriggerClasses = [ "btn-icon-ghost" ]
    , dropdownMenuTrigger = [ dotsIcon [] ]
    , dropdownMenuPopoverClasses = [ "min-w-32" ]
    }
    [ menuItem_ [] [ "Edit" ]
    , menuItem_ [] [ "Share" ]
    , menuSeparator_
    , menuItem_
      [ P.class_ "text-destructive hover:bg-destructive/10 dark:hover:bg-destructive/20 focus:bg-destructive/10 dark:focus:bg-destructive/20 focus:text-destructive [&_svg]:!text-destructive" ]
      [ trashIcon [], "Delete" ]
    ]
  ]
-----------------------------------------------------------------------------
dropdownMenuCodeSample :: View context model action
dropdownMenuCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyDropdownMenu (dropdownMenuUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Icons
  import           Miso.UI.Types
  import           Miso.UI.DropDownMenu
  -----------------------------------------------------------------------------
  dropdownMenuUsage :: View context model action
  dropdownMenuUsage =
    dropdownMenu_ defaultDropdownMenuProps
    { dropdownMenuId = "my-dropdown"
    , dropdownMenuTrigger = [ "Open" ]
    }
    [ menuGroup_ "my-account-options" "My Account"
      [ menuItem_ [] [ "Profile", menuShortcut_ "⇧⌘P" ]
      , menuItem_ [] [ "Billing", menuShortcut_ "⌘B" ]
      ]
    , menuSeparator_
    , menuItem_ [] [ "GitHub" ]
    , menuItem_ [ P.aria_ "disabled" "true" ] [ "API" ]
    , menuSeparator_
    , menuCheckboxItem_ True [] [ "Status Bar" ]
    , menuRadioItem_ True [] [ "Activity Bar" ]
    ]
  """
-----------------------------------------------------------------------------
dropdownMenuPropsApi :: View context model action
dropdownMenuPropsApi =
  """
  -- | Props for 'dropdownMenu_'
  data DropdownMenuProps context model action
    = DropdownMenuProps
    { dropdownMenuId :: MisoString
      -- ^ Base id; trigger\\/popover\\/menu ids are derived from it (required)
    , dropdownMenuTrigger :: [View context model action]
      -- ^ Content of the trigger button (nests other views)
    , dropdownMenuTriggerClasses :: [MisoString]
      -- ^ Classes of the trigger button (defaults to @btn-outline@)
    , dropdownMenuAlign :: Align
      -- ^ Popover alignment (@data-align@)
    , dropdownMenuPopoverClasses :: [MisoString]
      -- ^ Extra classes for the popover (e.g. @min-w-56@)
    , dropdownMenuAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: outline trigger button, no alignment override
  defaultDropdownMenuProps :: DropdownMenuProps context model action
  defaultDropdownMenuProps
    = DropdownMenuProps
    { dropdownMenuId = "dropdown-menu"
    , dropdownMenuTrigger = []
    , dropdownMenuTriggerClasses = [ "btn-outline" ]
    , dropdownMenuAlign = CenterAlign
    , dropdownMenuPopoverClasses = [ "min-w-56" ]
    , dropdownMenuAttrs = []
    }
  """
-----------------------------------------------------------------------------
