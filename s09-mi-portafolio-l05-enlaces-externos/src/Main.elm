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
        Browser.External urlString ->
            MsgEnlaceExterno urlString

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
            ( { model
                | url = url
                , titulo = getTitulo url
              }
            , Cmd.none
            )

        MsgEnlaceExterno urlString ->
            ( model
            , Browser.Navigation.load urlString
            )


view : Model -> Browser.Document Msg
view model =
    { title = model.titulo
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
        , viewContenido
        , viewPieDePagina
        ]


viewPieDePagina =
    Element.link []
        { url = "http://elm-lang.org"
        , label =
            Element.text "Sitio web hecho con Elm"
        }


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
    | MsgEnlaceExterno String


type alias Model =
    { titulo : String
    , url : Url.Url
    }
