defmodule Randomize do
  def random(number) do
		:random.seed(:erlang.now())
		:random.uniform(number)
	end
end
