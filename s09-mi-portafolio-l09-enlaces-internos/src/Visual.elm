module Visual exposing (..)

import Element
import Element.Font


viewLink url label =
    Element.link [ Element.Font.underline ]
        { url = url
        , label = Element.text label
        }
