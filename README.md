# Table

ascii tables for cli

## Installation

First, add `table` to your dependencies in `mix.exs`:

    def deps do
        [{:table, "~> 0.0.1"}]
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
