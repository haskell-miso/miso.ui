-----------------------------------------------------------------------------
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE LambdaCase                 #-}
-----------------------------------------------------------------------------
module Miso.UI.Button
  ( -- ** Component
    button_
  ) where
-----------------------------------------------------------------------------
import           Miso
-- import qualified Miso.Svg as S
-- import qualified Miso.Svg.Property as SP
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-- import           Miso.Lens
-----------------------------------------------------------------------------
button_ :: Component parent props model action
button_ = component undefined noop (\_ _ -> view_)
-----------------------------------------------------------------------------
view_ :: View model action
view_ = H.button_ [ P.class_ "btn" ] [ "Button" ]
-----------------------------------------------------------------------------
