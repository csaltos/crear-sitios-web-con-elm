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
    , resultado : List Libro
    }


type alias Libro =
    { titulo : Maybe String
    , muestraUrl : Maybe String
    }


type Msg
    = MsgBuscar
    | MsgEntradaDeTexto String
    | MsgResultados (Result Http.Error (List Libro))


initModel : Model
initModel =
    { texto = "Viajes"
    , error = Nothing
    , resultado = []
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )


booksApiUrl : String -> String
booksApiUrl texto =
    "https://www.googleapis.com/books/v1/volumes?q="
        ++ Url.percentEncode texto


buscarLibros : String -> Cmd Msg
buscarLibros texto =
    Http.get
        { url = booksApiUrl texto
        , expect = Http.expectJson MsgResultados parserLibros
        }


parserLibros : Json.Decode.Decoder (List Libro)
parserLibros =
    Json.Decode.field "items" parserItems


parserItems : Json.Decode.Decoder (List Libro)
parserItems =
    Json.Decode.list parserItem


parserItem : Json.Decode.Decoder Libro
parserItem =
    Json.Decode.field "volumeInfo" parserVolumeInfo


parserVolumeInfo : Json.Decode.Decoder Libro
parserVolumeInfo =
    Json.Decode.map2 Libro
        (Json.Decode.maybe
            (Json.Decode.field "title" Json.Decode.string)
        )
        (Json.Decode.maybe
            (Json.Decode.field "imageLinks" parserImageLinks)
        )


parserImageLinks : Json.Decode.Decoder String
parserImageLinks =
    Json.Decode.field "thumbnail" Json.Decode.string


view : Model -> Html Msg
view model =
    Element.layout [ Element.padding 20 ]
        (Element.column [ Element.spacing 22 ]
            [ viewBuscador model
            , viewResultado model
            ]
        )


viewBuscador : Model -> Element.Element Msg
viewBuscador model =
    Element.row []
        [ viewTexto model
        , viewBoton
        , viewError model
        ]


viewResultado : Model -> Element.Element Msg
viewResultado model =
    Element.column []
        (List.map viewLibro model.resultado)


viewLibro : Libro -> Element.Element Msg
viewLibro libro =
    case libro.titulo of
        Just titulo ->
            case libro.muestraUrl of
                Just muestraUrl ->
                    Element.image []
                        { src = muestraUrl
                        , description = titulo
                        }

                Nothing ->
                    Element.text "Imagen no disponible"

        Nothing ->
            Element.text "Título desconocido"


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
                Ok resultado ->
                    ( { model | resultado = resultado }, Cmd.none )

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
subscriptions _ =
    Sub.none
