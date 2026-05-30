-----------------------------------------------------------------------------
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE LambdaCase                 #-}
-----------------------------------------------------------------------------
module Miso.UI.Checkbox
  ( -- ** Component
    checkbox_
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
checkbox_ :: Component parent props model action
checkbox_ = component undefined noop (\_ _ -> view_)
-----------------------------------------------------------------------------
view_ :: View model action
view_ =
  H.label_
  [ P.class_ "label gap-3" ]
  [ H.input_ 
    [ P.type_ "checkbox" 
    , P.class_ "input" 
    ] 
  , "Accept terms and conditions" 
  ] 
-----------------------------------------------------------------------------
