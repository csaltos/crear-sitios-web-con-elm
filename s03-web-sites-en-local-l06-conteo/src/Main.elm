module Main exposing (..)

import Browser
import Html
import Html.Events exposing (onClick, onInput)


initModel =
    { nombre = ""
    , conteo = 0
    }


type Msg
    = MsgEntradaDeTexto String
    | MsgCalcular


view model =
    Html.div []
        [ Html.text "Cuál es tu nombre? "
        , Html.input [ onInput MsgEntradaDeTexto ] []
        , Html.button [ onClick MsgCalcular ] [ Html.text "Calcular" ]
        , Html.text (String.fromInt model.conteo)
        ]


update msg model =
    case msg of
        MsgEntradaDeTexto texto ->
            { nombre = texto, conteo = String.length texto }

        MsgCalcular ->
            { nombre = model.nombre, conteo = String.length model.nombre }


main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }
