-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
-----------------------------------------------------------------------------
module KitchenSink where
-----------------------------------------------------------------------------
import           Miso
import           Miso.Html hiding
  ( data_, button_, input_, label_, form_, table_, select_
  , textarea_, kbd_, dialog_, progress_
  )
import           Miso.Html.Property hiding (max_, min_, label_, form_)
import           Miso.Svg.Element hiding (switch_)
import           Miso.Svg.Property hiding (path_)
-----------------------------------------------------------------------------
import           Miso.UI
-----------------------------------------------------------------------------
import           Types
-----------------------------------------------------------------------------
kitchenSinkPage :: Eq context => View context props model Action
kitchenSinkPage = vfrag
    [ div_
        [ class_ "flex flex-col gap-4" ]
        [ div_
            []
            [ header_
                [ class_ "space-y-2 mb-8" ]
                [ h1_
                    [ class_ "text-3xl font-semibold tracking-tight" ]
                    [ "Components" ]
                , p_
                    [ class_ "text-muted-foreground" ]
                    [ "A collection of all the components available in miso.ui"
                    ]
                ]
            , div_
                [ class_ "flex flex-col gap-4" ]
                ( hr_ [] : concatMap uiComponent components )
            ]
        ]
    ]
  where
    components =
      [ ( "Accordion", "accordion"
        , "A vertically stacked set of interactive headings that each reveal a section of content."
        , accordionSample, accordionCodeSample, Just accordionPropsApi )
      , ( "Alert", "alert"
        , "Displays a callout for user attention."
        , alertSample, alertCodeSample, Just alertPropsApi )
      , ( "Alert Dialog", "alert-dialog"
        , "A modal dialog that interrupts the user with important content and expects a response."
        , mountWithProps_ "alert-dialog" defaultAlertDialogProps alertDialogComponent
        , alertDialogCodeSample, Just alertDialogPropsApi )
      , ( "Avatar", "avatar"
        , "An image element with a fallback for representing the user."
        , avatarSample, avatarCodeSample, Just avatarPropsApi )
      , ( "Badge", "badge"
        , "Displays a badge or a component that looks like a badge."
        , badgeSample, badgeCodeSample, Just badgePropsApi )
      , ( "Breadcrumb", "breadcrumb"
        , "Displays the path to the current resource using a hierarchy of links."
        , breadcrumbSample, breadcrumbCodeSample, Just breadcrumbPropsApi )
      , ( "Button", "button"
        , "Displays a button or a component that looks like a button."
        , buttonSample, buttonCodeSample, Just buttonPropsApi )
      , ( "Button Group", "button-group"
        , "A container that groups related buttons together."
        , buttonGroupSample, buttonGroupCodeSample, Just buttonGroupPropsApi )
      , ( "Card", "card"
        , "Displays a card with header, content, and footer."
        , cardSample, cardCodeSample, Just cardPropsApi )
      , ( "Checkbox", "checkbox"
        , "A control that allows the user to toggle between checked and not checked."
        , checkboxSample, checkboxCodeSample, Just checkboxPropsApi )
      , ( "Combobox", "combobox"
        , "Autocomplete input and command palette with a list of suggestions."
        , comboboxSample, comboboxCodeSample, Just comboboxPropsApi )
      , ( "Command Menu", "command-menu"
        , "Fast, composable command menu, opened with a keyboard shortcut."
        , mount_ commandMenuComponent, commandMenuCodeSample, Nothing )
      , ( "Dialog", "dialog"
        , "A window overlaid on either the primary window or another dialog window."
        , mount_ dialogComponent, dialogCodeSample, Just dialogPropsApi )
      , ( "Dropdown Menu", "dropdown-menu"
        , "Displays a menu to the user, triggered by a button."
        , dropdownMenuSample, dropdownMenuCodeSample, Just dropdownMenuPropsApi )
      , ( "Empty", "empty"
        , "A placeholder shown when there is no content to display."
        , emptySample, emptyCodeSample, Just emptyPropsApi )
      , ( "Form", "form"
        , "Building forms with labelled, described fields."
        , formSample, formCodeSample, Just formPropsApi )
      , ( "Input", "input"
        , "Displays a form input field or a component that looks like an input field."
        , inputSample, inputCodeSample, Just inputPropsApi )
      , ( "Input Group", "input-group"
        , "A control with pinned header and footer rows."
        , inputGroupSample, inputGroupCodeSample, Just inputGroupPropsApi )
      , ( "Kbd", "kbd"
        , "Displays keyboard input or shortcuts."
        , kbdSample, kbdCodeSample, Just kbdPropsApi )
      , ( "Label", "label"
        , "Renders an accessible label associated with controls."
        , labelSample, labelCodeSample, Just labelPropsApi )
      , ( "Pagination", "pagination"
        , "Pagination with page navigation, next and previous links."
        , paginationSample, paginationCodeSample, Just paginationPropsApi )
      , ( "Popover", "popover"
        , "Displays rich content in a portal, triggered by a button."
        , popoverSample, popoverCodeSample, Just popoverPropsApi )
      , ( "Progress", "progress"
        , "Displays an indicator showing the completion progress of a task."
        , progressSample, progressCodeSample, Just progressPropsApi )
      , ( "Radio Group", "radio-group"
        , "A set of checkable buttons where only one can be checked at a time."
        , radioGroupSample, radioGroupCodeSample, Just radioGroupPropsApi )
      , ( "Select", "select"
        , "Displays a list of options for the user to pick from."
        , selectSample, selectCodeSample, Just selectPropsApi )
      , ( "Skeleton", "skeleton"
        , "Use to show a placeholder while content is loading."
        , skeletonSample, skeletonCodeSample, Just skeletonPropsApi )
      , ( "Slider", "slider"
        , "An input where the user selects a value from within a given range."
        , sliderSample InitSlider DestroySlider, sliderCodeSample, Just sliderPropsApi )
      , ( "Spinner", "spinner"
        , "An indicator that can be used to show a loading state."
        , spinnerSample, spinnerCodeSample, Just spinnerPropsApi )
      , ( "Switch", "switch"
        , "A control that allows the user to toggle between on and off."
        , switchSample, switchCodeSample, Just switchPropsApi )
      , ( "Table", "table"
        , "A responsive table component."
        , tableSample, tableCodeSample, Just tablePropsApi )
      , ( "Tabs", "tabs"
        , "A set of layered sections of content displayed one at a time."
        , tabsSample, tabsCodeSample, Just tabsPropsApi )
      , ( "Textarea", "textarea"
        , "Displays a form textarea or a component that looks like a textarea."
        , textareaSample, textareaCodeSample, Just textareaPropsApi )
      , ( "Toast", "toast"
        , "A succinct message that is displayed temporarily."
        , toastSample toaster, toastCodeSample, Just toastPropsApi )
      , ( "Tooltip", "tooltip"
        , "A popup that displays information related to an element on hover or focus."
        , tooltipSample, tooltipCodeSample, Just tooltipPropsApi )
      ]
    toaster props = Toaster
      { category = toastCategory props
      , title = toastTitle props
      , description = toastDescription props
      , label = toastLabel props
      }
-----------------------------------------------------------------------------
-- | One kitchen sink section: heading, description, preview \/ code tabs
-- and (when the component has one) a collapsible props api reference
uiComponent
  :: ( MisoString, MisoString, MisoString
     , View context props model Action, View context props model Action, Maybe (View context props model Action)
     )
  -> [ View context props model Action ]
uiComponent (name, anchor, description, sample, codeSample, mPropsApi) =
  [ h1_
      [ class_ "text-3xl font-semibold tracking-tight scroll-mt-14"
      , id_ anchor
      ]
      [ text name ]
  , p_
      [ class_ "text-muted-foreground text-[1.05rem] sm:text-base" ]
      [ text description ]
  , uiSection name ("#" <> anchor)
      ( previewCode anchor sample codeSample
      : [ propsApiSection api | Just api <- [ mPropsApi ] ]
      )
  , br_ []
  , hr_ [ class_ "mt-20" ]
  ]
-----------------------------------------------------------------------------
-- | Collapsible "Props API" panel showing the component's props records and
-- smart-constructor defaults (generated from source by scripts\/sync-samples.hs)
propsApiSection :: View context props model Action -> View context props model Action
propsApiSection api =
  accordion_ defaultAccordionProps
    [ accordionSection_ defaultAccordionItemProps
      [ accordionHeader_ [] [ "Props API" ]
      , section_
        [ class_ "pb-4" ]
        [ div_
          [ class_ "relative" ]
          [ pre_
            [ class_ "grid text-sm max-h-[500px] overflow-y-auto rounded-xl scrollbar" ]
            [ code_
              [ class_ "language-haskell !p-3.5 hljs"
              , onCreatedWith Highlight
              ]
              [ api ]
            ]
          ]
        ]
      ]
    ]
