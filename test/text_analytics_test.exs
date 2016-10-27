defmodule CognixirTest.TextAnalytics do
    use ExUnit.Case
    doctest Cognixir

    test "detect english" do
        { :ok, result } = Cognixir.TextAnalytics.detect_language("Hello, this is english text")
        assert result === %{"iso6391Name" => "en", "name" => "English", "score" => 1.0}
    end

    test "detect german" do
        { :ok, result } = Cognixir.TextAnalytics.detect_language("Hallo, das ist deutscher Text")
        assert result === %{"iso6391Name" => "de", "name" => "German", "score" => 1.0}
    end

    test "detect topics" do
        samples = ["I like cars", "How to make cookie", "See you in London!"]
        document_list = 1..100 |> Enum.map(fn(_x) ->
            Enum.random(samples)
        end)

        result = Cognixir.TextAnalytics.detect_topics(document_list)
        assert elem(result, 0) === :ok
    end

    test "detect key phrases" do
        text = "I'am looking for bananas. Do you have bananas?"
        language = "en"
        result = Cognixir.TextAnalytics.detect_key_phrases(text, language)
        assert result === {:ok, ["I'am", "bananas"]}
    end
end
