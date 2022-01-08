# Whisk

A simple twisty puzzle scramble library, written in Elixir.

**Please note:** Generated scrambles are not checked for WCA compliance. For any kind of WCA-compliant scrambles, use [TNoodle](https://www.worldcubeassociation.org/regulations/scrambles/).

## Usage

```elixir
iex> Whisk.scramble("3x3")
"L F2 U R D B U2 R F' R F R2 D2 B R' B' D R B U"
```

## Installation

```elixir
def deps do
  [
    {:whisk, "~> 0.0.1"}
  ]
end
```

[Documentation](https://hexdocs.pm/whisk)

## Acknowledgements
* Inspired by the [Scrambler gem](https://github.com/timhabermaas/scrambler), written by [@timhabermaas](https://github.com/timhabermaas)
* Thanks Lou Whiting for the name idea :)
