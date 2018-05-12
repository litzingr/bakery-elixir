defmodule Server do

  def hire_servers(manager, number_of_servers) do
    IO.puts("making servers")
    servers = (1..number_of_servers)
      |> Enum.map(fn (n) -> spawn(Server, :free, [self(), manager, n]) end)
    servers
  end

  def free(server_number, manager, n) do
    IO.inspect("server initiated #{n}")
    send(manager, {:server_available, self()})
    serve(server_number,manager,n)
  end

  def serve(server_number, manager, n) do
    receive do
      {:order, customer, order} ->
        fibo = fib(order)
        send(customer, {:receive, fibo})
        free(server_number, manager, n)
    end
  end

  defp fib(0), do: 0
  defp fib(1), do: 1
  defp fib(n), do: fib(n-2) + fib(n-1)

end
