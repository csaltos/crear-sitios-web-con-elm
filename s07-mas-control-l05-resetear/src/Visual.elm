module Visual exposing (..)

import Element
import Element.Background
import Element.Border
import Element.Font
import Element.Input


viewBoton : String -> msg -> Element.Element msg
viewBoton etiqueta msg =
    Element.Input.button
        [ Element.Background.color (Element.rgb255 0 0 0)
        , Element.Font.color (Element.rgb255 255 255 255)
        , Element.padding 8
        , Element.Border.rounded 4
        ]
        { onPress = Just msg
        , label = Element.text etiqueta
        }
