module Main exposing (alphanumericChar, alphanumericWord, alphanumericWords, isAlphanumeric, just, suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, custom, int, list, string)
import Random
import Shrink
import Slug exposing (Slug)
import Test exposing (..)


suite : Test
suite =
    describe "Slug"
        [ describe "slug properties"
            [ fuzz alphanumericWords "cannot be empty" <|
                Slug.generate
                    >> just (Slug.toString >> Expect.notEqual "")
            , fuzz alphanumericWords "contains only dashes and alphanumeric characters" <|
                Slug.generate
                    >> just
                        (Slug.toString
                            >> String.toList
                            >> List.all (\c -> isAlphanumeric c || c == '-')
                            >> Expect.true "Expected slug to be alphanumeric"
                        )
            , fuzz alphanumericWords "does not begin with a dash" <|
                Slug.generate
                    >> just
                        (Slug.toString
                            >> String.left 1
                            >> Expect.notEqual "-"
                        )
            , fuzz alphanumericWords "does not end with a dash" <|
                Slug.generate
                    >> just
                        (Slug.toString
                            >> String.right 1
                            >> Expect.notEqual "-"
                        )
            , fuzz alphanumericWords "does not contain empty words between dashes" <|
                Slug.generate
                    >> just
                        (Slug.toString
                            >> String.split "-"
                            >> List.any ((==) "")
                            >> Expect.false "Expected no empty words between dashes"
                        )
            , fuzz alphanumericWords "does not contain upper case characters" <|
                Slug.generate
                    >> just
                        (\slug ->
                            Expect.equal
                                (String.toLower (Slug.toString slug))
                                (Slug.toString slug)
                        )
            ]
        , describe "generate"
            [ fuzz alphanumericWords "slug generation is idempotent" <|
                \text ->
                    Expect.equal
                        (Slug.generate text)
                        (Slug.generate text
                            |> Maybe.map Slug.toString
                            |> Maybe.andThen Slug.generate
                        )
            ]
        ]


just : (a -> Expect.Expectation) -> Maybe a -> Expect.Expectation
just function aMaybe =
    case aMaybe of
        Just value ->
            function value

        Nothing ->
            Expect.notEqual Nothing aMaybe


alphanumericWords : Fuzzer String
alphanumericWords =
    custom
        (Random.int 1 10
            |> Random.andThen (\i -> Random.list i alphanumericWord)
            |> Random.map (String.join " ")
        )
        (Shrink.keepIf (String.any isAlphanumeric) Shrink.string)


alphanumericWord : Random.Generator String
alphanumericWord =
    Random.int 1 10
        |> Random.andThen (\i -> Random.list i alphanumericChar)
        |> Random.map String.fromList


alphanumericChar : Random.Generator Char
alphanumericChar =
    String.toList "0123456789abcdefghijklmnropqstuvwxyzABCDEFGHIJKLMNROPQSTUVWXYZ"
        |> Random.uniform 'a'


isAlphanumeric : Char -> Bool
isAlphanumeric c =
    (c >= '0') && (c <= '9') || (c >= 'a') && (c <= 'z')
