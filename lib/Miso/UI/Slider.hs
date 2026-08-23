-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Slider
  ( -- ** Props
    SliderProps (..)
  , defaultSliderProps
    -- ** Views
  , slider_
    -- ** Samples
  , sliderSample
  , sliderCodeSample
  , sliderPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.CSS as CSS
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
-- | Props for 'slider_'
data SliderProps model action
  = SliderProps
  { sliderMin :: MisoString
  , sliderMax :: MisoString
  , sliderStep :: MisoString
  , sliderValue :: MisoString
  , sliderPercent :: MisoString
    -- ^ Initial track fill, sets the @--slider-value@ CSS variable (e.g. @\"75%\"@)
  , sliderClasses :: [MisoString]
    -- ^ Extra classes appended to the @input@
  , sliderAttrs :: [Attribute model action]
    -- ^ Extra attributes; basecoat's slider JS needs
    -- @onCreatedWith@ \/ @onBeforeDestroyedWith@ hooks passed here
  }
-----------------------------------------------------------------------------
-- | Smart constructor: 0-100, starts at 50
defaultSliderProps :: SliderProps model action
defaultSliderProps
  = SliderProps
  { sliderMin = "0"
  , sliderMax = "100"
  , sliderStep = "1"
  , sliderValue = "50"
  , sliderPercent = "50%"
  , sliderClasses = [ "w-full" ]
  , sliderAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/slider/ Slider>, driven by 'SliderProps'
slider_ :: SliderProps model action -> View context model action
slider_ SliderProps {..} = H.input_ $ concat
  [ [ CSS.style_ [ "--slider-value" =: sliderPercent ]
    , P.classes_ ("input" : sliderClasses)
    , P.type_ "range"
    , P.min_ sliderMin
    , P.max_ sliderMax
    , P.step_ sliderStep
    , P.value_ sliderValue
    ]
  , sliderAttrs
  ]
-----------------------------------------------------------------------------
-- | Takes the app's slider init\/destroy hooks (basecoat's JS keeps the
-- track fill in sync while dragging)
sliderSample
  :: (DOMRef -> action)
  -> (DOMRef -> action)
  -> View context model action
sliderSample initSlider destroySlider =
  H.div_
  [ P.class_ "max-w-sm" ]
  [ slider_ defaultSliderProps
    { sliderMax = "200"
    , sliderValue = "150"
    , sliderPercent = "75%"
    , sliderAttrs =
      [ onCreatedWith initSlider
      , onBeforeDestroyedWith destroySlider
      ]
    }
  ]
-----------------------------------------------------------------------------
sliderCodeSample :: View context model action
sliderCodeSample =
  """
  -----------------------------------------------------------------------------
  module MySlider (sliderSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.CSS as CSS
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Slider
  -----------------------------------------------------------------------------
  sliderSample
    :: (DOMRef -> action)
    -> (DOMRef -> action)
    -> View context model action
  sliderSample initSlider destroySlider =
    H.div_
    [ P.class_ "max-w-sm" ]
    [ slider_ defaultSliderProps
      { sliderMax = "200"
      , sliderValue = "150"
      , sliderPercent = "75%"
      , sliderAttrs =
        [ onCreatedWith initSlider
        , onBeforeDestroyedWith destroySlider
        ]
      }
    ]
  """
-----------------------------------------------------------------------------
sliderPropsApi :: View context model action
sliderPropsApi =
  """
  -- | Props for 'slider_'
  data SliderProps model action
    = SliderProps
    { sliderMin :: MisoString
    , sliderMax :: MisoString
    , sliderStep :: MisoString
    , sliderValue :: MisoString
    , sliderPercent :: MisoString
      -- ^ Initial track fill, sets the @--slider-value@ CSS variable (e.g. @\\"75%\\"@)
    , sliderClasses :: [MisoString]
      -- ^ Extra classes appended to the @input@
    , sliderAttrs :: [Attribute model action]
      -- ^ Extra attributes; basecoat's slider JS needs
      -- @onCreatedWith@ \\/ @onBeforeDestroyedWith@ hooks passed here
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: 0-100, starts at 50
  defaultSliderProps :: SliderProps model action
  defaultSliderProps
    = SliderProps
    { sliderMin = "0"
    , sliderMax = "100"
    , sliderStep = "1"
    , sliderValue = "50"
    , sliderPercent = "50%"
    , sliderClasses = [ "w-full" ]
    , sliderAttrs = []
    }
  """
-----------------------------------------------------------------------------
