module Main exposing (..)

import Browser
import Element
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


init : () -> ( Model, Cmd Msg )
init _ =
    ( { texto = "Viajes" }, Cmd.none )


view : Model -> Html Msg
view model =
    Element.layout []
        (Element.text model.texto)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
