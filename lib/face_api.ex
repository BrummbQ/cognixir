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
        Application.get_env(:Cognixir, :fa_api_key)
    end

    defp encode_body(image_url) do
        Poison.encode!(%{"url" => image_url})
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
        handle_post(image, "detect", Map.from_struct(options))
    end

    defp handle_post(image, endpoint, query \\ []) do
        if (String.valid?(image)) do
            json_post(image, endpoint, query)
        else
            binary_post(image, endpoint, query)
        end
    end

    defp json_post(image_url, endpoint, query) do
        encoded_body = encode_body(image_url)

        case HTTPotion.post(api_base <> endpoint, [query: query, body: encoded_body, headers: Cognixir.api_json_header(api_key)]) do
            %HTTPotion.Response{status_code: 200, body: body} ->
                { :ok, Poison.decode!(body) }
            %HTTPotion.Response{body: body} ->
                { :error, body }
            %HTTPotion.ErrorResponse{message: message} ->
                { :error, message }
            _ ->
                { :error, "unknown error" }
        end
    end

    defp binary_post(image_file, endpoint, query) do
        case HTTPotion.post(api_base <> endpoint, [query: query, body: image_file, headers: Cognixir.api_binary_header(api_key)]) do
            %HTTPotion.Response{status_code: 200, body: body} ->
                { :ok, Poison.decode!(body) }
            %HTTPotion.Response{body: body} ->
                { :error, body }
            %HTTPotion.ErrorResponse{message: message} ->
                { :error, message }
            _ ->
                { :error, "unknown error" }
        end
    end
end
