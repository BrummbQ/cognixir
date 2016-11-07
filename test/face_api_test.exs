defmodule CognixirTest.FaceApi do
    alias Cognixir.FaceApi

    use ExUnit.Case
    doctest Cognixir

    defp image_url do
        "https://portalstoragewuprod.azureedge.net/vision/Analysis/1-1.jpg"
    end

    defp image_url_2 do
        "https://portalstoragewuprod2.azureedge.net/face/demov1/detection%201%20thumbnail.jpg"
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

    test "verify 2 faces" do
        face_id_1 = FaceApi.detect_face(image_url) |> elem(1) |> Enum.at(0) |> Map.get("faceId")
        face_id_2 = FaceApi.detect_face(image_url_2) |> elem(1) |> Enum.at(0) |> Map.get("faceId")

        result = FaceApi.verify_faces(face_id_1, face_id_2)
        assert elem(result, 0) === :ok
        assert elem(result, 1) |> Map.get("confidence") < 0.5
        assert elem(result, 1) |> Map.get("isIdentical") === false
    end
end
