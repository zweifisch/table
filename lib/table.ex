defmodule Table do

  @styles %{plain: %{top:    ~w[+- -+- -+],
                     middle: ~w[+- -+- -+],
                     bottom: ~w[+- -+- -+],
                     dash: ?-,
                     header_walls: ["| ", " | ", " |"],
                     body_walls:   ["| ", " | ", " |"]},
            unicode: %{top:    ~w[┌─ ─┬─ ─┐],
                       middle: ~w[├─ ─┼─ ─┤],
                       bottom: ~w[└─ ─┴─ ─┘],
                       dash: ?─,
                       header_walls: ["│ ", " │ ", " │"],
                       body_walls:   ["│ ", " ╎ ", " │"]}}

  defp row(cells, walls, pad \\ ?\s) do
    [first, mid, last] = walls
    line = cells |> Enum.map(fn({content, width})-> String.ljust(content, width, pad) end)
                 |> Enum.join(mid)
    "#{first}#{line}#{last}"
  end

  defp compute_size(rows) do
    rows |> Enum.map(fn(row)-> Enum.map(row, &String.length/1) end)
         |> Enum.reduce(fn(row, acc)-> Enum.map(Enum.zip(row, acc), fn({a, b})-> max(a, b) end) end)
  end

  defp force_string(thing) do
    if is_bitstring(thing), do: thing, else: inspect(thing, pretty: true)
  end

  def handle_multi_line(rows) do
    rows |> Enum.flat_map(&handle_multi_line_row/1)
  end

  defp handle_multi_line_row(row) do
    splited = row |> Enum.map(&(String.split(&1, "\n")))
    max_lines = splited
        |> Enum.map(&Enum.count/1)
        |> Enum.max
    splited
        |> Enum.map(&fill_list(&1, max_lines, ""))
        |> List.zip
        |> Enum.map(&Tuple.to_list(&1))
  end

  defp fill_list(l, length, val) do
    len = length - Enum.count(l)
    cond do
      len > 0 -> Enum.concat(l, Enum.map(1..len, fn(_)-> val end))
      true -> l
    end
  end

  defp ensure_string(rows) do
    Enum.map(rows, fn(row)-> Enum.map(row, &force_string/1) end)
  end

  defp matrix(body, style) do
    body = body |> ensure_string |> handle_multi_line
    style = @styles[style]
    sizes = compute_size(body)
    empty = Enum.zip(Enum.map(sizes, fn(_)-> "" end), sizes)
    """
    #{row(empty, style[:top], style[:dash])}
    #{Enum.map_join(body, "\n", fn(x)-> row(Enum.zip(x, sizes), style[:body_walls]) end)}
    #{row(empty, style[:bottom], style[:dash])}
    """
  end

  defp matrix(header, body, style) do
    header = Enum.map(header, &force_string/1)
    body = body |> ensure_string |> handle_multi_line
    style = @styles[style]
    sizes = compute_size([header] ++ body)
    empty = Enum.zip(Enum.map(sizes, fn(_)-> "" end), sizes)
    """
    #{row(empty, style[:top], style[:dash])}
    #{row(Enum.zip(header, sizes), style[:header_walls])}
    #{row(empty, style[:middle], style[:dash])}
    #{Enum.map_join(body, "\n", fn(x)-> row(Enum.zip(x, sizes), style[:body_walls]) end)}
    #{row(empty, style[:bottom], style[:dash])}
    """
  end

  @doc """
  Supported types
  * map
  * list
  * list of map
  * list of list

  Examples

      iex> IO.write Table.table(%{"key"=> "value", "more"=> "more val"})
      +------+----------+
      | key  | value    |
      | more | more val |
      +------+----------+

      iex> IO.write Table.table(["list", "is", "vertical"])
      +----------+
      | list     |
      | is       |
      | vertical |
      +----------+

      iex> IO.write Table.table([%{"style"=> :ascii},
                                 %{"style"=> :unicode}], :unicode)
      ┌──────────┐
      │ style    │
      ├──────────┤
      │ :ascii   │
      │ :unicode │
      └──────────┘
  """
  def table(data, style \\ :plain) do
    cond do
      is_map(data) ->
        keys = Dict.keys(data)
        values = Enum.map keys, fn(x)-> Dict.get(data, x) end
        cond do
          Dict.size(data) == 0 -> ""
          Enum.all?(values, &is_list/1) -> matrix(keys, values, style)
          true -> matrix(Enum.map(Enum.zip(keys, values), &Tuple.to_list/1), style)
        end

      is_list(data) ->
        cond do
          Enum.count(data) == 0 -> ""
          Enum.all?(data, &is_list/1) -> matrix(data, style)
          Enum.all?(data, &is_map/1) ->
            header = Dict.keys List.first data
            data = Enum.map(data, fn(row)-> Enum.map(header, &(Dict.get(row, &1))) end)
            matrix(header, data, style)
          true -> data |> Enum.map(fn(x)-> [x] end) |> matrix(style)
        end
    end
  end
end
