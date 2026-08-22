-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
-----------------------------------------------------------------------------
-- | Shared types used by the props API of every @Miso.UI.*@ component.
module Miso.UI.Types
  ( -- ** Types
    Variant (..)
  , Size (..)
  , Side (..)
  , Align (..)
    -- ** Helpers
  , variantSuffix
  , sizeSuffix
  , sideText
  , alignText
  ) where
-----------------------------------------------------------------------------
import           Miso.String (MisoString)
-----------------------------------------------------------------------------
-- | Style variant shared by 'Miso.UI.Button.button_', 'Miso.UI.Badge.badge_', etc.
data Variant
  = Primary
  | Secondary
  | Destructive
  | Outline
  | Ghost
  | Link
  deriving (Show, Eq)
-----------------------------------------------------------------------------
-- | Component sizing
data Size
  = DefaultSize
  | Small
  | Large
  deriving (Show, Eq)
-----------------------------------------------------------------------------
-- | Placement side, used by tooltips, popovers and dropdown menus.
data Side
  = TopSide
  | RightSide
  | BottomSide
  | LeftSide
  deriving (Show, Eq)
-----------------------------------------------------------------------------
-- | Placement alignment, used by tooltips, popovers and dropdown menus.
data Align
  = StartAlign
  | CenterAlign
  | EndAlign
  deriving (Show, Eq)
-----------------------------------------------------------------------------
-- | Suffix used when building basecoat class names (e.g. @btn-outline@)
variantSuffix :: Variant -> MisoString
variantSuffix = \v ->
  case v of
    Primary     -> "primary"
    Secondary   -> "secondary"
    Destructive -> "destructive"
    Outline     -> "outline"
    Ghost       -> "ghost"
    Link        -> "link"
-----------------------------------------------------------------------------
-- | Suffix used when building basecoat class names (e.g. @btn-sm@)
sizeSuffix :: Size -> MisoString
sizeSuffix = \s ->
  case s of
    DefaultSize -> ""
    Small       -> "sm"
    Large       -> "lg"
-----------------------------------------------------------------------------
-- | Value for @data-side@ attributes
sideText :: Side -> MisoString
sideText = \s ->
  case s of
    TopSide    -> "top"
    RightSide  -> "right"
    BottomSide -> "bottom"
    LeftSide   -> "left"
-----------------------------------------------------------------------------
-- | Value for @data-align@ attributes
alignText :: Align -> MisoString
alignText = \a ->
  case a of
    StartAlign  -> "start"
    CenterAlign -> "center"
    EndAlign    -> "end"
-----------------------------------------------------------------------------
