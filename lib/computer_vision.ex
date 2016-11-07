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

    defp encode_body(image) do
        if String.valid?(image), do: %{"url" => image}, else: image
    end

    @doc """
    Analyze an image specified by an image url. You can set AnalyzeOptions to configure the meta data extraction.
    Consulate the official api doc for allowed options.

    ## Parameters

    - image: A string containing valid image url or binary file content of an image
    - options: AnalyzeOptions with additional parameters (optional)

    ## Examples

    iex> ComputerVision.analyze_image("http://example.com/images/test.jpg", %ComputerVision.AnalyzeOptions{language: "en", visualFeatures: "Faces,Color", details: "Celebrities"})

    { :ok, response_map }

    """
    def analyze_image(image, options \\ %ComputerVision.AnalyzeOptions{}) do
        Cognixir.post(encode_body(image), api_base <> "analyze", api_key, Map.from_struct(options))
    end

    @doc """
    Describes an image in english sentences. You can set the maximum number of descriptions.

    ## Parameters

    - image: A string containing valid image url or binary file content of an image
    - max_candidates: An integer larger then 0

    ## Examples

    iex> ComputerVision.analyze_image("http://example.com/images/test.jpg", 3)

    { :ok, response_map }

    """
    def describe_image(image, max_candidates \\ 1) do
        Cognixir.post(encode_body(image), api_base <> "describe", api_key, %{maxCandidates: max_candidates})
    end

    @doc """
    Runs OCR on a specified image. You can set OCROptions to auto-detect the image orientation

    ## Parameters

    - image: A string containing valid image url or binary file content of an image
    - options: AnalyzeOptions with additional parameters (optional)

    ## Examples

    iex> ComputerVision.recognize_character("http://example.com/images/test.jpg", %ComputerVision.OCROptions{detectOrientation: true})

    { :ok, response_map }

    """
    def recognize_character(image, options \\ %ComputerVision.OCROptions{}) do
        Cognixir.post(encode_body(image), api_base <> "ocr", api_key, Map.from_struct(options))
    end

    @doc """
    Get tags for an specified image.

    ## Parameters

    - image: A string containing valid image url or binary file content of an image

    ## Examples

    iex> ComputerVision.tag_image("http://example.com/images/test.jpg")

    { :ok, response_map }

    """
    def tag_image(image) do
        Cognixir.post(encode_body(image), api_base <> "tag", api_key)
    end
end
