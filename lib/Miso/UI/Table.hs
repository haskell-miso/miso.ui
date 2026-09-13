-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Table
  ( -- ** Props
    TableProps (..)
  , defaultTableProps
    -- ** Views
  , table_
    -- ** Samples
  , tableUsage
  , tableSample
  , tableCodeSample
  , tablePropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
-- | Props for 'table_'
data TableProps model action
  = TableProps
  { tableClasses :: [MisoString]
    -- ^ Extra classes appended to the @table@
  , tableWrapperClasses :: [MisoString]
    -- ^ Extra classes appended to the scrollable wrapper
  , tableAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultTableProps :: TableProps model action
defaultTableProps
  = TableProps
  { tableClasses = []
  , tableWrapperClasses = []
  , tableAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/table/ Table>: scroll-wrapped basecoat table.
-- Children are the usual @caption_@ \/ @thead_@ \/ @tbody_@ \/ @tfoot_@ views.
table_
  :: TableProps model action
  -> [View context props model action]
  -> View context props model action
table_ TableProps {..} kids =
  H.div_
  [ P.classes_ ("relative" : "w-full" : "overflow-x-auto" : tableWrapperClasses) ]
  [ H.table_
    ( P.classes_ ("table" : tableClasses)
    : tableAttrs
    ) kids
  ]
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
tableUsage :: View context props model action
tableUsage =
  table_ defaultTableProps
  [ H.caption_ [] [ "A list of your recent invoices." ]
  , H.thead_ []
    [ H.tr_ []
      [ H.th_ [] [ "Invoice" ]
      , H.th_ [] [ "Status" ]
      , H.th_ [] [ "Amount" ]
      ]
    ]
  , H.tbody_ []
    [ H.tr_ []
      [ H.td_ [ P.class_ "font-medium" ] [ "INV001" ]
      , H.td_ [] [ "Paid" ]
      , H.td_ [ P.class_ "text-right" ] [ "$250.00" ]
      ]
    ]
  ]
-----------------------------------------------------------------------------
tableSample :: View context props model action
tableSample =
  table_ defaultTableProps
  [ H.caption_ [] [ "A list of your recent invoices." ]
  , H.thead_ []
    [ H.tr_ []
      [ H.th_ [] [ "Invoice" ]
      , H.th_ [] [ "Status" ]
      , H.th_ [] [ "Method" ]
      , H.th_ [] [ "Amount" ]
      ]
    ]
  , H.tbody_ []
    [ H.tr_ []
      [ H.td_ [ P.class_ "font-medium" ] [ text invoice ]
      , H.td_ [] [ text status ]
      , H.td_ [] [ text method ]
      , H.td_ [ P.class_ "text-right" ] [ text amount ]
      ]
    | (invoice, status, method, amount) <- invoices
    ]
  , H.tfoot_ []
    [ H.tr_ []
      [ H.td_ [ P.colspan_ "3" ] [ "Total" ]
      , H.td_ [ P.class_ "text-right" ] [ "$2,500.00" ]
      ]
    ]
  ]
  where
    invoices =
      [ ("INV001", "Paid", "Credit Card", "$250.00")
      , ("INV002", "Pending", "PayPal", "$150.00")
      , ("INV003", "Unpaid", "Bank Transfer", "$350.00")
      , ("INV004", "Paid", "Paypal", "$450.00")
      , ("INV005", "Paid", "Credit Card", "$550.00")
      , ("INV006", "Pending", "Bank Transfer", "$200.00")
      , ("INV007", "Unpaid", "Credit Card", "$300.00")
      ]
-----------------------------------------------------------------------------
tableCodeSample :: View context props model action
tableCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyTable (tableUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Table
  -----------------------------------------------------------------------------
  tableUsage :: View context props model action
  tableUsage =
    table_ defaultTableProps
    [ H.caption_ [] [ "A list of your recent invoices." ]
    , H.thead_ []
      [ H.tr_ []
        [ H.th_ [] [ "Invoice" ]
        , H.th_ [] [ "Status" ]
        , H.th_ [] [ "Amount" ]
        ]
      ]
    , H.tbody_ []
      [ H.tr_ []
        [ H.td_ [ P.class_ "font-medium" ] [ "INV001" ]
        , H.td_ [] [ "Paid" ]
        , H.td_ [ P.class_ "text-right" ] [ "$250.00" ]
        ]
      ]
    ]
  """
-----------------------------------------------------------------------------
tablePropsApi :: View context props model action
tablePropsApi =
  """
  -- | Props for 'table_'
  data TableProps model action
    = TableProps
    { tableClasses :: [MisoString]
      -- ^ Extra classes appended to the @table@
    , tableWrapperClasses :: [MisoString]
      -- ^ Extra classes appended to the scrollable wrapper
    , tableAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultTableProps :: TableProps model action
  defaultTableProps
    = TableProps
    { tableClasses = []
    , tableWrapperClasses = []
    , tableAttrs = []
    }
  """
-----------------------------------------------------------------------------
