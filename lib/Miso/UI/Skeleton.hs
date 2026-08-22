-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Skeleton
  ( -- ** Props
    SkeletonProps (..)
  , defaultSkeletonProps
    -- ** Views
  , skeleton_
    -- ** Samples
  , skeletonSample
  , skeletonCodeSample
  , skeletonPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
-- | Props for 'skeleton_'
data SkeletonProps action
  = SkeletonProps
  { skeletonCircle :: Bool
    -- ^ Round skeleton (e.g. avatar placeholder) instead of rounded rectangle
  , skeletonClasses :: [MisoString]
    -- ^ Size the skeleton with utility classes (e.g. @h-4 w-[150px]@)
  , skeletonAttrs :: [Attribute action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: rounded rectangle
defaultSkeletonProps :: SkeletonProps action
defaultSkeletonProps
  = SkeletonProps
  { skeletonCircle = False
  , skeletonClasses = []
  , skeletonAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/skeleton/ Skeleton>, driven by 'SkeletonProps'
skeleton_ :: SkeletonProps action -> View model action
skeleton_ SkeletonProps {..} =
  H.div_
    ( P.classes_
      ( [ "bg-accent", "animate-pulse" ]
        ++ [ if skeletonCircle then "rounded-full" else "rounded-md" ]
        ++ skeletonClasses
      )
    : skeletonAttrs
    ) []
-----------------------------------------------------------------------------
skeletonSample :: View model action
skeletonSample =
  H.div_
  [ P.class_ "flex flex-col gap-4" ]
  [ H.div_
    [ P.class_ "flex items-center gap-4" ]
    [ skeleton_ defaultSkeletonProps
      { skeletonCircle = True
      , skeletonClasses = [ "size-10", "shrink-0" ]
      }
    , H.div_
      [ P.class_ "grid gap-2" ]
      [ skeleton_ defaultSkeletonProps { skeletonClasses = [ "h-4", "w-[150px]" ] }
      , skeleton_ defaultSkeletonProps { skeletonClasses = [ "h-4", "w-[100px]" ] }
      ]
    ]
  , H.div_
    [ P.class_ "flex max-sm:flex-col gap-4 w-full" ]
    [ skeletonCard, skeletonCard ]
  ]
  where
    skeletonCard =
      H.div_
      [ P.class_ "card w-full @md:w-auto @md:min-w-sm" ]
      [ H.header_ []
        [ skeleton_ defaultSkeletonProps { skeletonClasses = [ "h-4", "w-2/3" ] }
        , skeleton_ defaultSkeletonProps { skeletonClasses = [ "h-4", "w-1/2" ] }
        ]
      , H.section_ []
        [ skeleton_ defaultSkeletonProps { skeletonClasses = [ "aspect-square", "w-full" ] }
        ]
      ]
-----------------------------------------------------------------------------
skeletonCodeSample :: View model action
skeletonCodeSample =
  """
  -----------------------------------------------------------------------------
  module MySkeleton (skeletonSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Skeleton
  -----------------------------------------------------------------------------
  skeletonSample :: View model action
  skeletonSample =
    H.div_
    [ P.class_ "flex flex-col gap-4" ]
    [ H.div_
      [ P.class_ "flex items-center gap-4" ]
      [ skeleton_ defaultSkeletonProps
        { skeletonCircle = True
        , skeletonClasses = [ "size-10", "shrink-0" ]
        }
      , H.div_
        [ P.class_ "grid gap-2" ]
        [ skeleton_ defaultSkeletonProps { skeletonClasses = [ "h-4", "w-[150px]" ] }
        , skeleton_ defaultSkeletonProps { skeletonClasses = [ "h-4", "w-[100px]" ] }
        ]
      ]
    , H.div_
      [ P.class_ "flex max-sm:flex-col gap-4 w-full" ]
      [ skeletonCard, skeletonCard ]
    ]
    where
      skeletonCard =
        H.div_
        [ P.class_ "card w-full @md:w-auto @md:min-w-sm" ]
        [ H.header_ []
          [ skeleton_ defaultSkeletonProps { skeletonClasses = [ "h-4", "w-2/3" ] }
          , skeleton_ defaultSkeletonProps { skeletonClasses = [ "h-4", "w-1/2" ] }
          ]
        , H.section_ []
          [ skeleton_ defaultSkeletonProps { skeletonClasses = [ "aspect-square", "w-full" ] }
          ]
        ]
  """
-----------------------------------------------------------------------------
skeletonPropsApi :: View model action
skeletonPropsApi =
  """
  -- | Props for 'skeleton_'
  data SkeletonProps action
    = SkeletonProps
    { skeletonCircle :: Bool
      -- ^ Round skeleton (e.g. avatar placeholder) instead of rounded rectangle
    , skeletonClasses :: [MisoString]
      -- ^ Size the skeleton with utility classes (e.g. @h-4 w-[150px]@)
    , skeletonAttrs :: [Attribute action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: rounded rectangle
  defaultSkeletonProps :: SkeletonProps action
  defaultSkeletonProps
    = SkeletonProps
    { skeletonCircle = False
    , skeletonClasses = []
    , skeletonAttrs = []
    }
  """
-----------------------------------------------------------------------------
