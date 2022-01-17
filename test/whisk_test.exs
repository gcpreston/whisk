defmodule WhiskTest do
  use ExUnit.Case
  doctest Whisk, only: [puzzle_types: 0]

  test "puzzle_types/0" do
    assert Whisk.puzzle_types() == ["2x2", "3x3", "4x4", "5x5"]
  end

  describe "2x2" do
    @valid_moves ~w(R R' R2 F F' F2 U U' U2)

    test "defaults to length 10" do
      scramble = Whisk.scramble("2x2")
      assert Enum.count(String.split(scramble)) == 10
    end

    test "length can be customized" do
      scramble = Whisk.scramble("2x2", length: 15)
      assert Enum.count(String.split(scramble)) == 15
    end

    test "negative length gives empty scramble" do
      assert String.length(Whisk.scramble("2x2", length: -1)) == 0
    end

    test "contains only valid moves" do
      scramble = Whisk.scramble("2x2")
      assert Enum.all?(String.split(scramble), fn move -> move in @valid_moves end)
    end

    test "does not contain subsequent moves on the same axis" do
      move_groups = [~w(R R' R2), ~w(F F' F2), ~w(U U' U2)]

      move_group_index = fn move ->
        Enum.find_index(move_groups, fn group -> move in group end)
      end

      scramble = Whisk.scramble("2x2")

      for [move1, move2] <- Enum.chunk_every(String.split(scramble), 2, 1, :discard) do
        refute move_group_index.(move1) == move_group_index.(move2)
      end
    end
  end

  describe "3x3" do
    @valid_moves ~w(R R' R2 L L' L2 F F' F2 B B' B2 U U' U2 D D' D2)

    test "defaults to length 20" do
      scramble = Whisk.scramble("3x3")
      assert Enum.count(String.split(scramble)) == 20
    end

    test "length can be customized" do
      scramble = Whisk.scramble("3x3", length: 25)
      assert Enum.count(String.split(scramble)) == 25
    end

    test "negative length gives empty scramble" do
      assert String.length(Whisk.scramble("3x3", length: -1)) == 0
    end

    test "contains only valid moves" do
      scramble = Whisk.scramble("3x3")
      assert Enum.all?(String.split(scramble), fn move -> move in @valid_moves end)
    end

    test "does not contain subsequent moves on the same axis" do
      move_groups = [~w(R R' R2 L L' L2), ~w(F F' F2 B B' B2), ~w(U U' U2 D D' D2)]

      move_group_index = fn move ->
        Enum.find_index(move_groups, fn group -> move in group end)
      end

      scramble = Whisk.scramble("3x3")

      for [move1, move2] <- Enum.chunk_every(String.split(scramble), 2, 1, :discard) do
        refute move_group_index.(move1) == move_group_index.(move2)
      end
    end
  end

  describe "4x4" do
    @valid_moves ~w(R R' R2 Rw Rw' Rw2 L L' L2 F F' F2 Fw Fw' Fw2 B B' B2 U U' U2 Uw Uw' Uw2 D D' D2)

    test "defaults to length 45" do
      scramble = Whisk.scramble("4x4")
      assert Enum.count(String.split(scramble)) == 45
    end

    test "length can be customized" do
      scramble = Whisk.scramble("4x4", length: 30)
      assert Enum.count(String.split(scramble)) == 30
    end

    test "negative length gives empty scramble" do
      assert String.length(Whisk.scramble("4x4", length: -1)) == 0
    end

    test "contains only valid moves" do
      scramble = Whisk.scramble("4x4")
      assert Enum.all?(String.split(scramble), fn move -> move in @valid_moves end)
    end

    test "does not contain subsequent moves on the same axis" do
      move_groups = [
        ~w(R R' R2 Rw Rw' Rw2 L L' L2),
        ~w(F F' F2 Fw Fw' Fw2 B B' B2),
        ~w(U U' U2 Uw Uw' Uw2 D D' D2)
      ]

      move_group_index = fn move ->
        Enum.find_index(move_groups, fn group -> move in group end)
      end

      scramble = Whisk.scramble("4x4")

      for [move1, move2] <- Enum.chunk_every(String.split(scramble), 2, 1, :discard) do
        refute move_group_index.(move1) == move_group_index.(move2)
      end
    end
  end

  describe "5x5" do
    @valid_moves ~w(R R' R2 Rw Rw' Rw2 L L' L2 Lw Lw' Lw2 F F' F2 Fw Fw' Fw2 B B' B2 Bw Bw' Bw2 U U' U2 Uw Uw' Uw2 D D' D2 Dw Dw' Dw2)

    test "defaults to length 60" do
      scramble = Whisk.scramble("5x5")
      assert Enum.count(String.split(scramble)) == 60
    end

    test "length can be customized" do
      scramble = Whisk.scramble("5x5", length: 40)
      assert Enum.count(String.split(scramble)) == 40
    end

    test "negative length gives empty scramble" do
      assert String.length(Whisk.scramble("5x5", length: -1)) == 0
    end

    test "contains only valid moves" do
      scramble = Whisk.scramble("5x5")
      assert Enum.all?(String.split(scramble), fn move -> move in @valid_moves end)
    end

    test "does not contain subsequent moves on the same axis" do
      move_groups = [
        ~w(R R' R2 Rw Rw' Rw2 L L' L2 Lw Lw' Lw2),
        ~w(F F' F2 Fw Fw' Fw2 B B' B2 Bw Bw' Bw2),
        ~w(U U' U2 Uw Uw' Uw2 D D' D2 Dw Dw' Dw2)
      ]

      move_group_index = fn move ->
        Enum.find_index(move_groups, fn group -> move in group end)
      end

      scramble = Whisk.scramble("5x5")

      for [move1, move2] <- Enum.chunk_every(String.split(scramble), 2, 1, :discard) do
        refute move_group_index.(move1) == move_group_index.(move2)
      end
    end
  end
end
