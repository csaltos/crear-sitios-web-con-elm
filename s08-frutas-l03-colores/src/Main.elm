module Main exposing (..)

import Chart as C
import Chart.Attributes as CA
import Element as E
import Element.Background as EB
import Element.Font as EF
import Html as H


main : H.Html msg
main =
    E.layout [ EB.color (E.rgb255 215 215 215) ]
        (E.column
            [ E.padding 22
            , E.spacing 16
            ]
            [ viewTitulo
            , E.el [ EF.size 10 ] (E.html view)
            ]
        )


viewTitulo : E.Element msg
viewTitulo =
    E.paragraph [ EF.size 40 ]
        [ E.text "Frutas con calorías" ]


view : H.Html msg
view =
    C.chart
        [ CA.height 120
        , CA.width 250
        , CA.margin
            { top = 20
            , right = 20
            , bottom = 16
            , left = 40
            }
        ]
        [ C.binLabels .fruta [ CA.moveDown 20 ]
        , C.yLabels [ CA.withGrid ]
        , C.bars []
            [ C.bar .calorias [ CA.color CA.blue ]
            ]
            [ { fruta = "Ciruela", calorias = 46.0 }
            , { fruta = "Aguacate", calorias = 160 }
            , { fruta = "Dátiles", calorias = 282 }
            , { fruta = "Lichi", calorias = 66 }
            ]
        ]
