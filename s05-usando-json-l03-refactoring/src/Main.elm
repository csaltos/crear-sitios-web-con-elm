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
    { titulo : String
    }


type Msg
    = MsgCargarDatos
    | MsgJsonListo (Result Http.Error String)


initModel : Model
initModel =
    { titulo = "Hola JSON" }


init : () -> ( Model, Cmd msg )
init _ =
    ( initModel, Cmd.none )


view : Model -> Html Msg
view model =
    Element.layout []
        (Element.column []
            [ Element.text model.titulo
            , Element.Input.button [ Element.Font.underline ]
                { onPress = Just MsgCargarDatos
                , label = Element.text "Cargar datos"
                }
            ]
        )


jsonUrl : String
jsonUrl =
    "https://jsonplaceholder.typicode.com/photos/2"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgCargarDatos ->
            ( model, cargarDatos )

        MsgJsonListo resultado ->
            case resultado of
                Ok titulo ->
                    ( { model | titulo = titulo }, Cmd.none )

                Err _ ->
                    ( { model | titulo = "Error" }, Cmd.none )


cargarDatos : Cmd Msg
cargarDatos =
    Http.get
        { url = jsonUrl
        , expect = Http.expectJson MsgJsonListo parserFoto
        }


parserFoto : Json.Decode.Decoder String
parserFoto =
    Json.Decode.field "title" Json.Decode.string


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
