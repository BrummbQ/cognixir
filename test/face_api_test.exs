defmodule CognixirTest.FaceApi do
    alias Cognixir.FaceApi

    use ExUnit.Case
    doctest Cognixir

    defp image_url do
        "https://portalstoragewuprod.azureedge.net/vision/Analysis/1-1.jpg"
    end

    test "detect face without options" do
        result = FaceApi.detect_face(image_url)

        assert elem(result, 0) === :ok
        face = result |> elem(1) |> Enum.at(0)
        assert face |> Map.has_key?("faceId")
        assert face |> Map.has_key?("faceRectangle")
    end

    test "detect face with options" do
        result = FaceApi.detect_face(image_url, %FaceApi.DetectOptions{returnFaceLandmarks: true, returnFaceAttributes: "age,gender"})

        assert elem(result, 0) === :ok
        face = result |> elem(1) |> Enum.at(0)
        assert face |> Map.has_key?("faceId")
        assert face |> Map.has_key?("faceRectangle")
        assert face |> Map.has_key?("faceLandmarks")
        assert face |> Map.has_key?("faceAttributes")
    end
end
