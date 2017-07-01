module Demo exposing (..)

import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Slug exposing (Slug)


type alias Model =
    { text : Maybe String
    , slug : Maybe String
    }


type State
    = Empty
    | Dirty String


type Msg
    = TextChanged String
    | SlugChanged String


init : Model
init =
    { text = Nothing, slug = Nothing }


update : Msg -> Model -> Model
update msg model =
    case msg of
        TextChanged text ->
            { model | text = Just text }

        SlugChanged slug ->
            { model | slug = Just slug }


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


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }
