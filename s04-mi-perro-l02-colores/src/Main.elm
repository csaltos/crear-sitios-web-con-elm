module Main exposing (..)

import Element
import Element.Background
import Element.Font


azul =
    Element.rgb255 0 0 255


turquesa =
    Element.rgb255 0 150 150


gris =
    Element.rgb255 180 180 180


main =
    Element.layout
        [ Element.Background.color gris ]
        view


view =
    Element.column []
        [ Element.paragraph
            [ Element.Font.color azul
            , Element.Font.bold
            , Element.Font.size 44
            ]
            [ Element.text "Mi perro Lucas"
            ]
        , Element.paragraph
            [ Element.Font.size 28
            , Element.Font.color turquesa
            ]
            [ Element.text "Sitio web de mi perro"
            ]
        ]
