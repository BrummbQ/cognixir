defmodule Cognixir do
    def api_header(api_key) do
        ["Ocp-Apim-Subscription-Key": api_key, "Content-Type": "application/json", "Accept": "application/json"]
    end
end
