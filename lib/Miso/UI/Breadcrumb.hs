-----------------------------------------------------------------------------
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE LambdaCase                 #-}
-----------------------------------------------------------------------------
module Miso.UI.Breadcrumb
  ( -- ** Component
    breadcrumb_
  ) where
-----------------------------------------------------------------------------
import           Miso
import           Miso.Html
import qualified Miso.Svg as S
import qualified Miso.Svg.Property as SP
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-- import           Miso.Lens
-----------------------------------------------------------------------------
breadcrumb_ :: Component parent props model action
breadcrumb_ = component undefined noop (\_ _ -> view_)
-----------------------------------------------------------------------------
view_ :: View model action
view_ = H.ol_
    [ P.class_
        "text-muted-foreground flex flex-wrap items-center gap-1.5 text-sm break-words sm:gap-2.5"
    ]
    [ H.li_
        [ P.class_ "inline-flex items-center gap-1.5"]
        [ H.a_
            [ P.class_ "hover:text-foreground transition-colors"
            , P.href_ "#"
            ]
            ["Home"]
        ]
    , H.li_
        []
        [ H.svg_
            [ P.class_ "size-3.5"
            , SP.strokeWidth_ "2"
            , SP.strokeLinecap_ "round" 
            , SP.strokeLinejoin_ "round"
            , SP.stroke_ "currentColor"
            , SP.fill_ "none"
            , SP.viewBox_ "0 0 24 24"
            , P.height_ "24"
            , P.width_ "24"
            , P.xmlns_ "http://www.w3.org/2000/svg"
            ]
            [S.path_ [SP.d_ "m9 18 6-6-6-6"]]
        ]
    , H.li_
        [P.class_ "inline-flex items-center gap-1.5"]
        [ H.div_
            [ P.class_ "dropdown-menu"
            , P.id_ "demo-breadcrumb-menu"
            ]
            [ H.button_
                [ P.class_
                    "flex size-9 items-center justify-center h-4 w-4 hover:text-foreground cursor-pointer"
                , P.aria_ "expanded" "false"
                , P.aria_ "controls" "demo-breadcrumb-menu-menu"
                , P.aria_ "haspopup" "menu"
                , P.id_ "demo-breadcrumb-menu-trigger"
                , P.type_ "button"
                ]
                [ H.svg_
                    [ SP.strokeWidth_ "2"
                    , SP.strokeLinecap_ "round" 
                    , SP.strokeLinejoin_ "round"
                    , SP.stroke_ "currentColor"
                    , SP.fill_ "none"
                    , SP.viewBox_ "0 0 24 24"
                    , P.height_ "24"
                    , P.width_ "24"
                    , P.xmlns_ "http://www.w3.org/2000/svg"
                    ]
                    [ S.circle_ [SP.r_ "1", SP.cy_ "12", SP.cx_ "12"]
                    , S.circle_ [SP.r_ "1", SP.cy_ "12", SP.cx_ "19"]
                    , S.circle_ [SP.r_ "1", SP.cy_ "12", SP.cx_ "5"]
                    ]
                ]
            , H.div_
                [ P.aria_ "hidden" "true"
                , P.data_ "popover" ""
                , P.id_ "demo-breadcrumb-menu-popover"
                ]
                [ div_
                    [ P.aria_ "labelledby" "demo-breadcrumb-menu-trigger"
                    , P.id_ "demo-breadcrumb-menu-menu"
                    , P.role_ "menu"
                    ]
                    [ nav_
                        [P.role_ "menu"]
                        [ H.button_
                            [P.role_ "menuitem", P.type_ "button"]
                            ["Documentation"]
                        , H.button_
                            [P.role_ "menuitem", P.type_ "button"]
                            ["Themes"]
                        , H.button_
                            [P.role_ "menuitem", P.type_ "button"]
                            ["GitHub"]
                        ]
                    ]
                ]
            ]
        ]
    , H.li_
        []
        [ H.svg_
            [ P.class_ "size-3.5"
            , SP.strokeWidth_ "2"
            , SP.strokeLinecap_ "round" 
            , SP.strokeLinejoin_ "round"
            , SP.stroke_ "currentColor"
            , SP.fill_ "none"
            , SP.viewBox_ "0 0 24 24"
            , P.height_ "24"
            , P.width_ "24"
            , P.xmlns_ "http://www.w3.org/2000/svg"
            ]
            [S.path_ [SP.d_ "m9 18 6-6-6-6"]]
        ]
    , H.li_
        [P.class_ "inline-flex items-center gap-1.5"]
        [ H.a_
            [ P.class_ "hover:text-foreground transition-colors"
            , P.href_ "#"
            ]
            ["Components"]
        ]
    , H.li_
        []
        [ H.svg_
            [ P.class_ "size-3.5"
            , SP.strokeWidth_ "2"
            , SP.strokeLinecap_ "round" 
            , SP.strokeLinejoin_ "round"
            , SP.stroke_ "currentColor"
            , SP.fill_ "none"
            , SP.viewBox_ "0 0 24 24"
            , P.height_ "24"
            , P.width_ "24"
            , P.xmlns_ "http://www.w3.org/2000/svg"
            ]
            [S.path_ [SP.d_ "m9 18 6-6-6-6"]]
        ]
    , H.li_
        [P.class_ "inline-flex items-center gap-1.5"]
        [ H.span_
            [P.class_ "text-foreground font-normal"]
            ["Breadcrumb"]
        ]
    ]

