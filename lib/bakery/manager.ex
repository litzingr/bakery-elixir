defmodule Manager do
  def run(customer_number, server_number) do
    manager = spawn(__MODULE__, :run_bakery, [self(), []])
    customers = Customer.get_customers(manager, customer_number)
    servers = Server.hire_servers(manager,server_number)
    {self(),manager,customers, servers}
    run_bakery(manager, [])
  end

  def run_bakery(pid, available_servers) do
      receive do
        {:customer_waiting, from, n} ->
          server = List.first(available_servers)
          if server != nil do
            send(from, {:order, server})
            available_servers = List.delete_at(available_servers, 0)
          else
            send(from, {:wait, self()})
          end
        {:server_available, from} ->
          IO.puts("new server is available")
          available_servers = available_servers ++ [from]
        {:is_server_available} ->
          IO.puts("server available!!")
        {:pause, }
        {:finish} ->
          exit(:normal)
      end
      run_bakery(pid, available_servers)
  end
end
