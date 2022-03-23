module Main exposing (..)

import Browser
import Browser.Events
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
    , enlaceUrl : Maybe String
    , numeroDePaginas : Maybe Int
    , editorial : Maybe String
    }


type Msg
    = MsgBuscar
    | MsgEntradaDeTexto String
    | MsgResultados (Result Http.Error (List Libro))
    | MsgTeclaPulsada String


azulOscuro =
    Element.rgb255 0x00 0x33 0x66


azulClaro =
    Element.rgb255 0x33 0x66 0x99


blanco =
    Element.rgb255 0xDD 0xDD 0xDD


negro =
    Element.rgb255 0x23 0x23 0x23


initModel : Model
initModel =
    { texto = "Viajes a Bolivia"
    , error = Nothing
    , resultado = []
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, buscarLibros initModel.texto )


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
    Json.Decode.map5 Libro
        (Json.Decode.maybe
            (Json.Decode.field "title" Json.Decode.string)
        )
        (Json.Decode.maybe
            (Json.Decode.field "imageLinks" parserImageLinks)
        )
        (Json.Decode.maybe
            (Json.Decode.field "canonicalVolumeLink" Json.Decode.string)
        )
        (Json.Decode.maybe
            (Json.Decode.field "pageCount" Json.Decode.int)
        )
        (Json.Decode.maybe
            (Json.Decode.field "publisher" Json.Decode.string)
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
    Element.wrappedRow [ Element.spacing 20 ]
        (List.map viewLibro model.resultado)


viewLibro : Libro -> Element.Element Msg
viewLibro libro =
    case libro.enlaceUrl of
        Just url ->
            Element.newTabLink []
                { url = url
                , label =
                    viewLibroDetalle libro
                }

        Nothing ->
            viewLibroDetalle libro


viewLibroDetalle libro =
    Element.row
        [ Element.spacing 10
        , Element.width (Element.px 360)
        , Element.height (Element.px 280)
        , Element.Background.color azulClaro
        , Element.Font.color blanco
        , Element.padding 20
        , Element.Border.rounded 12
        ]
        [ viewCubierta libro
        , Element.column
            [ Element.spacing 18
            , Element.width (Element.px 180)
            ]
            [ viewTitulo libro
            , viewEditorial libro
            , viewPaginas libro
            ]
        ]


viewEditorial : Libro -> Element.Element Msg
viewEditorial libro =
    Element.paragraph [ Element.Font.size 14 ]
        [ Element.text
            (Maybe.withDefault
                "Editorial desconocido"
                libro.editorial
            )
        ]


viewPaginas : Libro -> Element.Element Msg
viewPaginas libro =
    Element.paragraph [ Element.Font.size 10 ]
        [ case libro.numeroDePaginas of
            Just numeroDePaginas ->
                Element.text
                    (String.fromInt numeroDePaginas
                        ++ " páginas"
                    )

            Nothing ->
                Element.text "Numero de páginas desconocido"
        ]


viewTitulo : Libro -> Element.Element Msg
viewTitulo libro =
    Element.paragraph
        [ Element.Font.bold
        , Element.Font.size 16
        ]
        [ Element.text
            (Maybe.withDefault "Sin título" libro.titulo)
        ]


viewCubierta : Libro -> Element.Element Msg
viewCubierta libro =
    case libro.muestraUrl of
        Just url ->
            Element.image []
                { src = url
                , description =
                    Maybe.withDefault "Sin título" libro.titulo
                }

        Nothing ->
            Element.none


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

        MsgTeclaPulsada tecla ->
            if tecla == "Enter" then
                ( model, buscarLibros model.texto )

            else
                ( model, Cmd.none )

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
    Browser.Events.onKeyUp parserTecla


parserTecla =
    Json.Decode.map MsgTeclaPulsada
        (Json.Decode.field "key" Json.Decode.string)
