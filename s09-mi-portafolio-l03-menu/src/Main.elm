module Main exposing (..)

import Browser
import Browser.Navigation
import Element
import Element.Font
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
    case msg of
        MsgCambiarDePagina ->
            ( { model | titulo = "Nueva página" }
            , Cmd.none
            )


view : Model -> Browser.Document Msg
view model =
    { title = model.titulo
    , body = [ Element.layout [] viewPage ]
    }


viewPage : Element.Element Msg
viewPage =
    Element.column
        [ Element.padding 22
        , Element.spacing 12
        ]
        [ viewCabecera
        , Element.text "Home"
        , viewContenido
        ]


viewContenido : Element.Element msg
viewContenido =
    Element.text "Esta es la página del home"


viewCabecera : Element.Element msg
viewCabecera =
    Element.row [ Element.paddingXY 12 0 ]
        [ Element.text "Carlos"
        , viewMenu
        ]


viewMenu : Element.Element msg
viewMenu =
    Element.row
        [ Element.paddingXY 12 0
        , Element.spacing 12
        ]
        [ Element.link [ Element.Font.underline ]
            { url = "/ayuda"
            , label = Element.text "Ayuda"
            }
        , Element.link [ Element.Font.underline ]
            { url = "/hoja-de-vida"
            , label = Element.text "Hoja de vida"
            }
        ]


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
