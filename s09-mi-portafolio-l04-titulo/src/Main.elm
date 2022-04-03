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
    case urlRequest of
        Browser.External url ->
            MsgEnlaceExterno

        Browser.Internal url ->
            MsgCambiarDePagina url


onUrlChange : Url.Url -> Msg
onUrlChange url =
    MsgCambiarDePagina url


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgCambiarDePagina url ->
            ( { model | url = url }
            , Cmd.none
            )

        MsgEnlaceExterno ->
            ( { model | titulo = "Enlace externo" }
            , Cmd.none
            )


view : Model -> Browser.Document Msg
view model =
    { title = getTitulo model.url
    , body = [ Element.layout [] (viewPage model) ]
    }


getTitulo url =
    if url.path == "/" then
        "Home"

    else if url.path == "/ayuda" then
        "Ayuda"

    else if url.path == "/hoja-de-vida" then
        "Mi hoja de vida"

    else
        "Página desconocida"


viewPage : Model -> Element.Element Msg
viewPage model =
    Element.column
        [ Element.padding 22
        , Element.spacing 12
        ]
        [ viewCabecera
        , Element.text model.url.path
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
    ( initModel url, Cmd.none )


initModel url =
    { titulo = "Home page"
    , url = url
    }


type Msg
    = MsgCambiarDePagina Url.Url
    | MsgEnlaceExterno


type alias Model =
    { titulo : String
    , url : Url.Url
    }
