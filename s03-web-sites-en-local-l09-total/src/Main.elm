module Main exposing (..)

import Browser
import Html
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)


type alias Model =
    { nombre : String
    , conteo : Int
    , total : Int
    }


initModel : Model
initModel =
    { nombre = ""
    , conteo = 0
    , total = 0
    }


type Msg
    = MsgEntradaDeTexto String


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.text "Cuál es tu nombre? "
        , Html.input [ onInput MsgEntradaDeTexto, value model.nombre ] []
        , Html.text (String.fromInt model.conteo)
        , Html.text ","
        , Html.text (String.fromInt model.total)
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        MsgEntradaDeTexto texto ->
            if String.startsWith "G" texto then
                { model
                    | nombre = texto
                    , total = model.total + 1
                }

            else if String.contains "a" texto then
                { model
                    | nombre = texto
                    , conteo = String.length texto
                }

            else
                { model
                    | nombre = texto
                    , conteo = String.length texto
                    , total = model.total + 1
                }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }
