-----------------------------------------------------------------------------
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE LambdaCase                 #-}
-----------------------------------------------------------------------------
module Miso.UI.Select
  ( -- ** Component
    select_
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
select_ :: Component parent props model action
select_ = component undefined noop (\_ _ -> view_)
-----------------------------------------------------------------------------
view_ :: View model action
view_ = H.select_
  [ P.class_ "select w-[180px]" ]
  [ H.optgroup_
      [ P.label_ "Fruits"
      ]
      [ H.option_ []  [ "Apple" ]
      , H.option_ []  [ "Banana" ]
      , H.option_ []  [ "Blueberry" ]
      , H.option_ []  [ "Grapes" ]
      , H.option_ []  [ "Pineapple" ]
      ]
  ]

