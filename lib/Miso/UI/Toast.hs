-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Toast
  ( -- ** Props
    ToastProps (..)
  , defaultToastProps
    -- ** Views
  , toastTrigger_
  , toaster_
    -- ** Samples
  , toastSample
  , toastCodeSample
  , toastPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Event as E
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Button
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props describing a basecoat toast. Dispatched to basecoat's toaster JS
-- (a @basecoat:toast@ custom event) by the application's update function.
data ToastProps
  = ToastProps
  { toastCategory :: MisoString
    -- ^ @success@, @error@, @info@ or @warning@
  , toastTitle :: MisoString
  , toastDescription :: MisoString
  , toastLabel :: MisoString
    -- ^ Label of the dismiss button
  } deriving (Show, Eq)
-----------------------------------------------------------------------------
-- | Smart constructor: informational toast
defaultToastProps :: ToastProps
defaultToastProps
  = ToastProps
  { toastCategory = "info"
  , toastTitle = ""
  , toastDescription = ""
  , toastLabel = "Dismiss"
  }
-----------------------------------------------------------------------------
-- | Button that raises a toast; the application maps 'ToastProps' into its
-- own action (which should dispatch the @basecoat:toast@ event)
toastTrigger_
  :: (ToastProps -> action)
  -> ToastProps
  -> [View context model action]
  -> View context model action
toastTrigger_ toAction cfg kids =
  button_ defaultButtonProps
    { buttonVariant = Outline
    , buttonAttrs = [ E.onClick (toAction cfg) ]
    } kids
-----------------------------------------------------------------------------
-- | The toaster container basecoat renders toasts into; place once per page
toaster_ :: [Attribute model action] -> View context model action
toaster_ attrs = H.div_ (P.id_ "toaster" : P.class_ "toaster" : attrs) []
-----------------------------------------------------------------------------
toastSample :: (ToastProps -> action) -> View context model action
toastSample toAction =
  H.div_
  [ P.class_ "flex flex-wrap items-center gap-2" ]
  [ toastTrigger_ toAction
      defaultToastProps
        { toastCategory = "success"
        , toastTitle = "Success"
        , toastDescription = "A successful toast !"
        }
      [ "Success" ]
  , toastTrigger_ toAction
      defaultToastProps
        { toastCategory = "error"
        , toastTitle = "Error"
        , toastDescription = "An error toast :("
        }
      [ "Error" ]
  , toastTrigger_ toAction
      defaultToastProps
        { toastCategory = "info"
        , toastTitle = "Info"
        , toastDescription = "An informational toast =]"
        }
      [ "Info" ]
  , toastTrigger_ toAction
      defaultToastProps
        { toastCategory = "warning"
        , toastTitle = "Warning"
        , toastDescription = "A warning toast :/"
        }
      [ "Warning" ]
  ]
-----------------------------------------------------------------------------
toastCodeSample :: View context model action
toastCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyToast (toastSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Event as E
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Button
  import           Miso.UI.Types
  import           Miso.UI.Toast
  -----------------------------------------------------------------------------
  toastSample :: (ToastProps -> action) -> View context model action
  toastSample toAction =
    H.div_
    [ P.class_ "flex flex-wrap items-center gap-2" ]
    [ toastTrigger_ toAction
        defaultToastProps
          { toastCategory = "success"
          , toastTitle = "Success"
          , toastDescription = "A successful toast !"
          }
        [ "Success" ]
    , toastTrigger_ toAction
        defaultToastProps
          { toastCategory = "error"
          , toastTitle = "Error"
          , toastDescription = "An error toast :("
          }
        [ "Error" ]
    , toastTrigger_ toAction
        defaultToastProps
          { toastCategory = "info"
          , toastTitle = "Info"
          , toastDescription = "An informational toast =]"
          }
        [ "Info" ]
    , toastTrigger_ toAction
        defaultToastProps
          { toastCategory = "warning"
          , toastTitle = "Warning"
          , toastDescription = "A warning toast :/"
          }
        [ "Warning" ]
    ]
  """
-----------------------------------------------------------------------------
toastPropsApi :: View context model action
toastPropsApi =
  """
  -- | Props describing a basecoat toast. Dispatched to basecoat's toaster JS
  -- (a @basecoat:toast@ custom event) by the application's update function.
  data ToastProps
    = ToastProps
    { toastCategory :: MisoString
      -- ^ @success@, @error@, @info@ or @warning@
    , toastTitle :: MisoString
    , toastDescription :: MisoString
    , toastLabel :: MisoString
      -- ^ Label of the dismiss button
    } deriving (Show, Eq)
  -----------------------------------------------------------------------------
  -- | Smart constructor: informational toast
  defaultToastProps :: ToastProps
  defaultToastProps
    = ToastProps
    { toastCategory = "info"
    , toastTitle = ""
    , toastDescription = ""
    , toastLabel = "Dismiss"
    }
  """
-----------------------------------------------------------------------------
