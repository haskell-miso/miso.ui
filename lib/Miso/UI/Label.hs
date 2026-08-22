-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Label
  ( -- ** Props
    LabelProps (..)
  , defaultLabelProps
    -- ** Views
  , label_
    -- ** Samples
  , labelSample
  , labelCodeSample
  , labelPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
-- | Props for 'label_'
data LabelProps action
  = LabelProps
  { labelFor :: Maybe MisoString
    -- ^ @for@ attribute (id of the labelled control)
  , labelClasses :: [MisoString]
    -- ^ Extra classes appended to @label@
  , labelAttrs :: [Attribute action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultLabelProps :: LabelProps action
defaultLabelProps
  = LabelProps
  { labelFor = Nothing
  , labelClasses = []
  , labelAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/label/ Label>, driven by 'LabelProps'
label_
  :: LabelProps action
  -> [View model action]
  -> View model action
label_ LabelProps {..} kids = H.label_
  ( concat
    [ [ P.classes_ ("label" : labelClasses) ]
    , [ P.for_ f | Just f <- [labelFor] ]
    , labelAttrs
    ]
  ) kids
-----------------------------------------------------------------------------
labelSample :: View model action
labelSample =
  H.div_
  [ P.class_ "grid w-full max-w-sm gap-6" ]
  [ H.div_
    [ P.class_ "flex items-center gap-3" ]
    [ H.input_
      [ P.class_ "input"
      , P.id_ "label-demo-terms"
      , P.type_ "checkbox"
      ]
    , label_ defaultLabelProps { labelFor = Just "label-demo-terms" }
      [ "Accept terms and conditions" ]
    ]
  , H.div_
    [ P.class_ "grid gap-3" ]
    [ label_ defaultLabelProps { labelFor = Just "label-demo-text" } [ "Username" ]
    , H.input_
      [ P.placeholder_ "Username"
      , P.class_ "input"
      , P.id_ "label-demo-text"
      , P.type_ "text"
      ]
    ]
  , H.div_
    [ P.class_ "grid gap-3" ]
    [ label_ defaultLabelProps { labelFor = Just "label-demo-disabled" } [ "Disabled" ]
    , H.input_
      [ P.disabled_
      , P.placeholder_ "Disabled"
      , P.class_ "peer input"
      , P.id_ "label-demo-disabled"
      , P.type_ "text"
      ]
    ]
  ]
-----------------------------------------------------------------------------
labelCodeSample :: View model action
labelCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyLabel (labelSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Label
  -----------------------------------------------------------------------------
  labelSample :: View model action
  labelSample =
    H.div_
    [ P.class_ "grid w-full max-w-sm gap-6" ]
    [ H.div_
      [ P.class_ "flex items-center gap-3" ]
      [ H.input_
        [ P.class_ "input"
        , P.id_ "label-demo-terms"
        , P.type_ "checkbox"
        ]
      , label_ defaultLabelProps { labelFor = Just "label-demo-terms" }
        [ "Accept terms and conditions" ]
      ]
    , H.div_
      [ P.class_ "grid gap-3" ]
      [ label_ defaultLabelProps { labelFor = Just "label-demo-text" } [ "Username" ]
      , H.input_
        [ P.placeholder_ "Username"
        , P.class_ "input"
        , P.id_ "label-demo-text"
        , P.type_ "text"
        ]
      ]
    , H.div_
      [ P.class_ "grid gap-3" ]
      [ label_ defaultLabelProps { labelFor = Just "label-demo-disabled" } [ "Disabled" ]
      , H.input_
        [ P.disabled_
        , P.placeholder_ "Disabled"
        , P.class_ "peer input"
        , P.id_ "label-demo-disabled"
        , P.type_ "text"
        ]
      ]
    ]
  """
-----------------------------------------------------------------------------
labelPropsApi :: View model action
labelPropsApi =
  """
  -- | Props for 'label_'
  data LabelProps action
    = LabelProps
    { labelFor :: Maybe MisoString
      -- ^ @for@ attribute (id of the labelled control)
    , labelClasses :: [MisoString]
      -- ^ Extra classes appended to @label@
    , labelAttrs :: [Attribute action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultLabelProps :: LabelProps action
  defaultLabelProps
    = LabelProps
    { labelFor = Nothing
    , labelClasses = []
    , labelAttrs = []
    }
  """
-----------------------------------------------------------------------------
