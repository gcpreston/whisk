defmodule WhiskTest do
  use ExUnit.Case
  doctest Whisk

  test "greets the world" do
    assert Whisk.hello() == :world
  end
end
