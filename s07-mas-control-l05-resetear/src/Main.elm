port module Main exposing (..)

import Browser
import Element
import Html
import Visual


main : Program Int Model Msg
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
    let
        contador =
            model + 1

        reseteo =
            0
    in
    case msg of
        MsgContar ->
            ( contador, grabarContador contador )

        MsgResetear ->
            ( reseteo, grabarContador reseteo )


view : Model -> Browser.Document Msg
view model =
    { title = "Mi contador " ++ String.fromInt model
    , body = [ viewElement model ]
    }


viewElement : Model -> Html.Html Msg
viewElement model =
    Element.layout []
        (viewContador model)


viewContador : Model -> Element.Element Msg
viewContador model =
    Element.column [ Element.padding 22, Element.spacing 8 ]
        [ Element.text (String.fromInt model)
        , Visual.viewBoton "Contar" MsgContar
        , Visual.viewBoton "Resetear" MsgResetear
        ]


init : Int -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, Cmd.none )


type Msg
    = MsgContar
    | MsgResetear


type alias Model =
    Int


initModel : Int -> Model
initModel flags =
    flags


port grabarContador : Int -> Cmd msg
