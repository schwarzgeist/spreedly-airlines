defmodule BackendWeb.TestkitController do
    use BackendWeb, :controller

    # Lists all gateways available provided with an environment
    def gateways(conn, _params) do
        url = "https://core.spreedly.com/v1/gateways.json"

        environment_key = System.get_env("ENVIRONMENT_KEY")
        environment_secret = System.get_env("ENVIRONMENT_SECRET")
        authentication = "#{environment_key}:#{environment_secret}"

        headers = ["Authorization": "Basic #{Base.encode64(authentication)}==", "Accept": "application/json; Charset=utf-8", "Content-Type": "application/json"]
        options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
        {:ok, response} = HTTPoison.get(url, headers, options)

        IO.puts "RESPONSE========================================"
        IO.inspect response

        json conn, response.body
    end

    # List all transactions for a particular gateway
    def transactions(conn, _params) do
        url = "https://core.spreedly.com/v1/gateways.json"

        environment_key = System.get_env("ENVIRONMENT_KEY")
        environment_secret = System.get_env("ENVIRONMENT_SECRET")
        authentication = "#{environment_key}:#{environment_secret}"

        headers = ["Authorization": "Basic #{Base.encode64(authentication)}==", "Accept": "application/json; Charset=utf-8", "Content-Type": "application/json"]
        options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
        {:ok, response} = HTTPoison.get(url, headers, options)

        IO.puts "RESPONSE========================================"
        IO.inspect response

        json conn, response.body
    end
end