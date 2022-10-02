module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { currentValue : Float
    , currentValueString : String
    , currentOp : Float -> Float
    }


type Op
    = Add
    | Sub
    | Mul
    | Div


toFn op =
    case op of
        Add ->
            (+)

        Sub ->
            (-)

        Mul ->
            (*)

        Div ->
            (/)


init : Model
init =
    Model 0.0 "" identity


type Msg
    = Number Int
    | Perform Op
    | Reset
    | Eval


update : Msg -> Model -> Model
update msg model =
    case msg of
        Number n ->
            let
                newValue =
                    model.currentValueString ++ String.fromInt n
            in
            { model
                | currentValueString = newValue
                , currentValue = newValue |> String.toFloat |> Maybe.withDefault 0
            }

        Perform op ->
            let
                updatedValue =
                    model.currentOp model.currentValue
            in
            { model
                | currentValue = updatedValue
                , currentOp = updatedValue |> toFn op
                , currentValueString = ""
            }

        Eval ->
            let
                result =
                    model.currentOp model.currentValue
            in
            { model
                | currentValue = result
                , currentValueString = ""
                , currentOp = identity
            }

        Reset ->
            init


view : Model -> Html Msg
view model =
    div [ class "base" ]
        [ div [ class "display" ] [ text (String.fromFloat model.currentValue) ]
        , div [ class "buttons" ]
            [ button [ class "operator", onClick (Perform Add) ] [ text "+" ]
            , button [ class "operator", onClick (Perform Sub) ] [ text "−" ]
            , button [ class "operator", onClick (Perform Mul) ] [ text "×" ]
            , button [ class "operator", onClick (Perform Div) ] [ text "÷" ]
            , button [ class "equals", onClick Eval ] [ text "=" ]
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

--- { cV = 0, cO = i, cS = "" }

--> Number 1

--- { cV = 1, cO = i, cS = "1" }

--> Perform Add

--- { cV = 1, cO = (+) 1, cS = "" }

--> Number 2

--- { cV = 2, cO = (+) 1, cS = "2"

--> Eval

-- { cV = 3, cO = i, cS = "" }
