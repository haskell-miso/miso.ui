-----------------------------------------------------------------------------
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE LambdaCase                 #-}
-----------------------------------------------------------------------------
module Miso.UI.Switch
  ( -- ** Component
    switch_
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
switch_ :: Component parent props model action
switch_ = component undefined noop (\_ _ -> view_)
-----------------------------------------------------------------------------
view_ :: View model action
view_ =
  H.label_
  [ P.class_ "label" ]
  [ H.input_
    [ P.type_ "checkbox"
    , P.name_ "switch"
    , P.role_ "switch"
    , P.class_ "input"
    ]
  , "Airplane Mode"
  ]
-----------------------------------------------------------------------------

