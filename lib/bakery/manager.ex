defmodule Manager do
  def __init__(customer_number, server_number) do
    customers = (1..customer_number)
      |> Enum.map(fn (n) -> spawn(Customer, :waiting_in_line, [n, self()]) end)
    servers = (1..server_number)
      |> Enum.map(fn (n) -> spawn(Server, :available, [n, self()]) end)
    {customers, servers}
  end

  def run_bakery(waiting_customers, available_servers) do
    receive do
      {:customer_waiting, from} ->
        IO.puts("new customer is in queue")
      {:customer_arrived, from} ->
        waiting_customers = waiting_customers ++ from
      {:server_available, from} ->
        IO.puts("new server is available")
        available_servers = available_servers ++ from
      {:is_server_available} ->
        cond do
          List.first(available_servers) == nil ->
            send(self(), {:is_server_available})
            IO.put("server is not available")
          true ->
            IO.put("server is available")
            send(List.first(available_servers), {:serve, List.first(waiting_customers)})
        end
      {:finish} ->
        exit(:normal)
    end
  end
end
