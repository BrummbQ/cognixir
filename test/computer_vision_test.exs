defmodule CognixirTest.ComputerVision do
    alias Cognixir.ComputerVision

    use ExUnit.Case
    doctest Cognixir

    defp image_url do
        "https://portalstoragewuprod.azureedge.net/vision/Analysis/1-1.jpg"
    end

    test "analyze image url with all options set" do
        result = ComputerVision.analyze_image(image_url,
            %ComputerVision.Options{language: "en", visualFeatures: "Faces,Color", details: "Celebrities"})

        assert elem(result, 0) === :ok
        assert result |> elem(1) |> Map.has_key?("metadata")
        assert result |> elem(1) |> Map.has_key?("requestId")
        assert result |> elem(1) |> Map.has_key?("categories")
        assert result |> elem(1) |> Map.has_key?("color")
        assert result |> elem(1) |> Map.has_key?("faces")
    end

    test "analyze image url with default options" do
        result = ComputerVision.analyze_image(image_url)

        assert elem(result, 0) === :ok
        assert result |> elem(1) |> Map.has_key?("metadata")
        assert result |> elem(1) |> Map.has_key?("requestId")
        assert result |> elem(1) |> Map.has_key?("categories")
    end
end
