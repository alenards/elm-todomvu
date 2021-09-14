module Main exposing (main)

import Browser
import EventHandlers exposing (onEnter)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Id exposing (Id, generate, unwrap)


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
    , id : Id
    }



-- Apologies Noah Z Gordon


type Msg
    = NoOp
    | ValueUpdated String
    | CreateTodo
    | MarkCompleted Int Bool


init =
    Initial


makeTodo : String -> Todo
makeTodo description =
    { description = description
    , completed = False
    , id = Id.generate description
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

        details =
            getDetails model
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
            , onEnter CreateTodo
            , value currValue
            ]
            []
        , ul [ style "list-style-type" "none" ]
            (details.entries |> List.map renderTodo)
        ]


renderTodo : Todo -> Html Msg
renderTodo todo =
    li []
        [ input
            [ type_ "checkbox"
            , onCheck (MarkCompleted (Id.unwrap todo.id))
            , checked todo.completed
            ]
            []
        , text todo.description
        ]



-- UPDATE


type alias UpdateFunc =
    String -> Details -> Model


handleUpdate : UpdateFunc -> Model -> Model
handleUpdate updateF model =
    case model of
        Initial ->
            Model "" { entries = [] }

        Model currValue details ->
            updateF currValue details


handleTodoUpdate : String -> Model -> Model
handleTodoUpdate newValue model =
    model
        |> handleUpdate
            (\_ details ->
                Model newValue details
            )


handleTodoCreate : Model -> Model
handleTodoCreate model =
    model
        |> handleUpdate
            (\currentValue details ->
                Model
                    ""
                    { details
                        | entries = makeTodo currentValue :: details.entries
                    }
            )


markCompletedIn : Details -> Int -> Bool -> Details
markCompletedIn details todoId checked =
    let
        updateTodo todo =
            if Id.equals todo.id todoId then
                { todo | completed = checked }

            else
                todo

        updatedEntries =
            List.map updateTodo details.entries
    in
    { details | entries = updatedEntries }


handleTodoCompletedFor : Int -> Bool -> Model -> Model
handleTodoCompletedFor todoId checked model =
    model
        |> handleUpdate
            (\currValue details ->
                Model
                    currValue
                    (markCompletedIn details todoId checked)
            )


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        ValueUpdated currValue ->
            handleTodoUpdate currValue model

        CreateTodo ->
            handleTodoCreate model

        MarkCompleted todoId checked ->
            handleTodoCompletedFor todoId checked model
