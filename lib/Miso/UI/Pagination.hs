-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Pagination
  ( -- ** Props
    PaginationProps (..)
  , defaultPaginationProps
    -- ** Views
  , pagination_
  , paginationLink_
  , paginationPrevious_
  , paginationNext_
  , paginationEllipsis_
    -- ** Samples
  , paginationSample
  , paginationCodeSample
  , paginationPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Icons
-----------------------------------------------------------------------------
-- | Props for 'pagination_'
data PaginationProps model action
  = PaginationProps
  { paginationClasses :: [MisoString]
    -- ^ Extra classes appended to the @nav@
  , paginationAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultPaginationProps :: PaginationProps model action
defaultPaginationProps
  = PaginationProps
  { paginationClasses = []
  , paginationAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/pagination/ Pagination>.
-- Children are 'paginationLink_' \/ 'paginationPrevious_' \/ etc.
pagination_
  :: PaginationProps model action
  -> [View context props model action]
  -> View context props model action
pagination_ PaginationProps {..} kids =
  H.nav_
    ( P.classes_ ("mx-auto" : "flex" : "w-full" : "justify-center" : paginationClasses)
    : P.aria_ "label" "pagination"
    : P.role_ "navigation"
    : paginationAttrs
    )
    [ H.ul_
      [ P.class_ "flex flex-row items-center gap-1" ]
      kids
    ]
-----------------------------------------------------------------------------
-- | Page number link; the 'Bool' marks the current page
paginationLink_
  :: Bool
  -> MisoString
  -- ^ href
  -> [View context props model action]
  -> View context props model action
paginationLink_ current url kids =
  H.li_ []
  [ H.a_
    [ P.classes_ [ if current then "btn-outline" else "btn-ghost", "size-9" ]
    , P.href_ url
    ] kids
  ]
-----------------------------------------------------------------------------
paginationPrevious_ :: MisoString -> View context props model action
paginationPrevious_ url =
  H.li_ []
  [ H.a_
    [ P.class_ "btn-ghost", P.href_ url ]
    [ chevronLeftIcon [], "Previous" ]
  ]
-----------------------------------------------------------------------------
paginationNext_ :: MisoString -> View context props model action
paginationNext_ url =
  H.li_ []
  [ H.a_
    [ P.class_ "btn-ghost", P.href_ url ]
    [ "Next", chevronRightIcon [] ]
  ]
-----------------------------------------------------------------------------
paginationEllipsis_ :: MisoString -> View context props model action
paginationEllipsis_ url =
  H.li_ []
  [ H.a_
    [ P.class_ "btn-icon-ghost", P.href_ url ]
    [ dotsIcon [] ]
  ]
-----------------------------------------------------------------------------
paginationSample :: View context props model action
paginationSample =
  H.div_
  [ P.class_ "inline-flex" ]
  [ pagination_ defaultPaginationProps
    [ paginationPrevious_ "#"
    , paginationLink_ False "#" [ "1" ]
    , paginationLink_ True "#" [ "2" ]
    , paginationLink_ False "#" [ "3" ]
    , paginationEllipsis_ "#"
    , paginationNext_ "#"
    ]
  ]
-----------------------------------------------------------------------------
paginationCodeSample :: View context props model action
paginationCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyPagination (paginationSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Icons
  import           Miso.UI.Pagination
  -----------------------------------------------------------------------------
  paginationSample :: View context props model action
  paginationSample =
    H.div_
    [ P.class_ "inline-flex" ]
    [ pagination_ defaultPaginationProps
      [ paginationPrevious_ "#"
      , paginationLink_ False "#" [ "1" ]
      , paginationLink_ True "#" [ "2" ]
      , paginationLink_ False "#" [ "3" ]
      , paginationEllipsis_ "#"
      , paginationNext_ "#"
      ]
    ]
  """
-----------------------------------------------------------------------------
paginationPropsApi :: View context props model action
paginationPropsApi =
  """
  -- | Props for 'pagination_'
  data PaginationProps model action
    = PaginationProps
    { paginationClasses :: [MisoString]
      -- ^ Extra classes appended to the @nav@
    , paginationAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultPaginationProps :: PaginationProps model action
  defaultPaginationProps
    = PaginationProps
    { paginationClasses = []
    , paginationAttrs = []
    }
  """
-----------------------------------------------------------------------------
