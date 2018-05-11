# Table

[![hex][hex-image]][hex-url]

ascii tables for cli

## Installation

First, add `table` to your dependencies in `mix.exs`:

    def deps do
        [{:table, "~> 0.0.5"}]
    end

Then, update your dependencies:

    $ mix deps.get

## Usage

    iex> IO.write Table.table(%{"key"=> "value"})
    +-----+-------+
    | key | value |
    +-----+-------+

    iex> IO.write Table.table([%{"style"=> :ascii},
                               %{"style"=> :unicode}], :unicode)
    ┌──────────┐
    │ style    │
    ├──────────┤
    │ :ascii   │
    │ :unicode │
    └──────────┘

    iex> IO.write Table.table(%{"key"=> "multiline\nvalue"}, :unicode)
    ┌─────┬───────────┐
    │ key ╎ multiline │
    │     ╎ value     │
    └─────┴───────────┘

    iex> IO.write Table.table([["list", "is", "horizontal"]])
    +------|----|-----------+
    | list | is | horizontal|
    +------|----|-----------+

[hex-image]: https://img.shields.io/hexpm/v/table.svg?style=flat
[hex-url]: https://hex.pm/packages/table
