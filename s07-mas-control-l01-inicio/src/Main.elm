module Main exposing (..)

import Browser
import Element
import Html


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgContar ->
            ( model + 1, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Mi contador"
    , body = [ viewElement model ]
    }


viewElement : Model -> Html.Html Msg
viewElement model =
    Element.layout []
        (Element.text (String.fromInt model))


init : () -> ( Model, Cmd Msg )
init flags =
    ( initModel, Cmd.none )


type Msg
    = MsgContar


type alias Model =
    Int


initModel : Model
initModel =
    0
