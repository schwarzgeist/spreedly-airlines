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

    # Checks to see whether or not a payment method is already retained(vaulted)
    def retained(payment_method_token) do
        url = "https://core.spreedly.com/v1/payment_methods/#{payment_method_token}.json"

        environment_key = System.get_env("ENVIRONMENT_KEY")
        environment_secret = System.get_env("ENVIRONMENT_SECRET")
        authentication = "#{environment_key}:#{environment_secret}"

        headers = ["Authorization": "Basic #{Base.encode64(authentication)}==", "Accept": "application/json; Charset=utf-8", "Content-Type": "application/json"]
        options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
        {:ok, response} = HTTPoison.get(url, headers, options)

        # Parse response
        response = JSON.decode(response.body) |> elem(1)

        # Return payment method's storage state
        response["payment_method"]["storage_state"]

    end

    def purchase(%Plug.Conn{body_params: body_params} = conn, _body_and_query_params) do

        flights = %{
            "1234" => 123401,
            "70" => 432110,
            "555" => 89432,
        }

        flight_number = body_params["flight_number"]
        payment_method_token = body_params["payment_method_token"]
        retain_on_success = body_params["retain_on_success"]

        gateway_token = System.get_env("TEST_GATEWAY_TOKEN")
        url = "https://core.spreedly.com/v1/gateways/#{gateway_token}/purchase.json"
        
        environment_key = System.get_env("ENVIRONMENT_KEY")
        environment_secret = System.get_env("ENVIRONMENT_SECRET")
        authentication = "#{environment_key}:#{environment_secret}"

        body = %{
            transaction: %{
                payment_method_token: payment_method_token,
                amount: flights[flight_number],
                currency_code: "USD",
                retain_on_success: retain_on_success
            }
        }

        body = Poison.encode(body) |> elem(1)

        headers = ["Authorization": "Basic #{Base.encode64(authentication)}==", "Accept": "application/json; Charset=utf-8", "Content-Type": "application/json"]
        options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
        {:ok, response} = HTTPoison.post(url, body, headers, options)

        # Check to see if token is already in storage
        parsed_response = JSON.decode(response.body) |> elem(1)
        token = parsed_response["transaction"]["payment_method"]["token"]
        
        retained_test = retained(token)
        retained_test = retained_test == "retained"

        new_response = %{
            success: parsed_response["transaction"]["succeeded"],
            message: parsed_response["transaction"]["response"]["message"],
            retained: retained_test
        }

        if !retained_test do
            new_response = Map.put(new_response, :token, parsed_response["transaction"]["payment_method"]["token"])
            new_response = Poison.encode(new_response) |> elem(1)
            json conn, new_response
        else
            new_response = Poison.encode(new_response) |> elem(1)
            json conn, new_response 
        end
    end  
end