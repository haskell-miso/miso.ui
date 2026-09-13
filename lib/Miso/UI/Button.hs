-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Button
  ( -- ** Props
    ButtonProps (..)
  , defaultButtonProps
    -- ** Views
  , button_
  , buttonClass
    -- ** Samples
  , buttonUsage
  , buttonSample
  , buttonCodeSample
  , buttonPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
import qualified Miso.String as MS
-----------------------------------------------------------------------------
import           Miso.UI.Types
import           Miso.UI.Icons
-----------------------------------------------------------------------------
-- | Props for 'button'
data ButtonProps model action
  = ButtonProps
  { buttonVariant :: Variant
    -- ^ 'Primary', 'Secondary', 'Destructive', 'Outline', 'Ghost' or 'Link'
  , buttonSize :: Size
    -- ^ 'DefaultSize', 'Small' or 'Large'
  , buttonIcon :: Bool
    -- ^ Square icon-only button (e.g. @btn-icon-outline@)
  , buttonDisabled :: Bool
  , buttonClasses :: [MisoString]
    -- ^ Extra classes appended to the computed basecoat class
  , buttonAttrs :: [Attribute model action]
    -- ^ Extra attributes (e.g. @onClick@)
  }
-----------------------------------------------------------------------------
-- | Smart constructor: primary variant, default size
defaultButtonProps :: ButtonProps model action
defaultButtonProps
  = ButtonProps
  { buttonVariant = Primary
  , buttonSize = DefaultSize
  , buttonIcon = False
  , buttonDisabled = False
  , buttonClasses = []
  , buttonAttrs = []
  }
-----------------------------------------------------------------------------
-- | Computes the basecoat button class (e.g. @btn-sm-icon-outline@)
buttonClass :: ButtonProps model action -> MisoString
buttonClass ButtonProps {..} = MS.intercalate "-" $ concat
  [ [ "btn" ]
  , [ sizeSuffix buttonSize | buttonSize /= DefaultSize ]
  , [ "icon" | buttonIcon ]
  , [ variantSuffix buttonVariant | buttonVariant /= Primary ]
  ]
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/button/ Button>, driven by 'ButtonProps'
button_
  :: ButtonProps model action
  -> [View context props model action]
  -> View context props model action
button_ cfg kids =
  optionalAttrs
    H.button_
    ( P.classes_ (buttonClass cfg : buttonClasses cfg)
    : buttonAttrs cfg
    )
    (buttonDisabled cfg)
    [ P.disabled_ ]
    kids
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
buttonUsage :: View context props model action
buttonUsage =
  H.div_
  [ P.class_ "flex flex-wrap items-center gap-2" ]
  [ button_ defaultButtonProps [ "Primary" ]
  , button_ defaultButtonProps { buttonVariant = Outline } [ "Outline" ]
  , button_ defaultButtonProps { buttonVariant = Ghost } [ "Ghost" ]
  , button_ defaultButtonProps { buttonVariant = Destructive }
    [ sendIcon [], "Danger" ]
  , button_ defaultButtonProps { buttonSize = Small, buttonVariant = Secondary }
    [ "Small" ]
  , button_ defaultButtonProps { buttonSize = Large } [ "Large" ]
  , button_ defaultButtonProps { buttonIcon = True, buttonVariant = Outline }
    [ arrowRightIcon [] ]
  , button_ defaultButtonProps { buttonVariant = Outline, buttonDisabled = True }
    [ loaderIcon [ P.class_ "animate-spin" ], "Loading" ]
  ]
-----------------------------------------------------------------------------
buttonSample :: View context props model action
buttonSample =
  H.div_
  [ P.class_ "flex flex-col gap-6" ]
  [ row DefaultSize, row Small, row Large, icons ]
  where
    row size =
      H.div_
      [ P.class_ "flex flex-wrap items-center gap-2 md:flex-row" ]
      [ button_ defaultButtonProps { buttonSize = size } [ "Primary" ]
      , button_ defaultButtonProps { buttonSize = size, buttonVariant = Outline } [ "Outline" ]
      , button_ defaultButtonProps { buttonSize = size, buttonVariant = Ghost } [ "Ghost" ]
      , button_ defaultButtonProps { buttonSize = size, buttonVariant = Destructive }
        [ sendIcon [], "Danger" ]
      , button_ defaultButtonProps { buttonSize = size, buttonVariant = Secondary } [ "Secondary" ]
      , button_ defaultButtonProps { buttonSize = size, buttonVariant = Link } [ "Link" ]
      , button_ defaultButtonProps { buttonSize = size, buttonVariant = Outline }
        [ sendIcon [], "Send" ]
      , button_ defaultButtonProps { buttonSize = size, buttonVariant = Outline }
        [ "Learn more", arrowRightIcon [] ]
      , button_ defaultButtonProps { buttonSize = size, buttonVariant = Outline, buttonDisabled = True }
        [ loaderIcon [ P.class_ "animate-spin" ], "Loading" ]
      ]
    icons =
      H.div_
      [ P.class_ "flex flex-wrap items-center gap-2 md:flex-row" ]
      [ iconButton Primary (downloadIcon [])
      , iconButton Secondary (uploadIcon [])
      , iconButton Outline (arrowRightIcon [])
      , iconButton Ghost (dotsIcon [])
      , iconButton Destructive (trashIcon [])
      , button_ defaultButtonProps
          { buttonIcon = True
          , buttonVariant = Outline
          , buttonDisabled = True
          }
          [ loaderIcon [ P.class_ "animate-spin" ] ]
      ]
    iconButton v icon =
      button_ defaultButtonProps { buttonIcon = True, buttonVariant = v } [ icon ]
-----------------------------------------------------------------------------
buttonCodeSample :: View context props model action
buttonCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyButton (buttonUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import qualified Miso.String as MS
  import           Miso.UI.Types
  import           Miso.UI.Icons
  import           Miso.UI.Button
  -----------------------------------------------------------------------------
  buttonUsage :: View context props model action
  buttonUsage =
    H.div_
    [ P.class_ "flex flex-wrap items-center gap-2" ]
    [ button_ defaultButtonProps [ "Primary" ]
    , button_ defaultButtonProps { buttonVariant = Outline } [ "Outline" ]
    , button_ defaultButtonProps { buttonVariant = Ghost } [ "Ghost" ]
    , button_ defaultButtonProps { buttonVariant = Destructive }
      [ sendIcon [], "Danger" ]
    , button_ defaultButtonProps { buttonSize = Small, buttonVariant = Secondary }
      [ "Small" ]
    , button_ defaultButtonProps { buttonSize = Large } [ "Large" ]
    , button_ defaultButtonProps { buttonIcon = True, buttonVariant = Outline }
      [ arrowRightIcon [] ]
    , button_ defaultButtonProps { buttonVariant = Outline, buttonDisabled = True }
      [ loaderIcon [ P.class_ "animate-spin" ], "Loading" ]
    ]
  """
-----------------------------------------------------------------------------
buttonPropsApi :: View context props model action
buttonPropsApi =
  """
  -- | Props for 'button'
  data ButtonProps model action
    = ButtonProps
    { buttonVariant :: Variant
      -- ^ 'Primary', 'Secondary', 'Destructive', 'Outline', 'Ghost' or 'Link'
    , buttonSize :: Size
      -- ^ 'DefaultSize', 'Small' or 'Large'
    , buttonIcon :: Bool
      -- ^ Square icon-only button (e.g. @btn-icon-outline@)
    , buttonDisabled :: Bool
    , buttonClasses :: [MisoString]
      -- ^ Extra classes appended to the computed basecoat class
    , buttonAttrs :: [Attribute model action]
      -- ^ Extra attributes (e.g. @onClick@)
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: primary variant, default size
  defaultButtonProps :: ButtonProps model action
  defaultButtonProps
    = ButtonProps
    { buttonVariant = Primary
    , buttonSize = DefaultSize
    , buttonIcon = False
    , buttonDisabled = False
    , buttonClasses = []
    , buttonAttrs = []
    }
  """
-----------------------------------------------------------------------------
