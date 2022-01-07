defmodule Whisk do
  @moduledoc """
  A twisty puzzle scramble generator.

  ## Exmples

  ```
  iex> Whisk.scramble("3x3")
  "L F2 U R D B U2 R F' R F R2 D2 B R' B' D R B U"

  iex> Whisk.scramble("2x2", length: 12)
  "R2 F R' U2 F R U2 R2 F2 R F2 U2"
  ```

  """

  @typedoc """
  A string representation of a puzzle name.

  Currently supported values are:
  - `"2x2"`
  - `"3x3"`
  """
  @type puzzle_type :: String.t()

  @typedoc """
  A scramble is string representing a sequence of moves, separated by spaces.

  Moves are also strings. Different puzzle types have different valid moves.
  """
  @type scramble :: String.t()

  # A puzzle spec is a 3-tuple containing the following:
  # - a list of groups of turns on the same axis (e. g. R and L for cubes)
  # - a list of turn modifiers (e. g. for cubes, ', 2, and nothing)
  # - the default move count in a scramble

  @puzzle_spec_2x2 {[~w(R), ~w(F), ~w(U)], ["", "'", "2"], 10}
  @puzzle_spec_3x3 {[~w(R L), ~w(F B), ~w(U D)], ["", "'", "2"], 20}

  ## API

  @doc """
  Generate a scramble for a puzzle type.

  Passing an unsupported puzzle type will generate an error.

  ## Options
    - `:length` - the number of moves in the scramble
  """
  @spec scramble(puzzle_type(), list()) :: scramble()
  def scramble(puzzle_name, opts \\ []) do
    {axes, modifiers, default_length} = puzzle_spec(puzzle_name)
    length = opts[:length] || default_length

    generate_scramble(axes, modifiers, length)
  end

  ## Helpers

  defp puzzle_spec("2x2") do
    @puzzle_spec_2x2
  end

  defp puzzle_spec("3x3") do
    @puzzle_spec_3x3
  end

  defp puzzle_spec(_) do
    raise "Unsupported puzzle type"
  end

  defp generate_scramble(axes, modifiers, length) do
    axis_idx = :rand.uniform(Enum.count(axes)) - 1
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

  defp different_axis_index(axes, index) do
    axis_count = Enum.count(axes)
    rem(index + :rand.uniform(axis_count - 1), axis_count)
  end
end
