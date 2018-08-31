module Slug exposing
    ( Slug
    , generate, parse
    , toString
    )

{-| Type-safe slugs for Elm


# Definition

@docs Slug


# Constructors

@docs generate, parse


# Helpers

@docs toString

-}

import Regex exposing (Regex)


{-| Represents a slug
-}
type Slug
    = Slug String


{-| Generate a valid slug from a given text.

If a valid slug can be generated it returns just the slug, otherwise nothing is
returned.

    generate "Some text here" == Just (Slug "some-text-here")

    generate "--!@·==)/()" == Nothing

-}
generate : String -> Maybe Slug
generate text =
    let
        words =
            processWords text
    in
    if words == [ "" ] then
        Nothing

    else
        Just (Slug (String.join "-" words))


{-| Parse a slug from its string representation.

It returns the slug if the input is a valid slug, otherwise it returns nothing.

    parse "some-valid-slug" == Just (Slug "some-valid-slug")

    parse "Not a valid slug" == Nothing

    parse "another-invalid-slug-" == Nothing

-}
parse : String -> Maybe Slug
parse slug =
    case generate slug of
        Just s ->
            if slug == toString s then
                Just s

            else
                Nothing

        Nothing ->
            Nothing


{-| Returns the string representation of a slug.

    Maybe.map toString (generate "Some text") == Just "some-text"

-}
toString : Slug -> String
toString (Slug s) =
    s


processWords : String -> List String
processWords =
    let
        mapHelp c =
            if isAlphanumeric c then
                c

            else
                ' '
    in
    Regex.replace simpleQuoteRegex (\_ -> "")
        >> String.toLower
        >> String.map mapHelp
        >> String.words


isAlphanumeric : Char -> Bool
isAlphanumeric c =
    (c >= '0') && (c <= '9') || (c >= 'a') && (c <= 'z')


simpleQuoteRegex : Regex
simpleQuoteRegex =
    Regex.fromString "'"
        |> Maybe.withDefault Regex.never
