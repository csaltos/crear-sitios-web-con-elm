module Main exposing (..)

import Browser
import Html
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, onInput)


initModel =
    { nombre = ""
    , conteo = 0
    }


type Msg
    = MsgEntradaDeTexto String


view model =
    Html.div []
        [ Html.text "Cuál es tu nombre? "
        , Html.input [ onInput MsgEntradaDeTexto, value model.nombre ] []
        , Html.text (String.fromInt model.conteo)
        ]


update msg model =
    case msg of
        MsgEntradaDeTexto texto ->
            { nombre = texto, conteo = String.length texto }


main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }
