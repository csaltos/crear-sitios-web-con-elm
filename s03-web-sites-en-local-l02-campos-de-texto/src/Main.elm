module Main exposing (..)

import Browser
import Html


initModel =
    ""


view model =
    Html.div []
        [ Html.text "Cuál es tu nombre: "
        , Html.input [] []
        , Html.button [] [ Html.text "Calcular" ]
        ]


update msg model =
    model


main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }
