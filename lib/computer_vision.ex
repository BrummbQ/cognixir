defmodule Cognixir.ComputerVision.Options do
    defstruct visualFeatures: "", details: "", language: "en"
end

defmodule Cognixir.ComputerVision do
    @moduledoc """
    Provides functions for image analytics.
    """
    alias Cognixir.ComputerVision

    defp api_base do
        "https://api.projectoxford.ai/vision/v1.0/analyze"
    end

    defp api_key do
        Application.get_env(:Cognixir, :cv_api_key)
    end

    def analyze_image(image_url, options \\ %ComputerVision.Options{}) do
        encoded_body = Poison.encode!(%{"url" => image_url})

        case HTTPotion.post(api_base, [query: Map.from_struct(options), body: encoded_body, headers: Cognixir.api_header(api_key)]) do
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
