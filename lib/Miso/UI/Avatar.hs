-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE RecordWildCards   #-}
-----------------------------------------------------------------------------
module Miso.UI.Avatar
  ( -- ** Props
    AvatarProps (..)
  , defaultAvatarProps
    -- ** Views
  , avatar_
  , avatarFallback_
  , avatarGroup_
    -- ** Samples
  , avatarSample
  , avatarCodeSample
  , avatarPropsApi
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Html.Element as H
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
import           Miso.UI.Types
-----------------------------------------------------------------------------
-- | Props for 'avatar_'
data AvatarProps model action
  = AvatarProps
  { avatarSrc :: MisoString
  , avatarAlt :: MisoString
  , avatarSize :: Size
    -- ^ 'DefaultSize' (@size-8@) or 'Large' (@size-12@)
  , avatarSquare :: Bool
    -- ^ @rounded-lg@ instead of @rounded-full@
  , avatarClasses :: [MisoString]
    -- ^ Extra classes appended to the @img@
  , avatarAttrs :: [Attribute model action]
  }
-----------------------------------------------------------------------------
-- | Smart constructor: small round avatar
defaultAvatarProps :: AvatarProps model action
defaultAvatarProps
  = AvatarProps
  { avatarSrc = ""
  , avatarAlt = ""
  , avatarSize = DefaultSize
  , avatarSquare = False
  , avatarClasses = []
  , avatarAttrs = []
  }
-----------------------------------------------------------------------------
-- | <https://basecoatui.com/components/avatar/ Avatar>, driven by 'AvatarProps'
avatar_ :: AvatarProps model action -> View context props model action
avatar_ AvatarProps {..} = H.img_ $ concat
  [ [ P.src_ avatarSrc
    , P.alt_ avatarAlt
    , P.classes_ $ concat
      [ [ if avatarSize == Large then "size-12" else "size-8" ]
      , [ "shrink-0", "object-cover" ]
      , [ if avatarSquare then "rounded-lg" else "rounded-full" ]
      , avatarClasses
      ]
    ]
  , avatarAttrs
  ]
-----------------------------------------------------------------------------
-- | Initials fallback when no image is available
avatarFallback_
  :: [Attribute model action]
  -> [View context props model action]
  -> View context props model action
avatarFallback_ attrs kids =
  H.span_
    ( P.class_ "size-8 shrink-0 bg-muted flex items-center justify-center rounded-full"
    : attrs
    ) kids
-----------------------------------------------------------------------------
-- | Overlapping stack of avatars. Children should be plain @img_@ views
-- (the group styles them via @[&_img]@ selectors).
avatarGroup_
  :: Size
  -> [Attribute model action]
  -> [View context props model action]
  -> View context props model action
avatarGroup_ size attrs kids =
  H.div_
    ( P.classes_
      [ "flex"
      , "-space-x-2"
      , "[&_img]:ring-background"
      , "[&_img]:ring-2"
      , "[&_img]:grayscale"
      , if size == Large then "[&_img]:size-12" else "[&_img]:size-8"
      , "[&_img]:shrink-0"
      , "[&_img]:object-cover"
      , "[&_img]:rounded-full"
      ]
    : attrs
    ) kids
-----------------------------------------------------------------------------
avatarSample :: View context props model action
avatarSample =
  H.div_
  [ P.class_ "flex flex-row flex-wrap items-center gap-4" ]
  [ avatar_ defaultAvatarProps
    { avatarSrc = "https://github.com/dmjio.png"
    , avatarAlt = "@dmjio"
    }
  , avatarFallback_ [] [ "CN" ]
  , avatar_ defaultAvatarProps
    { avatarSrc = "https://github.com/dmjio.png"
    , avatarAlt = "@dmjio"
    , avatarSize = Large
    }
  , avatar_ defaultAvatarProps
    { avatarSrc = "https://github.com/dmjio.png"
    , avatarAlt = "@dmjio"
    , avatarSquare = True
    }
  , avatarGroup_ DefaultSize [] members
  , avatarGroup_ Large [] members
  , avatarGroup_ Large
    [ P.class_ "hover:space-x-1 [&_img]:transition-all [&_img]:ease-in-out [&_img]:duration-300" ]
    members
  ]
  where
    members =
      [ H.img_ [ P.src_ ("https://github.com/" <> user <> ".png"), P.alt_ ("@" <> user) ]
      | user <- [ "dmjio", "shadcn", "adamwathan", "hunvreus" ]
      ]
-----------------------------------------------------------------------------
avatarCodeSample :: View context props model action
avatarCodeSample =
  """
  -----------------------------------------------------------------------------
  module MyAvatar (avatarSample) where
  -----------------------------------------------------------------------------
  import           Miso
  import qualified Miso.Html.Element as H
  import qualified Miso.Html.Property as P
  import           Miso.UI.Types
  import           Miso.UI.Avatar
  -----------------------------------------------------------------------------
  avatarSample :: View context props model action
  avatarSample =
    H.div_
    [ P.class_ "flex flex-row flex-wrap items-center gap-4" ]
    [ avatar_ defaultAvatarProps
      { avatarSrc = "https://github.com/dmjio.png"
      , avatarAlt = "@dmjio"
      }
    , avatarFallback_ [] [ "CN" ]
    , avatar_ defaultAvatarProps
      { avatarSrc = "https://github.com/dmjio.png"
      , avatarAlt = "@dmjio"
      , avatarSize = Large
      }
    , avatar_ defaultAvatarProps
      { avatarSrc = "https://github.com/dmjio.png"
      , avatarAlt = "@dmjio"
      , avatarSquare = True
      }
    , avatarGroup_ DefaultSize [] members
    , avatarGroup_ Large [] members
    , avatarGroup_ Large
      [ P.class_ "hover:space-x-1 [&_img]:transition-all [&_img]:ease-in-out [&_img]:duration-300" ]
      members
    ]
    where
      members =
        [ H.img_ [ P.src_ ("https://github.com/" <> user <> ".png"), P.alt_ ("@" <> user) ]
        | user <- [ "dmjio", "shadcn", "adamwathan", "hunvreus" ]
        ]
  """
-----------------------------------------------------------------------------
avatarPropsApi :: View context props model action
avatarPropsApi =
  """
  -- | Props for 'avatar_'
  data AvatarProps model action
    = AvatarProps
    { avatarSrc :: MisoString
    , avatarAlt :: MisoString
    , avatarSize :: Size
      -- ^ 'DefaultSize' (@size-8@) or 'Large' (@size-12@)
    , avatarSquare :: Bool
      -- ^ @rounded-lg@ instead of @rounded-full@
    , avatarClasses :: [MisoString]
      -- ^ Extra classes appended to the @img@
    , avatarAttrs :: [Attribute model action]
    }
  -----------------------------------------------------------------------------
  -- | Smart constructor: small round avatar
  defaultAvatarProps :: AvatarProps model action
  defaultAvatarProps
    = AvatarProps
    { avatarSrc = ""
    , avatarAlt = ""
    , avatarSize = DefaultSize
    , avatarSquare = False
    , avatarClasses = []
    , avatarAttrs = []
    }
  """
-----------------------------------------------------------------------------
