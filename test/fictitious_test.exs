defmodule FictitiousTest do
  use ExUnit.Case
  doctest Fictitious

  test "greets the world" do
    assert Fictitious.hello() == :world
  end
end
