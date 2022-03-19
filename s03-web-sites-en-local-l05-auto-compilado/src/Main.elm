module Main exposing (..)

import Browser
import Html
import Html.Events exposing (onClick, onInput)


initModel =
    ""


type Msg
    = MsgEntradaDeTexto String
    | MsgCalcular


view model =
    Html.div []
        [ Html.text "Cuál es tu nombre? "
        , Html.input [ onInput MsgEntradaDeTexto ] []
        , Html.button [ onClick MsgCalcular ] [ Html.text "Calcular" ]
        , Html.text model
        ]


update msg model =
    case msg of
        MsgEntradaDeTexto texto ->
            texto

        MsgCalcular ->
            String.fromInt (String.length model)


main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }
