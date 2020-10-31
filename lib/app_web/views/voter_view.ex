defmodule AppWeb.VoterView do
  use AppWeb, :view

  alias Elixlsx.{Workbook, Sheet}

  @header [
    "Name"
  ]

  def render(AppWeb.VoterView, "eleitores.xlsx", %{voters: voters}) do
    report_generator(voters)
    |> Elixlsx.write_to_memory("eleitores.xlsx")
    |> elem(1)
    |> elem(1)
  end

  def report_generator(voters) do
    rows = voters |> Enum.map(&row(&1))
    %Workbook{sheets: [%Sheet{name: "Voters", rows: [@header] ++ rows}]}
  end

  def row(voters) do
    [
      voters.name
    ]
  end
end
