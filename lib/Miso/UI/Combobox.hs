-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Combobox
  ( -- ** Props
    ComboboxProps (..)
  , defaultComboboxProps
    -- ** Views
  , combobox_
  , comboboxOption_
  , comboboxGroup_
    -- ** Samples
  , comboboxUsage
  , comboboxSample
  , comboboxCodeSample
  , comboboxPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
import qualified Miso.Svg           as S
import qualified Miso.Svg.Property  as SP
-----------------------------------------------------------------------------
import           Miso.UI.Icons
-----------------------------------------------------------------------------
-- | Props for 'combobox_'
data ComboboxProps context props model action
  = ComboboxProps
  { comboboxId :: MisoString
    -- ^ Base id; trigger\/popover\/listbox ids are derived from it (required)
  , comboboxLabel :: [View context props model action]
    -- ^ Content of the trigger button (current selection)
  , comboboxValue :: MisoString
    -- ^ Currently selected value (kept in a hidden input)
  , comboboxSearchPlaceholder :: MisoString
  , comboboxEmptyText :: MisoString
    -- ^ Shown when the search yields nothing (@data-empty@)
  , comboboxPopoverClasses :: [MisoString]
    -- ^ Extra classes for the popover (e.g. @w-48@)
  , comboboxTriggerClasses :: [MisoString]
    -- ^ Extra classes for the trigger button
  , comboboxAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultComboboxProps :: ComboboxProps context props model action
defaultComboboxProps
  = ComboboxProps
  { comboboxId = "combobox"
  , comboboxLabel = []
  , comboboxValue = ""
  , comboboxSearchPlaceholder = "Search entries..."
  , comboboxEmptyText = "No results found."
  , comboboxPopoverClasses = [ "w-48" ]
  , comboboxTriggerClasses = []
  , comboboxAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/combobox/ Combobox>: searchable select.
-- Children are 'comboboxOption_' \/ 'comboboxGroup_' views.
combobox_
  :: ComboboxProps context props model action
  -> [View context props model action]
  -> View context props model action
combobox_ cfg kids =
  H.div_
  ( P.class_ "select"
  : P.id_ (comboboxId cfg)
  : comboboxAttrs cfg
  )
  [ H.button_
    [ P.type_ "button"
    , P.classes_
      ( "btn-outline" : "justify-between" : "font-normal"
      : comboboxTriggerClasses cfg
      )
    , P.id_ (comboboxId cfg <> "-trigger")
    , P.aria_ "haspopup" "listbox"
    , P.aria_ "expanded" "false"
    , P.aria_ "controls" (comboboxId cfg <> "-listbox")
    ]
    [ H.span_ [ P.class_ "truncate" ] (comboboxLabel cfg)
    , chevronsUpDownIcon
      [ P.class_ "text-muted-foreground opacity-50 shrink-0" ]
    ]
  , H.div_
    [ P.classes_ (comboboxPopoverClasses cfg)
    , P.aria_ "hidden" "true"
    , P.data_ "popover" ""
    , P.id_ (comboboxId cfg <> "-popover")
    ]
    [ H.header_ []
      [ searchIcon []
      , H.input_
        [ P.type_ "text"
        , P.placeholder_ (comboboxSearchPlaceholder cfg)
        , P.autocomplete_ "off"
        , P.autocorrect_ False
        , P.spellcheck_ False
        , P.aria_ "autocomplete" "list"
        , P.role_ "combobox"
        , P.aria_ "expanded" "false"
        , P.aria_ "controls" (comboboxId cfg <> "-listbox")
        , P.aria_ "labelledby" (comboboxId cfg <> "-trigger")
        ]
      ]
    , H.div_
      [ P.role_ "listbox"
      , P.id_ (comboboxId cfg <> "-listbox")
      , P.aria_ "orientation" "vertical"
      , P.aria_ "labelledby" (comboboxId cfg <> "-trigger")
      , P.data_ "empty" (comboboxEmptyText cfg)
      ]
      kids
    ]
  , H.input_
    [ P.type_ "hidden"
    , P.name_ (comboboxId cfg <> "-value")
    , P.value_ (comboboxValue cfg)
    ]
  ]
-----------------------------------------------------------------------------
-- | Option inside 'combobox_'; the 'Bool' marks the current selection
comboboxOption_
  :: Bool
  -> MisoString
  -> [View context props model action]
  -> View context props model action
comboboxOption_ selected value kids =
  optionalAttrs
    H.div_
    [ P.data_ "value" value
    , P.role_ "option"
    ]
    selected
    [ P.aria_ "selected" "true" ]
    kids
-----------------------------------------------------------------------------
-- | Labelled group of options inside 'combobox_'
comboboxGroup_
  :: MisoString
  -- ^ group heading id
  -> MisoString
  -- ^ heading text
  -> [View context props model action]
  -> View context props model action
comboboxGroup_ headingId heading kids =
  H.div_
  [ P.aria_ "labelledby" headingId
  , P.role_ "group"
  ]
  ( H.span_ [ P.role_ "heading", P.id_ headingId ] [ text heading ]
  : kids
  )
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
comboboxUsage :: View context props model action
comboboxUsage =
  combobox_ defaultComboboxProps
  { comboboxId = "my-combobox"
  , comboboxLabel = [ "Next.js" ]
  , comboboxValue = "Next.js"
  , comboboxSearchPlaceholder = "Search framework..."
  , comboboxEmptyText = "No framework found."
  }
  [ comboboxOption_ True "Next.js" [ "Next.js" ]
  , comboboxOption_ False "SvelteKit" [ "SvelteKit" ]
  , comboboxOption_ False "Nuxt.js" [ "Nuxt.js" ]
  , comboboxOption_ False "Remix" [ "Remix" ]
  , comboboxOption_ False "Astro" [ "Astro" ]
  ]
-----------------------------------------------------------------------------
comboboxSample :: View context props model action
comboboxSample =
  H.div_
  [ P.class_ "flex flex-wrap items-start gap-4" ]
  [ combobox_ defaultComboboxProps
    { comboboxId = "combobox-frameworks"
    , comboboxLabel = [ "Next.js" ]
    , comboboxValue = "Next.js"
    , comboboxEmptyText = "No framework found."
    }
    [ comboboxOption_ True "Next.js" [ "Next.js" ]
    , comboboxOption_ False "SvelteKit" [ "SvelteKit" ]
    , comboboxOption_ False "Nuxt.js" [ "Nuxt.js" ]
    , comboboxOption_ False "Remix" [ "Remix" ]
    , comboboxOption_ False "Astro" [ "Astro" ]
    ]
  , combobox_ defaultComboboxProps
    { comboboxId = "combobox-timezones"
    , comboboxLabel = [ "(GMT-5) New York" ]
    , comboboxValue = "America/New_York"
    , comboboxEmptyText = "No timezone found."
    , comboboxPopoverClasses = [ "w-72" ]
    }
    [ H.div_
      [ P.class_ "max-h-64 overflow-y-auto scrollbar" ]
      [ comboboxGroup_ "demo-combobox-timezones-group-0" "Americas"
        [ comboboxOption_ (tz == "America/New_York") tz [ text label ]
        | (tz, label) <- americas
        ]
      , comboboxGroup_ "demo-combobox-timezones-group-1" "Europe"
        [ comboboxOption_ False tz [ text label ] | (tz, label) <- europe ]
      , comboboxGroup_ "demo-combobox-timezones-group-2" "Asia/Pacific"
        [ comboboxOption_ False tz [ text label ] | (tz, label) <- asiaPacific ]
      ]
    , H.hr_ [ P.role_ "separator" ]
    , H.div_
      [ P.role_ "option" ]
      [ plusIcon, "Create timezone" ]
    ]
  ]
  where
    americas =
      [ ("America/New_York", "(GMT-5) New York")
      , ("America/Los_Angeles", "(GMT-8) Los Angeles")
      , ("America/Chicago", "(GMT-6) Chicago")
      , ("America/Toronto", "(GMT-5) Toronto")
      , ("America/Vancouver", "(GMT-8) Vancouver")
      , ("America/Sao_Paulo", "(GMT-3) São Paulo")
      ]
    europe =
      [ ("Europe/London", "(GMT+0) London")
      , ("Europe/Paris", "(GMT+1) Paris")
      , ("Europe/Berlin", "(GMT+1) Berlin")
      , ("Europe/Rome", "(GMT+1) Rome")
      , ("Europe/Madrid", "(GMT+1) Madrid")
      , ("Europe/Amsterdam", "(GMT+1) Amsterdam")
      ]
    asiaPacific =
      [ ("Asia/Tokyo", "(GMT+9) Tokyo")
      , ("Asia/Shanghai", "(GMT+8) Shanghai")
      , ("Asia/Singapore", "(GMT+8) Singapore")
      , ("Asia/Dubai", "(GMT+4) Dubai")
      , ("Australia/Sydney", "(GMT+11) Sydney")
      , ("Asia/Seoul", "(GMT+9) Seoul")
      ]
    plusIcon = lucide_ []
      [ S.circle_ [ SP.cx_ "12", SP.cy_ "12", SP.r_ "10" ]
      , S.path_ [ SP.d_ "M8 12h8" ]
      , S.path_ [ SP.d_ "M12 8v8" ]
      ]
-----------------------------------------------------------------------------
comboboxCodeSample :: View context props model action
comboboxCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyCombobox (comboboxUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import qualified Miso.Svg           as S
  import qualified Miso.Svg.Property  as SP
  import           Miso.UI.Icons
  import           Miso.UI.Combobox
  -----------------------------------------------------------------------------
  comboboxUsage :: View context props model action
  comboboxUsage =
    combobox_ defaultComboboxProps
    { comboboxId = "my-combobox"
    , comboboxLabel = [ "Next.js" ]
    , comboboxValue = "Next.js"
    , comboboxSearchPlaceholder = "Search framework..."
    , comboboxEmptyText = "No framework found."
    }
    [ comboboxOption_ True "Next.js" [ "Next.js" ]
    , comboboxOption_ False "SvelteKit" [ "SvelteKit" ]
    , comboboxOption_ False "Nuxt.js" [ "Nuxt.js" ]
    , comboboxOption_ False "Remix" [ "Remix" ]
    , comboboxOption_ False "Astro" [ "Astro" ]
    ]
  """
-----------------------------------------------------------------------------
comboboxPropsApi :: View context props model action
comboboxPropsApi =
  """
  -- | Props for 'combobox_'
  data ComboboxProps context props model action
    = ComboboxProps
    { comboboxId :: MisoString
      -- ^ Base id; trigger\\/popover\\/listbox ids are derived from it (required)
    , comboboxLabel :: [View context props model action]
      -- ^ Content of the trigger button (current selection)
    , comboboxValue :: MisoString
      -- ^ Currently selected value (kept in a hidden input)
    , comboboxSearchPlaceholder :: MisoString
    , comboboxEmptyText :: MisoString
      -- ^ Shown when the search yields nothing (@data-empty@)
    , comboboxPopoverClasses :: [MisoString]
      -- ^ Extra classes for the popover (e.g. @w-48@)
    , comboboxTriggerClasses :: [MisoString]
      -- ^ Extra classes for the trigger button
    , comboboxAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultComboboxProps :: ComboboxProps context props model action
  defaultComboboxProps
    = ComboboxProps
    { comboboxId = "combobox"
    , comboboxLabel = []
    , comboboxValue = ""
    , comboboxSearchPlaceholder = "Search entries..."
    , comboboxEmptyText = "No results found."
    , comboboxPopoverClasses = [ "w-48" ]
    , comboboxTriggerClasses = []
    , comboboxAttrs = []
    }
  """
-----------------------------------------------------------------------------
