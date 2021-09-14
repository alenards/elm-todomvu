module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


{-| Todo MVU

Model
View
Update

-}
main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


{-| indicate the Model could not have data

second value is the current value of input

-}
type Model
    = Initial
    | Model String Details


type alias Details =
    { entries : List Todo }


type alias Todo =
    { description : String
    , completed : Bool
    }



-- Apologies Noah Z Gordon


type Msg
    = NoOp
    | ValueUpdated String


init =
    Initial


makeTodo : String -> Todo
makeTodo description =
    { description = description
    , completed = False
    }


getDetails : Model -> Details
getDetails model =
    case model of
        Initial ->
            { entries = [] }

        Model _ details ->
            details


getCurrentInput : Model -> String
getCurrentInput model =
    case model of
        Initial ->
            ""

        Model current _ ->
            current



-- VIEW


view : Model -> Html Msg
view model =
    let
        currValue =
            getCurrentInput model
    in
    div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "justify-content" "center"
        , style "align-items" "center"
        , style "height" "100vh"
        ]
        [ h1 [] [ text "Extreme Lofi Todo" ]
        , input
            [ onInput ValueUpdated
            , value currValue
            ]
            []
        ]



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        ValueUpdated currValue ->
            -- what to do?
            --               Details vvvvvv
            Model currValue { entries = [] }
