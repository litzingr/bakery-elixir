defmodule Server do

  def serving(server_number) do
    receive do
      {:serve, customer, order} ->
        fibo = fib(order)
        IO.puts("Server #{server_number} served customer #{customer} the fib of #{order} which is #{fibo}")

    end
  end

  defp fib(0), do: 0
  defp fib(1), do: 1
  defp fib(n), do: fib(n-2) + fib(n-1)

end
