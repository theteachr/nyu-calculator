module Main exposing (..)

import Browser
import Html exposing (Html, button, div, input, label, text)
import Html.Attributes exposing (checked, class, for, id, name, type_)
import Html.Events exposing (onClick)



-- FIXME: Issue with triggering `Perform` immediately after another `Perform`
-- TODO: Implement `.`
-- TODO: Implement unary operator (-)
-- TODO: Keep the operator button pressed in until a number is pressed
-- TODO: When `=` is pressed, apply the last operation to the value displayed


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { currentValue : Float
    , currentValueString : String
    , currentOp : Float -> Float
    , selectedOp : Maybe Op
    }


type Op
    = Add
    | Sub
    | Mul
    | Div


toFn : Op -> Float -> Float -> Float
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
    { currentValue = 0.0
    , currentValueString = ""
    , currentOp = identity
    , selectedOp = Nothing
    }


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
                    if String.isEmpty model.currentValueString then
                        model.currentValue

                    else
                        model.currentOp model.currentValue
            in
            { model
                | currentValue = updatedValue
                , selectedOp = Just op
                , currentOp = updatedValue |> toFn op
                , currentValueString = ""
            }

        Eval ->
            let
                result =
                    model.currentOp model.currentValue
            in
            { init | currentValue = result }

        Reset ->
            init


operatorId : Op -> String
operatorId op =
    case op of
        Add ->
            "add"

        Sub ->
            "sub"

        Mul ->
            "mul"

        Div ->
            "div"


operatorText : Op -> String
operatorText op =
    case op of
        Add ->
            "+"

        Sub ->
            "-"

        Mul ->
            "×"

        Div ->
            "÷"


viewOperatorButton : Maybe Op -> Op -> Html Msg
viewOperatorButton selectedOp op =
    div []
        [ input
            [ id (operatorId op)
            , class "operator-radio"
            , type_ "radio"
            , name "operator"
            , onClick (Perform op)
            , checked (selectedOp |> Maybe.map ((==) op) |> Maybe.withDefault False)
            ]
            []
        , label
            [ for (operatorId op)
            , class "operator calc-button"
            ]
            [ text (operatorText op) ]
        ]


view : Model -> Html Msg
view model =
    div [ class "base" ]
        [ div [ class "display" ] [ text (String.fromFloat model.currentValue) ]
        , div [ class "buttons" ]
            [ viewOperatorButton model.selectedOp Add
            , viewOperatorButton model.selectedOp Sub
            , viewOperatorButton model.selectedOp Mul
            , viewOperatorButton model.selectedOp Div
            , button [ class "calc-button equals", onClick Eval ] [ text "=" ]
            , button [ class "calc-button", onClick (Number 7) ] [ text "7" ]
            , button [ class "calc-button", onClick (Number 8) ] [ text "8" ]
            , button [ class "calc-button", onClick (Number 9) ] [ text "9" ]
            , button [ class "calc-button", onClick (Number 4) ] [ text "4" ]
            , button [ class "calc-button", onClick (Number 5) ] [ text "5" ]
            , button [ class "calc-button", onClick (Number 6) ] [ text "6" ]
            , button [ class "calc-button", onClick (Number 1) ] [ text "1" ]
            , button [ class "calc-button", onClick (Number 2) ] [ text "2" ]
            , button [ class "calc-button", onClick (Number 3) ] [ text "3" ]
            , button [ class "calc-button", onClick (Number 0) ] [ text "0" ]
            , button [ class "calc-button" ] [ text "." ]
            , button [ class "calc-button", onClick Reset ] [ text "C" ]
            ]
        ]



{-

   { cV = 0, cO = i, cS = "" }
   : Number 1

   { cV = 1, cO = i, cS = "1" }
   : Perform Add

   { cV = 1, cO = (+) 1, cS = "" }
   : Number 2

   { cV = 2, cO = (+) 1, cS = "2" }
   : Eval

   { cV = 3, cO = i, cS = "" }

-}
