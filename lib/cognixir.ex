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
end
