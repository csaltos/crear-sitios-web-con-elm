module Main exposing (..)

import Element
import Element.Background
import Element.Font


azul =
    Element.rgb255 0 0 255


turquesa =
    Element.rgb255 0 150 150


gris =
    Element.rgb255 180 180 180


fontHeader =
    Element.Font.family
        [ Element.Font.typeface "LuckiestGuy"
        ]


fontDefault =
    Element.Font.family
        [ Element.Font.typeface "Typewriter"
        ]


main =
    Element.layout
        [ Element.Background.color gris
        , fontDefault
        ]
        view


view =
    Element.column
        [ Element.padding 22
        , Element.spacing 12
        ]
        [ viewHeader
        , viewContent
        ]


viewContent =
    Element.textColumn []
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


viewHeader =
    Element.column []
        [ Element.paragraph
            [ Element.Font.color azul
            , Element.Font.bold
            , Element.Font.size 44
            , fontHeader
            ]
            [ Element.text "Mi perro Lucas"
            ]
        , Element.paragraph
            [ Element.Font.size 28
            , Element.Font.color turquesa
            , fontHeader
            ]
            [ Element.text "Sitio web de mi perro"
            ]
        ]
