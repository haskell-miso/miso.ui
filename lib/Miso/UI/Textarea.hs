-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Textarea
  ( -- ** Props
    TextareaProps (..)
  , defaultTextareaProps
    -- ** Views
  , textarea_
    -- ** Samples
  , textareaUsage
  , textareaSample
  , textareaCodeSample
  , textareaPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Label
-----------------------------------------------------------------------------
-- | Props for 'textarea_'
data TextareaProps action
  = TextareaProps
  { textareaId :: Maybe MisoString
  , textareaPlaceholder :: Maybe MisoString
  , textareaRows :: Maybe MisoString
  , textareaDisabled :: Bool
  , textareaInvalid :: Bool
    -- ^ Renders with @aria-invalid@ (error styling)
  , textareaClasses :: [MisoString]
    -- ^ Extra classes appended to @textarea@
  , textareaAttrs :: [Attribute action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: enabled, no placeholder
defaultTextareaProps :: TextareaProps action
defaultTextareaProps
  = TextareaProps
  { textareaId = Nothing
  , textareaPlaceholder = Nothing
  , textareaRows = Nothing
  , textareaDisabled = False
  , textareaInvalid = False
  , textareaClasses = []
  , textareaAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/textarea/ Textarea>, driven by 'TextareaProps'
textarea_ :: TextareaProps action -> View model action
textarea_ TextareaProps {..} = H.textarea_ $ concat
  [ [ P.classes_ ("textarea" : textareaClasses) ]
  , [ P.id_ i | Just i <- [textareaId] ]
  , [ P.placeholder_ p | Just p <- [textareaPlaceholder] ]
  , [ P.rows_ r | Just r <- [textareaRows] ]
  , [ P.disabled_ | textareaDisabled ]
  , [ P.aria_ "invalid" "true" | textareaInvalid ]
  , textareaAttrs
  ]
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
textareaUsage :: View model action
textareaUsage =
  H.div_
  [ P.class_ "flex flex-col gap-y-6" ]
  [ textarea_ defaultTextareaProps { textareaPlaceholder = Just "Type your message here" }
  , textarea_ defaultTextareaProps
    { textareaPlaceholder = Just "Type your message here"
    , textareaInvalid = True
    }
  , H.div_
    [ P.class_ "grid gap-3" ]
    [ label_ defaultLabelProps { labelFor = Just "my-textarea" } [ "Label" ]
    , textarea_ defaultTextareaProps
      { textareaPlaceholder = Just "Type your message here"
      , textareaId = Just "my-textarea"
      }
    ]
  ]
-----------------------------------------------------------------------------
textareaSample :: View model action
textareaSample =
  H.div_
  [ P.class_ "flex flex-col gap-y-10" ]
  [ textarea_ defaultTextareaProps { textareaPlaceholder = Just "Type your message here" }
  , textarea_ defaultTextareaProps
    { textareaPlaceholder = Just "Type your message here"
    , textareaInvalid = True
    }
  , H.div_
    [ P.class_ "grid gap-3" ]
    [ label_ defaultLabelProps { labelFor = Just "textarea-demo-label" } [ "Label" ]
    , textarea_ defaultTextareaProps
      { textareaPlaceholder = Just "Type your message here"
      , textareaId = Just "textarea-demo-label"
      }
    ]
  , H.div_
    [ P.class_ "grid gap-3" ]
    [ label_ defaultLabelProps { labelFor = Just "textarea-demo-label-and-description" }
      [ "With label and description" ]
    , textarea_ defaultTextareaProps
      { textareaPlaceholder = Just "Type your message here"
      , textareaId = Just "textarea-demo-label-and-description"
      }
    , H.p_
      [ P.class_ "text-muted-foreground text-sm" ]
      [ "Type your message and press enter to send." ]
    ]
  , H.div_
    [ P.class_ "grid gap-3" ]
    [ label_ defaultLabelProps { labelFor = Just "textarea-demo-disabled" } [ "Disabled" ]
    , textarea_ defaultTextareaProps
      { textareaPlaceholder = Just "Type your message here"
      , textareaId = Just "textarea-demo-disabled"
      , textareaDisabled = True
      }
    ]
  ]
-----------------------------------------------------------------------------
textareaCodeSample :: View model action
textareaCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyTextarea (textareaUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Label
  import           Miso.UI.Textarea
  -----------------------------------------------------------------------------
  textareaUsage :: View model action
  textareaUsage =
    H.div_
    [ P.class_ "flex flex-col gap-y-6" ]
    [ textarea_ defaultTextareaProps { textareaPlaceholder = Just "Type your message here" }
    , textarea_ defaultTextareaProps
      { textareaPlaceholder = Just "Type your message here"
      , textareaInvalid = True
      }
    , H.div_
      [ P.class_ "grid gap-3" ]
      [ label_ defaultLabelProps { labelFor = Just "my-textarea" } [ "Label" ]
      , textarea_ defaultTextareaProps
        { textareaPlaceholder = Just "Type your message here"
        , textareaId = Just "my-textarea"
        }
      ]
    ]
  """
-----------------------------------------------------------------------------
textareaPropsApi :: View model action
textareaPropsApi =
  """
  -- | Props for 'textarea_'
  data TextareaProps action
    = TextareaProps
    { textareaId :: Maybe MisoString
    , textareaPlaceholder :: Maybe MisoString
    , textareaRows :: Maybe MisoString
    , textareaDisabled :: Bool
    , textareaInvalid :: Bool
      -- ^ Renders with @aria-invalid@ (error styling)
    , textareaClasses :: [MisoString]
      -- ^ Extra classes appended to @textarea@
    , textareaAttrs :: [Attribute action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: enabled, no placeholder
  defaultTextareaProps :: TextareaProps action
  defaultTextareaProps
    = TextareaProps
    { textareaId = Nothing
    , textareaPlaceholder = Nothing
    , textareaRows = Nothing
    , textareaDisabled = False
    , textareaInvalid = False
    , textareaClasses = []
    , textareaAttrs = []
    }
  """
-----------------------------------------------------------------------------
