module Main exposing (..)

import Browser
import Element


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
    = MsgPrueba


init flags =
    ( { titulo = "Hola JSON" }, Cmd.none )


view model =
    Element.layout []
        (Element.text model.titulo)


update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
