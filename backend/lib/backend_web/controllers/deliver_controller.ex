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

    def create(%Plug.Conn{body_params: body_params} = conn, _body_and_query_params) do
        Logger.debug "Token: #{body_params[:token]}"

        json conn, nil
    end  
end