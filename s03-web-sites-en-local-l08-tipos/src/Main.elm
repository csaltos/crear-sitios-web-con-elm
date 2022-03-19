module Main exposing (..)

import Browser
import Html
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)


type alias Model =
    { nombre : String
    , conteo : Int
    }


initModel : Model
initModel =
    { nombre = ""
    , conteo = 0
    }


type Msg
    = MsgEntradaDeTexto String


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.text "Cuál es tu nombre? "
        , Html.input [ onInput MsgEntradaDeTexto, value model.nombre ] []
        , Html.text (String.fromInt model.conteo)
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        MsgEntradaDeTexto texto ->
            { nombre = texto, conteo = String.length texto }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }
