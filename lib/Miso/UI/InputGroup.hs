-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.InputGroup
  ( -- ** Props
    InputGroupProps (..)
  , defaultInputGroupProps
    -- ** Views
  , inputGroup_
  , inputGroupHeader_
  , inputGroupFooter_
    -- ** Samples
  , inputGroupUsage
  , inputGroupSample
  , inputGroupCodeSample
  , inputGroupPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
import qualified Miso.Svg           as S
import qualified Miso.Svg.Property  as SP
-----------------------------------------------------------------------------
import           Miso.UI.Button
import           Miso.UI.Icons
import           Miso.UI.Textarea
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props for 'inputGroup_'. Header and footer overlay the wrapped control.
data InputGroupProps context model action
  = InputGroupProps
  { inputGroupHeader :: [View context model action]
    -- ^ Content pinned to the top of the group
  , inputGroupFooter :: [View context model action]
    -- ^ Content pinned to the bottom of the group
  , inputGroupClasses :: [MisoString]
  , inputGroupAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor
defaultInputGroupProps :: InputGroupProps context model action
defaultInputGroupProps
  = InputGroupProps
  { inputGroupHeader = []
  , inputGroupFooter = []
  , inputGroupClasses = []
  , inputGroupAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/input-group/ Input Group>: control with
-- pinned header\/footer rows. Children are the wrapped control(s).
inputGroup_
  :: InputGroupProps context model action
  -> [View context model action]
  -> View context model action
inputGroup_ InputGroupProps {..} kids =
  H.div_
    ( P.classes_ ("relative" : inputGroupClasses)
    : inputGroupAttrs
    )
    $ concat
    [ kids
    , [ inputGroupHeader_ [] inputGroupHeader | not (null inputGroupHeader) ]
    , [ inputGroupFooter_ [] inputGroupFooter | not (null inputGroupFooter) ]
    ]
-----------------------------------------------------------------------------
inputGroupHeader_
  :: [Attribute model action]
  -> [View context model action]
  -> View context model action
inputGroupHeader_ attrs kids =
  H.header_
    ( P.class_ "absolute top-0 flex items-center w-full gap-2 p-3 border-b"
    : attrs
    ) kids
-----------------------------------------------------------------------------
inputGroupFooter_
  :: [Attribute model action]
  -> [View context model action]
  -> View context model action
inputGroupFooter_ attrs kids =
  H.footer_
    ( P.class_ "absolute bottom-0 flex items-center w-full gap-2 p-3 border-t"
    : attrs
    ) kids
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
inputGroupUsage :: View context model action
inputGroupUsage =
  inputGroup_ defaultInputGroupProps
  { inputGroupHeader =
    [ H.span_
      [ P.class_ "font-mono text-sm text-muted-foreground mr-auto" ]
      [ "script.js" ]
    ]
  , inputGroupFooter =
    [ H.span_
      [ P.class_ "text-sm text-muted-foreground mr-auto" ]
      [ "Line 1, Column 1" ]
    , button_ defaultButtonProps { buttonSize = Small } [ "Run" ]
    ]
  }
  [ textarea_ defaultTextareaProps
    { textareaPlaceholder = Just "console.log('Hello, world!')."
    , textareaClasses = [ "pt-15", "pb-17", "min-h-77" ]
    }
  ]
-----------------------------------------------------------------------------
inputGroupSample :: View context model action
inputGroupSample =
  inputGroup_ defaultInputGroupProps
    { inputGroupHeader =
      [ jsIcon
      , H.span_
        [ P.class_ "font-mono text-sm text-muted-foreground mr-auto" ]
        [ "script.js" ]
      , button_ defaultButtonProps
        { buttonSize = Small
        , buttonIcon = True
        , buttonVariant = Ghost
        , buttonClasses = [ "text-muted-foreground", "hover:text-accent-foreground", "size-6" ]
        }
        [ refreshIcon ]
      , button_ defaultButtonProps
        { buttonSize = Small
        , buttonIcon = True
        , buttonVariant = Ghost
        , buttonClasses = [ "text-muted-foreground", "hover:text-accent-foreground", "size-6" ]
        }
        [ copyIcon ]
      ]
    , inputGroupFooter =
      [ H.span_
        [ P.class_ "text-sm text-muted-foreground mr-auto" ]
        [ "Line 1, Column 1" ]
      , button_ defaultButtonProps { buttonSize = Small }
        [ "Run", returnIcon ]
      ]
    }
    [ textarea_ defaultTextareaProps
      { textareaPlaceholder = Just "console.log('Hello, world!')."
      , textareaClasses = [ "pt-15", "pb-17", "min-h-77" ]
      }
    ]
  where
    jsIcon = lucide_
      [ P.class_ "size-4 text-muted-foreground" ]
      [ S.path_ [ SP.d_ "M20 4l-2 14.5l-6 2l-6 -2l-2 -14.5z" ]
      , S.path_ [ SP.d_ "M7.5 8h3v8l-2 -1" ]
      , S.path_
        [ SP.d_ "M16.5 8h-2.5a.5 .5 0 0 0 -.5 .5v3a.5 .5 0 0 0 .5 .5h1.423a.5 .5 0 0 1 .495 .57l-.418 2.93l-2 .5"
        ]
      ]
    refreshIcon = lucide_ []
      [ S.path_ [ SP.d_ "M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8" ]
      , S.path_ [ SP.d_ "M3 3v5h5" ]
      , S.path_ [ SP.d_ "M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16" ]
      , S.path_ [ SP.d_ "M16 16h5v5" ]
      ]
    copyIcon = lucide_ []
      [ S.rect_
        [ SP.x_ "8", SP.y_ "8", SP.rx_ "2", SP.ry_ "2"
        , P.width_ "14", P.height_ "14"
        ]
      , S.path_ [ SP.d_ "M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2" ]
      ]
    returnIcon = lucide_ []
      [ S.polyline_ [ SP.points_ "9 10 4 15 9 20" ]
      , S.path_ [ SP.d_ "M20 4v7a4 4 0 0 1-4 4H4" ]
      ]
-----------------------------------------------------------------------------
inputGroupCodeSample :: View context model action
inputGroupCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyInputGroup (inputGroupUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import qualified Miso.Svg           as S
  import qualified Miso.Svg.Property  as SP
  import           Miso.UI.Button
  import           Miso.UI.Icons
  import           Miso.UI.Textarea
  import           Miso.UI.Types
  import           Miso.UI.InputGroup
  -----------------------------------------------------------------------------
  inputGroupUsage :: View context model action
  inputGroupUsage =
    inputGroup_ defaultInputGroupProps
    { inputGroupHeader =
      [ H.span_
        [ P.class_ "font-mono text-sm text-muted-foreground mr-auto" ]
        [ "script.js" ]
      ]
    , inputGroupFooter =
      [ H.span_
        [ P.class_ "text-sm text-muted-foreground mr-auto" ]
        [ "Line 1, Column 1" ]
      , button_ defaultButtonProps { buttonSize = Small } [ "Run" ]
      ]
    }
    [ textarea_ defaultTextareaProps
      { textareaPlaceholder = Just "console.log('Hello, world!')."
      , textareaClasses = [ "pt-15", "pb-17", "min-h-77" ]
      }
    ]
  """
-----------------------------------------------------------------------------
inputGroupPropsApi :: View context model action
inputGroupPropsApi =
  """
  -- | Props for 'inputGroup_'. Header and footer overlay the wrapped control.
  data InputGroupProps context model action
    = InputGroupProps
    { inputGroupHeader :: [View context model action]
      -- ^ Content pinned to the top of the group
    , inputGroupFooter :: [View context model action]
      -- ^ Content pinned to the bottom of the group
    , inputGroupClasses :: [MisoString]
    , inputGroupAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor
  defaultInputGroupProps :: InputGroupProps context model action
  defaultInputGroupProps
    = InputGroupProps
    { inputGroupHeader = []
    , inputGroupFooter = []
    , inputGroupClasses = []
    , inputGroupAttrs = []
    }
  """
-----------------------------------------------------------------------------
