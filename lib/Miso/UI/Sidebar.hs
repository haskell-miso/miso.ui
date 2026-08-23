-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Sidebar
  ( -- ** Props
    SidebarProps (..)
  , defaultSidebarProps
    -- ** Views
  , sidebar_
  , sidebarGroup_
  , sidebarNav_
  , sidebarItem_
    -- ** Samples
  , sidebarCodeSample
  , sidebarPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
-- | Props for 'sidebar_'
data SidebarProps model action
  = SidebarProps
  { sidebarId :: MisoString
  , sidebarOpen :: Bool
    -- ^ Visible (@aria-hidden@ when closed)
  , sidebarClasses :: [MisoString]
    -- ^ Extra classes appended to @aside.sidebar@
  , sidebarAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: open sidebar
defaultSidebarProps :: SidebarProps model action
defaultSidebarProps
  = SidebarProps
  { sidebarId = "sidebar"
  , sidebarOpen = True
  , sidebarClasses = []
  , sidebarAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/sidebar/ Sidebar>, driven by 'SidebarProps'.
-- Children are 'sidebarGroup_' views wrapped in a @nav@.
sidebar_
  :: SidebarProps model action
  -> [View context model action]
  -> View context model action
sidebar_ SidebarProps {..} kids =
  H.aside_
    ( concat
      [ [ P.classes_ ("sidebar" : sidebarClasses)
        , P.id_ sidebarId
        , P.aria_ "hidden" (if sidebarOpen then "false" else "true")
        ]
      , sidebarAttrs
      ]
    )
    [ H.nav_ [] kids ]
-----------------------------------------------------------------------------
-- | Labelled group of sidebar items
sidebarGroup_
  :: MisoString
  -- ^ group heading
  -> [View context model action]
  -> View context model action
sidebarGroup_ heading kids =
  H.section_
  [ P.class_ "scrollbar" ]
  [ H.h3_ [] [ text heading ]
  , sidebarNav_ [] kids
  ]
-----------------------------------------------------------------------------
sidebarNav_
  :: [Attribute model action]
  -> [View context model action]
  -> View context model action
sidebarNav_ attrs kids =
  H.ul_ attrs [ H.li_ [] [ k ] | k <- kids ]
-----------------------------------------------------------------------------
-- | Sidebar link; the 'Bool' marks the current page
sidebarItem_
  :: Bool
  -> MisoString
  -- ^ href
  -> [View context model action]
  -> View context model action
sidebarItem_ current url kids =
  optionalAttrs
    H.a_
    [ P.href_ url ]
    current
    [ P.aria_ "current" "page" ]
    kids
-----------------------------------------------------------------------------
sidebarCodeSample :: View context model action
sidebarCodeSample =
  """
  -----------------------------------------------------------------------------
  module MySidebar (mySidebar) where
  -----------------------------------------------------------------------------
  import           Miso
  -----------------------------------------------------------------------------
  import           Miso.UI.Sidebar
  -----------------------------------------------------------------------------
  mySidebar :: View context model action
  mySidebar =
    sidebar_ defaultSidebarProps
    [ sidebarGroup_ "Getting Started"
      [ sidebarItem_ True "#introduction" [ "Introduction" ]
      , sidebarItem_ False "#installation" [ "Installation" ]
      ]
    , sidebarGroup_ "Components"
      [ sidebarItem_ False "#accordion" [ "Accordion" ]
      , sidebarItem_ False "#button" [ "Button" ]
      ]
    ]
  """
-----------------------------------------------------------------------------
sidebarPropsApi :: View context model action
sidebarPropsApi =
  """
  -- | Props for 'sidebar_'
  data SidebarProps model action
    = SidebarProps
    { sidebarId :: MisoString
    , sidebarOpen :: Bool
      -- ^ Visible (@aria-hidden@ when closed)
    , sidebarClasses :: [MisoString]
      -- ^ Extra classes appended to @aside.sidebar@
    , sidebarAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: open sidebar
  defaultSidebarProps :: SidebarProps model action
  defaultSidebarProps
    = SidebarProps
    { sidebarId = "sidebar"
    , sidebarOpen = True
    , sidebarClasses = []
    , sidebarAttrs = []
    }
  """
-----------------------------------------------------------------------------
