-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Accordion
  ( -- ** Props
    AccordionProps (..)
  , defaultAccordionProps
  , AccordionItemProps (..)
  , defaultAccordionItemProps
    -- ** Views
  , accordion_
  , accordionSection_
  , accordionHeader_
  , accordionBody_
    -- ** Sample
  , accordionSample
  , accordionCodeSample
  , accordionPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html          as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Icons
-----------------------------------------------------------------------------
-- | Props for 'accordion_'
data AccordionProps model action
  = AccordionProps
  { accordionMultiple :: Bool
    -- ^ Allow several sections open at once (@data-multiple@)
  , accordionClasses :: [MisoString]
    -- ^ Extra classes appended to the root @section.accordion@
  , accordionAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: exclusive expand
defaultAccordionProps :: AccordionProps model action
defaultAccordionProps
  = AccordionProps
  { accordionMultiple = False
  , accordionClasses = []
  , accordionAttrs = []
  }
-----------------------------------------------------------------------------
-- | Props for 'accordionSection_'
data AccordionItemProps model action
  = AccordionItemProps
  { accordionItemOpen :: Bool
    -- ^ Section expanded initially
  , accordionItemDisabled :: Bool
    -- ^ Renders with @aria-disabled@
  , accordionItemClasses :: [MisoString]
  , accordionItemAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: collapsed, enabled
defaultAccordionItemProps :: AccordionItemProps model action
defaultAccordionItemProps
  = AccordionItemProps
  { accordionItemOpen = False
  , accordionItemDisabled = False
  , accordionItemClasses = []
  , accordionItemAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/accordion/ Accordion>, driven by 'AccordionProps'
accordion_
  :: AccordionProps model action
  -> [View context model action]
  -> View context model action
accordion_ AccordionProps {..} kids =
  H.section_
    ( concat
      [ [ P.classes_ ("accordion" : accordionClasses) ]
      , [ P.data_ "multiple" "" | accordionMultiple ]
      , accordionAttrs
      ]
    ) kids
-----------------------------------------------------------------------------
accordionSection_
  :: AccordionItemProps model action
  -> [View context model action]
  -> View context model action
accordionSection_ AccordionItemProps {..} kids =
  H.details_
    ( concat
      [ [ P.classes_
          ( [ "group", "border-b", "last:border-b-0" ] ++ accordionItemClasses )
        ]
      , [ P.open_ True | accordionItemOpen ]
      , [ P.aria_ "disabled" "true" | accordionItemDisabled ]
      , accordionItemAttrs
      ]
    ) kids
-----------------------------------------------------------------------------
accordionHeader_
  :: [ Attribute model action ]
  -> [ View context model action ]
  -> View context model action
accordionHeader_ attrs kids = H.summary_
  ( P.className
      "w-full focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] transition-all outline-none rounded-md"
  : attrs
  )
  [ H.h2_
    [ P.className "flex flex-1 items-start justify-between gap-4 py-4 text-left text-sm font-medium hover:underline"
    ]
    kids
  , chevronDownIcon
    [ P.classes_
      [ "text-muted-foreground"
      , "pointer-events-none"
      , "size-4"
      , "shrink-0"
      , "translate-y-0.5"
      , "transition-transform"
      , "duration-200"
      , "group-open:rotate-180"
      ]
    ]
  ]
-----------------------------------------------------------------------------
accordionBody_
  :: [ Attribute model action ]
  -> [ View context model action ]
  -> View context model action
accordionBody_ attrs kids =
  H.section_
    ( P.className "pb-4"
    : attrs
    )
    [ H.p_
      [ P.classes_ ["text-sm"]
      ]
      kids
    ]
-----------------------------------------------------------------------------
accordionSample :: View context model action
accordionSample =
  accordion_ defaultAccordionProps
    [ accordionSection_ defaultAccordionItemProps { accordionItemOpen = True }
      [ accordionHeader_ []
        [ "Is it accessible?" ]
      , accordionBody_ []
        [ "Yes. It adheres to the WAI-ARIA design pattern." ]
      ]
    , accordionSection_ defaultAccordionItemProps
      [ accordionHeader_ []
        [ "Is it styled?" ]
      , accordionBody_ []
        [ "Yes. It comes with default styles that match other component aesthetic." ]
      ]
    , accordionSection_ defaultAccordionItemProps
      [ accordionHeader_ []
        [ "Is it animated?" ]
      , accordionBody_ []
        [ "Yes. It's animated by default, but you can disable it if you prefer." ]
      ]
    ]
-----------------------------------------------------------------------------
accordionCodeSample :: View context model action
accordionCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyAccordion (accordionSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html          as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Icons
  import           Miso.UI.Accordion
  -----------------------------------------------------------------------------
  accordionSample :: View context model action
  accordionSample =
    accordion_ defaultAccordionProps
      [ accordionSection_ defaultAccordionItemProps { accordionItemOpen = True }
        [ accordionHeader_ []
          [ "Is it accessible?" ]
        , accordionBody_ []
          [ "Yes. It adheres to the WAI-ARIA design pattern." ]
        ]
      , accordionSection_ defaultAccordionItemProps
        [ accordionHeader_ []
          [ "Is it styled?" ]
        , accordionBody_ []
          [ "Yes. It comes with default styles that match other component aesthetic." ]
        ]
      , accordionSection_ defaultAccordionItemProps
        [ accordionHeader_ []
          [ "Is it animated?" ]
        , accordionBody_ []
          [ "Yes. It's animated by default, but you can disable it if you prefer." ]
        ]
      ]
  """
-----------------------------------------------------------------------------
accordionPropsApi :: View context model action
accordionPropsApi =
  """
  -- | Props for 'accordion_'
  data AccordionProps model action
    = AccordionProps
    { accordionMultiple :: Bool
      -- ^ Allow several sections open at once (@data-multiple@)
    , accordionClasses :: [MisoString]
      -- ^ Extra classes appended to the root @section.accordion@
    , accordionAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: exclusive expand
  defaultAccordionProps :: AccordionProps model action
  defaultAccordionProps
    = AccordionProps
    { accordionMultiple = False
    , accordionClasses = []
    , accordionAttrs = []
    }
  -----------------------------------------------------------------------------
  -- | Props for 'accordionSection_'
  data AccordionItemProps model action
    = AccordionItemProps
    { accordionItemOpen :: Bool
      -- ^ Section expanded initially
    , accordionItemDisabled :: Bool
      -- ^ Renders with @aria-disabled@
    , accordionItemClasses :: [MisoString]
    , accordionItemAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: collapsed, enabled
  defaultAccordionItemProps :: AccordionItemProps model action
  defaultAccordionItemProps
    = AccordionItemProps
    { accordionItemOpen = False
    , accordionItemDisabled = False
    , accordionItemClasses = []
    , accordionItemAttrs = []
    }
  """
-----------------------------------------------------------------------------
