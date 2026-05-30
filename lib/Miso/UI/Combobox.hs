-----------------------------------------------------------------------------
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE LambdaCase                 #-}
-----------------------------------------------------------------------------
module Miso.UI.Combobox
  ( -- ** Component
    combobox_
  ) where
-----------------------------------------------------------------------------
import           Miso
import           Miso.Html
import qualified Miso.Svg.Property as SP
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
combobox_ :: Component parent props model action
combobox_ = component undefined noop (\_ _ -> view_)
-----------------------------------------------------------------------------
view_ :: View model action
view_ =
  H.div_
  [ P.id_ "select-909078"
  , P.class_ "select"
  ]
  [ H.button_
    [ P.type_ "button"
    , P.class_ "btn-outline justify-between font-normal w-[200px]"
    , P.id_ "select-909078-trigger"
    , P.aria_ "haspopup" "listbox"
    , P.aria_ "expanded" "false"
    , P.aria_ "controls" "select-909078-listbox"
    ]
    [ H.span_
      [ P.class_ "truncate" ][]
    , svg_
      [ P.height_ "24"
      , SP.viewBox_ "0 0 24 24"
      , SP.fill_ "none"
      , SP.stroke_ "currentColor"
      , SP.strokeWidth_ "2"
      , SP.strokeLinecap_ "round"
      , SP.strokeLinejoin_ "round"
      , P.class_ "lucide lucide-chevrons-up-down-icon lucide-chevrons-up-down text-muted-foreground opacity-50 shrink-0"
      ]
      []
    ]
  , H.div_
    [ P.id_ "select-909078-popover"
    , P.aria_ "hidden" "true"
    ]
    [ H.header_ []
      [ H.svg_
        [ P.xmlns_ "http://www.w3.org/2000/svg"
        , P.width_ "24"
        , P.height_ "24"
        , SP.viewBox_ "0 0 24 24"
        , SP.fill_ "none"
        , SP.stroke_ "currentColor"
        , SP.strokeWidth_ "2"
        , SP.strokeLinecap_ "round" 
        , SP.strokeLinejoin_ "round"
        , P.class_ "lucide lucide-search-icon lucide-search"
        ] []
      , H.input_
        [ P.type_ "text"
        , P.value_ ""
        , P.placeholder_ "Search framework..."
        , P.autocomplete_ False
        , P.autocorrect_ False
        , P.spellcheck_ False
        , P.aria_ "autocomplete" "list"
        , P.role_ "combobox"
        , P.aria_ "expanded" "false"
        , P.aria_ "controls" "select-909078-listbox"
        , P.aria_ "labelledby" "select-909078-trigger"
        ]
      ]
    , H.div_
      [ P.role_ "listbox"
      , P.id_ "select-909078-listbox"
      , P.aria_ "orientation" "vertical"
      , P.aria_ "labelledby" "select-909078-trigger"
      , P.data_ "empty" "No framework found."
      ]
      [ H.div_
        [ P.role_ "option"
        , P.data_ "value" "Next.js"
        ]
        [ "Next.js" ]
      , H.div_
        [ P.role_ "option"
        , P.data_ "value" "SvelteKit"
        ]
        [ "SvelteKit" ]
      , H.div_
        [ P.role_ "option"
        , P.data_ "value" "Nuxt.js"
        ]
        [ "Nuxt.js" ]
      , H.div_
        [ P.role_ "option"
        , P.data_ "value" "Remix"
        ]
        [ "Remix" ]
      , H.div_
        [ P.role_ "option"
        , P.data_ "value" "Astro"
        ]
        [ "Astro" ]
      ]
    ]
  , H.input_
    [ P.type_ "hidden"
    , P.name_ "select-909078-value"
    , P.value_ ""
    ]
  ]
-----------------------------------------------------------------------------
