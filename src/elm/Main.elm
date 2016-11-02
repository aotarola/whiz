module Whiz exposing (..)

import Html.App as App
import Models exposing (initAppState, AppState)
import Views exposing (view)
import Messages exposing (Msg(..))
import Update exposing (update)
import Subscriptions exposing (subscriptions)


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( AppState, Cmd Msg )
init =
    initAppState ! []
