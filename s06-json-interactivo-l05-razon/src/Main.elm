module Main exposing (..)

import Browser
import Element
import Element.Background
import Element.Border
import Element.Font
import Element.Input
import Html exposing (Html)
import Http
import Json.Decode
import Url


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
    , error : Maybe String
    }


type Msg
    = MsgBuscar
    | MsgEntradaDeTexto String
    | MsgResultados (Result Http.Error Int)


initModel =
    { texto = "Viajes"
    , error = Nothing
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )


booksApiUrl texto =
    "https://www.googleapis.com/books/v1/volumes?q="
        ++ Url.percentEncode texto


buscarLibros texto =
    Http.get
        { url = booksApiUrl texto
        , expect = Http.expectJson MsgResultados parserLibros
        }


parserLibros =
    Json.Decode.field "totalItems" Json.Decode.int


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
            , case model.error of
                Just error ->
                    Element.text error

                Nothing ->
                    Element.none
            ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgEntradaDeTexto texto ->
            ( { model | texto = texto }, Cmd.none )

        MsgBuscar ->
            ( model, buscarLibros model.texto )

        MsgResultados respuesta ->
            case respuesta of
                Ok totalItems ->
                    ( { model | texto = String.fromInt totalItems }, Cmd.none )

                Err razon ->
                    case razon of
                        Http.BadBody error ->
                            ( { model
                                | error = Just ("Error: " ++ error)
                              }
                            , Cmd.none
                            )

                        Http.Timeout ->
                            ( { model
                                | error = Just "Timeout"
                              }
                            , Cmd.none
                            )

                        Http.BadStatus status ->
                            ( { model
                                | error =
                                    Just
                                        ("Error en el servidor: "
                                            ++ String.fromInt status
                                        )
                              }
                            , Cmd.none
                            )

                        Http.NetworkError ->
                            ( { model
                                | error = Just "La red no está disponible"
                              }
                            , Cmd.none
                            )

                        Http.BadUrl fallo ->
                            ( { model
                                | error = Just ("Error de petición: " ++ fallo)
                              }
                            , Cmd.none
                            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
