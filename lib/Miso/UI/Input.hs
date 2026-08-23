-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Input
  ( -- ** Props
    InputProps (..)
  , defaultInputProps
    -- ** Views
  , input_
    -- ** Samples
  , inputSample
  , inputCodeSample
  , inputPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
-- | Props for 'input_'
data InputProps model action
  = InputProps
  { inputType :: MisoString
    -- ^ @type@ attribute (@text@, @email@, @password@, @date@, ...)
  , inputId :: Maybe MisoString
  , inputPlaceholder :: Maybe MisoString
  , inputValue :: Maybe MisoString
  , inputDisabled :: Bool
  , inputInvalid :: Bool
    -- ^ Renders with @aria-invalid@ (error styling)
  , inputClasses :: [MisoString]
    -- ^ Extra classes appended to @input@
  , inputAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: text input, enabled, no placeholder
defaultInputProps :: InputProps model action
defaultInputProps
  = InputProps
  { inputType = "text"
  , inputId = Nothing
  , inputPlaceholder = Nothing
  , inputValue = Nothing
  , inputDisabled = False
  , inputInvalid = False
  , inputClasses = []
  , inputAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/input/ Input>, driven by 'InputProps'
input_ :: InputProps model action -> View context model action
input_ InputProps {..} = H.input_ $ concat
  [ [ P.classes_ ("input" : inputClasses)
    , P.type_ inputType
    ]
  , [ P.id_ i | Just i <- [inputId] ]
  , [ P.placeholder_ p | Just p <- [inputPlaceholder] ]
  , [ P.value_ v | Just v <- [inputValue] ]
  , [ P.disabled_ | inputDisabled ]
  , [ P.aria_ "invalid" "true" | inputInvalid ]
  , inputAttrs
  ]
-----------------------------------------------------------------------------
inputSample :: View context model action
inputSample =
  H.div_
  [ P.class_ "flex flex-col gap-y-4" ]
  $ [ input_ defaultInputProps { inputPlaceholder = Just "Text" }
    , input_ defaultInputProps { inputPlaceholder = Just "Disabled", inputDisabled = True }
    , input_ defaultInputProps { inputPlaceholder = Just "Error", inputInvalid = True }
    , input_ defaultInputProps { inputType = "email", inputPlaceholder = Just "Email" }
    , input_ defaultInputProps { inputType = "password", inputPlaceholder = Just "Password" }
    , input_ defaultInputProps { inputType = "number", inputPlaceholder = Just "Number" }
    , input_ defaultInputProps { inputType = "file" }
    , input_ defaultInputProps { inputType = "tel", inputPlaceholder = Just "Tel" }
    , input_ defaultInputProps { inputType = "url", inputPlaceholder = Just "URL" }
    , input_ defaultInputProps { inputType = "search", inputPlaceholder = Just "Search" }
    ] ++
    [ input_ defaultInputProps { inputType = t }
    | t <- [ "date", "datetime-local", "month", "week", "time" ]
    ]
-----------------------------------------------------------------------------
inputCodeSample :: View context model action
inputCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyInput (inputSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Input
  -----------------------------------------------------------------------------
  inputSample :: View context model action
  inputSample =
    H.div_
    [ P.class_ "flex flex-col gap-y-4" ]
    $ [ input_ defaultInputProps { inputPlaceholder = Just "Text" }
      , input_ defaultInputProps { inputPlaceholder = Just "Disabled", inputDisabled = True }
      , input_ defaultInputProps { inputPlaceholder = Just "Error", inputInvalid = True }
      , input_ defaultInputProps { inputType = "email", inputPlaceholder = Just "Email" }
      , input_ defaultInputProps { inputType = "password", inputPlaceholder = Just "Password" }
      , input_ defaultInputProps { inputType = "number", inputPlaceholder = Just "Number" }
      , input_ defaultInputProps { inputType = "file" }
      , input_ defaultInputProps { inputType = "tel", inputPlaceholder = Just "Tel" }
      , input_ defaultInputProps { inputType = "url", inputPlaceholder = Just "URL" }
      , input_ defaultInputProps { inputType = "search", inputPlaceholder = Just "Search" }
      ] ++
      [ input_ defaultInputProps { inputType = t }
      | t <- [ "date", "datetime-local", "month", "week", "time" ]
      ]
  """
-----------------------------------------------------------------------------
inputPropsApi :: View context model action
inputPropsApi =
  """
  -- | Props for 'input_'
  data InputProps model action
    = InputProps
    { inputType :: MisoString
      -- ^ @type@ attribute (@text@, @email@, @password@, @date@, ...)
    , inputId :: Maybe MisoString
    , inputPlaceholder :: Maybe MisoString
    , inputValue :: Maybe MisoString
    , inputDisabled :: Bool
    , inputInvalid :: Bool
      -- ^ Renders with @aria-invalid@ (error styling)
    , inputClasses :: [MisoString]
      -- ^ Extra classes appended to @input@
    , inputAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: text input, enabled, no placeholder
  defaultInputProps :: InputProps model action
  defaultInputProps
    = InputProps
    { inputType = "text"
    , inputId = Nothing
    , inputPlaceholder = Nothing
    , inputValue = Nothing
    , inputDisabled = False
    , inputInvalid = False
    , inputClasses = []
    , inputAttrs = []
    }
  """
-----------------------------------------------------------------------------
