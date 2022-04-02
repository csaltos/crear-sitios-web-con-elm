port module Main exposing (..)

import Browser
import Element
import Element.Background
import Element.Border
import Element.Font
import Element.Input
import Html


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
    in
    case msg of
        MsgContar ->
            ( contador, grabarContador contador )


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
        , Element.Input.button
            [ Element.Background.color (Element.rgb255 0 0 0)
            , Element.Font.color (Element.rgb255 255 255 255)
            , Element.padding 8
            , Element.Border.rounded 4
            ]
            { onPress = Just MsgContar
            , label = Element.text "Contar"
            }
        ]


init : Int -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, Cmd.none )


type Msg
    = MsgContar


type alias Model =
    Int


initModel : Int -> Model
initModel flags =
    flags


port grabarContador : Int -> Cmd msg
