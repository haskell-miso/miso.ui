-----------------------------------------------------------------------------
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TypeApplications           #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE LambdaCase                 #-}
-----------------------------------------------------------------------------
module Miso.UI.Dialog
  ( -- ** Component
    dialogComponent
  ) where
-----------------------------------------------------------------------------
import           Miso
import           Miso.Html hiding (data_)
import           Miso.Html.Property hiding (form_, label_)
import           Miso.Svg hiding (view_)
import           Miso.Svg.Property hiding (path_)
import           Miso.Lens
-----------------------------------------------------------------------------
import qualified Miso.CSS as CSS
-----------------------------------------------------------------------------
import           Control.Monad
-----------------------------------------------------------------------------
data Action
  = ShowDialog MisoString DOMRef
  | CloseDialog 
  | NoOp
-----------------------------------------------------------------------------
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
view_ :: View m Action
view_ = section_
    [ id_ "dialog"
    , class_ "w-full rounded-lg border scroll-mt-14"
    ]
    [ header_
        [ class_
            "border-b px-4 py-3 flex items-center justify-between"
        ]
        [ h2_ [class_ "text-sm font-medium"] ["Dialog"]
        , a_
            [ href_ "#dialog"
            , class_
                "text-muted-foreground hover:text-foreground"
            , data_ "tooltip" "See documentation"
            , data_ "side" "left"
            ]
            [ svg_
                [ xmlns_ "http://www.w3.org/2000/svg"
                , width_ "24"
                , height_ "24"
                , viewBox_ "0 0 24 24"
                , fill_ "none"
                , stroke_ "currentColor"
                , strokeWidth_ "2"
                , strokeLinecap_ "round"
                , strokeLinejoin_ "round"
                , class_ "size-4"
                ]
                [ path_ [d_ "M12 7v14"]
                , path_
                    [ d_
                        "M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"
                    ]
                ]
            ]
        ]
    , div_
        [class_ "p-4"]
        [ div_
            [ class_ "flex flex-wrap items-center gap-4"
            ]
            [ button_
                [type_ "button", class_ "btn-outline", onClickWith (ShowDialog "demo-dialog-edit-profile") ]
                ["Edit Profile"]
            , dialog_
                [ id_ "demo-dialog-edit-profile"
                , onClick CloseDialog
                , class_
                    "dialog w-full sm:max-w-[425px] max-h-[612px]"
                , aria_
                    "labelledby"
                    "demo-dialog-edit-profile-title"
                , aria_
                    "describedby"
                    "demo-dialog-edit-profile-description"
                ]
                [ div_
                    [ onClickWithOptions stopPropagation NoOp
                    ]
                    [ header_
                        []
                        [ h2_
                            [id_ "demo-dialog-edit-profile-title"]
                            ["Edit profile"]
                        , p_
                            [id_ "demo-dialog-edit-profile-description"]
                            [ "Make changes to your profile here. Click save when you're done."
                            ]
                        ]
                    , section_
                        []
                        [ form_
                            [class_ "form grid gap-4"]
                            [ div_
                                [class_ "grid gap-3"]
                                [ label_
                                    [for_ "demo-dialog-edit-profile-name"]
                                    ["Name"]
                                , input_
                                    [ type_ "text"
                                    , id_ "demo-dialog-edit-profile-name"
                                    ]
                                ]
                            , div_
                                [class_ "grid gap-3"
                                ]
                                [ label_
                                    [for_ "demo-dialog-edit-profile-username"]
                                    ["Username"]
                                , input_
                                    [ type_ "text"
                                    , id_ "demo-dialog-edit-profile-username"
                                    ]
                                ]
                            ]
                        ]
                    , footer_
                        []
                        [ button_ [class_ "btn-outline", onClick CloseDialog ] ["Cancel"]
                        , button_ [class_ "btn", onClick CloseDialog ] ["Save changes"]
                        ]
                    , button_
                        [ type_ "button"
                        , aria_ "label" "Close dialog"
                        , CSS.style_ [ CSS.cursor "pointer" ]
                        , onClick CloseDialog
                        ]
                        [ svg_
                            [ xmlns_ "http://www.w3.org/2000/svg"
                            , width_ "24"
                            , height_ "24"
                            , viewBox_ "0 0 24 24"
                            , fill_ "none"
                            , stroke_ "currentColor"
                            , strokeWidth_ "2"
                            , strokeLinecap_ "round"
                            , strokeLinejoin_ "round"
                            , class_ "lucide lucide-x-icon lucide-x"
                            ]
                            [ path_ [d_ "M18 6 6 18"]
                            , path_ [d_ "m6 6 12 12"]
                            ]
                        ]
                    ]
                ]
            , button_
                [type_ "button", class_ "btn-outline", onClickWith (ShowDialog "dialog-example") ]
                ["Scrollable Content"]
            , dialog_
                [ id_ "dialog-example"
                , onClick CloseDialog
                , class_
                    "dialog w-full sm:max-w-[425px] max-h-[612px]"
                , aria_ "labelledby" "dialog-example-title"
                , aria_ "describedby" "dialog-example-description"
                ]
                [ div_
                    [ onClickWithOptions stopPropagation NoOp ]
                    [ header_
                        []
                        [ h2_
                            [id_ "dialog-example-title"]
                            ["Scrollable Content"]
                        , p_
                            [id_ "dialog-example-description"]
                            ["This is a dialog with scrollable content."]
                        ]
                    , section_
                        [class_ "overflow-y-auto scrollbar"]
                        [ div_
                            [class_ "space-y-4 text-sm"]
                            [ p_
                                []
                                [ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                                ]
                            , p_
                                []
                                [ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                                ]
                            , p_
                                []
                                [ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                                ]
                            , p_
                                []
                                [ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                                ]
                            , p_
                                []
                                [ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                                ]
                            , p_
                                []
                                [ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                                ]
                            , p_
                                []
                                [ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                                ]
                            , p_
                                []
                                [ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                                ]
                            , p_
                                []
                                [ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                                ]
                            , p_
                                []
                                [ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                                ]
                            ]
                        ]
                    , footer_
                        []
                        [button_ [class_ "btn-outline", onClick CloseDialog ] ["Close"] ]
                    , button_
                        [ type_ "button"
                        , aria_ "label" "Close dialog"
                        , onClick CloseDialog
                        , CSS.style_ [ CSS.cursor "pointer" ]
                        ]
                        [ svg_
                            [ xmlns_ "http://www.w3.org/2000/svg"
                            , width_ "24"
                            , height_ "24"
                            , viewBox_ "0 0 24 24"
                            , fill_ "none"
                            , stroke_ "currentColor"
                            , strokeWidth_ "2"
                            , strokeLinecap_ "round"
                            , strokeLinejoin_ "round"
                            , class_ "lucide lucide-x-icon lucide-x"
                            ]
                            [ path_ [d_ "M18 6 6 18"]
                            , path_ [d_ "m6 6 12 12"]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]
-----------------------------------------------------------------------------
