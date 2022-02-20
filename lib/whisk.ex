defmodule Whisk do
  @moduledoc """
  The scrambler.
  """

  @typedoc """
  A string representation of a puzzle type.

  See `puzzle_types/0` for supported values.
  """
  @type puzzle_type :: atom()

  @typedoc """
  A scramble is string representing a sequence of moves, separated by spaces.

  Moves are also strings. Different puzzle types have different valid moves.
  """
  @type scramble :: String.t()

  # A moveset is a 3-tuple containing the following:
  # - a list of groups of turns on the same axis (e. g. R and L for cubes)
  # - a list of turn modifiers (e. g. for cubes, ', 2, and nothing)
  # - the default move count in a scramble

  # A puzzle spec is one of:
  # - a moveset
  # - {moveset, moveset, integer}
  # Interpretation:
  # A scramble for a puzzle spec of the second shape takes the form
  # (<moves of one pattern...> <moves of another pattern>) * <integer repetitions>

  @puzzle_spec_2x2 {[~w(R), ~w(F), ~w(U)], ["", "'", "2"], 10}
  @puzzle_spec_3x3 {[~w(R L), ~w(F B), ~w(U D)], ["", "'", "2"], 20}
  @puzzle_spec_4x4 {[~w(R L Rw), ~w(F B Fw), ~w(U D Uw)], ["", "'", "2"], 40}
  @puzzle_spec_5x5 {[~w(R L Rw Lw), ~w(F B Fw Bw), ~w(U D Uw Dw)], ["", "'", "2"], 60}
  @puzzle_spec_6x6 {[~w(R L Rw Lw 3Rw), ~w(F B Fw Bw 3Fw), ~w(U D Uw Dw 3Uw)], ["", "'", "2"], 80}
  @puzzle_spec_7x7 {[~w(R L Rw Lw 3Rw 3Lw), ~w(F B Fw Bw 3Fw 3Bw), ~w(U D Uw Dw 3Uw 3Dw)],
                    ["", "'", "2"], 100}

  @puzzle_spec_skewb {[~w(R), ~w(L), ~w(U), ~w(B)], ["", "'"], 11}

  @puzzle_spec_pyraminx {
    {[~w(U), ~w(L), ~w(R), ~w(B)], ["", "'"], 11},
    {[~w(u), ~w(l), ~w(r), ~w(b)], ["", "'"], 0..1},
    1
  }

  @puzzle_spec_megaminx {
    {[~w(R), ~w(D)], ["++", "--"], 10},
    {[~w(U)], ["", "'"], 1},
    7
  }

  ## API

  @doc """
  Returns a list of supported puzzle types.

  ```
  iex> Whisk.puzzle_types()
  [:"2x2", :"3x3", :"4x4", :"5x5", :"6x6", :"7x7", :Skewb, :Pyraminx, :Megaminx]
  ```
  """
  @spec puzzle_types() :: [atom()]
  def puzzle_types do
    [:"2x2", :"3x3", :"4x4", :"5x5", :"6x6", :"7x7", :Skewb, :Pyraminx, :Megaminx]
  end

  @doc """
  Generate a scramble for a puzzle type. Also accepts the puzzle type as a string.

  Passing an unsupported puzzle type will generate an error.

  ## Options
    - `:length` - the number of moves in the scramble
    - `:reps` - for puzzles with repeating patterns, like Megaminx, specify the
      number of repetitions

  ## Examples

  ```
  iex> Whisk.scramble(:"3x3")
  "L F2 U R D B U2 R F' R F R2 D2 B R' B' D R B U"

  iex> Whisk.scramble(:"Skewb", length: 12)
  "L R B' R U' R' B L' U' B' L R U' R' L'"

  iex> Whisk.scramble(:Megaminx, length: 5, reps: 3)
  "D-- R-- D++ R-- D++ U' D++ R-- D++ R-- D++ U R-- D-- R-- D-- R++ U"
  ```

  """
  @spec scramble(puzzle_type() | String.t(), list()) :: scramble()
  def scramble(puzzle_name, opts \\ [])

  def scramble(puzzle_name, opts) when is_binary(puzzle_name) do
    puzzle_type_atom =
      try do
        String.to_existing_atom(puzzle_name)
      rescue
        ArgumentError -> raise "Unsupported puzzle type: #{inspect(puzzle_name)}"
      end
    scramble(puzzle_type_atom, opts)
  end

  def scramble(puzzle_name, opts) when is_atom(puzzle_name) do
    scramble_from_spec(puzzle_spec(puzzle_name), opts)
  end

  defp scramble_from_spec(spec, opts)

  defp scramble_from_spec({
    {axes1, modifiers1, default_length},
    {axes2, modifiers2, length2},
    default_reps
  }, opts) do
    validate_opts(opts)
    length1 = opts[:length] || default_length
    reps = opts[:reps] || default_reps

    Enum.join(for _ <- 1..reps do
      part1 = generate_scramble(axes1, modifiers1, length1)
      part2 = generate_addon_scramble(axes2, modifiers2, length2)

      String.trim(part1 <> " " <> part2)
    end, " ")
  end

  defp scramble_from_spec({axes, modifiers, default_length}, opts) do
    validate_opts(opts)
    length = opts[:length] || default_length

    generate_scramble(axes, modifiers, length)
  end

  defp validate_opts(opts) do
    cond do
      opts[:length] && opts[:length] < 0 -> raise "Invalid length: #{inspect(opts[:length])}"
      opts[:reps] && opts[:reps] < 0 -> raise "Invalid reps: #{inspect(opts[:reps])}"
      true -> nil
    end
  end

  ## Helpers

  defp puzzle_spec(puzzle_name) do
    case puzzle_name do
      :"2x2" -> @puzzle_spec_2x2
      :"3x3" -> @puzzle_spec_3x3
      :"4x4" -> @puzzle_spec_4x4
      :"5x5" -> @puzzle_spec_5x5
      :"6x6" -> @puzzle_spec_6x6
      :"7x7" -> @puzzle_spec_7x7
      :Skewb -> @puzzle_spec_skewb
      :Pyraminx -> @puzzle_spec_pyraminx
      :Megaminx -> @puzzle_spec_megaminx
      _ -> raise "Unsupported puzzle type: #{inspect(puzzle_name)}"
    end
  end

  defp generate_scramble(axes, modifiers, length) when is_number(length) do
    axis_idx = initial_axis_index(axes)
    Enum.join(generate_moves(axes, modifiers, axis_idx, [], length), " ")
  end

  defp generate_moves(axes, modifiers, last_axis_index, acc, remaining) do
    if remaining <= 0 do
      acc
    else
      axis_idx = different_axis_index(axes, last_axis_index)

      generate_moves(
        axes,
        modifiers,
        axis_idx,
        [generate_move(axes, modifiers, axis_idx) | acc],
        remaining - 1
      )
    end
  end

  defp generate_move(axes, modifiers, axis_idx) do
    Enum.random(Enum.at(axes, axis_idx)) <> Enum.random(modifiers)
  end

  defp generate_addon_scramble(axes, modifiers, %Range{} = range) do
    axes
    |> Enum.map(fn axis ->
      reps = Enum.random(range)

      1..reps//1
      |> Enum.map(fn _ -> Enum.random(axis) <> Enum.random(modifiers) end)
      |> Enum.join(" ")
    end)
    |> Enum.filter(fn move -> move != "" end)
    |> Enum.join(" ")
  end

  defp generate_addon_scramble(axes, modifiers, length) when is_number(length) do
    Enum.join(for axis <- axes do
      Enum.join(for _ <- 1..length//1 do
        Enum.random(axis) <> Enum.random(modifiers)
      end, " ")
    end, " ")
  end

  defp initial_axis_index(axes) when length(axes) == 1 do
    0
  end

  defp initial_axis_index(axes) do
    :rand.uniform(Enum.count(axes)) - 1
  end

  defp different_axis_index(axes, _index) when length(axes) == 1 do
    0
  end

  defp different_axis_index(axes, index) do
    axis_count = Enum.count(axes)
    rem(index + :rand.uniform(axis_count - 1), axis_count)
  end
end
