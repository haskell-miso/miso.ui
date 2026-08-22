-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.ThemeSwitcher
  ( -- ** Props
    ThemeSwitcherProps (..)
  , defaultThemeSwitcherProps
    -- ** Views
  , themeSelect_
  , darkModeToggle_
    -- ** Samples
  , themeSwitcherCodeSample
  , themeSwitcherPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Event as E
import qualified Miso.Html.Property as P
import qualified Miso.Svg           as S
import qualified Miso.Svg.Property  as SP
-----------------------------------------------------------------------------
import           Miso.UI.Icons
-----------------------------------------------------------------------------
-- | Props for 'themeSelect_'
data ThemeSwitcherProps action
  = ThemeSwitcherProps
  { themeSwitcherThemes :: [(MisoString, MisoString)]
    -- ^ (value, label) pairs
  , themeSwitcherSelected :: MisoString
    -- ^ value of the currently selected theme
  , themeSwitcherClasses :: [MisoString]
    -- ^ Extra classes for the @select@
  , themeSwitcherAttrs :: [Attribute action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: basecoat's stock themes
defaultThemeSwitcherProps :: ThemeSwitcherProps action
defaultThemeSwitcherProps
  = ThemeSwitcherProps
  { themeSwitcherThemes =
    [ ("", "Default")
    , ("claude", "Claude")
    , ("cosmic", "Cosmic")
    , ("tangerine", "Tangerine")
    , ("supabase", "Supabase")
    ]
  , themeSwitcherSelected = ""
  , themeSwitcherClasses = [ "h-8", "leading-none" ]
  , themeSwitcherAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/theme-switcher/ Theme Switcher>:
-- select that emits the chosen theme name
themeSelect_
  :: (MisoString -> action)
  -> ThemeSwitcherProps action
  -> View model action
themeSelect_ changeTheme ThemeSwitcherProps {..} =
  H.select_
    ( P.classes_ ("select" : themeSwitcherClasses)
    : E.onChange changeTheme
    : themeSwitcherAttrs
    )
    [ H.option_
      ( P.value_ value
      : [ P.selected_ True | value == themeSwitcherSelected ]
      )
      [ text label ]
    | (value, label) <- themeSwitcherThemes
    ]
-----------------------------------------------------------------------------
-- | Sun\/moon button that emits the given action on click
darkModeToggle_ :: action -> View model action
darkModeToggle_ toggle =
  H.button_
  [ P.class_ "btn-icon-outline size-8"
  , P.data_ "side" "bottom"
  , P.data_ "tooltip" "Toggle dark mode"
  , P.aria_ "label" "Toggle dark mode"
  , P.type_ "button"
  , E.onClickCapture toggle
  ]
  [ H.span_
    [ P.class_ "hidden dark:block" ]
    [ lucide_ []
      [ S.circle_ [ SP.cx_ "12", SP.cy_ "12", SP.r_ "4" ]
      , S.path_ [ SP.d_ "M12 2v2" ]
      , S.path_ [ SP.d_ "M12 20v2" ]
      , S.path_ [ SP.d_ "m4.93 4.93 1.41 1.41" ]
      , S.path_ [ SP.d_ "m17.66 17.66 1.41 1.41" ]
      , S.path_ [ SP.d_ "M2 12h2" ]
      , S.path_ [ SP.d_ "M20 12h2" ]
      , S.path_ [ SP.d_ "m6.34 17.66-1.41 1.41" ]
      , S.path_ [ SP.d_ "m19.07 4.93-1.41 1.41" ]
      ]
    ]
  , H.span_
    [ P.class_ "block dark:hidden" ]
    [ lucide_ []
      [ S.path_ [ SP.d_ "M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z" ]
      ]
    ]
  ]
-----------------------------------------------------------------------------
themeSwitcherCodeSample :: View model action
themeSwitcherCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyThemeSwitcher (myHeader) where
  -----------------------------------------------------------------------------
  import           Miso
  -----------------------------------------------------------------------------
  import           Miso.UI.ThemeSwitcher
  -----------------------------------------------------------------------------
  data Action = ChangeTheme MisoString | ToggleDarkMode
  -----------------------------------------------------------------------------
  myHeader :: View model Action
  myHeader = vfrag
    [ themeSelect_ ChangeTheme defaultThemeSwitcherProps
    , darkModeToggle_ ToggleDarkMode
    ]
  """
-----------------------------------------------------------------------------
themeSwitcherPropsApi :: View model action
themeSwitcherPropsApi =
  """
  -- | Props for 'themeSelect_'
  data ThemeSwitcherProps action
    = ThemeSwitcherProps
    { themeSwitcherThemes :: [(MisoString, MisoString)]
      -- ^ (value, label) pairs
    , themeSwitcherSelected :: MisoString
      -- ^ value of the currently selected theme
    , themeSwitcherClasses :: [MisoString]
      -- ^ Extra classes for the @select@
    , themeSwitcherAttrs :: [Attribute action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: basecoat's stock themes
  defaultThemeSwitcherProps :: ThemeSwitcherProps action
  defaultThemeSwitcherProps
    = ThemeSwitcherProps
    { themeSwitcherThemes =
      [ ("", "Default")
      , ("claude", "Claude")
      , ("cosmic", "Cosmic")
      , ("tangerine", "Tangerine")
      , ("supabase", "Supabase")
      ]
    , themeSwitcherSelected = ""
    , themeSwitcherClasses = [ "h-8", "leading-none" ]
    , themeSwitcherAttrs = []
    }
  """
-----------------------------------------------------------------------------
