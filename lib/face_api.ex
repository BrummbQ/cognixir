defmodule Cognixir.FaceApi.DetectOptions do
    @moduledoc """
    Options for function detect_face. See official api doc for supported options.

    ## Keys
    - returnFaceId: boolean, return detected face ids
    - returnFaceLandmarks: boolean, return face landmarks
    - returnFaceAttributes: comma separated strings, analyze specific face attributes in detail
    """
    defstruct returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: ""
end

defmodule Cognixir.FaceApi do
    @moduledoc """
    Provides functions for face detection, verification and grouping
    """
    alias Cognixir.FaceApi

    defp api_base do
        "https://api.projectoxford.ai/face/v1.0/"
    end

    defp api_key do
        Application.get_env(:cognixir, :fa_api_key)
    end

    @doc """
    Detects a face and returns various detail information like face position, landmarks and attributes.
    See official api doc for supported options.

    ## Parameters

    - image: A string containing valid image url or binary file content of an image
    - options: DetectOptions with additional parameters (optional)

    ## Examples

    iex> ComputerVision.analyze_image("http://example.com/images/test.jpg", %FaceApi.DetectOptions{returnFaceLandmarks: true, returnFaceAttributes: "age,gender"})

    { :ok, response_map }

    """
    def detect_face(image, options \\ %FaceApi.DetectOptions{}) do
        body = if String.valid?(image), do: %{"url" => image}, else: image

        Cognixir.post(body, api_base <> "detect", api_key, Map.from_struct(options))
    end

    @doc """
    Checks if two provided faces are identical. First, you need to run detect_face on each face to get a face id, then you can compare both faces

    ## Parameters

    - face_id_1: face id of first face
    - face_id_2: face id of second face

    ## Examples

    iex> ComputerVision.verify_faces("id_1", "id_2")

    { :ok, %{"isIdentical" => false, "confidence" => 0.0} }

    """
    def verify_faces(face_id_1, face_id_2) do
        body = %{"faceId1" => face_id_1, "faceId2" => face_id_2}

        Cognixir.post(body, api_base <> "verify", api_key)
    end
end
