-----------------------------------------------------------------------------
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ExistentialQuantification  #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TypeApplications           #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE LambdaCase                 #-}
-----------------------------------------------------------------------------
module Miso.UI.CommandMenu where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.CSS as CSS
import           Miso.Html hiding (data_)
import           Miso.Html.Property hiding (form_, label_)
import           Miso.Svg hiding (view_)
import           Miso.Svg.Property hiding (path_)
import           Miso.Lens
-----------------------------------------------------------------------------
import           Control.Monad
-----------------------------------------------------------------------------
data Action
  = ShowDialog MisoString DOMRef
  | CloseDialog 
  | NoOp
-----------------------------------------------------------------------------
commandMenuComponent :: Component parent props MisoString Action
commandMenuComponent = component "" update_ $ \_ _ -> view_
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
    [ id_ "command-menu"
    , class_ "w-full rounded-lg scroll-mt-14"
    ]
    [ button_
      [ onClickWith (ShowDialog "demo-command-dialog")
      , class_ "btn-outline"
      , type_ "button"
      ]
      [ "Open Command Menu"
      , kbd_ [class_ "kbd"] ["⌘J"]
      ]
    , dialog_
      [ onClick CloseDialog
      , aria_ "label" "Command Menu"
      , class_ "command-dialog"
      , id_ "demo-command-dialog"
      ]
      [ div_
        [class_ "command"]
        [ header_
            []
            [ svg_
                [ class_ "lucide lucide-search-icon lucide-search"
                , strokeLinejoin_ "round"
                , strokeLinecap_ "round"
                , strokeWidth_ "2"
                , stroke_ "currentColor"
                , fill_ "none"
                , viewBox_ "0 0 24 24"
                , height_ "24"
                , width_ "24"
                , xmlns_ "http://www.w3.org/2000/svg"
                ]
                [ circle_ [r_ "8", cy_ "11", cx_ "11"]
                , path_ [d_ "m21 21-4.3-4.3"]
                ]
            , input_
                [ aria_ "controls" "demo-command-dialog-menu"
                , aria_ "expanded" "true"
                , role_ "combobox"
                , aria_ "autocomplete" "list"
                , onClickWithOptions stopPropagation NoOp
                , spellcheck_ False
                , autocorrect_ False
                , autocomplete_ False
                , placeholder_ "Type a command or search..."
                , id_ "demo-command-dialog-input"
                , type_ "text"
                ]
            ]
        , div_
            [ class_ "scrollbar"
            , data_ "empty" "No results found."
            , aria_ "orientation" "vertical"
            , id_ "demo-command-dialog-menu"
            , role_ "menu"
            ]
            [ div_
                [ aria_ "labelledby" "cmd-suggestions"
                , role_ "group"
                ]
                [ span_
                    [id_ "cmd-suggestions", role_ "heading"]
                    ["Suggestions"]
                , div_
                    [ -- onclick_ "console.log('Open calendar')"
                      role_ "menuitem"
                    ]
                    [ svg_
                        [ strokeLinejoin_ "round"
                        , strokeLinecap_ "round"
                        , strokeWidth_ "2"
                        , stroke_ "currentColor"
                        , fill_ "none"
                        , viewBox_ "0 0 24 24"
                        , height_ "24"
                        , width_ "24"
                        , xmlns_ "http://www.w3.org/2000/svg"
                        ]
                        [ path_ [d_ "M8 2v4"]
                        , path_ [d_ "M16 2v4"]
                        , rect_
                            [ rx_ "2"
                            , y_ "4"
                            , x_ "3"
                            , height_ "18"
                            , width_ "18"
                            ]
                        , path_ [d_ "M3 10h18"]
                        ]
                    , span_ [] ["Calendar"]
                    ]
                , div_
                    [ -- onclick_ "console.log('Search emoji')"
                      role_ "menuitem"
                    ]
                    [ svg_
                        [ strokeLinejoin_ "round"
                        , strokeLinecap_ "round"
                        , strokeWidth_ "2"
                        , stroke_ "currentColor"
                        , fill_ "none"
                        , viewBox_ "0 0 24 24"
                        , height_ "24"
                        , width_ "24"
                        , xmlns_ "http://www.w3.org/2000/svg"
                        ]
                        [ circle_ [r_ "10", cy_ "12", cx_ "12"]
                        , path_ [d_ "M8 14s1.5 2 4 2 4-2 4-2"]
                        , line_ [y2_ "9", y1_ "9", x2_ "9.01", x1_ "9"]
                        , line_
                            [y2_ "9", y1_ "9", x2_ "15.01", x1_ "15"]
                        ]
                    , span_ [] ["Search Emoji"]
                    ]
                , div_
                    [aria_ "disabled" "true", role_ "menuitem"]
                    [ svg_
                        [ strokeLinejoin_ "round"
                        , strokeLinecap_ "round"
                        , strokeWidth_ "2"
                        , stroke_ "currentColor"
                        , fill_ "none"
                        , viewBox_ "0 0 24 24"
                        , height_ "24"
                        , width_ "24"
                        , xmlns_ "http://www.w3.org/2000/svg"
                        ]
                        [ rect_
                            [ rx_ "2"
                            , y_ "2"
                            , x_ "4"
                            , height_ "20"
                            , width_ "16"
                            ]
                        , line_ [y2_ "6", y1_ "6", x2_ "16", x1_ "8"]
                        , line_
                            [y2_ "18", y1_ "14", x2_ "16", x1_ "16"]
                        , path_ [d_ "M16 10h.01"]
                        , path_ [d_ "M12 10h.01"]
                        , path_ [d_ "M8 10h.01"]
                        , path_ [d_ "M12 14h.01"]
                        , path_ [d_ "M8 14h.01"]
                        , path_ [d_ "M12 18h.01"]
                        , path_ [d_ "M8 18h.01"]
                        ]
                    , span_ [] ["Calculator"]
                    ]
                ]
            , hr_ [role_ "separator"]
            , div_
                [ aria_ "labelledby" "cmd-settings"
                , role_ "group"
                ]
                [ span_
                    [id_ "cmd-settings", role_ "heading"]
                    ["Settings"]
                , div_
                    [ data_ "filter" "Profile"
                    -- , onclick_ "console.log('Open profile')"
                    , role_ "menuitem"
                    ]
                    [ svg_
                        [ strokeLinejoin_ "round"
                        , strokeLinecap_ "round"
                        , strokeWidth_ "2"
                        , stroke_ "currentColor"
                        , fill_ "none"
                        , viewBox_ "0 0 24 24"
                        , height_ "24"
                        , width_ "24"
                        , xmlns_ "http://www.w3.org/2000/svg"
                        ]
                        [ path_
                            [d_ "M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"]
                        , circle_ [r_ "4", cy_ "7", cx_ "12"]
                        ]
                    , span_ [] ["Profile"]
                    , kbd_
                        [ class_
                            "ml-auto text-muted-foreground bg-transparent tracking-widest"
                        ]
                        ["⌘P"]
                    ]
                , div_
                    [ data_ "filter" "Billing"
                    -- , onclick_ "console.log('Open billing')"
                    , role_ "menuitem"
                    ]
                    [ svg_
                        [ strokeLinejoin_ "round"
                        , strokeLinecap_ "round"
                        , strokeWidth_ "2"
                        , stroke_ "currentColor"
                        , fill_ "none"
                        , viewBox_ "0 0 24 24"
                        , height_ "24"
                        , width_ "24"
                        , xmlns_ "http://www.w3.org/2000/svg"
                        ]
                        [ rect_
                            [ rx_ "2"
                            , y_ "5"
                            , x_ "2"
                            , height_ "14"
                            , width_ "20"
                            ]
                        , line_ [y2_ "10", y1_ "10", x2_ "22", x1_ "2"]
                        ]
                    , span_ [] ["Billing"]
                    , kbd_
                        [ class_
                            "ml-auto text-muted-foreground bg-transparent tracking-widest"
                        ]
                        ["⌘B"]
                    ]
                , div_
                    [ data_ "filter" "Settings"
                    -- , onclick_ "console.log('Open settings')"
                    , role_ "menuitem"
                    ]
                    [ svg_
                        [ strokeLinejoin_ "round"
                        , strokeLinecap_ "round"
                        , strokeWidth_ "2"
                        , stroke_ "currentColor"
                        , fill_ "none"
                        , viewBox_ "0 0 24 24"
                        , height_ "24"
                        , width_ "24"
                        , xmlns_ "http://www.w3.org/2000/svg"
                        ]
                        [ path_
                            [ d_
                                "M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z"
                            ]
                        , circle_ [r_ "3", cy_ "12", cx_ "12"]
                        ]
                    , span_ [] ["Settings"]
                    , kbd_
                        [ class_
                            "ml-auto text-muted-foreground bg-transparent tracking-widest"
                        ]
                        ["⌘S"]
                    ]
                ]
            ]
        , button_
            [ onClick CloseDialog
            , aria_ "label" "Close dialog"
            , CSS.style_ [ CSS.cursor "pointer" ]
            , type_ "button"
            ]
            [ svg_
                [ class_ "lucide lucide-x-icon lucide-x"
                , strokeLinejoin_ "round"
                , strokeLinecap_ "round"
                , strokeWidth_ "2"
                , stroke_ "currentColor"
                , fill_ "none"
                , viewBox_ "0 0 24 24"
                , height_ "24"
                , width_ "24"
                , xmlns_ "http://www.w3.org/2000/svg"
                ]
                [ path_ [d_ "M18 6 6 18"]
                , path_ [d_ "m6 6 12 12"]
                ]
            ]
        ]
    ]
 ]

