-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Badge
  ( -- ** Props
    BadgeProps (..)
  , defaultBadgeProps
    -- ** Views
  , badge_
  , badgeClass
    -- ** Samples
  , badgeSample
  , badgeCodeSample
  , badgePropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props for 'badge_'
data BadgeProps model action
  = BadgeProps
  { badgeVariant :: Variant
    -- ^ 'Primary', 'Secondary', 'Destructive' or 'Outline'
  , badgeRounded :: Bool
    -- ^ Pill badge (@rounded-full@), typically for counters
  , badgeHref :: Maybe MisoString
    -- ^ When set, renders as a link (an anchor element)
  , badgeClasses :: [MisoString]
    -- ^ Extra classes appended to the computed basecoat class
  , badgeAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: primary variant, not rounded
defaultBadgeProps :: BadgeProps model action
defaultBadgeProps
  = BadgeProps
  { badgeVariant = Primary
  , badgeRounded = False
  , badgeHref = Nothing
  , badgeClasses = []
  , badgeAttrs = []
  }
-----------------------------------------------------------------------------
-- | Computes the basecoat badge class (e.g. @badge-outline@)
badgeClass :: BadgeProps model action -> MisoString
badgeClass BadgeProps {..} =
  case badgeVariant of
    Primary -> "badge"
    v -> "badge-" <> variantSuffix v
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/badge/ Badge>, driven by 'BadgeProps'
badge_
  :: BadgeProps model action
  -> [View context model action]
  -> View context model action
badge_ cfg kids = element attrs kids
  where
    element =
      case badgeHref cfg of
        Just _ -> H.a_
        Nothing -> H.span_
    attrs = concat
      [ [ P.classes_ $ concat
          [ [ badgeClass cfg ]
          , [ "rounded-full min-w-5 px-1" | badgeRounded cfg ]
          , badgeClasses cfg
          ]
        ]
      , [ P.href_ h | Just h <- [badgeHref cfg] ]
      , badgeAttrs cfg
      ]
-----------------------------------------------------------------------------
badgeSample :: View context model action
badgeSample =
  H.div_
  [ P.class_ "flex flex-col gap-2" ]
  [ H.div_
    [ P.class_ "flex flex-wrap items-center gap-2 md:flex-row" ]
    [ badge_ defaultBadgeProps [ "Primary" ]
    , badge_ defaultBadgeProps { badgeVariant = Secondary } [ "Secondary" ]
    , badge_ defaultBadgeProps { badgeVariant = Outline } [ "Outline" ]
    , badge_ defaultBadgeProps { badgeVariant = Destructive } [ "Destructive" ]
    , badge_ defaultBadgeProps { badgeRounded = True } [ "8" ]
    , badge_ defaultBadgeProps { badgeRounded = True, badgeVariant = Destructive } [ "99" ]
    , badge_ defaultBadgeProps
      { badgeRounded = True
      , badgeVariant = Outline
      , badgeClasses = [ "font-mono", "tabular-nums" ]
      }
      [ "20+" ]
    ]
  , H.div_
    [ P.class_ "flex flex-wrap items-center gap-2 md:flex-row" ]
    [ badge_ defaultBadgeProps { badgeHref = Just "#" } [ "Link" ]
    , badge_ defaultBadgeProps { badgeHref = Just "#", badgeVariant = Secondary } [ "Link" ]
    , badge_ defaultBadgeProps { badgeHref = Just "#", badgeVariant = Destructive } [ "Link" ]
    , badge_ defaultBadgeProps { badgeHref = Just "#", badgeVariant = Outline } [ "Link" ]
    ]
  ]
-----------------------------------------------------------------------------
badgeCodeSample :: View context model action
badgeCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyBadge (badgeSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Types
  import           Miso.UI.Badge
  -----------------------------------------------------------------------------
  badgeSample :: View context model action
  badgeSample =
    H.div_
    [ P.class_ "flex flex-col gap-2" ]
    [ H.div_
      [ P.class_ "flex flex-wrap items-center gap-2 md:flex-row" ]
      [ badge_ defaultBadgeProps [ "Primary" ]
      , badge_ defaultBadgeProps { badgeVariant = Secondary } [ "Secondary" ]
      , badge_ defaultBadgeProps { badgeVariant = Outline } [ "Outline" ]
      , badge_ defaultBadgeProps { badgeVariant = Destructive } [ "Destructive" ]
      , badge_ defaultBadgeProps { badgeRounded = True } [ "8" ]
      , badge_ defaultBadgeProps { badgeRounded = True, badgeVariant = Destructive } [ "99" ]
      , badge_ defaultBadgeProps
        { badgeRounded = True
        , badgeVariant = Outline
        , badgeClasses = [ "font-mono", "tabular-nums" ]
        }
        [ "20+" ]
      ]
    , H.div_
      [ P.class_ "flex flex-wrap items-center gap-2 md:flex-row" ]
      [ badge_ defaultBadgeProps { badgeHref = Just "#" } [ "Link" ]
      , badge_ defaultBadgeProps { badgeHref = Just "#", badgeVariant = Secondary } [ "Link" ]
      , badge_ defaultBadgeProps { badgeHref = Just "#", badgeVariant = Destructive } [ "Link" ]
      , badge_ defaultBadgeProps { badgeHref = Just "#", badgeVariant = Outline } [ "Link" ]
      ]
    ]
  """
-----------------------------------------------------------------------------
badgePropsApi :: View context model action
badgePropsApi =
  """
  -- | Props for 'badge_'
  data BadgeProps model action
    = BadgeProps
    { badgeVariant :: Variant
      -- ^ 'Primary', 'Secondary', 'Destructive' or 'Outline'
    , badgeRounded :: Bool
      -- ^ Pill badge (@rounded-full@), typically for counters
    , badgeHref :: Maybe MisoString
      -- ^ When set, renders as a link (an anchor element)
    , badgeClasses :: [MisoString]
      -- ^ Extra classes appended to the computed basecoat class
    , badgeAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: primary variant, not rounded
  defaultBadgeProps :: BadgeProps model action
  defaultBadgeProps
    = BadgeProps
    { badgeVariant = Primary
    , badgeRounded = False
    , badgeHref = Nothing
    , badgeClasses = []
    , badgeAttrs = []
    }
  """
-----------------------------------------------------------------------------
