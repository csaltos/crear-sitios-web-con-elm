module Main exposing (..)

import Browser
import Element
import Element.Font
import Element.Input
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


init flags =
    ( { titulo = "Hola JSON" }, Cmd.none )


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


jsonUrl =
    "https://jsonplaceholder.typicode.com/photos/2"


update msg model =
    case msg of
        MsgCargarDatos ->
            ( model, cargarDatos )

        MsgJsonListo resultado ->
            case resultado of
                Ok titulo ->
                    ( { model | titulo = titulo }, Cmd.none )

                Err error ->
                    ( { model | titulo = "Error" }, Cmd.none )


cargarDatos =
    Http.get
        { url = jsonUrl
        , expect = Http.expectJson MsgJsonListo parserFoto
        }


parserFoto =
    Json.Decode.field "title" Json.Decode.string


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
