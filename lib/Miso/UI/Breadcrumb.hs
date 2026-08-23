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
data BreadcrumbProps model action
  = BreadcrumbProps
  { breadcrumbClasses :: [MisoString]
    -- ^ Extra classes appended to the @ol@
  , breadcrumbAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultBreadcrumbProps :: BreadcrumbProps model action
defaultBreadcrumbProps
  = BreadcrumbProps
  { breadcrumbClasses = []
  , breadcrumbAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/breadcrumb/ Breadcrumb>.
-- Children are 'breadcrumbItem_' \/ 'breadcrumbSeparator_' views.
breadcrumb_
  :: BreadcrumbProps model action
  -> [View context model action]
  -> View context model action
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
  :: [Attribute model action]
  -> [View context model action]
  -> View context model action
breadcrumbItem_ attrs kids =
  H.li_ (P.class_ "inline-flex items-center gap-1.5" : attrs) kids
-----------------------------------------------------------------------------
-- | Link to an ancestor page
breadcrumbLink_
  :: MisoString
  -- ^ href
  -> [View context model action]
  -> View context model action
breadcrumbLink_ url kids = breadcrumbItem_ []
  [ H.a_
    [ P.class_ "hover:text-foreground transition-colors"
    , P.href_ url
    ] kids
  ]
-----------------------------------------------------------------------------
-- | The current page (last crumb)
breadcrumbPage_
  :: [View context model action]
  -> View context model action
breadcrumbPage_ kids = breadcrumbItem_ []
  [ H.span_ [ P.class_ "text-foreground font-normal" ] kids
  ]
-----------------------------------------------------------------------------
breadcrumbSeparator_ :: View context model action
breadcrumbSeparator_ =
  H.li_ [] [ chevronRightIcon [ P.class_ "size-3.5" ] ]
-----------------------------------------------------------------------------
breadcrumbSample :: View context model action
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
breadcrumbCodeSample :: View context model action
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
  breadcrumbSample :: View context model action
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
breadcrumbPropsApi :: View context model action
breadcrumbPropsApi =
  """
  -- | Props for 'breadcrumb_'
  data BreadcrumbProps model action
    = BreadcrumbProps
    { breadcrumbClasses :: [MisoString]
      -- ^ Extra classes appended to the @ol@
    , breadcrumbAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultBreadcrumbProps :: BreadcrumbProps model action
  defaultBreadcrumbProps
    = BreadcrumbProps
    { breadcrumbClasses = []
    , breadcrumbAttrs = []
    }
  """
-----------------------------------------------------------------------------
