module Main exposing (..)

import Browser
import Element
import Element.Background
import Element.Border
import Element.Font
import Element.Input


coloresDark =
    { primario = Element.rgb255 0x3D 0x26 0x22
    , primarioDark = Element.rgb255 0x1A 0x00 0x00
    , primarioLight = Element.rgb255 0x69 0x4E 0x4A
    , secundario = Element.rgb255 0xFF 0xAB 0x00
    , secundarioDark = Element.rgb255 0xC6 0x7C 0x00
    , secundarioLight = Element.rgb255 0xFF 0xDD 0x4B
    , textoEnPrimario = Element.rgb255 0xFF 0xFF 0xFF
    , textoEnSecundario = Element.rgb255 0x00 0x00 0x00
    }


coloresLight =
    { primario = Element.rgb255 0x3D 0x26 0x22
    , primarioDark = Element.rgb255 0xFF 0xFF 0xFF
    , primarioLight = Element.rgb255 0x69 0x4E 0x4A
    , secundario = Element.rgb255 0xFF 0xAB 0x00
    , secundarioDark = Element.rgb255 0xC6 0x7C 0x00
    , secundarioLight = Element.rgb255 0xFF 0xDD 0x4B
    , textoEnPrimario = Element.rgb255 0x00 0x00 0x00
    , textoEnSecundario = Element.rgb255 0x00 0x00 0x00
    }


fontHeader =
    Element.Font.family
        [ Element.Font.typeface "LuckiestGuy"
        ]


fontDefault =
    Element.Font.family
        [ Element.Font.typeface "Typewriter"
        ]


main =
    Browser.sandbox
        { init = initModel
        , view = viewPage
        , update = update
        }


type Msg
    = MsgCambiarColores


initModel =
    coloresLight


update msg model =
    case msg of
        MsgCambiarColores ->
            if model == coloresLight then
                coloresDark

            else
                coloresLight


viewPage model =
    Element.layout
        [ Element.Background.color model.primarioDark
        , fontDefault
        , Element.Font.color model.textoEnPrimario
        ]
        (viewLayout
            model
        )


viewLayout model =
    Element.column
        [ Element.padding 22
        , Element.spacing 12
        , Element.width Element.fill
        ]
        [ viewHeader model
        , viewContent
        ]


viewContent =
    Element.textColumn [ Element.width Element.fill ]
        [ Element.paragraph
            [ Element.alignLeft
            , Element.paddingXY 20 0
            ]
            [ Element.image
                [ Element.width (Element.px 180)
                ]
                { src = "foto.jpeg"
                , description = "Foto de mi perro"
                }
            ]
        , Element.paragraph [ Element.Font.size 12 ]
            [ Element.text "Pie liquorice oat cake sweet roll wafer. Fruitcake muffin muffin lollipop marshmallow soufflé. Wafer halvah apple pie halvah chocolate cake sweet roll. Candy pie cheesecake bonbon sesame snaps croissant croissant biscuit. Sesame snaps jelly beans cookie liquorice cookie pie. Cake sweet jujubes tootsie roll biscuit shortbread sugar plum sweet roll. Candy cake fruitcake candy sesame snaps bonbon danish lollipop. Cake jelly beans brownie croissant soufflé. Tiramisu chupa chups powder cake apple pie cupcake liquorice. Sweet roll sesame snaps soufflé cotton candy halvah tart bonbon. Icing macaroon caramels apple pie macaroon. Tart soufflé gingerbread wafer sesame snaps icing. Marshmallow oat cake icing sweet roll caramels sesame snaps apple pie muffin. Macaroon sugar plum croissant caramels tart."
            ]
        ]


viewHeader model =
    Element.row
        [ Element.width Element.fill
        ]
        [ viewTitle model
        , viewButton model
        ]


viewTitle model =
    Element.column [ Element.width Element.fill ]
        [ Element.paragraph
            [ Element.Font.color model.secundarioDark
            , Element.Font.bold
            , Element.Font.size 44
            , fontHeader
            ]
            [ Element.text "Mi perro Lucas"
            ]
        , Element.paragraph
            [ Element.Font.size 22
            , Element.Font.color model.primarioLight
            , fontHeader
            ]
            [ Element.text "Sitio web de mi perro"
            ]
        ]


viewButton model =
    Element.Input.button
        [ Element.Background.color model.primarioLight
        , Element.Border.rounded 8
        , Element.Font.size 16
        , Element.padding 10
        ]
        { onPress = Just MsgCambiarColores
        , label = Element.text "Cambiar colores"
        }
