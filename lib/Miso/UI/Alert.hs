-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Alert
  ( -- ** Props
    AlertProps (..)
  , defaultAlertProps
    -- ** Views
  , alert_
  , alertHeader_
  , alertSection_
    -- ** Sample
  , alertSample
  , alertCodeSample
  , alertPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso hiding (alert)
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Icons
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props for 'alert_'
data AlertProps model action
  = AlertProps
  { alertVariant :: Variant
    -- ^ 'Primary' (default) or 'Destructive'
  , alertClasses :: [MisoString]
    -- ^ Extra classes appended to the alert
  , alertAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: default (success-styled) alert
defaultAlertProps :: AlertProps model action
defaultAlertProps
  = AlertProps
  { alertVariant = Primary
  , alertClasses = []
  , alertAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/alert/ Alert>, driven by 'AlertProps'.
-- Children are typically an icon, an 'alertHeader_' and an 'alertSection_'.
alert_
  :: AlertProps model action
  -> [View context model action]
  -> View context model action
alert_ AlertProps {..} kids =
  H.div_
    ( P.classes_
      ( ( case alertVariant of
            Destructive -> "alert-destructive"
            _ -> "alert"
        ) : alertClasses
      )
    : alertAttrs
    ) kids
-----------------------------------------------------------------------------
alertHeader_
  :: [Attribute model action]
  -> [View context model action]
  -> View context model action
alertHeader_ attrs kids = H.h2_ attrs kids
-----------------------------------------------------------------------------
alertSection_
  :: [Attribute model action]
  -> [View context model action]
  -> View context model action
alertSection_ attrs kids = H.section_ attrs kids
-----------------------------------------------------------------------------
alertSample :: View context model action
alertSample =
  H.div_
  [ P.class_ "p-4" ]
  [ H.div_ [ P.class_ "grid max-w-xl items-start gap-4" ]
    [ alert_ defaultAlertProps
      [ circleCheckIcon []
      , alertHeader_ [] [ "Success!" ]
      , alertSection_ []
        [ """
          Congratulations this is a
          successful alert !
          """
        ]
      ]
    , alert_ defaultAlertProps { alertVariant = Destructive }
      [ circleAlertIcon []
      , alertHeader_ [] [ "Warning!" ]
      , alertSection_ []
        [ """
          Something bad happened :( you're getting
          a destructive alert!
          """
        ]
      ]
    ]
  ]
-----------------------------------------------------------------------------
alertCodeSample :: View context model action
alertCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyAlert (alertSample) where
  -----------------------------------------------------------------------------
  import           Miso hiding (alert)
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Icons
  import           Miso.UI.Types
  import           Miso.UI.Alert
  -----------------------------------------------------------------------------
  alertSample :: View context model action
  alertSample =
    H.div_
    [ P.class_ "p-4" ]
    [ H.div_ [ P.class_ "grid max-w-xl items-start gap-4" ]
      [ alert_ defaultAlertProps
        [ circleCheckIcon []
        , alertHeader_ [] [ "Success!" ]
        , alertSection_ []
          [ \"\"\"
            Congratulations this is a
            successful alert !
            \"\"\"
          ]
        ]
      , alert_ defaultAlertProps { alertVariant = Destructive }
        [ circleAlertIcon []
        , alertHeader_ [] [ "Warning!" ]
        , alertSection_ []
          [ \"\"\"
            Something bad happened :( you're getting
            a destructive alert!
            \"\"\"
          ]
        ]
      ]
    ]
  """
-----------------------------------------------------------------------------
alertPropsApi :: View context model action
alertPropsApi =
  """
  -- | Props for 'alert_'
  data AlertProps model action
    = AlertProps
    { alertVariant :: Variant
      -- ^ 'Primary' (default) or 'Destructive'
    , alertClasses :: [MisoString]
      -- ^ Extra classes appended to the alert
    , alertAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: default (success-styled) alert
  defaultAlertProps :: AlertProps model action
  defaultAlertProps
    = AlertProps
    { alertVariant = Primary
    , alertClasses = []
    , alertAttrs = []
    }
  """
-----------------------------------------------------------------------------
