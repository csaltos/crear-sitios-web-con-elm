module Main exposing (..)

import Chart as C
import Chart.Attributes as CA
import Element as E
import Element.Background as EB
import Html as H


main : H.Html msg
main =
    E.layout [ EB.color (E.rgb255 215 215 215) ]
        (E.html view)


view : H.Html msg
view =
    C.chart
        [ CA.height 120
        , CA.width 250
        ]
        [ C.xLabels []
        , C.yLabels [ CA.withGrid ]
        , C.bars []
            [ C.bar .z []
            , C.bar .y []
            ]
            [ { z = 20.5, y = 2.7 }
            , { z = 10.3, y = 8 }
            , { z = 0.3, y = 2 }
            , { z = 8.7, y = 5.4 }
            ]
        ]
