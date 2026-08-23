-----------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
-----------------------------------------------------------------------------
-- | Lucide icons used throughout the @Miso.UI.*@ samples.
module Miso.UI.Icons
  ( -- ** Smart constructor
    lucide_
    -- ** Icons
  , arrowLeftIcon
  , arrowRightIcon
  , checkIcon
  , chevronDownIcon
  , chevronLeftIcon
  , chevronRightIcon
  , chevronsUpDownIcon
  , circleAlertIcon
  , circleCheckIcon
  , dotsIcon
  , downloadIcon
  , infoIcon
  , loaderIcon
  , searchIcon
  , sendIcon
  , trashIcon
  , uploadIcon
  , xIcon
  ) where
-----------------------------------------------------------------------------
import           Miso
import qualified Miso.Svg           as S
import qualified Miso.Svg.Property  as SP
import qualified Miso.Html.Property as P
-----------------------------------------------------------------------------
-- | Smart constructor for a lucide-styled inline svg icon
lucide_
  :: [Attribute model action]
  -> [View context model action]
  -> View context model action
lucide_ attrs kids = S.svg_
  ( [ P.xmlns_ "http://www.w3.org/2000/svg"
    , P.width_ "24"
    , P.height_ "24"
    , SP.viewBox_ "0 0 24 24"
    , SP.fill_ "none"
    , SP.stroke_ "currentColor"
    , SP.strokeWidth_ "2"
    , SP.strokeLinecap_ "round"
    , SP.strokeLinejoin_ "round"
    ] ++ attrs
  ) kids
-----------------------------------------------------------------------------
arrowLeftIcon :: [Attribute model action] -> View context model action
arrowLeftIcon attrs = lucide_ attrs
  [ S.path_ [ SP.d_ "m12 19-7-7 7-7" ]
  , S.path_ [ SP.d_ "M19 12H5" ]
  ]
-----------------------------------------------------------------------------
arrowRightIcon :: [Attribute model action] -> View context model action
arrowRightIcon attrs = lucide_ attrs
  [ S.path_ [ SP.d_ "M5 12h14" ]
  , S.path_ [ SP.d_ "m12 5 7 7-7 7" ]
  ]
-----------------------------------------------------------------------------
checkIcon :: [Attribute model action] -> View context model action
checkIcon attrs = lucide_ attrs
  [ S.path_ [ SP.d_ "M20 6 9 17l-5-5" ]
  ]
-----------------------------------------------------------------------------
chevronDownIcon :: [Attribute model action] -> View context model action
chevronDownIcon attrs = lucide_ attrs
  [ S.path_ [ SP.d_ "m6 9 6 6 6-6" ]
  ]
-----------------------------------------------------------------------------
chevronLeftIcon :: [Attribute model action] -> View context model action
chevronLeftIcon attrs = lucide_ attrs
  [ S.path_ [ SP.d_ "m15 18-6-6 6-6" ]
  ]
-----------------------------------------------------------------------------
chevronRightIcon :: [Attribute model action] -> View context model action
chevronRightIcon attrs = lucide_ attrs
  [ S.path_ [ SP.d_ "m9 18 6-6-6-6" ]
  ]
-----------------------------------------------------------------------------
chevronsUpDownIcon :: [Attribute model action] -> View context model action
chevronsUpDownIcon attrs = lucide_ attrs
  [ S.path_ [ SP.d_ "m7 15 5 5 5-5" ]
  , S.path_ [ SP.d_ "m7 9 5-5 5 5" ]
  ]
-----------------------------------------------------------------------------
circleAlertIcon :: [Attribute model action] -> View context model action
circleAlertIcon attrs = lucide_ attrs
  [ S.circle_ [ SP.cx_ "12", SP.cy_ "12", SP.r_ "10" ]
  , S.line_ [ SP.x1_ "12", SP.x2_ "12", SP.y1_ "8", SP.y2_ "12" ]
  , S.line_ [ SP.x1_ "12", SP.x2_ "12.01", SP.y1_ "16", SP.y2_ "16" ]
  ]
-----------------------------------------------------------------------------
circleCheckIcon :: [Attribute model action] -> View context model action
circleCheckIcon attrs = lucide_ attrs
  [ S.circle_ [ SP.cx_ "12", SP.cy_ "12", SP.r_ "10" ]
  , S.path_ [ SP.d_ "m9 12 2 2 4-4" ]
  ]
