-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE LambdaCase        #-}
-----------------------------------------------------------------------------
module Miso.UI.Dialog
  ( -- ** Props
    DialogProps (..)
  , defaultDialogProps
    -- ** Views
  , dialog_
  , dialogHeader_
  , dialogSection_
  , dialogFooter_
  , dialogCloseButton_
    -- ** Component
  , dialogComponent
    -- ** Samples
  , dialogCodeSample
  , dialogPropsApi
  ) where
-----------------------------------------------------------------------------
import           Control.Monad
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.CSS as CSS
import qualified Miso.Html.Element as H
import qualified Miso.Html.Event as E
import qualified Miso.Html.Property as P
import           Miso.Lens
-----------------------------------------------------------------------------
import           Miso.UI.Button
import           Miso.UI.Icons
import           Miso.UI.Input
import           Miso.UI.Label
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props for 'dialog_' (the native @dialog@ element)
data DialogProps action
  = DialogProps
  { dialogId :: MisoString
    -- ^ id of the dialog; @-title@ \/ @-description@ ids derive from it
  , dialogClasses :: [MisoString]
    -- ^ Extra classes appended to @dialog.dialog@
  , dialogAttrs :: [Attribute action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultDialogProps :: DialogProps action
defaultDialogProps
  = DialogProps
  { dialogId = "dialog"
  , dialogClasses = [ "w-full", "sm:max-w-[425px]", "max-h-[612px]" ]
  , dialogAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/dialog/ Dialog>, driven by 'DialogProps'.
-- Children typically include 'dialogHeader_', 'dialogSection_', 'dialogFooter_'
-- and a 'dialogCloseButton_'.
dialog_
  :: DialogProps action
  -> [View model action]
  -> View model action
dialog_ DialogProps {..} kids =
  H.dialog_
    ( concat
      [ [ P.id_ dialogId
        , P.classes_ ("dialog" : dialogClasses)
        , P.aria_ "labelledby" (dialogId <> "-title")
        , P.aria_ "describedby" (dialogId <> "-description")
        ]
      , dialogAttrs
      ]
    ) kids
-----------------------------------------------------------------------------
-- | Header with title and description (ids derived from the dialog id)
dialogHeader_
  :: MisoString
  -- ^ dialog id (matches 'dialogId')
  -> [View model action]
  -- ^ title
  -> [View model action]
  -- ^ description
  -> View model action
dialogHeader_ did title description =
  H.header_ []
  [ H.h2_ [ P.id_ (did <> "-title") ] title
  , H.p_ [ P.id_ (did <> "-description") ] description
  ]
-----------------------------------------------------------------------------
dialogSection_
  :: [Attribute action]
  -> [View model action]
  -> View model action
dialogSection_ = H.section_
-----------------------------------------------------------------------------
dialogFooter_
  :: [Attribute action]
  -> [View model action]
  -> View model action
dialogFooter_ = H.footer_
-----------------------------------------------------------------------------
-- | The x-shaped close button in the dialog's corner
dialogCloseButton_ :: action -> View model action
dialogCloseButton_ close =
  H.button_
  [ P.type_ "button"
  , P.aria_ "label" "Close dialog"
  , CSS.style_ [ CSS.cursor "pointer" ]
  , E.onClick close
  ]
  [ xIcon [] ]
-----------------------------------------------------------------------------
data Action
  = ShowDialog MisoString DOMRef
  | CloseDialog
  | NoOp
-----------------------------------------------------------------------------
-- | Demo component: two dialogs with triggers. The model tracks the id of
-- the currently open dialog.
dialogComponent :: Component parent props MisoString Action
dialogComponent = component "" update_ $ \_ _ -> view_
  where
    update_ NoOp = pure ()
    update_ (ShowDialog sel domRef) = do
      this .= sel
      io_ $ do
        dialogRef <- nextSibling domRef
        void $ dialogRef # ("showModal" :: MisoString) $ ()

    update_ CloseDialog = do
      sel <- use this
      io_ $ do
        dialog <- jsg "document"
          # ("getElementById" :: MisoString)
          $ [sel :: MisoString]
        void $ dialog # ("close" :: MisoString) $ ()
-----------------------------------------------------------------------------
view_ :: View MisoString Action
view_ =
  H.div_
  [ P.class_ "flex flex-wrap items-center gap-4" ]
  [ button_ defaultButtonProps
    { buttonVariant = Outline
    , buttonAttrs = [ P.type_ "button", E.onClickWith (ShowDialog "demo-dialog-edit-profile") ]
    }
    [ "Edit Profile" ]
  , dialog_ defaultDialogProps
    { dialogId = "demo-dialog-edit-profile"
    , dialogAttrs = [ E.onClick CloseDialog ]
    }
    [ H.div_
      [ E.onClickWithOptions stopPropagation NoOp ]
      [ dialogHeader_ "demo-dialog-edit-profile"
        [ "Edit profile" ]
        [ "Make changes to your profile here. Click save when you're done." ]
      , dialogSection_ []
        [ H.form_
          [ P.class_ "form grid gap-4" ]
          [ H.div_
            [ P.class_ "grid gap-3" ]
            [ label_ defaultLabelProps { labelFor = Just "demo-dialog-edit-profile-name" }
              [ "Name" ]
            , input_ defaultInputProps { inputId = Just "demo-dialog-edit-profile-name" }
            ]
          , H.div_
            [ P.class_ "grid gap-3" ]
            [ label_ defaultLabelProps { labelFor = Just "demo-dialog-edit-profile-username" }
              [ "Username" ]
            , input_ defaultInputProps { inputId = Just "demo-dialog-edit-profile-username" }
            ]
          ]
        ]
      , dialogFooter_ []
        [ button_ defaultButtonProps
          { buttonVariant = Outline, buttonAttrs = [ E.onClick CloseDialog ] }
          [ "Cancel" ]
        , button_ defaultButtonProps
          { buttonAttrs = [ E.onClick CloseDialog ] }
          [ "Save changes" ]
        ]
      , dialogCloseButton_ CloseDialog
      ]
    ]
  , button_ defaultButtonProps
    { buttonVariant = Outline
    , buttonAttrs = [ P.type_ "button", E.onClickWith (ShowDialog "dialog-example") ]
    }
    [ "Scrollable Content" ]
  , dialog_ defaultDialogProps
    { dialogId = "dialog-example"
    , dialogAttrs = [ E.onClick CloseDialog ]
    }
    [ H.div_
      [ E.onClickWithOptions stopPropagation NoOp ]
      [ dialogHeader_ "dialog-example"
        [ "Scrollable Content" ]
        [ "This is a dialog with scrollable content." ]
      , dialogSection_
        [ P.class_ "overflow-y-auto scrollbar" ]
        [ H.div_
          [ P.class_ "space-y-4 text-sm" ]
          [ H.p_ [] [ lorem ] | _ <- [ (1 :: Int) .. 10 ] ]
        ]
      , dialogFooter_ []
        [ button_ defaultButtonProps
          { buttonVariant = Outline, buttonAttrs = [ E.onClick CloseDialog ] }
          [ "Close" ]
        ]
      , dialogCloseButton_ CloseDialog
      ]
    ]
  ]
  where
    lorem =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
-----------------------------------------------------------------------------
dialogCodeSample :: View model action
dialogCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyDialog (dialogComponent) where
  -----------------------------------------------------------------------------
  import           Control.Monad
  import           Miso
  import           Miso.Html.Event
  import           Miso.Lens
  import qualified Miso.Html as H
  import qualified Miso.Html.Property as P
  -----------------------------------------------------------------------------
  import           Miso.UI.Button
  import           Miso.UI.Dialog
  import           Miso.UI.Types
  -----------------------------------------------------------------------------
  data Action
    = ShowDialog MisoString DOMRef
    | CloseDialog
    | NoOp
  -----------------------------------------------------------------------------
  dialogComponent :: Component parent props MisoString Action
  dialogComponent = component "" update_ $ \\_ _ ->
      H.div_ []
      [ button_ defaultButtonProps
        { buttonVariant = Outline
        , buttonAttrs = [ onClickWith (ShowDialog "my-dialog") ]
        }
        [ "Edit Profile" ]
      , dialog_ defaultDialogProps
        { dialogId = "my-dialog"
        , dialogAttrs = [ onClick CloseDialog ]
        }
        [ H.div_
          [ onClickWithOptions stopPropagation NoOp ]
          [ dialogHeader_ "my-dialog"
            [ "Edit profile" ]
            [ "Make changes to your profile here." ]
          , dialogFooter_ []
            [ button_ defaultButtonProps
              { buttonAttrs = [ onClick CloseDialog ] }
              [ "Save changes" ]
            ]
          , dialogCloseButton_ CloseDialog
          ]
        ]
      ]
    where
      update_ NoOp = pure ()
      update_ (ShowDialog sel domRef) = do
        this .= sel
        io_ $ do
          dialogRef <- nextSibling domRef
          void $ dialogRef # ("showModal" :: MisoString) $ ()
      update_ CloseDialog = do
        sel <- use this
        io_ $ do
          dialog <- jsg "document"
            # ("getElementById" :: MisoString)
            $ [sel :: MisoString]
          void $ dialog # ("close" :: MisoString) $ ()
  """
-----------------------------------------------------------------------------
dialogPropsApi :: View model action
dialogPropsApi =
  """
  -- | Props for 'dialog_' (the native @dialog@ element)
  data DialogProps action
    = DialogProps
    { dialogId :: MisoString
      -- ^ id of the dialog; @-title@ \\/ @-description@ ids derive from it
    , dialogClasses :: [MisoString]
      -- ^ Extra classes appended to @dialog.dialog@
    , dialogAttrs :: [Attribute action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultDialogProps :: DialogProps action
  defaultDialogProps
    = DialogProps
    { dialogId = "dialog"
    , dialogClasses = [ "w-full", "sm:max-w-[425px]", "max-h-[612px]" ]
    , dialogAttrs = []
    }
  """
-----------------------------------------------------------------------------
