# elm-slug [![Build Status](https://travis-ci.org/hecrj/elm-slug.svg?branch=master)](https://travis-ci.org/hecrj/elm-slug)

Type-safe slugs for Elm.

[Try it out!](https://hecrj.github.io/elm-slug)

```elm

-- Generating slugs
Slug.generate "Generate some slug from text!" == Just (Slug "generate-some-slug-from-text")
Slug.generate "@!áñ#@~¬{}" == Nothing

-- Parsing slugs
Slug.parse "some-valid-slug" == Just (Slug "some-valid-slug")
Slug.parse "-invalid-slug!" == Nothing
```
