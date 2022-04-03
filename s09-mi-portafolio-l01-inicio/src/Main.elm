module Main exposing (..)

import Browser
import Browser.Navigation
import Html
import Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = onUrlChange
        , onUrlRequest = onUrlRequest
        }


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest urlRequest =
    MsgCambiarDePagina


onUrlChange : Url.Url -> Msg
onUrlChange url =
    MsgCambiarDePagina


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = model.titulo
    , body = [ viewPage ]
    }


viewPage =
    Html.text "Home"


init : flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url navigationKey =
    ( initModel, Cmd.none )


initModel =
    { titulo = "Home page" }


type Msg
    = MsgCambiarDePagina


type alias Model =
    { titulo : String
    }