-----------------------------------------------------------------------------
dotsIcon :: [Attribute model action] -> View context model action
dotsIcon attrs = lucide_ attrs
  [ S.circle_ [ SP.cx_ "12", SP.cy_ "12", SP.r_ "1" ]
  , S.circle_ [ SP.cx_ "19", SP.cy_ "12", SP.r_ "1" ]
  , S.circle_ [ SP.cx_ "5",  SP.cy_ "12", SP.r_ "1" ]
  ]
-----------------------------------------------------------------------------
downloadIcon :: [Attribute model action] -> View context model action
downloadIcon attrs = lucide_ attrs
  [ S.path_ [ SP.d_ "M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" ]
  , S.polyline_ [ SP.points_ "7 10 12 15 17 10" ]
  , S.line_ [ SP.x1_ "12", SP.x2_ "12", SP.y1_ "15", SP.y2_ "3" ]
  ]
-----------------------------------------------------------------------------
infoIcon :: [Attribute model action] -> View context model action
infoIcon attrs = lucide_ attrs
  [ S.circle_ [ SP.cx_ "12", SP.cy_ "12", SP.r_ "10" ]
  , S.path_ [ SP.d_ "M12 16v-4" ]
  , S.path_ [ SP.d_ "M12 8h.01" ]
  ]
-----------------------------------------------------------------------------
loaderIcon :: [Attribute model action] -> View context model action
loaderIcon attrs = lucide_ attrs
  [ S.path_ [ SP.d_ "M12 2v4" ]
  , S.path_ [ SP.d_ "m16.2 7.8 2.9-2.9" ]
  , S.path_ [ SP.d_ "M18 12h4" ]
  , S.path_ [ SP.d_ "m16.2 16.2 2.9 2.9" ]
  , S.path_ [ SP.d_ "M12 18v4" ]
  , S.path_ [ SP.d_ "m4.9 19.1 2.9-2.9" ]
  , S.path_ [ SP.d_ "M2 12h4" ]
  , S.path_ [ SP.d_ "m4.9 4.9 2.9 2.9" ]
  ]
-----------------------------------------------------------------------------
searchIcon :: [Attribute model action] -> View context model action
searchIcon attrs = lucide_ attrs
  [ S.circle_ [ SP.cx_ "11", SP.cy_ "11", SP.r_ "8" ]
  , S.path_ [ SP.d_ "m21 21-4.3-4.3" ]
  ]
-----------------------------------------------------------------------------
sendIcon :: [Attribute model action] -> View context model action
sendIcon attrs = lucide_ attrs
  [ S.path_
    [ SP.d_ "M14.536 21.686a.5.5 0 0 0 .937-.024l6.5-19a.496.496 0 0 0-.635-.635l-19 6.5a.5.5 0 0 0-.024.937l7.93 3.18a2 2 0 0 1 1.112 1.11z"
    ]
  , S.path_ [ SP.d_ "m21.854 2.147-10.94 10.939" ]
  ]
-----------------------------------------------------------------------------
trashIcon :: [Attribute model action] -> View context model action
trashIcon attrs = lucide_ attrs
  [ S.path_ [ SP.d_ "M3 6h18" ]
  , S.path_ [ SP.d_ "M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6" ]
  , S.path_ [ SP.d_ "M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2" ]
  , S.line_ [ SP.x1_ "10", SP.x2_ "10", SP.y1_ "11", SP.y2_ "17" ]
  , S.line_ [ SP.x1_ "14", SP.x2_ "14", SP.y1_ "11", SP.y2_ "17" ]
  ]
-----------------------------------------------------------------------------
uploadIcon :: [Attribute model action] -> View context model action
uploadIcon attrs = lucide_ attrs
  [ S.path_ [ SP.d_ "M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" ]
  , S.polyline_ [ SP.points_ "17 8 12 3 7 8" ]
  , S.line_ [ SP.x1_ "12", SP.x2_ "12", SP.y1_ "3", SP.y2_ "15" ]
  ]
-----------------------------------------------------------------------------
xIcon :: [Attribute model action] -> View context model action
xIcon attrs = lucide_ attrs
  [ S.path_ [ SP.d_ "M18 6 6 18" ]
  , S.path_ [ SP.d_ "m6 6 12 12" ]
  ]
-----------------------------------------------------------------------------
