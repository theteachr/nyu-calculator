module Main exposing (..)

import Browser

import Html exposing (text, div, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

-- main
-- update
-- view

main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { onScreen : String
    , current : String
    , value : Float
    , currentOp : Float -> Float
    }

init : Model
init = Model "0" "" 0.0 identity

type Msg
    = Number Int
    | Perform (Float -> Float -> Float)
    | Reset

update : Msg -> Model -> Model
update msg model =
    case msg of
        Number n ->
            let
                newValue = model.current ++ (String.fromInt n)
            in
            { model
            | onScreen = newValue
            , current = newValue
            }

        Perform op ->
            { model | currentOp = op (String.toFloat model.current
                |> Maybe.withDefault 0) }

        Reset ->
            init

view model =
    div [ class "base" ]
        [ div [ class "display" ] [ text model.onScreen ]
        , div [ class "buttons" ]
            [ button [ class "operator", onClick (Perform (+))] [ text "+" ]
            , button [ class "operator", onClick (Perform (-))] [ text "−" ]
            , button [ class "operator", onClick (Perform (*))] [ text "×" ]
            , button [ class "operator", onClick (Perform (/))] [ text "÷" ]
            , button [ class "equals" ] [ text "=" ]
            , button [ onClick (Number 7) ] [ text "7" ]
            , button [ onClick (Number 8) ] [ text "8" ]
            , button [ onClick (Number 9) ] [ text "9" ]
            , button [ onClick (Number 4) ] [ text "4" ]
            , button [ onClick (Number 5) ] [ text "5" ]
            , button [ onClick (Number 6) ] [ text "6" ]
            , button [ onClick (Number 1) ] [ text "1" ]
            , button [ onClick (Number 2) ] [ text "2" ]
            , button [ onClick (Number 3) ] [ text "3" ]
            , button [ onClick (Number 0) ] [ text "0" ]
            , button [] [ text "." ]
            , button [ onClick Reset ] [ text "C" ]
            ]
        ]
