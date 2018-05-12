defmodule Customer do
  def get_customers(manager, number_of_customers) do
    customers = (1..number_of_customers)
      |> Enum.map(fn (n) -> spawn(Customer, :startup, [self(), manager, n]) end)
    customers
  end

  def startup(customer_number, manager,n) do
      IO.inspect("Customer initiated #{n}")
      send(manager, {:customer_waiting, self()})
      ordering(customer_number, manager, n)
  end

  def ordering(customer_number, manager, n) do
    receive do
      {:order, pid} ->
        fib = Randomize.random(13)
        IO.puts("Customer #{n} is ordering #{fib}")
        send(pid, {:order, self(), fib})
      {:receive, answer} ->
        IO.puts("Customer #{n} got the answer #{answer}")
        sleep(customer_number, manager, n)
    end
    ordering(customer_number, manager, n)
  end

  def sleep(customer_number, manager, n) do
    IO.inspect("Customer initiated #{n}")

    :timer.sleep(Randomize.random(10))
    send(manager, {:customer_waiting, self()})
    ordering(customer_number, manager, n)
  end

end
