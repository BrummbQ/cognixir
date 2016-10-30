defmodule Cognixir.TextAnalytics do
    @moduledoc """
    Provides functions for text analytics, including language and topic detection.
    """

    defp api_base do
        "https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/"
    end

    defp api_key do
        Application.get_env(:Cognixir, :ta_api_key)
    end

    @doc """
    Tries to detect the language for the given string

    ## Parameters

    - text: String that will be analyzed

    ## Examples

    iex> Cognixir.TextAnalytics.detect_language("my english text")

    { :ok, %{"iso6391Name" => "en", "name" => "English", "score" => 1.0} }
    """
    def detect_language(text) when is_binary(text) do
        encoded_body = Poison.encode!(%{"documents" => [%{"id" => 1, "text" => text}]})

        case HTTPotion.post(api_base <> "languages", [body: encoded_body, headers: Cognixir.api_header(api_key)]) do
            %HTTPotion.Response{status_code: 200, body: body} ->
                { :ok, Poison.decode!(body)["documents"] |> hd |> Map.get("detectedLanguages") |> hd }
            %HTTPotion.Response{body: body} ->
                { :error, body }
            %HTTPotion.ErrorResponse{message: message} ->
                { :error, message }
            _ ->
                { :error, "unknown error" }
        end
    end

    @doc """
    Tries to detect the topics for the given documents. You must provide at least 100 documents.
    This function returns an url where you can fetch your results with a get request after some delay.

    ## Parameters

    - documents: A string list containing your documents
    - stop_words: A list containing stop words

    ## Examples

    iex> Cognixir.TextAnalytics.detect_topics(["text1", "text2", "text3", ...], ["the"])

    { :ok, "https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/operations/token" }

    """
    def detect_topics(documents, stop_words \\ []) when is_list(documents) and is_list(stop_words) do
        indexed_documents = Enum.with_index(documents) |> Enum.map(fn(x) ->
            %{"id" => elem(x, 1), "text" => elem(x, 0)}
        end)
        encoded_body = Poison.encode!(%{"documents" => indexed_documents, "stopWords": stop_words, "topicsToExclude": []})

        case HTTPotion.post(api_base <> "topics", [body: encoded_body, headers: Cognixir.api_header(api_key), timeout: 10000]) do
            %HTTPotion.Response{status_code: 202, headers: header} ->
                { :ok, header["operation-location"] }
            %HTTPotion.Response{body: body} ->
                { :error, body }
            %HTTPotion.ErrorResponse{message: message} ->
                { :error, message }
            _ ->
                { :error, "unknown error" }
        end
    end

    @doc """
    Tries to extract the key phrases for given text. You need to submit the language of the text, too.

    ## Parameters

    - text: String that will be analyzed
    - language: language of the text (en, ja, de, es)

    ## Examples

    iex> Cognixir.TextAnalytics.detect_key_phrases("I'am looking for bananas. Do you have bananas?", "en")

    { :ok, ["I'am", "bananas"] }

    """
    def detect_key_phrases(text, language) do
        encoded_body = Poison.encode!(%{"documents" => [%{"id" => 1, "text" => text, "language" => language}]})

        case HTTPotion.post(api_base <> "keyPhrases", [body: encoded_body, headers: Cognixir.api_header(api_key)]) do
            %HTTPotion.Response{status_code: 200, body: body} ->
                { :ok, Poison.decode!(body)["documents"] |> hd |> Map.get("keyPhrases") }
            %HTTPotion.Response{body: body} ->
                { :error, body }
            %HTTPotion.ErrorResponse{message: message} ->
                { :error, message }
            _ ->
                { :error, "unknown error" }
        end
    end

    @doc """
    Tries to detect the sentiment for given text. Returns a score between 0 and 1. Scores close to 1 indicate positive sentiment, closer to 0 negative sentiment.
    You need to submit the language of the text, too.

    ## Parameters

    - text: String that will be analyzed
    - language: language of the text (en, ja, de, es)

    ## Examples

    iex> Cognixir.TextAnalytics.detect_sentiment("I'am a happy person", "en")

    { :ok, 0.9599599 }

    """
    def detect_sentiment(text, language) do
        encoded_body = Poison.encode!(%{"documents" => [%{"id" => 1, "text" => text, "language" => language}]})

        case HTTPotion.post(api_base <> "sentiment", [body: encoded_body, headers: Cognixir.api_header(api_key)]) do
            %HTTPotion.Response{status_code: 200, body: body} ->
                { :ok, Poison.decode!(body)["documents"] |> hd |> Map.get("score") }
            %HTTPotion.Response{body: body} ->
                { :error, body }
            %HTTPotion.ErrorResponse{message: message} ->
                { :error, message }
            _ ->
                { :error, "unknown error" }
        end
    end
end
