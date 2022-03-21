module Main exposing (..)

import Browser
import Element
import Element.Background
import Element.Border
import Element.Font
import Element.Input
import Html exposing (Html)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { texto : String
    }


type Msg
    = MsgBuscar
    | MsgEntradaDeTexto String


init : () -> ( Model, Cmd Msg )
init _ =
    ( { texto = "Viajes" }, Cmd.none )


view : Model -> Html Msg
view model =
    Element.layout [ Element.padding 20 ]
        (Element.row [ Element.spacing 22 ]
            [ Element.Input.text []
                { onChange = MsgEntradaDeTexto
                , text = model.texto
                , placeholder =
                    Just
                        (Element.Input.placeholder [] (Element.text "Libro a buscar"))
                , label = Element.Input.labelLeft [] (Element.text "Buscar: ")
                }
            , Element.Input.button
                [ Element.Background.color (Element.rgb255 0 0 0)
                , Element.Font.color (Element.rgb255 255 255 255)
                , Element.Border.rounded 10
                , Element.padding 10
                , Element.Font.bold
                ]
                { onPress = Just MsgBuscar
                , label = Element.text "Buscar"
                }
            ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgEntradaDeTexto texto ->
            ( { model | texto = texto }, Cmd.none )

        MsgBuscar ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
