-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Card
  ( -- ** Props
    CardProps (..)
  , defaultCardProps
    -- ** Views
  , card_
  , cardHeader_
  , cardContent_
  , cardFooter_
    -- ** Samples
  , cardUsage
  , cardSample
  , cardCodeSample
  , cardPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Button
import           Miso.UI.Input
import           Miso.UI.Label
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props for 'card_'. Title, description and footer nest other views.
data CardProps context model action
  = CardProps
  { cardTitle :: Maybe (View context props model action)
    -- ^ Heading shown in the card header
  , cardDescription :: Maybe (View context props model action)
    -- ^ Sub-heading shown under the title
  , cardFooter :: Maybe [View context props model action]
    -- ^ Footer content
  , cardFooterClasses :: [MisoString]
  , cardClasses :: [MisoString]
    -- ^ Extra classes appended to @div.card@ (e.g. @w-full max-w-sm@)
  , cardAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: bare card
defaultCardProps :: CardProps context model action
defaultCardProps
  = CardProps
  { cardTitle = Nothing
  , cardDescription = Nothing
  , cardFooter = Nothing
  , cardFooterClasses = []
  , cardClasses = []
  , cardAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/card/ Card>, driven by 'CardProps'.
-- Children render inside the card's content section.
card_
  :: CardProps context model action
  -> [View context props model action]
  -> View context props model action
card_ CardProps {..} kids =
  H.div_
    ( P.classes_ ("card" : cardClasses)
    : cardAttrs
    )
    $ concat
    [ [ cardHeader_ [] $ concat
        [ [ H.h2_ [] [ t ] | Just t <- [cardTitle] ]
        , [ H.p_ [] [ d ] | Just d <- [cardDescription] ]
        ]
      | any id [ maybe False (const True) cardTitle
               , maybe False (const True) cardDescription
               ]
      ]
    , [ cardContent_ [] kids | not (null kids) ]
    , [ cardFooter_ [ P.classes_ cardFooterClasses ] f | Just f <- [cardFooter] ]
    ]
-----------------------------------------------------------------------------
cardHeader_
  :: [Attribute model action]
  -> [View context props model action]
  -> View context props model action
cardHeader_ = H.header_
-----------------------------------------------------------------------------
cardContent_
  :: [Attribute model action]
  -> [View context props model action]
  -> View context props model action
cardContent_ = H.section_
-----------------------------------------------------------------------------
cardFooter_
  :: [Attribute model action]
  -> [View context props model action]
  -> View context props model action
cardFooter_ = H.footer_
-----------------------------------------------------------------------------
-- | Compact usage example (source of the kitchen sink "Code" tab)
cardUsage :: View context props model action
cardUsage =
  card_ defaultCardProps
  { cardTitle = Just "Login to your account"
  , cardDescription = Just "Enter your details below to login to your account"
  , cardClasses = [ "w-full", "max-w-sm" ]
  , cardFooter = Just
    [ button_ defaultButtonProps { buttonClasses = [ "w-full" ] } [ "Login" ] ]
  }
  [ H.form_
    [ P.class_ "form grid gap-6" ]
    [ H.div_
      [ P.class_ "grid gap-2" ]
      [ label_ defaultLabelProps { labelFor = Just "my-email" } [ "Email" ]
      , input_ defaultInputProps
        { inputType = "email"
        , inputId = Just "my-email"
        }
      ]
    ]
  ]
-----------------------------------------------------------------------------
cardSample :: View context props model action
cardSample =
  H.div_
  [ P.class_ "flex flex-col gap-4" ]
  [ card_ defaultCardProps
    { cardTitle = Just "Login to your account"
    , cardDescription = Just "Enter your details below to login to your account"
    , cardClasses = [ "w-full", "max-w-sm" ]
    , cardFooter = Just
      [ button_ defaultButtonProps { buttonClasses = [ "w-full" ] } [ "Login" ]
      , button_ defaultButtonProps { buttonVariant = Outline, buttonClasses = [ "w-full" ] }
        [ "Login with Google" ]
      , H.p_ [ P.class_ "mt-4 text-center text-sm" ]
        [ "Don't have an account? "
        , H.a_
          [ P.href_ "#"
          , P.class_ "underline-offset-4 hover:underline"
          ] [ "Sign up" ]
        ]
      ]
    , cardFooterClasses = [ "flex", "flex-col", "items-center", "gap-2" ]
    }
    [ H.form_
      [ P.class_ "form grid gap-6" ]
      [ H.div_
        [ P.class_ "grid gap-2" ]
        [ label_ defaultLabelProps { labelFor = Just "demo-card-form-email" } [ "Email" ]
        , input_ defaultInputProps
          { inputType = "email"
          , inputId = Just "demo-card-form-email"
          }
        ]
      , H.div_ [ P.class_ "grid gap-2" ]
        [ H.div_ [ P.class_ "flex items-center gap-2" ]
          [ label_ defaultLabelProps { labelFor = Just "demo-card-form-password" } [ "Password" ]
          , H.a_
            [ P.href_ "#"
            , P.class_ "ml-auto inline-block text-sm underline-offset-4 hover:underline"
            ] [ "Forgot your password?" ]
          ]
        , input_ defaultInputProps
          { inputType = "password"
          , inputId = Just "demo-card-form-password"
          }
        ]
      ]
    ]
  , H.div_
    [ P.class_ "flex w-full flex-wrap items-start gap-8 md:*:[.card]:basis-1/4" ]
    [ card_ defaultCardProps [ "Content Only" ]
    , card_ defaultCardProps
      { cardTitle = Just "Header Only"
      , cardDescription = Just "This is a card with a header and a description."
      } []
    , card_ defaultCardProps
      { cardTitle = Just "Header and Content"
      , cardDescription = Just "This is a card with a header and a content."
      }
      [ "Content only." ]
    , card_ defaultCardProps { cardFooter = Just [ "Footer Only" ] } []
    , card_ defaultCardProps
      { cardTitle = Just "Header + Footer"
      , cardDescription = Just "This is a card with a header and a footer."
      , cardFooter = Just [ "Footer" ]
      } []
    , card_ defaultCardProps { cardFooter = Just [ "Footer" ] } [ "Content" ]
    , card_ defaultCardProps
      { cardTitle = Just "Header + Content + Footer"
      , cardDescription = Just "This is a card with a header, content and footer."
      , cardFooter = Just [ "Footer" ]
      }
      [ "Content" ]
    ]
  ]
-----------------------------------------------------------------------------
cardCodeSample :: View context props model action
cardCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyCard (cardUsage) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Button
  import           Miso.UI.Input
  import           Miso.UI.Label
  import           Miso.UI.Types
  import           Miso.UI.Card
  -----------------------------------------------------------------------------
  cardUsage :: View context props model action
  cardUsage =
    card_ defaultCardProps
    { cardTitle = Just "Login to your account"
    , cardDescription = Just "Enter your details below to login to your account"
    , cardClasses = [ "w-full", "max-w-sm" ]
    , cardFooter = Just
      [ button_ defaultButtonProps { buttonClasses = [ "w-full" ] } [ "Login" ] ]
    }
    [ H.form_
      [ P.class_ "form grid gap-6" ]
      [ H.div_
        [ P.class_ "grid gap-2" ]
        [ label_ defaultLabelProps { labelFor = Just "my-email" } [ "Email" ]
        , input_ defaultInputProps
          { inputType = "email"
          , inputId = Just "my-email"
          }
        ]
      ]
    ]
  """
-----------------------------------------------------------------------------
cardPropsApi :: View context props model action
cardPropsApi =
  """
  -- | Props for 'card_'. Title, description and footer nest other views.
  data CardProps context model action
    = CardProps
    { cardTitle :: Maybe (View context props model action)
      -- ^ Heading shown in the card header
    , cardDescription :: Maybe (View context props model action)
      -- ^ Sub-heading shown under the title
    , cardFooter :: Maybe [View context props model action]
      -- ^ Footer content
    , cardFooterClasses :: [MisoString]
    , cardClasses :: [MisoString]
      -- ^ Extra classes appended to @div.card@ (e.g. @w-full max-w-sm@)
    , cardAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: bare card
  defaultCardProps :: CardProps context model action
  defaultCardProps
    = CardProps
    { cardTitle = Nothing
    , cardDescription = Nothing
    , cardFooter = Nothing
    , cardFooterClasses = []
    , cardClasses = []
    , cardAttrs = []
    }
  """
-----------------------------------------------------------------------------
