defmodule OverviewFormatter do
  @moduledoc """
  OverviewFormatter provides an overview of passing and failing tests. It prints a list of modules with a count of passed, failed, and skipped tests for each.

  ## Example Output
      ........................................FFF.F...................................................ss....s.............................sFFFFFFFF...................................................................... .......................................................................................................s.............................................................
      
      Summary:
      Failed Passed Skipped Name
           0      7       0 Catalog.Parsers.SDM.Promotion.Test
           0      2       0 ElixirBackOffice.Assortments.AssortmentSourcesTest
           0      6       0 ElixirBackOffice.AssortmentsTest
           0      9       0 ElixirBackOffice.DispatchTest
           0      1       0 ElixirBackOffice.Feeds.Loader.BroadwayTest
           0     23       0 ElixirBackOffice.Feeds.Loader.LoaderTest
           0     13       0 ElixirBackOffice.Feeds.Loader.TransformerTest
           0      2       0 ElixirBackOffice.Feeds.Parsers.Assortment.ForcedBanPubSubTest
           0      1       0 ElixirBackOffice.Feeds.Parsers.Assortment.PubSubIntegrationTest
           0      3       0 ElixirBackOffice.Feeds.Parsers.Assortment.PubSubTest
           0      1       0 ElixirBackOffice.Feeds.Parsers.ControlNutrition.PubSubTest
           0      1       0 ElixirBackOffice.Feeds.Parsers.DD.PubsubTest
           0      1       0 ElixirBackOffice.Feeds.Parsers.GCHub.PubsubTest
           0      9       1 ElixirBackOffice.Feeds.Parsers.GcHub.ParserTest
           0      1       0 ElixirBackOffice.Feeds.Parsers.JF.PubsubTest
           0      1       0 ElixirBackOffice.Feeds.Parsers.JFCOM.PubsubTest
           0      3       0 ElixirBackOffice.Feeds.Parsers.Media.ImageAnglesOG.PubSubTest
           0      2       0 ElixirBackOffice.Feeds.Parsers.Nutrition.ParserTest
           0      1       0 ElixirBackOffice.Feeds.Parsers.Nutrition.PubSubTest
           0     13       0 ElixirBackOffice.Feeds.Parsers.SDM.Offer.Parser.Test
           0      1       0 ElixirBackOffice.Feeds.Parsers.SDM.PubsubTest
           0      2       0 ElixirBackOffice.Feeds.Parsers.Support.UtilsDownloadTest
           0     46       0 ElixirBackOffice.Feeds.Parsers.Support.UtilsTest
           0      1       0 ElixirBackOffice.Feeds.Parsers.Vendor.PubSubTest
           0     12       0 ElixirBackOffice.Feeds.ParsersTest
           0      4       0 ElixirBackOffice.Feeds.Support.GCloudTest
           0     18       0 ElixirBackOffice.FeedsTest
           0      8       0 ElixirBackOffice.Media.ImageAnglesTest
           0      1       0 ElixirBackOffice.Nutritions.RoundingTest
           0      3       0 ElixirBackOffice.NutritionsTest
           8      0       1 ElixirBackOffice.OfferExportTest
           0     10       0 ElixirBackOffice.Offers.OfferUtilsTest
           0      8       0 ElixirBackOffice.Offers.VendorsTest
           0     20       1 ElixirBackOffice.OffersTest
           0      4       0 ElixirBackOffice.Parsers.DD.Offer.Parser.Test
           0      7       0 ElixirBackOffice.Parsers.DD.Price.Test
           0     10       0 ElixirBackOffice.Parsers.JF.Test
           0      9       0 ElixirBackOffice.Parsers.SDM.Price.Test
           0     26       0 ElixirBackOffice.PricesTest
           0      1       0 ElixirBackOffice.Products.EnrichmentsTest
           0      4       2 ElixirBackOffice.Products.UPCSTest
           0      1       0 ElixirBackOffice.Products.VariantTemplatesTest
           4     21       0 ElixirBackOffice.ProductsTest
           0     22       0 ElixirBackOffice.PromotionsTest
           0      8       0 Parsers.Types.Feed1446e.Test
           0      3       0 Parsers.Types.Feed1446f.Test
           0      4       0 Parsers.Types.Feed1446g.Test
           0      4       0 Parsers.Types.ProductAttribute.Test
           0      3       0 Parsers.Types.Was.Test
      =====================================================================================
          12    361       5 Total
  """
  use GenServer

  def init(_opts) do
    config = %{
      tests: %{}
    }

    {:ok, config}
  end

  def handle_cast({:suite_finished, _times_us}, config) do
    print_summary(config.tests)
    {:noreply, config}
  end

  def handle_cast({:test_finished, %ExUnit.Test{} = test}, config) do
    print_test(test)
    config = update(config, test)
    {:noreply, config}
  end

  def handle_cast(:max_failures_reached, config) do
    IO.write([
      "\n\n",
      IO.ANSI.red(),
      "--max-failures reached, aborting test suite",
      IO.ANSI.reset()
    ])

    {:noreply, config}
  end

  def handle_cast({:sigquit, _}, config) do
    IO.puts(["\n\n", IO.ANSI.red(), "Aborted", IO.ANSI.reset()])

    {:noreply, config}
  end

  def handle_cast(_, config) do
    {:noreply, config}
  end

  defp update(config, %ExUnit.Test{} = test) do
    %{
      config
      | tests: Map.update(config.tests, test.module, [test], fn tests -> [test | tests] end)
    }
  end

  defp print_test(%ExUnit.Test{state: state}) do
    {colour, char} =
      case get_state(state) do
        :excluded -> {IO.ANSI.light_black(), "e"}
        :failed -> {IO.ANSI.red(), "F"}
        :invalid -> {IO.ANSI.red(), "I"}
        :skipped -> {IO.ANSI.light_yellow(), "s"}
        :passed -> {IO.ANSI.green(), "."}
        nil -> {IO.ANSI.green(), "."}
        v -> {[IO.ANSI.blue(), IO.ANSI.red_background()], inspect(v)}
      end

    IO.write([colour, char, IO.ANSI.reset()])
  end

  defp print_summary(tests) do
    fields = [
      {[:failed, :invalid], IO.ANSI.light_red(), IO.ANSI.red(), "Failed"},
      {[nil, :passed], IO.ANSI.light_green(), IO.ANSI.green(), "Passed"},
      {[:skipped, :excluded], IO.ANSI.light_yellow(), IO.ANSI.yellow(), "Skipped"}
    ]

    fields_length =
      fields
      |> Enum.map(fn {_, _, _, label} -> String.length(label) + 1 end)
      |> Enum.sum()

    tests =
      tests
      |> Enum.map(&summarize(&1, fields))
      |> Enum.sort_by(fn test -> elem(test, 0) end)

    longest_line =
      tests
      |> Enum.map(fn {label, _} -> String.length(label) + fields_length end)
      |> Enum.max()

    totals =
      Enum.reduce(tests, {"Total", Enum.map(fields, fn _ -> 0 end)}, fn {_, val_fields},
                                                                        {label, acc_fields} ->
        new_fields =
          val_fields
          |> Enum.zip(acc_fields)
          |> Enum.map(fn {val, acc} -> val + acc end)

        {label, new_fields}
      end)

    IO.puts([
      "\n\nSummary:\n",
      print_heading(totals, fields),
      Enum.map(tests, &print(&1, fields)),
      String.duplicate("=", longest_line),
      "\n",
      print(totals, fields)
    ])
  end

  defp print({label, values}, fields) do
    colour =
      values
      |> Enum.zip(fields)
      |> Enum.filter(fn {v, _} -> v > 0 end)
      |> Enum.map(fn {_, {_, _, c, _}} -> c end)
      |> Enum.at(0, IO.ANSI.black())

    formatted_fields =
      values
      |> Enum.zip(fields)
      |> Enum.map(fn {v, {_, c1, c2, label}} -> fmt(v, String.length(label), c1, c2) end)
      |> Enum.intersperse(" ")

    [
      formatted_fields,
      " ",
      colour,
      label,
      IO.ANSI.reset(),
      "\n"
    ]
  end

  defp print_heading({_, totals}, fields) do
    formatted_fields =
      totals
      |> Enum.zip(fields)
      |> Enum.map(fn {v, {_, c1, c2, label}} -> fmt(label, v, c1, c2) end)
      |> Enum.intersperse(" ")

    [formatted_fields, " Name\n"]
  end

  defp summarize({name, tests}, fields) do
    values = Enum.map(fields, &summary_of(&1, tests))

    {label(name), values}
  end

  defp summary_of({states, _, _, _}, module) do
    count(module, states)
  end

  defp count(tests, state) do
    Enum.count(tests, &(get_state(&1.state) in state))
  end

  defp label(atom) do
    atom
    |> Atom.to_string()
    |> String.replace_leading("Elixir.", "")
  end

  defp fmt(number, length, active_colour, inactive_colour) when is_number(number) do
    text = String.pad_leading(Integer.to_string(number), length, " ")
    fmt(text, number, active_colour, inactive_colour)
  end

  defp fmt(text, count, active_colour, inactive_colour) do
    if count > 0 do
      [active_colour, text, IO.ANSI.reset()]
    else
      [inactive_colour, text, IO.ANSI.reset()]
    end
  end

  defp get_state({state, _}), do: state
  defp get_state(nil), do: nil
  defp get_state(state), do: inspect(state)
end
