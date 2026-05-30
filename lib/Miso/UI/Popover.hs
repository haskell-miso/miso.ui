-----------------------------------------------------------------------------
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE LambdaCase                 #-}
-----------------------------------------------------------------------------
module Miso.UI.Popover
  ( -- ** Component
    popover_
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
popover_ :: Component parent props model action
popover_ = component undefined noop (\_ _ -> view_)
-----------------------------------------------------------------------------
view_ :: View model action
view_ =
  H.div_
    [ P.id_ "demo-popover"
    , P.class_ "popover"
    ]
    [ H.button_
        [ P.id_ "demo-popover-trigger"
        , P.type_ "button"
        , P.aria_ "expanded" "false"
        , P.aria_ "controls" "demo-popover-popover"
        , P.class_ "btn-outline"
        ][ "Open popover" ]
    , H.div_
        [ P.id_ "demo-popover-popover"
        , textProp "data-popover" ""
        , textProp "aria-hidden" "true"
        , P.class_ "w-80"
        ]
        [ H.div_
            [ P.class_ "grid gap-4" ]
            [ H.header_
                [ P.class_ "grid gap-1.5" ]
                [ H.h4_
                    [ P.class_ "leading-none font-medium" ][ "Dimensions" ]
                , H.p_
                    [ P.class_ "text-muted-foreground text-sm" ][ "Set the dimensions for the layer." ]
                ]
            , H.form_
                [ P.class_ "form grid gap-2" ]
                [ H.div_
                    [ P.class_ "grid grid-cols-3 items-center gap-4" ]
                    [ H.label_
                        [ P.for_ "demo-popover-width" ][ "Width" ]
                    , H.input_
                        [ P.type_ "text"
                        , P.id_ "demo-popover-width"
                        , P.value_ "100%"
                        , P.class_ "col-span-2 h-8"
                        , textProp "autofocus" ""
                        ]
                    , ">"
                    ]
                , H.div_
                    [ P.class_ "grid grid-cols-3 items-center gap-4" ]
                    [ H.label_
                        [ P.for_ "demo-popover-max-width" ][ "Max. width" ]
                    , H.input_
                        [ P.type_ "text"
                        , P.id_ "demo-popover-max-width"
                        , P.value_ "300px"
                        , P.class_ "col-span-2 h-8"
                        ]
                    , ">"
                    ]
                , H.div_
                    [ P.class_ "grid grid-cols-3 items-center gap-4" ]
                    [ H.label_
                        [ P.for_ "demo-popover-height" ][ "Height" ]
                    , H.input_
                        [ P.type_ "text"
                        , P.id_ "demo-popover-height"
                        , P.value_ "25px"
                        , P.class_ "col-span-2 h-8"
                        ]
                    , ">"
                    ]
                , H.div_
                    [ P.class_ "grid grid-cols-3 items-center gap-4" ]
                    [ H.label_
                        [ P.for_ "demo-popover-max-height" ][ "Max. height" ]
                    , H.input_
                        [ P.type_ "text"
                        , P.id_ "demo-popover-max-height"
                        , P.value_ "none"
                        , P.class_ "col-span-2 h-8"
                        ]
                    , ">"
                    ]
                ]
            ]
        ]
    ]

