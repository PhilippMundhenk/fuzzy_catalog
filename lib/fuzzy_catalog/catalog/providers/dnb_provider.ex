defmodule FuzzyCatalog.Catalog.Providers.DNBProvider do
  @moduledoc """
  Book lookup provider backed by Deutsche Nationalbibliothek (DNB).

  Features:
  - Lookup by ISBN, title, or UPC/barcode (treated as ISBN)
  - Full book metadata from DNB SRU OAI-DC records
  - Includes page count, description, subjects, publisher, date
  - Fetches covers directly from DNB cover service
  """

  @behaviour FuzzyCatalog.Catalog.BookLookupProvider

  import SweetXml
  require Logger

  @sru_base "https://services.dnb.de/sru/dnb"

  # ------------------------------------------------------------
  # Behaviour callbacks
  # ------------------------------------------------------------

  @impl true
  def provider_name, do: "DNB"

  @impl true
  def lookup_by_isbn(isbn) when is_binary(isbn) do
    isbn
    |> sru_search("isbn")
    |> first_record()
  end

  @impl true
  def lookup_by_title(title) when is_binary(title) do
    title
    |> sru_search("title")
    |> all_records()
  end

  @impl true
  # UPC / barcode often *is* an ISBN → treat identically
  def lookup_by_upc(upc) when is_binary(upc) do
    lookup_by_isbn(upc)
  end

  # ------------------------------------------------------------
  # SRU search
  # ------------------------------------------------------------

  defp sru_search(term, field) do
    query = "#{field}=\"#{term}\""

    url =
      @sru_base <>
        "?version=1.1" <>
        "&operation=searchRetrieve" <>
        "&recordSchema=oai_dc" <>
        "&query=#{URI.encode(query)}"

    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, %{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %{status_code: code}} -> {:error, "SRU HTTP #{code}"}
      {:error, reason} -> {:error, inspect(reason)}
    end
  end

  # ------------------------------------------------------------
  # Result handling
  # ------------------------------------------------------------

  defp first_record({:error, _} = err), do: err

  defp first_record({:ok, xml}) do
    case extract_records(xml) do
      [record | _] -> {:ok, build_book(record)}
      [] -> {:error, "No DNB record found"}
    end
  end

  defp all_records({:error, _} = err), do: err

  defp all_records({:ok, xml}) do
    books =
      xml
      |> extract_records()
      |> Enum.map(&build_book/1)

    {:ok, books}
  end

  # ------------------------------------------------------------
  # XML parsing
  # ------------------------------------------------------------

  defp extract_records(xml) do
    # Return the xmlElement nodes returned by SweetXml instead of converting
    # them to strings. build_book/1 and SweetXml's xpath handle xmlElement
    # nodes directly.
    xml
    |> xpath(~x"//record"l)
  end

  defp build_book(xml) do
    title = text(xml, "//dc:title")
    subtitle = text(xml, "//dc:title[@xsi:type='subtitle']")

    authors =
      xml
      |> texts("//dc:creator")
      |> Enum.join(", ")

    identifiers = texts(xml, "//dc:identifier")
    {isbn10, isbn13} = extract_isbns(identifiers)

    %{
      title: title || "",
      subtitle: subtitle,
      author: authors,
      isbn10: isbn10,
      isbn13: isbn13,
      publisher: text(xml, "//dc:publisher"),
      publication_date: parse_date(text(xml, "//dc:date")),
      pages: parse_pages(text(xml, "//dc:extent")),
      description: text(xml, "//dc:description"),
      genre: text(xml, "//dc:subject"),
      series: nil,
      series_number: nil,
      original_title: nil,
      cover_url: cover_url(isbn13 || isbn10)
    }
  end

  # ------------------------------------------------------------
  # Helpers
  # ------------------------------------------------------------

  defp text(xml, path) do
    xpath(xml, ~x"#{path}/text()"s, dc: dc_ns(), xsi: xsi_ns())
    |> blank_to_nil()
  end

  defp texts(xml, path) do
    xpath(xml, ~x"#{path}/text()"l, dc: dc_ns())
    |> Enum.map(&String.trim/1)
  end

  defp extract_isbns(ids) do
    clean =
      ids
      |> Enum.map(&String.replace(&1, ~r/[^0-9X]/i, ""))

    isbn10 = Enum.find(clean, &(String.length(&1) == 10))
    isbn13 = Enum.find(clean, &(String.length(&1) == 13))

    {isbn10, isbn13}
  end

  defp parse_pages(nil), do: nil

  defp parse_pages(extent) do
    case Regex.run(~r/(\d+)/, extent) do
      [_, num] -> String.to_integer(num)
      _ -> nil
    end
  end

  defp parse_date(nil), do: nil

  defp parse_date(date) do
    case Date.from_iso8601(date) do
      {:ok, d} -> d
      _ -> nil
    end
  end

  defp cover_url(nil), do: nil

  defp cover_url(isbn) do
    normalized = isbn |> String.replace(~r/[^0-9X]/i, "")
    "https://portal.dnb.de/opac/mvb/cover?isbn=#{hyphenate_isbn(normalized)}"
  end

  # Minimal hyphenation for DNB cover service
  defp hyphenate_isbn(isbn) do
    case String.length(isbn) do
      13 ->
        String.replace(isbn, ~r/^(\d{3})(\d)(\d{4})(\d{4})(\d)$/, "\\1-\\2-\\3-\\4-\\5")

      10 ->
        String.replace(isbn, ~r/^(\d)(\d{4})(\d{4})([\dX])$/, "\\1-\\2-\\3-\\4")

      _ ->
        isbn
    end
  end

  defp blank_to_nil(""), do: nil
  defp blank_to_nil(v), do: v

  defp dc_ns, do: "http://purl.org/dc/elements/1.1/"
  defp xsi_ns, do: "http://www.w3.org/2001/XMLSchema-instance"
end
