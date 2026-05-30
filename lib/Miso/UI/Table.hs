-----------------------------------------------------------------------------
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE LambdaCase                 #-}
-----------------------------------------------------------------------------
module Miso.UI.Table
  ( -- ** Component
    table_
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
table_ :: Component parent props model action
table_ = component undefined noop (\_ _ -> view_)
-----------------------------------------------------------------------------
view_ :: View model action
view_ =
  H.div_
    [ P.class_ "overflow-x-auto" ]
    [ H.table_
        [ P.class_ "table" ]
        [ H.caption_ [] [ "A list of your recent invoices." ]
        , H.thead_ []
            [ H.tr_ []
                [ H.th_ [][ "Invoice" ]
                , H.th_ [][ "Status" ]
                , H.th_ [][ "Method" ]
                , H.th_ [][ "Amount" ]
                ]
            ]
        , H.tbody_ []
            [ H.tr_ []
                [ H.td_
                    [ P.class_ "font-medium" ][ "INV001" ]
                , H.td_ [][ "Paid" ]
                , H.td_ [][ "Credit Card" ]
                , H.td_
                    [ P.class_ "text-right" ][ "$250.00" ]
                ]
            , H.tr_ []
                [ H.td_
                    [ P.class_ "font-medium" ][ "INV002" ]
                , H.td_ [][ "Pending" ]
                , H.td_ [][ "PayPal" ]
                , H.td_
                    [ P.class_ "text-right" ][ "$150.00" ]
                ]
            , H.tr_ []
                [ H.td_
                    [ P.class_ "font-medium" ][ "INV003" ]
                , H.td_ [][ "Unpaid" ]
                , H.td_ [][ "Bank Transfer" ]
                , H.td_
                    [ P.class_ "text-right" ][ "$350.00" ]
                ]
            , H.tr_ []
                [ H.td_
                    [ P.class_ "font-medium" ][ "INV004" ]
                , H.td_ [][ "Paid" ]
                , H.td_ [][ "Paypal" ]
                , H.td_
                    [ P.class_ "text-right" ][ "$450.00" ]
                ]
            , H.tr_ []
                [ H.td_
                    [ P.class_ "font-medium" ][ "INV005" ]
                , H.td_ [][ "Paid" ]
                , H.td_ [][ "Credit Card" ]
                , H.td_
                    [ P.class_ "text-right" ][ "$550.00" ]
                ]
            , H.tr_ []
                [ H.td_
                    [ P.class_ "font-medium" ][ "INV006" ]
                , H.td_ [][ "Pending" ]
                , H.td_ [][ "Bank Transfer" ]
                , H.td_
                    [ P.class_ "text-right" ][ "$200.00" ]
                ]
            , H.tr_ []
                [ H.td_
                    [ P.class_ "font-medium" ][ "INV007" ]
                , H.td_ [][ "Unpaid" ]
                , H.td_ [][ "Credit Card" ]
                , H.td_
                    [ P.class_ "text-right" ][ "$300.00" ]
                ]
            ]
        , H.tfoot_ []
            [ H.tr_ []
                [ H.td_
                    [ P.colspan_ "3" ][ "Total" ]
                , H.td_
                    [ P.class_ "text-right" ][ "$2,500.00" ]
                ]
            ]
        ]
    ]

