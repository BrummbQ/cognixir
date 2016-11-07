defmodule Cognixir do
    defp api_base_header(api_key) do
        ["Ocp-Apim-Subscription-Key": api_key, "Accept": "application/json"]
    end

    def api_json_header(api_key) do
        api_base_header(api_key) ++ ["Content-Type": "application/json"]
    end

    def api_binary_header(api_key) do
        api_base_header(api_key) ++ ["Content-Type": "application/octet-stream"]
    end

    def post(body, endpoint, key, query \\ []) do
        if (is_map(body)) do
            json_post(Poison.encode!(body), endpoint, key, query)
        else
            binary_post(body, endpoint, key, query)
        end
    end

    defp json_post(encoded_body, endpoint, key, query) do
        HTTPotion.post(endpoint, [query: query, body: encoded_body, headers: Cognixir.api_json_header(key)]) |> handle_result
    end

    defp binary_post(file, endpoint, key, query) do
        HTTPotion.post(endpoint, [query: query, body: file, headers: Cognixir.api_binary_header(key)]) |> handle_result
    end

    defp handle_result(http_result) do
        case http_result do
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
