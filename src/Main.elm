module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type Model
    = Initial
    | Model String Details


type alias Details =
    { entries : List Todo }


type alias Todo =
    { description : String
    , completed : Bool
    }


type Msg
    = NoOp
    | UpdateTodo String


main : Program () Model Msg
main =
    -- When you work in Ellie, you'll be using a sandbox
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


init : Model
init =
    Initial


createTodo : String -> Todo
createTodo description =
    { description = description
    , completed = False
    }



-- VIEW


view : Model -> Html Msg
view _ =
    div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "justify-content" "center"
        , style "align-items" "center"
        , style "height" "100vh"
        ]
        [ h1 [] [ text "Extreme Lofi Todo" ]
        , input [ onInput UpdateTodo ] []
        ]



-- UPDATE


handleTodoUpdate : String -> Model -> Model
handleTodoUpdate newValue model =
    case model of
        Initial ->
            Model newValue { entries = [] }

        Model _ details ->
            Model newValue details


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        UpdateTodo newValue ->
            handleTodoUpdate newValue model
