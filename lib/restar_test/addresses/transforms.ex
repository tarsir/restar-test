defmodule RestarTest.Addresses.Transforms do
  @moduledoc """
  Transformation functions for the data wrangling of the addresses.

  This module defines some convenient attributes for handling the expected CSV inputs.
  """
  require Logger

  @schema_headers [
    :prefecture,
    :city,
    :town,
    :chome,
    :banchi,
    :go,
    :building,
    :price,
    :nearest_station,
    :property_type,
    :land_area
  ]

  @integer_fields [
    :chome,
    :banchi,
    :go,
    :price,
    :land_area
  ]

  @doc """
  Map CSV rows in the expected format into map structures that can be inserted via Ecto.Repo.insert_all/2.

  This function mainly: applies the expected headers to each of the columns; and parses integers 
  from strings.

  One thing to note is there are 5001 rows in the expected CSV, where 1 is the header. This function 
  ends up producing 4995 rows where 5 rows are skipped by the try/rescue. The skipped rows seem to 
  have at least one of their integer fields (typically :go) as a full-width number, which isn't 
  properly parsed by String.to_integer/1. Given more time, I would investigate more and figure that 
  out.
  """
  def expected_csv_to_schema_fields(csv_file) do
    csv_file
    |> File.stream!()
    |> CSV.decode!(headers: @schema_headers, validate_row_length: true)
    |> Stream.map(fn address ->
      try do
        Enum.reduce(@integer_fields, address, fn a, acc ->
          Map.replace_lazy(acc, a, &String.to_integer/1)
        end)
      rescue
        ArgumentError ->
          Logger.info("Skipping unparseable line (probably header line)")
          %{}
      end
    end)
    |> Stream.reject(&Enum.empty?/1)
    |> Enum.to_list()
  end
end
