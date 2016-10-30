defmodule Cognixir.ComputerVision.AnalyzeOptions do
    @moduledoc """
    Options for function analyze_image. See official api doc for supported options.

    ## Keys
    - visualFeatures: list of strings, comma separated
    - details: list of strings, comma separated
    - language: which language to return
    """
    defstruct visualFeatures: "", details: "", language: "en"
end

defmodule Cognixir.ComputerVision.OCROptions do
    @moduledoc """
    Options for function recognize_character.

    ## Keys
    - detectOrientation: toggles orientation detection
    - language: language of the text, "unk" for auto detection
    """
    defstruct detectOrientation: false, language: "en"
end

defmodule Cognixir.ComputerVision do
    @moduledoc """
    Provides functions for image analytics. Including OCR, image descriptions, tagging and face detection
    """
    alias Cognixir.ComputerVision

    defp api_base do
        "https://api.projectoxford.ai/vision/v1.0/"
    end

    defp api_key do
        Application.get_env(:Cognixir, :cv_api_key)
    end

    defp encode_body(image_url) do
        Poison.encode!(%{"url" => image_url})
    end

    @doc """
    Analyze an image specified by an image url. You can set AnalyzeOptions to configure the meta data extraction.
    Consulate the official api doc for allowed options.

    ## Parameters

    - image_url: A string containing a valid image url
    - options: AnalyzeOptions with additional parameters (optional)

    ## Examples

    iex> ComputerVision.analyze_image("http://example.com/images/test.jpg", %ComputerVision.AnalyzeOptions{language: "en", visualFeatures: "Faces,Color", details: "Celebrities"})

    { :ok, response_map }

    """
    def analyze_image(image_url, options \\ %ComputerVision.AnalyzeOptions{}) do
        encoded_body = encode_body(image_url)

        case HTTPotion.post(api_base <> "analyze", [query: Map.from_struct(options), body: encoded_body, headers: Cognixir.api_header(api_key)]) do
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

    @doc """
    Describes an image in english sentences. You can set the maximum number of descriptions.

    ## Parameters

    - image_url: A string containing a valid image url
    - max_candidates: An integer larger then 0

    ## Examples

    iex> ComputerVision.analyze_image("http://example.com/images/test.jpg", 3)

    { :ok, response_map }

    """
    def describe_image(image_url, max_candidates \\ 1) do
        encoded_body = encode_body(image_url)

        case HTTPotion.post(api_base <> "describe", [query: %{maxCandidates: max_candidates}, body: encoded_body, headers: Cognixir.api_header(api_key)]) do
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

    @doc """
    Runs OCR on a specified image. You can set OCROptions to auto-detect the image orientation

    ## Parameters

    - image_url: A string containing a valid image url
    - options: AnalyzeOptions with additional parameters (optional)

    ## Examples

    iex> ComputerVision.recognize_character("http://example.com/images/test.jpg", %ComputerVision.OCROptions{detectOrientation: true})

    { :ok, response_map }

    """
    def recognize_character(image_url, options \\ %ComputerVision.OCROptions{}) do
        encoded_body = encode_body(image_url)

        case HTTPotion.post(api_base <> "ocr", [query: Map.from_struct(options), body: encoded_body, headers: Cognixir.api_header(api_key)]) do
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

    @doc """
    Tags an specified image.

    ## Parameters

    - image_url: A string containing a valid image url

    ## Examples

    iex> ComputerVision.tag_image("http://example.com/images/test.jpg")

    { :ok, response_map }

    """
    def tag_image(image_url) do
        encoded_body = encode_body(image_url)

        case HTTPotion.post(api_base <> "tag", [body: encoded_body, headers: Cognixir.api_header(api_key)]) do
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
