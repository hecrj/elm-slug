module Demo exposing (..)

import Browser
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Slug exposing (Slug)


type alias Model =
    { text : Maybe String
    , slug : Maybe String
    }


type Msg
    = TextChanged String
    | SlugChanged String


init : ( Model, Cmd Msg )
init =
    ( { text = Nothing, slug = Nothing }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TextChanged text ->
            ( { model | text = Just text }, Cmd.none )

        SlugChanged slug ->
            ( { model | slug = Just slug }, Cmd.none )


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.section []
            [ Html.h1 [] [ Html.text "Generate" ]
            , Html.input
                [ Events.onInput TextChanged
                , Attrs.value <| Maybe.withDefault "" model.text
                , Attrs.placeholder "Type something..."
                ]
                []
            , model.text
                |> Maybe.map (viewResult Slug.generate "No valid slug for the given input")
                |> Maybe.withDefault (Html.text "")
            ]
        , Html.section []
            [ Html.h1 [] [ Html.text "Parse" ]
            , Html.input
                [ Events.onInput SlugChanged
                , Attrs.value <| Maybe.withDefault "" model.slug
                , Attrs.placeholder "Type a slug..."
                ]
                []
            , model.slug
                |> Maybe.map (viewResult Slug.parse "Invalid slug")
                |> Maybe.withDefault (Html.text "")
            ]
        ]


viewResult : (String -> Maybe Slug) -> String -> String -> Html Msg
viewResult toSlug errMsg text =
    Html.p [] [ viewSlug (toSlug text) errMsg ]


viewSlug : Maybe Slug -> String -> Html Msg
viewSlug maybeSlug errMsg =
    case maybeSlug of
        Just slug ->
            Html.span []
                [ Html.span [ Attrs.class "valid" ] [ Html.text "Valid slug: " ]
                , Html.code [] [ Html.text <| Slug.toString slug ]
                ]

        Nothing ->
            Html.span [ Attrs.class "invalid" ] [ Html.text errMsg ]


main : Program () Model Msg
main =
    Browser.embed
        { init = always init
        , subscriptions = always Sub.none
        , update = update
        , view = view
        }
