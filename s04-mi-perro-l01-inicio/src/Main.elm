module Main exposing (..)

import Element
import Element.Font


main =
    Element.layout
        [ Element.Font.bold
        , Element.Font.size 98
        ]
        view


view =
    Element.text "Hola Elm UI"
