# Cognixir

**Elixir API Wrapper for [Cognitive Services](https://www.microsoft.com/cognitive-services/en-us/apis) from Microsoft**

## Installation

The package can be installed as:

  1. Add `Cognixir` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:cognixir, "~> 0.4.0"}]
    end
    ```

  2. Ensure `Cognixir` is started before your application:

    ```elixir
    def application do
      [applications: [:cognixir]]
    end
    ```

## Configuration

You need a subscription key to access the different cognitive service api. Head over to https://www.microsoft.com/cognitive-services, create an account and fetch your api key. You can get started with a free subscription.

Add to your config.exs:

```elixir
# api key for text analytics
config :cognixir, ta_api_key: "<your key>"
# api key for computer vision
config :cognixir, cv_api_key: "<your key>"
# api key for face api
config :cognixir, fa_api_key: "<your key>"
```

## Implemented Features

### Text Analytics
 * detect language [x]
 * initiate topic analysis [x]
 * detect key phrases [x]
 * detect sentiment [x]

### Computer Vision
 * analyze image [x]
 * describe image [x]
 * get thumbnail []
 * list domain specific models []
 * OCR [x]
 * recognize domain specific content []
 * tag image [x]

### Face Api
 * face detection [x]
 * find similar []
 * group []
 * identify []
 * verify [x]

## Api Documentation

You can find the api documentation for published packages on [Hex Doc](https://hexdocs.pm/cognixir/api-reference.html)
