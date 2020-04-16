defmodule BackendWeb.DeliverController do
    use BackendWeb, :controller

    defp conn_with_status(conn, nil) do
        conn
        |> put_status(:not_found)
    end

    defp conn_with_status(conn, _) do
        conn
        |> put_status(:ok)
    end

    def deliver(%Plug.Conn{body_params: body_params} = conn, _body_and_query_params) do
        payment_method_token = body_params["payment_method_token"]

        receiver_token = System.get_env("RECEIVER_TOKEN")
        url = "https://core.spreedly.com/v1/receivers/#{receiver_token}/deliver.json"
        
        environment_key = System.get_env("ENVIRONMENT_KEY")
        environment_secret = System.get_env("ENVIRONMENT_SECRET")
        authentication = "#{environment_key}:#{environment_secret}"

        body = %{
            delivery: %{
                payment_method_token: payment_method_token,
                url: "https://spreedly-echo.herokuapp.com",
                headers: "Content-Type: application/json",
                body: Poison.encode!(%{
                        card_number: "{{ credit_card_number }}"
                })
            }
        }

        body = Poison.encode(body) |> elem(1)

        headers = ["Authorization": "Basic #{Base.encode64(authentication)}==", "Accept": "application/json; Charset=utf-8", "Content-Type": "application/json"]
        options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
        {:ok, response} = HTTPoison.post(url, body, headers, options)

        json conn, response.body
    end  
end