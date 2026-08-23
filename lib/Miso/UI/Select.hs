-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Select
  ( -- ** Props
    SelectProps (..)
  , defaultSelectProps
  , SelectMenuProps (..)
  , defaultSelectMenuProps
    -- ** Views
  , select_
  , selectMenu_
  , selectOption_
  , selectGroup_
    -- ** Samples
  , selectUsage
  , selectSample
  , selectCodeSample
  , selectPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Icons
-----------------------------------------------------------------------------
-- | Props for the native 'select_'
data SelectProps model action
  = SelectProps
  { selectId :: Maybe MisoString
  , selectDisabled :: Bool
  , selectClasses :: [MisoString]
    -- ^ Extra classes appended to @select@ (e.g. @w-[180px]@)
  , selectAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor for the native select
defaultSelectProps :: SelectProps model action
defaultSelectProps
  = SelectProps
  { selectId = Nothing
  , selectDisabled = False
  , selectClasses = [ "w-[180px]" ]
  , selectAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/native-select/ Native select>.
-- Children are native @optgroup_@ \/ @option_@ views.
select_
  :: SelectProps model action
  -> [View context model action]
  -> View context model action
select_ SelectProps {..} kids = H.select_
  ( concat
    [ [ P.classes_ ("select" : selectClasses) ]
    , [ P.id_ i | Just i <- [selectId] ]
    , [ P.disabled_ | selectDisabled ]
    , selectAttrs
    ]
  ) kids
-----------------------------------------------------------------------------
-- | Props for the popover-based 'selectMenu_' (basecoat JS select)
data SelectMenuProps context model action
  = SelectMenuProps
  { selectMenuId :: MisoString
    -- ^ Base id; trigger\/popover\/listbox ids are derived from it (required)
  , selectMenuLabel :: [View context model action]
    -- ^ Content of the trigger button (current selection)
  , selectMenuValue :: MisoString
    -- ^ Currently selected value (kept in a hidden input)
  , selectMenuDisabled :: Bool
  , selectMenuScrollable :: Bool
    -- ^ Constrain the listbox height and scroll (@max-h-64@)
  , selectMenuTriggerClasses :: [MisoString]
    -- ^ Extra classes for the trigger button
  , selectMenuAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor for the JS select
defaultSelectMenuProps :: SelectMenuProps context model action
defaultSelectMenuProps
  = SelectMenuProps
  { selectMenuId = "select-menu"
  , selectMenuLabel = []
  , selectMenuValue = ""
  , selectMenuDisabled = False
  , selectMenuScrollable = False
  , selectMenuTriggerClasses = [ "w-[180px]" ]
  , selectMenuAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/select/ Select> (popover listbox).
-- Children are 'selectOption_' \/ 'selectGroup_' views.
selectMenu_
  :: SelectMenuProps context model action
  -> [View context model action]
  -> View context model action
selectMenu_ cfg kids =
  H.div_
  ( P.class_ "select"
  : P.id_ (selectMenuId cfg)
  : selectMenuAttrs cfg
  )
  [ H.button_
    ( concat
      [ [ P.type_ "button"
        , P.classes_
          ( "btn-outline" : "justify-between" : "font-normal"
          : selectMenuTriggerClasses cfg
          )
        , P.id_ (selectMenuId cfg <> "-trigger")
        , P.aria_ "haspopup" "listbox"
        , P.aria_ "expanded" "false"
        , P.aria_ "controls" (selectMenuId cfg <> "-listbox")
        ]
      , [ P.disabled_ | selectMenuDisabled cfg ]
      ]
    )
    [ H.span_ [ P.class_ "truncate" ] (selectMenuLabel cfg)
    , chevronDownIcon
      [ P.class_ "text-muted-foreground opacity-50 shrink-0" ]
    ]
  , H.div_
    [ P.aria_ "hidden" "true"
    , P.data_ "popover" ""
    , P.id_ (selectMenuId cfg <> "-popover")
    ]
    [ H.div_
      ( concat
        [ [ P.aria_ "labelledby" (selectMenuId cfg <> "-trigger")
          , P.aria_ "orientation" "vertical"
          , P.id_ (selectMenuId cfg <> "-listbox")
          , P.role_ "listbox"
          ]
        , [ P.class_ "scrollbar overflow-y-auto max-h-64" | selectMenuScrollable cfg ]
        ]
      ) kids
    ]
  , H.input_
    [ P.type_ "hidden"
    , P.name_ (selectMenuId cfg <> "-value")
    , P.value_ (selectMenuValue cfg)
    ]
  ]
-----------------------------------------------------------------------------
-- | Option inside 'selectMenu_'; the 'Bool' marks the current selection
selectOption_
  :: Bool
  -> MisoString
  -> [View context model action]
  -> View context model action
selectOption_ selected value kids =
  optionalAttrs
    H.div_
    [ P.data_ "value" value
    , P.role_ "option"
    ]
    selected
    [ P.aria_ "selected" "true" ]
    kids
-----------------------------------------------------------------------------
-- | Labelled group of options inside 'selectMenu_'
selectGroup_
  :: MisoString
  -- ^ group heading id
  -> MisoString
  -- ^ heading text
  -> [View context model action]
  -> View context model action
selectGroup_ headingId heading kids =
  H.div_
  [ P.aria_ "labelledby" headingId
  , P.role_ "group"
  ]
  ( H.div_ [ P.id_ headingId, P.role_ "heading" ] [ text heading ]
  : kids
  )
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
selectUsage :: View context model action
selectUsage =
  H.div_
  [ P.class_ "flex flex-wrap items-center gap-2" ]
  [ select_ defaultSelectProps
    [ H.optgroup_
      [ P.label_ "Fruits" ]
      [ H.option_ [] [ "Apple" ]
      , H.option_ [] [ "Banana" ]
      ]
    ]
  , selectMenu_ defaultSelectMenuProps
    { selectMenuId = "my-select"
    , selectMenuLabel = [ "Blueberry" ]
    , selectMenuValue = "blueberry"
    }
    [ selectOption_ False "apple" [ "Apple" ]
    , selectOption_ True "blueberry" [ "Blueberry" ]
    ]
  ]
-----------------------------------------------------------------------------
selectSample :: View context model action
selectSample =
  H.div_
  [ P.class_ "flex flex-col gap-4" ]
  [ H.div_
    [ P.class_ "flex flex-wrap items-center gap-2 md:flex-row" ]
    [ select_ defaultSelectProps
      [ H.optgroup_
        [ P.label_ "Fruits" ]
        [ H.option_ [] [ "Apple" ]
        , H.option_ [] [ "Banana" ]
        , H.option_ [] [ "Blueberry" ]
        ]
      , H.optgroup_
        [ P.label_ "Grapes" ]
        [ H.option_ [] [ "Pineapple" ] ]
      ]
    , select_ defaultSelectProps { selectDisabled = True }
      [ H.option_ [] [ "Disabled" ] ]
    ]
  , H.div_
    [ P.class_ "flex flex-wrap items-center gap-2 md:flex-row" ]
    [ selectMenu_ defaultSelectMenuProps
      { selectMenuId = "select-default"
      , selectMenuLabel = [ "Blueberry" ]
      , selectMenuValue = "blueberry"
      }
      [ selectGroup_ "group-label-select-default-items-1" "Fruits"
        [ selectOption_ False "apple" [ "Apple" ]
        , selectOption_ False "banana" [ "Banana" ]
        , selectOption_ True "blueberry" [ "Blueberry" ]
        ]
      , selectGroup_ "group-label-select-default-items-2" "Grapes"
        [ selectOption_ False "pineapple" [ "Pineapple" ] ]
      ]
    , selectMenu_ defaultSelectMenuProps
      { selectMenuId = "select-scrollbar"
      , selectMenuLabel = [ "Item 0" ]
      , selectMenuValue = "item-0"
      , selectMenuScrollable = True
      }
      [ selectOption_ (i == (0 :: Int)) ("item-" <> ms i) [ text ("Item " <> ms i) ]
      | i <- [ 0 .. 98 ]
      ]
    , selectMenu_ defaultSelectMenuProps
      { selectMenuId = "select-disabled"
      , selectMenuLabel = [ "Disabled" ]
      , selectMenuValue = "disabled"
      , selectMenuDisabled = True
      }
      [ selectOption_ True "disabled" [ "Disabled" ] ]
    ]
  ]
-----------------------------------------------------------------------------
selectCodeSample :: View context model action
selectCodeSample =
  """
  -----------------------------------------------------------------------------
  module MySelect (selectUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Icons
  import           Miso.UI.Select
  -----------------------------------------------------------------------------
  selectUsage :: View context model action
  selectUsage =
    H.div_
    [ P.class_ "flex flex-wrap items-center gap-2" ]
    [ select_ defaultSelectProps
      [ H.optgroup_
        [ P.label_ "Fruits" ]
        [ H.option_ [] [ "Apple" ]
        , H.option_ [] [ "Banana" ]
        ]
      ]
    , selectMenu_ defaultSelectMenuProps
      { selectMenuId = "my-select"
      , selectMenuLabel = [ "Blueberry" ]
      , selectMenuValue = "blueberry"
      }
      [ selectOption_ False "apple" [ "Apple" ]
      , selectOption_ True "blueberry" [ "Blueberry" ]
      ]
    ]
  """
-----------------------------------------------------------------------------
selectPropsApi :: View context model action
selectPropsApi =
  """
  -- | Props for the native 'select_'
  data SelectProps model action
    = SelectProps
    { selectId :: Maybe MisoString
    , selectDisabled :: Bool
    , selectClasses :: [MisoString]
      -- ^ Extra classes appended to @select@ (e.g. @w-[180px]@)
    , selectAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor for the native select
  defaultSelectProps :: SelectProps model action
  defaultSelectProps
    = SelectProps
    { selectId = Nothing
    , selectDisabled = False
    , selectClasses = [ "w-[180px]" ]
    , selectAttrs = []
    }
  -----------------------------------------------------------------------------
  -- | Props for the popover-based 'selectMenu_' (basecoat JS select)
  data SelectMenuProps context model action
    = SelectMenuProps
    { selectMenuId :: MisoString
      -- ^ Base id; trigger\\/popover\\/listbox ids are derived from it (required)
    , selectMenuLabel :: [View context model action]
      -- ^ Content of the trigger button (current selection)
    , selectMenuValue :: MisoString
      -- ^ Currently selected value (kept in a hidden input)
    , selectMenuDisabled :: Bool
    , selectMenuScrollable :: Bool
      -- ^ Constrain the listbox height and scroll (@max-h-64@)
    , selectMenuTriggerClasses :: [MisoString]
      -- ^ Extra classes for the trigger button
    , selectMenuAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor for the JS select
  defaultSelectMenuProps :: SelectMenuProps context model action
  defaultSelectMenuProps
    = SelectMenuProps
    { selectMenuId = "select-menu"
    , selectMenuLabel = []
    , selectMenuValue = ""
    , selectMenuDisabled = False
    , selectMenuScrollable = False
    , selectMenuTriggerClasses = [ "w-[180px]" ]
    , selectMenuAttrs = []
    }
  """
-----------------------------------------------------------------------------
