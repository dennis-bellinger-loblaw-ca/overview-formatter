# OverviewFormatter

Provides an overview of passing and failing tests. It prints a list of modules with a count of passed, failed, and skipped tests for each.

## Example Output

```
$ mix test.overview
........................................FFF.F.................................................
..ss....s.............................sFFFFFFFF...............................................
..............................................................................................
................................s.............................................................

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
```


## Installation

The package can be installed by adding `overview_formatter` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:overview_formatter, git: "ssh://git@gitlab.lblw.ca:2222/dennis.bellinger/overview_formatter.git", tag: "0.1.0"}
  ]
end
```

If you'd like to be able to run `mix test.overview` you'll need to add the following snippet to your project definition:
```elixir
def project do
  [
    preferred_cli_env: ["test.overview": :test]
  ]
end
```

