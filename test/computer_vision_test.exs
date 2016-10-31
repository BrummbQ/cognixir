defmodule CognixirTest.ComputerVision do
    alias Cognixir.ComputerVision

    use ExUnit.Case
    doctest Cognixir

    defp image_url do
        "https://portalstoragewuprod.azureedge.net/vision/Analysis/1-1.jpg"
    end

    defp ocr_image_url do
        "https://portalstoragewuprod.azureedge.net/vision/OpticalCharacterRecognition/1-1.jpg"
    end

    defp test_meta(result) do
        assert result |> elem(1) |> Map.has_key?("metadata")
        assert result |> elem(1) |> Map.has_key?("requestId")
    end

    test "analyze image url with all options set" do
        result = ComputerVision.analyze_image(image_url,
            %ComputerVision.AnalyzeOptions{language: "en", visualFeatures: "Faces,Color", details: "Celebrities"})

        assert elem(result, 0) === :ok
        test_meta(result)
        assert result |> elem(1) |> Map.has_key?("categories")
        assert result |> elem(1) |> Map.has_key?("color")
        assert result |> elem(1) |> Map.has_key?("faces")
    end

    test "analyze image url with default options" do
        result = ComputerVision.analyze_image(image_url)

        assert elem(result, 0) === :ok
        test_meta(result)
        assert result |> elem(1) |> Map.has_key?("categories")
    end

    test "describe image with max 3 descriptions" do
        result = ComputerVision.describe_image(image_url, 3)

        assert elem(result, 0) === :ok
        test_meta(result)
        assert result |> elem(1) |> Map.has_key?("description")
        assert result |> elem(1) |> Map.get("description") |> Map.get("captions") |> Enum.count === 3
    end

    test "describe image with default options" do
        result = ComputerVision.describe_image(image_url)

        assert elem(result, 0) === :ok
        test_meta(result)
        assert result |> elem(1) |> Map.has_key?("description")
        assert result |> elem(1) |> Map.get("description") |> Map.get("captions") |> Enum.count === 1
    end

    test "recognize image text with default options" do
        result = ComputerVision.recognize_character(ocr_image_url)

        assert elem(result, 0) === :ok
        assert result |> elem(1) |> Map.get("language") === "en"
        assert result |> elem(1) |> Map.has_key?("regions")
    end

    test "recognize image text with options" do
        result = ComputerVision.recognize_character(ocr_image_url, %ComputerVision.OCROptions{detectOrientation: true})

        assert elem(result, 0) === :ok
        assert result |> elem(1) |> Map.get("language") === "en"
        assert result |> elem(1) |> Map.has_key?("regions")
        assert result |> elem(1) |> Map.get("orientation") === "Up"
    end

    test "tag image url" do
        result = ComputerVision.tag_image(image_url)

        assert elem(result, 0) === :ok
        test_meta(result)
        assert result |> elem(1) |> Map.has_key?("tags")
    end

    test "tag image raw upload" do
        file_content = File.read!("test/test.jpg")

        result = ComputerVision.tag_image(file_content)

        assert elem(result, 0) === :ok
        test_meta(result)
        assert result |> elem(1) |> Map.has_key?("tags")
    end
end
