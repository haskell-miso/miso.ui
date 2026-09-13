-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.AlertDialog
  ( -- ** Props
    AlertDialogProps (..)
  , defaultAlertDialogProps
    -- ** Component
  , alertDialogComponent
    -- ** Sample
  , alertDialogCodeSample
  , alertDialogPropsApi
  ) where
-----------------------------------------------------------------------------
import           Control.Monad
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Event as E
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Button
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props for 'alertDialogComponent'. These live in the @props@ slot of the
-- miso 'Component' and are supplied at mount time via 'mountWithProps_'.
data AlertDialogProps
  = AlertDialogProps
  { alertDialogId :: MisoString
  , alertDialogTrigger :: MisoString
    -- ^ Label of the trigger button
  , alertDialogTitle :: MisoString
  , alertDialogDescription :: MisoString
  , alertDialogCancelLabel :: MisoString
  , alertDialogActionLabel :: MisoString
  } deriving (Show, Eq)
-----------------------------------------------------------------------------
-- | Smart constructor: destructive-action confirmation
defaultAlertDialogProps :: AlertDialogProps
defaultAlertDialogProps
  = AlertDialogProps
  { alertDialogId = "alert-dialog-demo"
  , alertDialogTrigger = "Open alert dialog"
  , alertDialogTitle = "Are you absolutely sure?"
  , alertDialogDescription =
      "This action cannot be undone. This will permanently delete your \
      \account and remove your data from our servers."
  , alertDialogCancelLabel = "Cancel"
  , alertDialogActionLabel = "Continue"
  }
-----------------------------------------------------------------------------
data Action
  = ShowModal DOMRef
  | CloseDialog MisoString
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/alert-dialog/ Alert Dialog> as a miso
-- 'Component'; 'AlertDialogProps' is its @props@ type parameter. Mount with
--
-- @
-- mountWithProps_ "alert-dialog" defaultAlertDialogProps alertDialogComponent
-- @
alertDialogComponent :: Component parent AlertDialogProps () Action
alertDialogComponent = component () update_ view_
  where
    update_ (ShowModal domRef) = io_ $ do
      dialogRef <- nextSibling domRef
      void $ dialogRef # ("showModal" :: MisoString) $ ()

    update_ (CloseDialog did) = io_ $ do
      dialog <- jsg "document"
        # ("getElementById" :: MisoString)
        $ [did]
      void $ dialog # ("close" :: MisoString) $ ()

    view_ () = vprops $ \AlertDialogProps {..} ->
      H.div_
      []
      [ button_ defaultButtonProps
        { buttonVariant = Outline
        , buttonAttrs = [ P.type_ "button", E.onClickWith ShowModal ]
        }
        [ text alertDialogTrigger ]
      , H.dialog_
          [ P.id_ alertDialogId
          , P.class_ "dialog"
          , P.aria_ "labelledby" (alertDialogId <> "-title")
          , P.aria_ "describedby" (alertDialogId <> "-description")
          ]
          [ H.article_ []
            [ H.header_ []
              [ H.h2_
                [ P.id_ (alertDialogId <> "-title") ]
                [ text alertDialogTitle ]
              , H.p_
                [ P.id_ (alertDialogId <> "-description") ]
                [ text alertDialogDescription ]
              ]
            , H.footer_ []
              [ button_ defaultButtonProps
                { buttonVariant = Outline
                , buttonAttrs = [ E.onClick (CloseDialog alertDialogId) ]
                }
                [ text alertDialogCancelLabel ]
              , button_ defaultButtonProps
                { buttonAttrs = [ E.onClick (CloseDialog alertDialogId) ] }
                [ text alertDialogActionLabel ]
              ]
            ]
          ]
        ]
-----------------------------------------------------------------------------
alertDialogCodeSample :: View context props model action
alertDialogCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyAlertDialog (myView) where
  -----------------------------------------------------------------------------
  import           Miso
  -----------------------------------------------------------------------------
  import           Miso.UI.AlertDialog
  -----------------------------------------------------------------------------
  -- 'AlertDialogProps' lives in the props slot of the miso 'Component' and is
  -- supplied at the mount site:
  myView :: View context props model action
  myView = mountWithProps_ "alert-dialog"
    defaultAlertDialogProps
      { alertDialogTitle = "Are you absolutely sure?"
      , alertDialogDescription = "This action cannot be undone."
      , alertDialogActionLabel = "Continue"
      }
    alertDialogComponent
  """
-----------------------------------------------------------------------------
alertDialogPropsApi :: View context props model action
alertDialogPropsApi =
  """
  -- | Props for 'alertDialogComponent'. These live in the @props@ slot of the
  -- miso 'Component' and are supplied at mount time via 'mountWithProps_'.
  data AlertDialogProps
    = AlertDialogProps
    { alertDialogId :: MisoString
    , alertDialogTrigger :: MisoString
      -- ^ Label of the trigger button
    , alertDialogTitle :: MisoString
    , alertDialogDescription :: MisoString
    , alertDialogCancelLabel :: MisoString
    , alertDialogActionLabel :: MisoString
    } deriving (Show, Eq)
  -----------------------------------------------------------------------------
  -- | Smart constructor: destructive-action confirmation
  defaultAlertDialogProps :: AlertDialogProps
  defaultAlertDialogProps
    = AlertDialogProps
    { alertDialogId = "alert-dialog-demo"
    , alertDialogTrigger = "Open alert dialog"
    , alertDialogTitle = "Are you absolutely sure?"
    , alertDialogDescription =
        "This action cannot be undone. This will permanently delete your \\
        \\account and remove your data from our servers."
    , alertDialogCancelLabel = "Cancel"
    , alertDialogActionLabel = "Continue"
    }
  """
-----------------------------------------------------------------------------
