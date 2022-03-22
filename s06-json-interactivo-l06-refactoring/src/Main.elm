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
            [ viewTexto model
            , viewBoton
            , viewError model
            ]
        )


viewError : Model -> Element.Element msg
viewError model =
    case model.error of
        Just error ->
            Element.text error

        Nothing ->
            Element.none


viewTexto : Model -> Element.Element Msg
viewTexto model =
    Element.Input.text []
        { onChange = MsgEntradaDeTexto
        , text = model.texto
        , placeholder =
            Just
                (Element.Input.placeholder [] (Element.text "Libro a buscar"))
        , label = Element.Input.labelLeft [] (Element.text "Buscar: ")
        }


viewBoton : Element.Element Msg
viewBoton =
    Element.Input.button
        [ Element.Background.color (Element.rgb255 0 0 0)
        , Element.Font.color (Element.rgb255 255 255 255)
        , Element.Border.rounded 10
        , Element.padding 10
        , Element.Font.bold
        ]
        { onPress = Just MsgBuscar
        , label = Element.text "Buscar"
        }


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
                    ( { model | error = Just (getError razon) }, Cmd.none )


getError : Http.Error -> String
getError razon =
    case razon of
        Http.BadBody error ->
            "Error: " ++ error

        Http.Timeout ->
            "Timeout"

        Http.BadStatus status ->
            "Error en el servidor: " ++ String.fromInt status

        Http.NetworkError ->
            "La red no está disponible"

        Http.BadUrl fallo ->
            "Error de petición: " ++ fallo


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
