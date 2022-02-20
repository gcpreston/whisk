defmodule WhiskTest do
  use ExUnit.Case
  doctest Whisk, only: [puzzle_types: 0]

  test "raises on unsupported puzzle type" do
    assert_raise RuntimeError, ~s(Unsupported puzzle type: :"3x4x5"), fn ->
      Whisk.scramble(:"3x4x5")
    end

    assert_raise RuntimeError, ~s(Unsupported puzzle type: "idk some string"), fn ->
      Whisk.scramble("idk some string")
    end
  end

  describe "2x2" do
    @puzzle_name :"2x2"
    @valid_moves ~w(R R' R2 F F' F2 U U' U2)

    test "accepts string" do
      Whisk.scramble("2x2")
    end

    test "defaults to length 10" do
      scramble = Whisk.scramble(@puzzle_name)
      assert Enum.count(String.split(scramble)) == 10
    end

    test "length can be customized" do
      scramble = Whisk.scramble(@puzzle_name, length: 15)
      assert Enum.count(String.split(scramble)) == 15
    end

    test "negative length raises" do
      assert_raise RuntimeError, fn ->
        Whisk.scramble(@puzzle_name, length: -1)
      end
    end

    test "contains only valid moves" do
      scramble = Whisk.scramble(@puzzle_name)
      assert Enum.all?(String.split(scramble), fn move -> move in @valid_moves end)
    end

    test "does not contain subsequent moves on the same axis" do
      move_groups = [~w(R R' R2), ~w(F F' F2), ~w(U U' U2)]

      move_group_index = fn move ->
        Enum.find_index(move_groups, fn group -> move in group end)
      end

      scramble = Whisk.scramble(@puzzle_name)

      for [move1, move2] <- Enum.chunk_every(String.split(scramble), 2, 1, :discard) do
        refute move_group_index.(move1) == move_group_index.(move2)
      end
    end
  end

  describe "3x3" do
    @puzzle_name :"3x3"
    @valid_moves ~w(R R' R2 L L' L2 F F' F2 B B' B2 U U' U2 D D' D2)

    test "accepts string" do
      Whisk.scramble("3x3")
    end

    test "defaults to length 20" do
      scramble = Whisk.scramble(@puzzle_name)
      assert Enum.count(String.split(scramble)) == 20
    end

    test "length can be customized" do
      scramble = Whisk.scramble(@puzzle_name, length: 25)
      assert Enum.count(String.split(scramble)) == 25
    end

    test "negative length raises" do
      assert_raise RuntimeError, fn ->
        Whisk.scramble(@puzzle_name, length: -1)
      end
    end

    test "contains only valid moves" do
      scramble = Whisk.scramble(@puzzle_name)
      assert Enum.all?(String.split(scramble), fn move -> move in @valid_moves end)
    end

    test "does not contain subsequent moves on the same axis" do
      move_groups = [~w(R R' R2 L L' L2), ~w(F F' F2 B B' B2), ~w(U U' U2 D D' D2)]

      move_group_index = fn move ->
        Enum.find_index(move_groups, fn group -> move in group end)
      end

      scramble = Whisk.scramble(@puzzle_name)

      for [move1, move2] <- Enum.chunk_every(String.split(scramble), 2, 1, :discard) do
        refute move_group_index.(move1) == move_group_index.(move2)
      end
    end
  end

  describe "4x4" do
    @puzzle_name :"4x4"
    @valid_moves ~w(R R' R2 Rw Rw' Rw2 L L' L2 F F' F2 Fw Fw' Fw2 B B' B2 U U' U2 Uw Uw' Uw2 D D' D2)

    test "accepts string" do
      Whisk.scramble("4x4")
    end

    test "defaults to length 40" do
      scramble = Whisk.scramble(@puzzle_name)
      assert Enum.count(String.split(scramble)) == 40
    end

    test "length can be customized" do
      scramble = Whisk.scramble(@puzzle_name, length: 30)
      assert Enum.count(String.split(scramble)) == 30
    end

    test "negative length raises" do
      assert_raise RuntimeError, fn ->
        Whisk.scramble(@puzzle_name, length: -1)
      end
    end

    test "contains only valid moves" do
      scramble = Whisk.scramble(@puzzle_name)
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

      scramble = Whisk.scramble(@puzzle_name)

      for [move1, move2] <- Enum.chunk_every(String.split(scramble), 2, 1, :discard) do
        refute move_group_index.(move1) == move_group_index.(move2)
      end
    end
  end

  describe "5x5" do
    @puzzle_name :"5x5"
    @valid_moves ~w"""
    R R' R2 Rw Rw' Rw2
    L L' L2 Lw Lw' Lw2
    F F' F2 Fw Fw' Fw2
    B B' B2 Bw Bw' Bw2
    U U' U2 Uw Uw' Uw2
    D D' D2 Dw Dw' Dw2
    """

    test "accepts string" do
      Whisk.scramble("5x5")
    end

    test "defaults to length 60" do
      scramble = Whisk.scramble(@puzzle_name)
      assert Enum.count(String.split(scramble)) == 60
    end

    test "length can be customized" do
      scramble = Whisk.scramble(@puzzle_name, length: 40)
      assert Enum.count(String.split(scramble)) == 40
    end

    test "negative length raises" do
      assert_raise RuntimeError, fn ->
        Whisk.scramble(@puzzle_name, length: -1)
      end
    end

    test "contains only valid moves" do
      scramble = Whisk.scramble(@puzzle_name)
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

      scramble = Whisk.scramble(@puzzle_name)

      for [move1, move2] <- Enum.chunk_every(String.split(scramble), 2, 1, :discard) do
        refute move_group_index.(move1) == move_group_index.(move2)
      end
    end
  end

  describe "6x6" do
    @puzzle_name :"6x6"
    @valid_moves ~w"""
    R R' R2 Rw Rw' Rw2 3Rw 3Rw' 3Rw2
    L L' L2 Lw Lw' Lw2
    F F' F2 Fw Fw' Fw2 3Fw 3Fw' 3Fw2
    B B' B2 Bw Bw' Bw2
    U U' U2 Uw Uw' Uw2 3Uw 3Uw' 3Uw2
    D D' D2 Dw Dw' Dw2
    """

    test "accepts string" do
      Whisk.scramble("6x6")
    end

    test "defaults to length 80" do
      scramble = Whisk.scramble(@puzzle_name)
      assert Enum.count(String.split(scramble)) == 80
    end

    test "length can be customized" do
      scramble = Whisk.scramble(@puzzle_name, length: 62)
      assert Enum.count(String.split(scramble)) == 62
    end

    test "negative length raises" do
      assert_raise RuntimeError, fn ->
        Whisk.scramble(@puzzle_name, length: -1)
      end
    end

    test "contains only valid moves" do
      scramble = Whisk.scramble(@puzzle_name)
      assert Enum.all?(String.split(scramble), fn move -> move in @valid_moves end)
    end

    test "does not contain subsequent moves on the same axis" do
      move_groups = [
        ~w(R R' R2 Rw Rw' Rw2 3Rw 3Rw' 3Rw2 L L' L2 Lw Lw' Lw2),
        ~w(F F' F2 Fw Fw' Fw2 3Fw 3Fw' 3Fw2 B B' B2 Bw Bw' Bw2),
        ~w(U U' U2 Uw Uw' Uw2 3Uw 3Uw' 3Uw2 D D' D2 Dw Dw' Dw2)
      ]

      move_group_index = fn move ->
        Enum.find_index(move_groups, fn group -> move in group end)
      end

      scramble = Whisk.scramble(@puzzle_name)

      for [move1, move2] <- Enum.chunk_every(String.split(scramble), 2, 1, :discard) do
        refute move_group_index.(move1) == move_group_index.(move2)
      end
    end
  end

  describe "7x7" do
    @puzzle_name :"7x7"
    @valid_moves ~w"""
    R R' R2 Rw Rw' Rw2 3Rw 3Rw' 3Rw2
    L L' L2 Lw Lw' Lw2 3Lw 3Lw' 3Lw2
    F F' F2 Fw Fw' Fw2 3Fw 3Fw' 3Fw2
    B B' B2 Bw Bw' Bw2 3Bw 3Bw' 3Bw2
    U U' U2 Uw Uw' Uw2 3Uw 3Uw' 3Uw2
    D D' D2 Dw Dw' Dw2 3Dw 3Dw' 3Dw2
    """

    test "accepts string" do
      Whisk.scramble("7x7")
    end

    test "defaults to length 100" do
      scramble = Whisk.scramble(@puzzle_name)
      assert Enum.count(String.split(scramble)) == 100
    end

    test "length can be customized" do
      scramble = Whisk.scramble(@puzzle_name, length: 121)
      assert Enum.count(String.split(scramble)) == 121
    end

    test "negative length raises" do
      assert_raise RuntimeError, fn ->
        Whisk.scramble(@puzzle_name, length: -1)
      end
    end

    test "contains only valid moves" do
      scramble = Whisk.scramble(@puzzle_name)
      assert Enum.all?(String.split(scramble), fn move -> move in @valid_moves end)
    end

    test "does not contain subsequent moves on the same axis" do
      move_groups = [
        ~w(R R' R2 Rw Rw' Rw2 3Rw 3Rw' 3Rw2 L L' L2 Lw Lw' Lw2 3Lw 3Lw' 3Lw2),
        ~w(F F' F2 Fw Fw' Fw2 3Fw 3Fw' 3Fw2 B B' B2 Bw Bw' Bw2 3Bw 3Bw' 3Bw2),
        ~w(U U' U2 Uw Uw' Uw2 3Uw 3Uw' 3Uw2 D D' D2 Dw Dw' Dw2 3Dw 3Dw' 3Dw2)
      ]

      move_group_index = fn move ->
        Enum.find_index(move_groups, fn group -> move in group end)
      end

      scramble = Whisk.scramble(@puzzle_name)

      for [move1, move2] <- Enum.chunk_every(String.split(scramble), 2, 1, :discard) do
        refute move_group_index.(move1) == move_group_index.(move2)
      end
    end
  end

  describe "Skewb" do
    @puzzle_name :Skewb
    @valid_moves ~w(R R' L L' U U' B B')
    @move_groups [~w(R R'), ~w(L L'), ~w(U U'), ~w(B B')]

    test "accepts string" do
      Whisk.scramble("Skewb")
    end

    test "defaults to length 11" do
      scramble = Whisk.scramble(@puzzle_name)
      assert Enum.count(String.split(scramble)) == 11
    end

    test "length can be customized" do
      scramble = Whisk.scramble(@puzzle_name, length: 14)
      assert Enum.count(String.split(scramble)) == 14
    end

    test "negative length raises" do
      assert_raise RuntimeError, fn ->
        Whisk.scramble(@puzzle_name, length: -1)
      end
    end

    test "contains only valid moves" do
      scramble = Whisk.scramble(@puzzle_name)
      assert Enum.all?(String.split(scramble), fn move -> move in @valid_moves end)
    end

    test "does not contain subsequent moves on the same axis" do
      move_group_index = fn move ->
        Enum.find_index(@move_groups, fn group -> move in group end)
      end

      scramble = Whisk.scramble(@puzzle_name)

      for [move1, move2] <- Enum.chunk_every(String.split(scramble), 2, 1, :discard) do
        refute move_group_index.(move1) == move_group_index.(move2)
      end
    end
  end

  describe "Pyraminx" do
    @puzzle_name :Pyraminx
    @move_groups [~w(R R'), ~w(L L'), ~w(U U'), ~w(B B')]
    @base_regex ~r/^((U|L|R|B)'? ?)+/
    @full_regex ~r/^((U|L|R|B)'? ){10}((U|L|R|B)'?)( u'?)?( l'?)?( r'?)?( b'?)?$/

    test "accepts string" do
      Whisk.scramble("Pyraminx")
    end

    test "base defaults to length 11" do
      scramble = Whisk.scramble(@puzzle_name)
      [base] = Regex.run(@base_regex, scramble, capture: :first)

      assert Enum.count(String.split(base)) == 11
    end

    test "base scramble length can be customized" do
      scramble = Whisk.scramble(@puzzle_name, length: 14)
      [base] = Regex.run(@base_regex, scramble, capture: :first)

      assert Enum.count(String.split(base)) == 14
    end

    test "negative length raises" do
      assert_raise RuntimeError, fn ->
        Whisk.scramble(@puzzle_name, length: -1)
      end
    end

    test "is of valid format" do
      for _ <- 1..10 do
        scramble = Whisk.scramble(@puzzle_name)
        assert Regex.match?(@full_regex, scramble)
      end
    end

    test "base does not contain subsequent moves on the same axis" do
      move_group_index = fn move ->
        Enum.find_index(@move_groups, fn group -> move in group end)
      end

      scramble = Whisk.scramble(@puzzle_name)
      [base] = Regex.run(@base_regex, scramble, capture: :first)

      for [move1, move2] <- Enum.chunk_every(String.split(base), 2, 1, :discard) do
        refute move_group_index.(move1) == move_group_index.(move2)
      end
    end
  end

  describe "Megaminx" do
    @puzzle_name :Megaminx
    @move_groups [~w(R++ R--), ~w(D++ D--)]
    @base_regex ~r/^((R|D)((\+\+)|(--)) ?)+/
    @full_regex ~r/^(((R|D)((\+\+)|(--)) ){10}U'? ?){7}$/

    test "accepts string" do
      Whisk.scramble("Megaminx")
    end

    test "base defaults to length 10" do
      scramble = Whisk.scramble(@puzzle_name)
      [base] = Regex.run(@base_regex, scramble, capture: :first)

      assert Enum.count(String.split(base)) == 10
    end

    test "base scramble length can be customized" do
      scramble = Whisk.scramble(@puzzle_name, length: 14)
      [base] = Regex.run(@base_regex, scramble, capture: :first)

      assert Enum.count(String.split(base)) == 14
    end

    test "reps can be customized" do
      scramble = Whisk.scramble(@puzzle_name, reps: 3)

      assert Regex.match?(~r/^(((R|D)((\+\+)|(--)) ){10}U'? ?){3}$/, scramble)
    end

    test "base length and reps can be customized simultaneously" do
      scramble = Whisk.scramble(@puzzle_name, length: 7, reps: 5)

      assert Regex.match?(~r/^(((R|D)((\+\+)|(--)) ){7}U'? ?){5}$/, scramble)
    end

    test "negative length raises" do
      assert_raise RuntimeError, fn ->
        Whisk.scramble(@puzzle_name, length: -1)
      end
    end

    test "is of valid format" do
      for _ <- 1..10 do
        scramble = Whisk.scramble(@puzzle_name)
        assert Regex.match?(@full_regex, scramble)
      end
    end

    test "base does not contain subsequent moves on the same axis" do
      move_group_index = fn move ->
        Enum.find_index(@move_groups, fn group -> move in group end)
      end

      scramble = Whisk.scramble(@puzzle_name)
      [base] = Regex.run(@base_regex, scramble, capture: :first)

      for [move1, move2] <- Enum.chunk_every(String.split(base), 2, 1, :discard) do
        refute move_group_index.(move1) == move_group_index.(move2)
      end
    end
  end
end