-----------------------------------------------------------------------------
uiSection
  :: MisoString
  -> MisoString
  -> [View context props model action]
  -> View context props model action
uiSection name url content = section_
  [ class_ "w-full rounded-lg border scroll-mt-14"
  ]
  [ header_
    [ class_
      "border-b px-4 py-3 flex items-center justify-between"
    ]
    [ h2_
      [ class_ "text-sm font-medium"
      ]
      [ text name ]
    , a_
      [ data_ "side" "left"
      , data_ "tooltip" "See documentation"
      , class_
        "text-muted-foreground hover:text-foreground"
      , href_ url
      ]
      [ svg_
        [ class_ "size-4"
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
        [ path_ [d_ "M12 7v14"]
        , path_
          [ d_
            "M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"
          ]
        ]
      ]
    ]
  , div_
    [ class_ "p-4" ]
    [ div_
      [ class_ "group grid w-full max-w-xl gap-4" ]
      content
    ]
  ]
-----------------------------------------------------------------------------
copyButton :: View context props model Action
copyButton = button_
    defaultButtonProps
      { buttonIcon = True
      , buttonVariant = Ghost
      , buttonClasses =
        [ "size-8", "absolute", "right-2.5", "top-2"
        , "text-muted-foreground", "hover:text-foreground", "group"
        ]
      , buttonAttrs = [ onClickWith CopyButton ]
      }
    [ svg_
        [ class_ "group-[.copied]:hidden"
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
        [ rect_
            [ ry_ "2"
            , rx_ "2"
            , y_ "8"
            , x_ "8"
            , height_ "14"
            , width_ "14"
            ]
        , path_
            [ d_
                "M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"
            ]
        ]
    , checkIcon [ class_ "hidden group-[.copied]:block" ]
    ]
-----------------------------------------------------------------------------
previewCode
  :: MisoString
  -> View context props m Action
  -> View context props m Action
  -> View context props m Action
previewCode name sample codeSample = tabs_
  defaultTabsProps
    { tabsId = "demo-tabs-with-panels-" <> name
    }
  [ tabList_ []
    [ tabButton_
      defaultTabButtonProps
        { tabButtonId = "demo-tabs-with-panels-tab-1-" <> name
        , tabButtonControls = "demo-tabs-with-panels-panel-1-" <> name
        , tabButtonSelected = True
        }
      [ "Preview" ]
    , tabButton_
      defaultTabButtonProps
        { tabButtonId = "demo-tabs-with-panels-tab-2-" <> name
        , tabButtonControls = "demo-tabs-with-panels-panel-2-" <> name
        }
      [ "Code" ]
    ]
  , hr_ []
  , tab_
    defaultTabPanelProps
      { tabPanelId = "demo-tabs-with-panels-panel-1-" <> name
      , tabPanelLabelledBy = "demo-tabs-with-panels-tab-1-" <> name
      , tabPanelSelected = True
      }
    [ sample
    ]
  , tab_
    defaultTabPanelProps
      { tabPanelId = "demo-tabs-with-panels-panel-2-" <> name
      , tabPanelLabelledBy = "demo-tabs-with-panels-tab-2-" <> name
      }
    [ div_
      [ class_ "relative"
      ]
      [ pre_
        [ class_
          "grid text-sm max-h-[650px] overflow-y-auto rounded-xl scrollbar"
        ]
        [ code_
          [ class_ "language-haskell !p-3.5 hljs"
          , onCreatedWith Highlight
          ]
          [ codeSample
          ]
        ]
      , copyButton
      ]
    ]
  ]
-----------------------------------------------------------------------------
