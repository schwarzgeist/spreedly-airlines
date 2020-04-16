defmodule BackendWeb.PurchaseController do
    use BackendWeb, :controller

    defp conn_with_status(conn, nil) do
        conn
        |> put_status(:not_found)
    end

    defp conn_with_status(conn, _) do
        conn
        |> put_status(:ok)
    end

    def purchase(%Plug.Conn{body_params: body_params} = conn, _body_and_query_params) do

        flights = %{
            "1234" => 123401,
            "70" => 432110,
            "555" => 89432,
        }

        flight_number = body_params["flight_number"]

        payment_method_token = body_params["payment_method_token"]

        gateway_token = System.get_env("TEST_GATEWAY_TOKEN")
        url = "https://core.spreedly.com/v1/gateways/#{gateway_token}/purchase.json"
        
        environment_key = System.get_env("ENVIRONMENT_KEY")
        environment_secret = System.get_env("ENVIRONMENT_SECRET")
        authentication = "#{environment_key}:#{environment_secret}"

        body = %{
            transaction: %{
                payment_method_token: payment_method_token,
                amount: flights[flight_number],
                currency_code: "USD"
            }
        }

        body = Poison.encode(body) |> elem(1)

        headers = ["Authorization": "Basic #{Base.encode64(authentication)}==", "Accept": "application/json; Charset=utf-8", "Content-Type": "application/json"]
        options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
        {:ok, response} = HTTPoison.post(url, body, headers, options)

        json conn, response.body
    end  
end