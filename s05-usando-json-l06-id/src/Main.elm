module Main exposing (..)

import Browser
import Element
import Element.Font
import Element.Input
import Html exposing (Html)
import Http
import Json.Decode


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { id : Int
    , titulo : String
    , imagenUrl : Maybe String
    }


type Msg
    = MsgCargarDatos
    | MsgJsonListo (Result Http.Error Model)
    | MsgEntradaDeTexto String


initModel : Model
initModel =
    { id = 1
    , titulo = "Hola JSON"
    , imagenUrl = Nothing
    }


init : () -> ( Model, Cmd msg )
init _ =
    ( initModel, Cmd.none )


view : Model -> Html Msg
view model =
    Element.layout []
        (Element.column []
            [ viewCajaDeTextoId (String.fromInt model.id)
            , Element.text model.titulo
            , Element.Input.button [ Element.Font.underline ]
                { onPress = Just MsgCargarDatos
                , label = Element.text "Cargar datos"
                }
            , case model.imagenUrl of
                Just url ->
                    Element.image []
                        { src = url
                        , description = model.titulo
                        }

                Nothing ->
                    Element.none
            ]
        )


viewCajaDeTextoId : String -> Element.Element Msg
viewCajaDeTextoId id =
    Element.Input.text []
        { onChange = MsgEntradaDeTexto
        , text = id
        , placeholder = Nothing
        , label =
            Element.Input.labelAbove []
                (Element.text "ID de la foto:")
        }


jsonUrl : Int -> String
jsonUrl id =
    "https://jsonplaceholder.typicode.com/photos/"
        ++ String.fromInt id


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgCargarDatos ->
            ( model, cargarDatos model.id )

        MsgEntradaDeTexto texto ->
            case String.toInt texto of
                Just id ->
                    ( { model | id = id }, Cmd.none )

                Nothing ->
                    ( { model | titulo = "ID invalido" }, Cmd.none )

        MsgJsonListo resultado ->
            case resultado of
                Ok datos ->
                    ( datos, Cmd.none )

                Err _ ->
                    ( { model | titulo = "Error" }, Cmd.none )


cargarDatos : Int -> Cmd Msg
cargarDatos id =
    Http.get
        { url = jsonUrl id
        , expect = Http.expectJson MsgJsonListo parserFoto
        }


parserFoto : Json.Decode.Decoder Model
parserFoto =
    Json.Decode.map3 Model
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.maybe
            (Json.Decode.field "url" Json.Decode.string)
        )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
