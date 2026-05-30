-----------------------------------------------------------------------------
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE LambdaCase                 #-}
-----------------------------------------------------------------------------
module Miso.UI.Card
  ( -- ** Component
    card_
  ) where
-----------------------------------------------------------------------------
import           Miso
import           Miso.Html
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
card_ :: Component parent props model action
card_ = component undefined noop (\_ _ -> view_)
-----------------------------------------------------------------------------
view_ :: View model action
view_ =
  H.div_
  [ P.class_ "card w-full" ]
  [ H.header_ []
    [ H.h2_ [][ "Login to your account" ]
    , H.p_ [][ "Enter your details below to login to your account" ]
    ]
  , H.section_ []
    [ H.form_
      [ P.class_ "form grid gap-6"
      ]
      [ H.div_
        [ P.class_ "grid gap-2" ]
        [ H.label_ [ P.for_ "demo-card-form-email" ][ "Email" ]
        , input_
          [ P.type_ "email"
          , P.id_ "demo-card-form-email"
          ]
        ]
      , H.div_ [ P.class_ "grid gap-2" ]
        [ H.div_ [ P.class_ "flex items-center gap-2" ]
          [ H.label_ [ P.for_ "demo-card-form-password" ][ "Password" ]
          , H.a_
            [ P.href_ "#"
            , P.class_ "ml-auto inline-block text-sm underline-offset-4 hover:underline"
            ] [ "Forgot your password?" ]
          ]
        , H.input_
          [ P.type_ "password"
          , P.id_ "demo-card-form-password"
          ]
        ]
      ]
    ]
  , H.footer_ [ P.class_ "flex flex-col items-center gap-2" ]
    [ H.button_
      [ P.type_ "button"
      , P.class_ "btn w-full"
      ] [ "Login" ]
    , H.button_
      [ P.type_ "button"
      , P.class_ "btn-outline w-full"
      ] [ "Login with Google" ]
    , H.p_ [ P.class_ "mt-4 text-center text-sm" ]
      [ "Don't have an account? "
      , H.a_
        [ P.href_ "#"
        , P.class_ "underline-offset-4 hover:underline"
        ] [ "Sign up" ]
      ]
    ]
  ]

