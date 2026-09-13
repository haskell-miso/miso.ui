-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Kbd
  ( -- ** Props
    KbdProps (..)
  , defaultKbdProps
    -- ** Views
  , kbd_
  , kbdGroup_
    -- ** Samples
  , kbdSample
  , kbdCodeSample
  , kbdPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
-- | Props for 'kbd_'
data KbdProps model action
  = KbdProps
  { kbdClasses :: [MisoString]
    -- ^ Extra classes appended to @kbd@
  , kbdAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultKbdProps :: KbdProps model action
defaultKbdProps
  = KbdProps
  { kbdClasses = []
  , kbdAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/kbd/ Kbd>, driven by 'KbdProps'
kbd_
  :: KbdProps model action
  -> [View context props model action]
  -> View context props model action
kbd_ KbdProps {..} kids =
  H.kbd_
    ( P.classes_ ("kbd" : kbdClasses)
    : kbdAttrs
    ) kids
-----------------------------------------------------------------------------
-- | Groups several 'kbd_' keys on one line
kbdGroup_
  :: [Attribute model action]
  -> [View context props model action]
  -> View context props model action
kbdGroup_ attrs kids =
  H.span_
    ( P.class_ "inline-flex items-center gap-1"
    : attrs
    ) kids
-----------------------------------------------------------------------------
kbdSample :: View context props model action
kbdSample =
  H.div_
  [ P.class_ "flex flex-col items-center gap-4" ]
  [ kbdGroup_ []
    [ kbd_ defaultKbdProps [ k ] | k <- [ "⌘", "⇧", "⌥", "⌃" ] ]
  , kbdGroup_ []
    [ kbd_ defaultKbdProps [ "Ctrl" ]
    , H.span_ [] [ "+" ]
    , kbd_ defaultKbdProps [ "B" ]
    ]
  ]
-----------------------------------------------------------------------------
kbdCodeSample :: View context props model action
kbdCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyKbd (kbdSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Kbd
  -----------------------------------------------------------------------------
  kbdSample :: View context props model action
  kbdSample =
    H.div_
    [ P.class_ "flex flex-col items-center gap-4" ]
    [ kbdGroup_ []
      [ kbd_ defaultKbdProps [ k ] | k <- [ "⌘", "⇧", "⌥", "⌃" ] ]
    , kbdGroup_ []
      [ kbd_ defaultKbdProps [ "Ctrl" ]
      , H.span_ [] [ "+" ]
      , kbd_ defaultKbdProps [ "B" ]
      ]
    ]
  """
-----------------------------------------------------------------------------
kbdPropsApi :: View context props model action
kbdPropsApi =
  """
  -- | Props for 'kbd_'
  data KbdProps model action
    = KbdProps
    { kbdClasses :: [MisoString]
      -- ^ Extra classes appended to @kbd@
    , kbdAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultKbdProps :: KbdProps model action
  defaultKbdProps
    = KbdProps
    { kbdClasses = []
    , kbdAttrs = []
    }
  """
-----------------------------------------------------------------------------
