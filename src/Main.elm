module Main exposing (main)
import Browser
import Html exposing (Html, button, div, text, input, Attribute, ul, li)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)
import Random
import Array

main =
  Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }
type alias Model = 
  { counter: Int
  , themes: List String
  , inputTheme: String
  , selectedItem: String
  }

init : () -> (Model, Cmd Msg)
init _ =
  ({counter = 0, themes=[], inputTheme = "", selectedItem = ""},Cmd.none)

type Msg = Increment | Decrement | ToMsg String | Show | Push | Spinx | NewFace Int

update msg model =
  case msg of
    Increment ->
      (Debug.log (String.fromInt model.counter) {model | counter = model.counter + 1},Cmd.none)

    Decrement ->
      ({model | counter = model.counter - 1},Cmd.none)

    ToMsg e ->
      ({model | inputTheme = e},Cmd.none)

    Show ->
      (Debug.log model.inputTheme model,Cmd.none)

    Push ->
      ({model | themes = model.inputTheme::model.themes, inputTheme = ""},Cmd.none)

    Spinx ->
      (
        -- {model | selectedItem = Array.get Random.generate NewFace (Random.int 0 List.length model.themes) Array.fromList model.themes },
        model,
        Random.generate NewFace (Random.int 0 ((List.length model.themes)-1))
      )

    NewFace newFace ->
      ( {model | selectedItem = ((Array.get newFace (Array.fromList model.themes)) |> Maybe.withDefault "配列外です")}
      , Cmd.none
      )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

view: Model -> Html Msg
view model =
  div []
    [ button [ onClick Show ] [ text "show" ]
    , button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model.counter) ]
    , button [ onClick Increment ] [ text "+" ]
    , input [ placeholder "Enter theme", value model.inputTheme, onInput ToMsg ] []
    , button [onClick Push ] [text "テーマを追加"]
    , ul [] (List.map viewLi model.themes)
    , button [onClick Spinx ] [text "ルーレットを回す"]
    , div [] [ text model.selectedItem ] 
    ]

viewLi: String -> Html msg
viewLi theme =
  li [] [ text theme ]
