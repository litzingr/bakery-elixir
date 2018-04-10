# bakery-elixir
Lambert's Bakery Algorithm in Elixir for class CSCI 4409 at UMN Morris


## Assignment outline:

For this problem set we're going to implement a version of Lesley Lambort's Bakery Algorithm in Elixir. The model Lamport based his algorithm on was that of a bakery where customers take a numbered ticket when they enter, and staff call out the next number when they're ready to serve a new customer. Here, however, I recommend modifying that model somewhat when doing it in Elixir. We could explicitly model the ticket machine, the “now serving” sign, and the free servers queue as separate, but I think it would be more "Elixir-y" if we bring all those things together and have a single process that manages all three together, accepting messages like:

   send(:manager, { :add_free_server, PID })
   send(:manager, { :add_customer, PID })

(I'm assuming here that this uses a registered process called :manager.) Each of these will join the new server/customer with a previously queued customer/server, or add the free server or customer to the list of servers/customers if there's not a companion to join the new person up with.

There will then be processes for each of the servers and customers. The servers should just immediately add themselves to the free servers list; the customers will all take a nap for a random period of time (using sleep) and then register themselves as customers. (Sleeping for a random period simulates people arriving at the shop at different times.) When the :manager has a customer and free server to pair up, it should send a message to (probably) the customer like:

  send(customer, { :pair_with_server, server }

The customer then sends a message to the server with a random value to compute the fib() of (just to generate some load so we can see the parallelism on the system monitor), and when the server is done it sends a message to the customer with the result and adds itself back to the free server list.

You should have some sort of output using `IO.puts()` that at least lets us know:
   * When a server begins helping a customer (including the customer PID and server PID and what number the server is computing the fib() of)
   * When a customer receives a value from a server

Be careful to do this in small pieces so you don't have a huge pile of code to work through when you're buried in the inevitable debugging morass.
