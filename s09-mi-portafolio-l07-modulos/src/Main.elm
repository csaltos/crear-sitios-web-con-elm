module Main exposing (..)

import Browser
import Browser.Navigation
import Element
import Pagina.Ayuda
import Pagina.Fotos
import Pagina.HojaDeVida
import Pagina.Home
import Url
import Visual


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
            let
                pagina =
                    getPagina url
            in
            ( { model
                | url = url
                , titulo = getTitulo pagina
                , pagina = pagina
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


getPagina url =
    if url.path == "/" then
        PaginaHome

    else if url.path == "/ayuda" then
        PaginaAyuda

    else if url.path == "/hoja-de-vida" then
        PaginaHojaDeVida

    else if url.path == "/fotos" then
        PaginaFotos

    else
        PaginaNotFound404


getTitulo pagina =
    case pagina of
        PaginaHome ->
            "Home"

        PaginaAyuda ->
            "Ayuda"

        PaginaHojaDeVida ->
            "Mi hoja de vida"

        PaginaFotos ->
            "Fotos"

        PaginaNotFound404 ->
            "Página no encontrada"


viewPage : Model -> Element.Element Msg
viewPage model =
    Element.column
        [ Element.padding 22
        , Element.spacing 12
        ]
        [ viewCabecera
        , viewContenido model
        , viewPieDePagina
        ]


viewPieDePagina =
    Visual.viewLink "http://elm-lang.org"
        "Sitio web hecho con Elm"


viewContenido : Model -> Element.Element msg
viewContenido model =
    case model.pagina of
        PaginaHome ->
            Pagina.Home.viewHome

        PaginaAyuda ->
            Pagina.Ayuda.viewAyuda

        PaginaHojaDeVida ->
            Pagina.HojaDeVida.viewHojaDeVida

        PaginaFotos ->
            Pagina.Fotos.viewFotos

        PaginaNotFound404 ->
            viewNotFound404


viewNotFound404 =
    Element.text "Página no encontrada"


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
        [ Visual.viewLink "/ayuda" "Ayuda"
        , Visual.viewLink "/hoja-de-vida" "Hoja de vida"
        , Visual.viewLink "/fotos" "Fotos"
        ]


init : flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url navigationKey =
    ( initModel url, Cmd.none )


initModel url =
    { titulo = "Home page"
    , url = url
    , pagina = PaginaHome
    }


type Pagina
    = PaginaHome
    | PaginaAyuda
    | PaginaHojaDeVida
    | PaginaFotos
    | PaginaNotFound404


type Msg
    = MsgCambiarDePagina Url.Url
    | MsgEnlaceExterno String


type alias Model =
    { titulo : String
    , url : Url.Url
    , pagina : Pagina
    }
