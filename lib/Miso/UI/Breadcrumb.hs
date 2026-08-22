-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Breadcrumb
  ( -- ** Props
    BreadcrumbProps (..)
  , defaultBreadcrumbProps
    -- ** Views
  , breadcrumb_
  , breadcrumbLink_
  , breadcrumbPage_
  , breadcrumbSeparator_
  , breadcrumbItem_
    -- ** Samples
  , breadcrumbSample
  , breadcrumbCodeSample
  , breadcrumbPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.DropDownMenu
import           Miso.UI.Icons
-----------------------------------------------------------------------------
-- | Props for 'breadcrumb_'
data BreadcrumbProps action
  = BreadcrumbProps
  { breadcrumbClasses :: [MisoString]
    -- ^ Extra classes appended to the @ol@
  , breadcrumbAttrs :: [Attribute action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultBreadcrumbProps :: BreadcrumbProps action
defaultBreadcrumbProps
  = BreadcrumbProps
  { breadcrumbClasses = []
  , breadcrumbAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/breadcrumb/ Breadcrumb>.
-- Children are 'breadcrumbItem_' \/ 'breadcrumbSeparator_' views.
breadcrumb_
  :: BreadcrumbProps action
  -> [View model action]
  -> View model action
breadcrumb_ BreadcrumbProps {..} kids =
  H.ol_
    ( P.classes_
      ( [ "text-muted-foreground"
        , "flex", "flex-wrap", "items-center"
        , "gap-1.5", "text-sm", "break-words", "sm:gap-2.5"
        ] ++ breadcrumbClasses
      )
    : breadcrumbAttrs
    ) kids
-----------------------------------------------------------------------------
breadcrumbItem_
  :: [Attribute action]
  -> [View model action]
  -> View model action
breadcrumbItem_ attrs kids =
  H.li_ (P.class_ "inline-flex items-center gap-1.5" : attrs) kids
-----------------------------------------------------------------------------
-- | Link to an ancestor page
breadcrumbLink_
  :: MisoString
  -- ^ href
  -> [View model action]
  -> View model action
breadcrumbLink_ url kids = breadcrumbItem_ []
  [ H.a_
    [ P.class_ "hover:text-foreground transition-colors"
    , P.href_ url
    ] kids
  ]
-----------------------------------------------------------------------------
-- | The current page (last crumb)
breadcrumbPage_
  :: [View model action]
  -> View model action
breadcrumbPage_ kids = breadcrumbItem_ []
  [ H.span_ [ P.class_ "text-foreground font-normal" ] kids
  ]
-----------------------------------------------------------------------------
breadcrumbSeparator_ :: View model action
breadcrumbSeparator_ =
  H.li_ [] [ chevronRightIcon [ P.class_ "size-3.5" ] ]
-----------------------------------------------------------------------------
breadcrumbSample :: View model action
breadcrumbSample =
  breadcrumb_ defaultBreadcrumbProps
  [ breadcrumbLink_ "#" [ "Home" ]
  , breadcrumbSeparator_
  , breadcrumbItem_ []
    [ dropdownMenu_ defaultDropdownMenuProps
      { dropdownMenuId = "demo-breadcrumb-menu"
      , dropdownMenuTriggerClasses =
        [ "flex", "size-9", "items-center", "justify-center"
        , "h-4", "w-4", "hover:text-foreground", "cursor-pointer"
        ]
      , dropdownMenuTrigger = [ dotsIcon [] ]
      , dropdownMenuPopoverClasses = [ "p-1" ]
      }
      [ menuItem_ [] [ "Documentation" ]
      , menuItem_ [] [ "Themes" ]
      , menuItem_ [] [ "GitHub" ]
      ]
    ]
  , breadcrumbSeparator_
  , breadcrumbLink_ "#" [ "Components" ]
  , breadcrumbSeparator_
  , breadcrumbPage_ [ "Breadcrumb" ]
  ]
-----------------------------------------------------------------------------
breadcrumbCodeSample :: View model action
breadcrumbCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyBreadcrumb (breadcrumbSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.DropDownMenu
  import           Miso.UI.Icons
  import           Miso.UI.Breadcrumb
  -----------------------------------------------------------------------------
  breadcrumbSample :: View model action
  breadcrumbSample =
    breadcrumb_ defaultBreadcrumbProps
    [ breadcrumbLink_ "#" [ "Home" ]
    , breadcrumbSeparator_
    , breadcrumbItem_ []
      [ dropdownMenu_ defaultDropdownMenuProps
        { dropdownMenuId = "demo-breadcrumb-menu"
        , dropdownMenuTriggerClasses =
          [ "flex", "size-9", "items-center", "justify-center"
          , "h-4", "w-4", "hover:text-foreground", "cursor-pointer"
          ]
        , dropdownMenuTrigger = [ dotsIcon [] ]
        , dropdownMenuPopoverClasses = [ "p-1" ]
        }
        [ menuItem_ [] [ "Documentation" ]
        , menuItem_ [] [ "Themes" ]
        , menuItem_ [] [ "GitHub" ]
        ]
      ]
    , breadcrumbSeparator_
    , breadcrumbLink_ "#" [ "Components" ]
    , breadcrumbSeparator_
    , breadcrumbPage_ [ "Breadcrumb" ]
    ]
  """
-----------------------------------------------------------------------------
breadcrumbPropsApi :: View model action
breadcrumbPropsApi =
  """
  -- | Props for 'breadcrumb_'
  data BreadcrumbProps action
    = BreadcrumbProps
    { breadcrumbClasses :: [MisoString]
      -- ^ Extra classes appended to the @ol@
    , breadcrumbAttrs :: [Attribute action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultBreadcrumbProps :: BreadcrumbProps action
  defaultBreadcrumbProps
    = BreadcrumbProps
    { breadcrumbClasses = []
    , breadcrumbAttrs = []
    }
  """
-----------------------------------------------------------------------------
