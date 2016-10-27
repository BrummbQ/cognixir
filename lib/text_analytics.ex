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

    defp header do
        ["Ocp-Apim-Subscription-Key": api_key, "Content-Type": "application/json", "Accept": "application/json"]
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

        case HTTPotion.post(api_base <> "languages", [body: encoded_body, headers: header]) do
            %HTTPotion.Response{status_code: 200, body: body} ->
                { :ok, Poison.decode!(body)["documents"] |> hd |> Map.get("detectedLanguages") |> hd }
            %HTTPotion.Response{body: body} ->
                { :error, body }
            %HTTPotion.ErrorResponse{message: message} ->
                { :error, message }
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

        case HTTPotion.post(api_base <> "topics", [body: encoded_body, headers: header, timeout: 10000]) do
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
end
