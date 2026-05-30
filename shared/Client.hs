-----------------------------------------------------------------------------
{-# LANGUAGE CPP                #-}
{-# LANGUAGE LambdaCase         #-}
{-# LANGUAGE QuasiQuotes        #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE NamedFieldPuns     #-}
{-# LANGUAGE DeriveAnyClass     #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TemplateHaskell    #-}
{-# LANGUAGE TypeApplications   #-}
{-# LANGUAGE MultilineStrings   #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE DerivingStrategies #-}
-----------------------------------------------------------------------------
module Client where
-----------------------------------------------------------------------------
import           Prelude hiding ((.))
-----------------------------------------------------------------------------
import           Miso.FFI.QQ (js)
import           Miso.Html hiding (data_)
import qualified Miso.Html as H
import qualified Miso.Html.Property as P
import           Miso.Html.Property hiding (title_, label_, href_, form_)
import           Miso.Svg.Element hiding (title_)
import qualified Miso.Svg.Element as S
import           Miso.Svg.Property hiding (target_)
-----------------------------------------------------------------------------
import           Miso
import           Miso.Lens
-----------------------------------------------------------------------------
import           KitchenSink (kitchenSinkPage)
import           Types
-----------------------------------------------------------------------------
currentPage :: Lens Model Page
currentPage = lens _currentPage $ \r x -> r { _currentPage = x }
-----------------------------------------------------------------------------
app :: Component parent props Model Action
app = (component emptyModel update_ homeView) { mount = Just ScrollIntoView }
  where
    update_ = \case
      ScrollIntoView -> io_ $ do
        URI { uriFragment } <- getURI
        [js|
          const frag = ${uriFragment}.slice(1);
          if (frag) {
            const element = document.getElementById (frag);
            if (element) element.scrollIntoView();
          }
          return;
        |]
      CopyButton domRef ->
        io_ [js| return copyButton(${domRef}); |]
      Toaster {..} ->
        io_ [js| const msg = toastMsg (${category}, ${title}, ${description}, ${label});
                 return document.dispatchEvent (new CustomEvent('basecoat:toast', msg)); |]
      InitSlider domRef ->
        io_ [js| return initSlider(${domRef}); |]
      DestroySlider domRef ->
        io_ [js| return deinitSlider(${domRef}); |]
      ToggleSidebar ->
        io_ [js| document.dispatchEvent (new CustomEvent('basecoat:sidebar')); |]
      ToggleDarkMode ->
        io_ [js| return document.dispatchEvent (new CustomEvent('basecoat:theme')); |]
      Highlight domRef ->
        io_ [js| return hljs.highlightElement(${domRef}); |]
      ChangeTheme theme ->
        io_ [js| document.documentElement.classList.forEach(c => {
                   if (c.startsWith('theme-')) {
                     document.documentElement.classList.remove(c);
                   }
                 });
                 return document.documentElement.classList.add('theme-' + ${theme}); |]
-----------------------------------------------------------------------------
withMainAs
  :: View Model Action
  -> View Model Action
withMainAs content = vfrag
  [ asideView
  , main_
    [ id_ "content" ]
    [ header_
        [ class_
            "bg-background sticky inset-x-0 top-0 isolate flex shrink-0 items-center gap-2 border-b z-10"
        ]
        [ topSection
        ]
    , content
    ]
  ]
-----------------------------------------------------------------------------
homeView :: props -> Model -> View Model Action
homeView _ = \case
  Model Index ->
    withMainAs mainContent

topSection :: View Model Action
topSection = div_
            [ class_ "flex h-14 w-full items-center gap-2 px-4"
            ]
            [ button_
                [ class_ "btn-sm-icon-ghost mr-auto size-7 -ml-1.5"
                , data_ "align" "start"
                , data_ "side" "bottom"
                , data_ "tooltip" "Toggle sidebar"
                , aria_ "label" "Toggle sidebar"
                , type_ "button"
                , onClick ToggleSidebar
                ]
                [ svg_
                    [ strokeLinejoin_ "round"
                    , strokeLinecap_ "round"
                    , strokeWidth_ "2"
                    , stroke_ "currentcolor"
                    , fill_ "none"
                    , viewBox_ "0 0 24 24"
                    , height_ "24"
                    , width_ "24"
                    , xmlns_ "http://www.w3.org/2000/svg"
                    ]
                    [ rect_
                        [ rx_ "2"
                        , y_ "3"
                        , x_ "3"
                        , height_ "18"
                        , width_ "18"
                        ]
                    , S.path_ [d_ "M9 3v18"]
                    ]
                ]
            , select_
                [ id_ "theme-select"
                , class_ "select h-8 leading-none"
                , onChange ChangeTheme
                ]
                [ option_ [value_ ""] ["Default"]
                , option_ [value_ "claude", selected_ True ] ["Claude"]
                , option_ [value_ "cosmic"] ["Cosmic"]
                , option_ [value_ "tangerine"] ["Tangerine"]
                , option_ [value_ "supabase"] ["Supabase"]
                ]
            , a_
                [ data_ "align" "end"
                , data_ "side" "bottom"
                , data_ "tooltip" "GitHub repository"
                , rel_ "noopener noreferrer"
                , target_ "_blank"
                , class_ "btn-icon size-8"
                , P.href_ "https://github.com/haskell-miso/miso-ui"
                ]
                [ svg_
                    [ strokeLinejoin_ "round"
                    , strokeLinecap_ "round"
                    , strokeWidth_ "2"
                    , stroke_ "currentcolor"
                    , fill_ "none"
                    , viewBox_ "0 0 24 24"
                    , height_ "24"
                    , width_ "24"
                    , xmlns_ "http://www.w3.org/2000/svg"
                    ]
                    [ S.path_
                        [ d_
                            "M15 22v-4a4.8 4.8 0 0 0-1-3.5c3 0 6-2 6-5.5.08-1.25-.27-2.48-1-3.5.28-1.15.28-2.35 0-3.5 0 0-1 0-3 1.5-2.64-.5-5.36-.5-8 0C6 2 5 2 5 2c-.3 1.15-.3 2.35 0 3.5A5.403 5.403 0 0 0 4 9c0 3.5 3 5.5 6 5.5-.39.49-.68 1.05-.85 1.65-.17.6-.22 1.23-.15 1.85v4"
                        ]
                    , S.path_ [d_ "M9 18c-4.51 2-5-2-7-2"]
                    ]
                ]
             , a_
                [ data_ "align" "end"
                , data_ "side" "bottom"
                , data_ "tooltip" "Discord server"
                , rel_ "noopener noreferrer"
                , target_ "_blank"
                , class_ "btn-icon size-8"
                , P.href_ "https://discord.gg/QVDtfYNSxq"
                ]
                [ svg_
                  [ xmlns_ "http://www.w3.org/2000/svg"
                  , viewBox_ "0 0 24 24"
                  , fill_ "currentColor"
                  ]
                  [ S.path_
                    [ d_ "M20.317 4.3698a19.7913 19.7913 0 00-4.8851-1.5152.0741.0741 0 00-.0785.0371c-.211.3753-.4447.8648-.6083 1.2495-1.8447-.2762-3.68-.2762-5.4868 0-.1636-.3933-.4058-.8742-.6177-1.2495a.077.077 0 00-.0785-.037 19.7363 19.7363 0 00-4.8852 1.515.0699.0699 0 00-.0321.0277C.5334 9.0458-.319 13.5799.0992 18.0578a.0824.0824 0 00.0312.0561c2.0528 1.5076 4.0413 2.4228 5.9929 3.0294a.0777.0777 0 00.0842-.0276c.4616-.6304.8731-1.2952 1.226-1.9942a.076.076 0 00-.0416-.1057c-.6528-.2476-1.2743-.5495-1.8722-.8923a.077.077 0 01-.0076-.1277c.1258-.0943.2517-.1923.3718-.2914a.0743.0743 0 01.0776-.0105c3.9278 1.7933 8.18 1.7933 12.0614 0a.0739.0739 0 01.0785.0095c.1202.099.246.1981.3728.2924a.077.077 0 01-.0066.1276 12.2986 12.2986 0 01-1.873.8914.0766.0766 0 00-.0407.1067c.3604.698.7719 1.3628 1.225 1.9932a.076.076 0 00.0842.0286c1.961-.6067 3.9495-1.5219 6.0023-3.0294a.077.077 0 00.0313-.0552c.5004-5.177-.8382-9.6739-3.5485-13.6604a.061.061 0 00-.0312-.0286zM8.02 15.3312c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9555-2.4189 2.157-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.9555 2.4189-2.1569 2.4189zm7.9748 0c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9554-2.4189 2.1569-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.946 2.4189-2.1568 2.4189Z"
                   ]
                ]
            ]
        , button_
                [ class_ "btn-icon-outline size-8"
                , data_ "side" "bottom"
                , data_ "tooltip" "Toggle dark mode"
                , aria_ "label" "Toggle dark mode"
                , type_ "button"
                , onClickCapture ToggleDarkMode
                ]
                [ span_
                    [class_ "hidden dark:block"]
                    [ svg_
                        [ strokeLinejoin_ "round"
                        , strokeLinecap_ "round"
                        , strokeWidth_ "2"
                        , stroke_ "currentcolor"
                        , fill_ "none"
                        , viewBox_ "0 0 24 24"
                        , height_ "24"
                        , width_ "24"
                        , xmlns_ "http://www.w3.org/2000/svg"
                        ]
                        [ circle_ [r_ "4", cy_ "12", cx_ "12"]
                        , S.path_ [d_ "M12 2v2"]
                        , S.path_ [d_ "M12 20v2"]
                        , S.path_ [d_ "m4.93 4.93 1.41 1.41"]
                        , S.path_ [d_ "m17.66 17.66 1.41 1.41"]
                        , S.path_ [d_ "M2 12h2"]
                        , S.path_ [d_ "M20 12h2"]
                        , S.path_ [d_ "m6.34 17.66-1.41 1.41"]
                        , S.path_ [d_ "m19.07 4.93-1.41 1.41"]
                        ]
                    ]
                , span_
                    [class_ "block dark:hidden"]
                    [ svg_
                        [ strokeLinejoin_ "round"
                        , strokeLinecap_ "round"
                        , strokeWidth_ "2"
                        , stroke_ "currentcolor"
                        , fill_ "none"
                        , viewBox_ "0 0 24 24"
                        , height_ "24"
                        , width_ "24"
                        , xmlns_ "http://www.w3.org/2000/svg"
                        ]
                        [ S.path_
                            [d_ "M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"]
                        ]
                    ]
                ]
        ]
-----------------------------------------------------------------------------
mainContent :: View Model Action
mainContent = div_
        [ class_ "p-4 md:p-6 xl:p-12" ]
        [ div_
            [ class_ "max-w-screen-lg" ]
            [ header_
                [class_ "flex flex-col gap-4"]
                [ div_
                  [class_ "flex flex-col gap-2"]
                    [ h1_
                      [ class_
                         "text-2xl font-bold tracking-tight sm:text-3xl md:text-4xl"
                      ]
                      ["🍜 miso.ui"]
                    , p_
                      [ class_ "sm:text-lg text-muted-foreground"]
                      [ "A "
                      , a_
                        [ P.href_ "https://haskell-miso.org"
                        , P.target_ "_blank"
                        , class_ "underline underline-offset-4"
                        ] ["miso"]
                      , " component library built with "
                      , a_
                        [ P.href_ "https://tailwindcss.com/"
                        , P.target_ "_blank"
                        , class_ "underline underline-offset-4"
                        ]
                        [ "Tailwind" ]
                      , ", "
                      , a_ [ P.href_ "https://ui.shadcn.com/"
                           , P.target_ "_blank"
                           , class_ "underline underline-offset-4"
                           ]
                           ["ShadCN"]
                      , ", "
                      , a_ [ P.href_ "https://github.com/hunvreus/basecoat"
                           , P.target_ "_blank"
                           , class_ "underline underline-offset-4"
                           ] ["Basecoat"]
                      , " and "
                      , a_ [ P.href_ "https://tweakcn.com/"
                           , P.target_ "_blank"
                           , class_ "underline underline-offset-4"
                           ] ["TweakCN"]
                      , "."
                   ]
                ]
            ]
        ]
       , br_ []
       , hr_ [class_ "mt-20"]
       , br_ []
       , kitchenSinkPage
       ]
-----------------------------------------------------------------------------
asideView :: View Model Action
asideView = aside_
    [ aria_ "hidden" "true"
    , boolProp "inert" True
    , data_ "side" "left"
    , class_ "sidebar"
    , id_ "sidebar"
    ]
    [ nav_
        [ aria_ "label" "Sidebar navigation" ]
        [ header_
            []
            [ a_
                [ class_ "btn-ghost p-2 h-12 w-full justify-start"
                , P.href_ "#content"
                ]
                [ div_
                    [ class_
                        "bg-sidebar-primary text-sidebar-primary-foreground flex aspect-square size-8 items-center justify-center rounded-lg"
                    ]
                    [ "🍜"
                    ]
                , div_
                    [ class_
                        "grid flex-1 text-left text-sm leading-tight"
                    ]
                    [ span_
                        [class_ "truncate font-medium"]
                        ["🍜 miso.ui"]
                    , span_ [class_ "truncate text-xs"] ["v1.0.0"]
                    ]
                ]
            ]
        , section_
            [ class_
                "scrollbar [&_[data-new-link]::after]:content-['New'] [&_[data-new-link]::after]:ml-auto [&_[data-new-link]::after]:text-xs [&_[data-new-link]::after]:font-medium [&_[data-new-link]::after]:bg-sidebar-primary [&_[data-new-link]::after]:text-sidebar-primary-foreground [&_[data-new-link]::after]:px-2 [&_[data-new-link]::after]:py-0.5 [&_[data-new-link]::after]:rounded-md"
            ]
            [ div_
                [ aria_ "labelledby" "group-label-sidebar-content-1"
                , role_ "group"
                ]
                [ h3_
                    [id_ "group-label-sidebar-content-1"]
                    ["Getting started"]
                , ul_
                    []
                    [ li_
                    []
                    [ a_
                       [ P.href_ "#content"
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
                               [ rx_ "1"
                               , y_ "3"
                               , x_ "3"
                               , height_ "9"
                               , width_ "7"
                               ]
                           , rect_
                               [ rx_ "1"
                               , y_ "3"
                               , x_ "14"
                               , height_ "5"
                               , width_ "7"
                               ]
                           , rect_
                               [ rx_ "1"
                               , y_ "12"
                               , x_ "14"
                               , height_ "9"
                               , width_ "7"
                               ]
                           , rect_
                               [ rx_ "1"
                               , y_ "16"
                               , x_ "3"
                               , height_ "5"
                               , width_ "7"
                               ]
                           ]
                       , span_ [] ["Home"]
                       ]
                   ],
                     li_
                        []
                        [ a_
                            [ target_ "_blank"
                            , P.href_ "https://github.com/haskell-miso/miso-ui"
                            ]
                            [ svg_
                                [ xmlns_ "http://www.w3.org/2000/svg"
                                , viewBox_ "0 0 24 24"
                                , fill_ "currentColor"
                                ]
                                [ H.title_ [] ["GitHub"]
                                , S.path_
                                    [ d_
                                        "M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"
                                    ]
                                ]
                            , span_ [] ["GitHub"]
                            ]
                        ]
                    , li_
                        []
                        [ a_
                            [ target_ "_blank"
                            , P.href_ "https://discord.com/invite/QVDtfYNSxq"
                            ]
                            [ svg_
                                [ xmlns_ "http://www.w3.org/2000/svg"
                                , viewBox_ "0 0 24 24"
                                , fill_ "currentColor"
                                ]
                                [ H.title_ [] ["Discord"]
                                , S.path_
                                    [ d_
                                        "M20.317 4.3698a19.7913 19.7913 0 00-4.8851-1.5152.0741.0741 0 00-.0785.0371c-.211.3753-.4447.8648-.6083 1.2495-1.8447-.2762-3.68-.2762-5.4868 0-.1636-.3933-.4058-.8742-.6177-1.2495a.077.077 0 00-.0785-.037 19.7363 19.7363 0 00-4.8852 1.515.0699.0699 0 00-.0321.0277C.5334 9.0458-.319 13.5799.0992 18.0578a.0824.0824 0 00.0312.0561c2.0528 1.5076 4.0413 2.4228 5.9929 3.0294a.0777.0777 0 00.0842-.0276c.4616-.6304.8731-1.2952 1.226-1.9942a.076.076 0 00-.0416-.1057c-.6528-.2476-1.2743-.5495-1.8722-.8923a.077.077 0 01-.0076-.1277c.1258-.0943.2517-.1923.3718-.2914a.0743.0743 0 01.0776-.0105c3.9278 1.7933 8.18 1.7933 12.0614 0a.0739.0739 0 01.0785.0095c.1202.099.246.1981.3728.2924a.077.077 0 01-.0066.1276 12.2986 12.2986 0 01-1.873.8914.0766.0766 0 00-.0407.1067c.3604.698.7719 1.3628 1.225 1.9932a.076.076 0 00.0842.0286c1.961-.6067 3.9495-1.5219 6.0023-3.0294a.077.077 0 00.0313-.0552c.5004-5.177-.8382-9.6739-3.5485-13.6604a.061.061 0 00-.0312-.0286zM8.02 15.3312c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9555-2.4189 2.157-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.9555 2.4189-2.1569 2.4189zm7.9748 0c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9554-2.4189 2.1569-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.946 2.4189-2.1568 2.4189Z"
                                    ]
                                ]
                            , span_ [] ["Discord"]
                            ]
                        ]
                    ]
                ]
            , div_
                [ aria_ "labelledby" "group-label-sidebar-content-2"
                , role_ "group"
                ]
                [ h3_
                    [id_ "group-label-sidebar-content-2"]
                    ["Components"]
                , ul_
                    []
                    [ li_ [] [a_ [ P.href_ "#accordion"] ["Accordion"]]
                    , li_ [] [a_ [ P.href_ "#alert"] ["Alert"]]
                    , li_ [] [a_ [ P.href_ "#alert-dialog"] ["Alert Dialog"]]
                    , li_ [] [a_ [ P.href_ "#avatar"] ["Avatar"]]
                    , li_ [] [a_ [ P.href_ "#badge"] ["Badge"]]
                    , li_ [] [a_ [ P.href_ "#breadcrumb"] ["Breadcrumb"]]
                    , li_ [] [a_ [ P.href_ "#button"] ["Button"]]
                    , li_ [] [a_ [ P.href_ "#button-group"] ["Button Group"]]
                    , li_ [] [a_ [ P.href_ "#card"] ["Card"]]
                    , li_ [] [a_ [ P.href_ "#checkbox"] ["Checkbox"]]
                    , li_ [] [a_ [ P.href_ "#combobox"] ["Combobox"]]
                    , li_ [] [a_ [ P.href_ "#command-menu"] ["Command Menu"]]
                    , li_ [] [a_ [ P.href_ "#dialog"] ["Dialog"]]
                    , li_ [] [a_ [ P.href_ "#dropdown-menu"] ["Dropdown Menu"]]
                    , li_ [] [a_ [ P.href_ "#empty"] ["Empty"]]
                    , li_ [] [a_ [ P.href_ "#form"] ["Form"]]
                    , li_ [] [a_ [ P.href_ "#input"] ["Input"]]
                    , li_ [] [a_ [ P.href_ "#input-group"] ["Input Group"]]
                    , li_ [] [a_ [ P.href_ "#kbd"] ["Kbd"]]
                    , li_ [] [a_ [ P.href_ "#label"] ["Label"]]
                    , li_ [] [a_ [ P.href_ "#pagination"] ["Pagination"]]
                    , li_ [] [a_ [ P.href_ "#popover"] ["Popover"]]
                    , li_ [] [a_ [ P.href_ "#radio-group"] ["Radio Group"]]
                    , li_ [] [a_ [ P.href_ "#select"] ["Select"]]
                    , li_ [] [a_ [ P.href_ "#skeleton"] ["Skeleton"]]
                    , li_ [] [a_ [ P.href_ "#slider"] ["Slider"]]
                    , li_ [] [a_ [ P.href_ "#spinner"] ["Spinner"]]
                    , li_ [] [a_ [ P.href_ "#switch"] ["Switch"]]
                    , li_ [] [a_ [ P.href_ "#table"] ["Table"]]
                    , li_ [] [a_ [ P.href_ "#tabs"] ["Tabs"]]
                    , li_ [] [a_ [ P.href_ "#textarea"] ["Textarea"]]
                    , li_ [] [a_ [ P.href_ "#toast"] ["Toast"]]
                    , li_ [] [a_ [ P.href_ "#tooltip"] ["Tooltip"]]
                    ]
                ]
            ]
        , footer_
            []
            [ div_
                [class_ "popover ", id_ "popover-925347"]
                [ button_
                    [ data_ "keep-mobile-sidebar-open" ""
                    , class_
                        "btn-ghost p-2 h-12 w-full flex items-center justify-start"
                    , aria_ "controls" "popover-925347-popover"
                    , aria_ "expanded" "false"
                    , type_ "button"
                    , id_ "popover-925347-trigger"
                    ]
                    [ img_
                        [ class_ "rounded-lg shrink-0 size-8"
                        , src_ "https://github.com/dmjio.png"
                        ]
                    , div_
                        [ class_
                            "grid flex-1 text-left text-sm leading-tight"
                        ]
                        [ span_
                            [class_ "truncate font-medium"]
                            ["David M. Johnson"]
                        , span_ [class_ "truncate text-xs"] ["@dmjio"]
                        ]
                    , svg_
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
                        [ S.path_ [d_ "m7 15 5 5 5-5"]
                        , S.path_ [d_ "m7 9 5-5 5 5"]
                        ]
                    ]
                , div_
                    [ class_ "w-[271px] md:w-[239px]"
                    , data_ "side" "top"
                    , aria_ "hidden" "true"
                    , data_ "popover" ""
                    , id_ "popover-925347-popover"
                    ]
                    [ div_
                        [class_ "grid gap-4"]
                        [ header_
                            [class_ "grid gap-1.5"]
                            [ h2_
                                [class_ "font-semibold"]
                                ["🍜 miso.ui"]
                            , p_
                                [class_ "text-muted-foreground text-sm"]
                                [ " Hi, I'm "
                                , a_
                                    [ target_ "_blank"
                                    , P.href_ "https://github.com/dmjio"
                                    , class_ "underline underline-offset-4"
                                    ]
                                    ["@dmjio"]
                                , ", and I'm using "
                                , a_
                                    [ target_ "_blank"
                                    , P.href_ "https://basecoatui.com/"
                                    , class_ "underline underline-offset-4"
                                    ]
                                    ["Basecoat CSS"]
                                , " to build "
                                , a_
                                    [ target_ "_blank"
                                    , P.href_ "https://github.com/haskell-miso/miso-ui"
                                    , class_ "underline underline-offset-4"
                                    ]
                                    ["miso.ui"]
                                , ". If you find it useful, please consider sponsoring "
                                , a_
                                    [ target_ "_blank"
                                    , P.href_ "https://github.com/hunvreus"
                                    , class_ "underline underline-offset-4"
                                    ]
                                    ["@hunvreus"]
                                ]
                            ]
                        , footer_
                            [class_ "grid gap-2"]
                            [ a_
                                [ target_ "_blank"
                                , class_ "btn-sm"
                                , P.href_ "https://github.com/sponsors/hunvreus"
                                ]
                                ["Sponsor @hunvreus"]
                            , a_
                                [ target_ "_blank"
                                , class_ "btn-sm-outline"
                                , P.href_ "https://x.com/hunvreus"
                                ]
                                ["Follow @hunvreus on X"]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]
----------------------------------------------------------------------------
