-----------------------------------------------------------------------------
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE LambdaCase                 #-}
-----------------------------------------------------------------------------
module Miso.UI.RadioGroup
  ( -- ** Component
    radioGroup_
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
radioGroup_ :: Component parent props model action
radioGroup_ = component undefined noop (\_ _ -> view_)
-----------------------------------------------------------------------------
view_ :: View model action
view_ =
  H.fieldset_
    [ P.class_ "grid gap-3" ]
    [ H.label_
        [ P.class_ "label" ]
        [ H.input_
            [ P.type_ "radio"
            , P.name_ "radio-group"
            , P.value_ "default"
            , P.class_ "input"
            ]
        , "Default"
        ]
    , H.label_
        [ P.class_ "label" ]
        [ H.input_
            [ P.type_ "radio"
            , P.name_ "radio-group"
            , P.value_ "comfortable"
            , P.class_ "input"
            , P.checked_ True
            ]
        , "Comfortable"
        ]
    , H.label_
        [ P.class_ "label" ]
        [ H.input_
            [ P.type_ "radio"
            , P.name_ "radio-group"
            , P.value_ "compact"
            , P.class_ "input"
            ]
        , "Compact"
        ]
    ]
-----------------------------------------------------------------------------
