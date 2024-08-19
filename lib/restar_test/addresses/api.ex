defmodule RestarTest.Addresses.AddressApi do
  import Ecto.Query, warn: false
  alias RestarTest.Addresses.Transforms
  alias RestarTest.Repo

  alias RestarTest.Addresses.AddressSchema, as: Addresses
  require Logger

  def list_addresses() do
    Repo.all(Addresses)
  end

  def insert_addresses_from_file(csv_file) do
    timestamps =
      DateTime.now!("Etc/UTC") |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)

    # insert_all doesn't apply timestamps or changesets so we have to add these manually.
    # Arguably, manually adding timestamps is better anyway since we probably don't want addresses 
    # added in the same upload to have different timestamps.
    addresses =
      csv_file
      |> Transforms.expected_csv_to_schema_fields()
      |> Enum.map(fn a ->
        full_address = "#{a.prefecture}#{a.city}#{a.town}#{a.chome}丁目#{a.banchi}-#{a.go}"

        a
        |> Map.put(:full_address, full_address)
        |> Map.put(:inserted_at, timestamps)
        |> Map.put(:updated_at, timestamps)
      end)

    # if we try to insert too many at once, Postgres fails out here, so we add 1000 at a time
    inserts =
      addresses
      |> Enum.chunk_every(1000)
      |> Enum.map(fn address_chunk ->
        {inserts, _} = Repo.insert_all(Addresses, address_chunk)
        Logger.info("Inserted #{inserts} addresses out of #{Enum.count(address_chunk)} attempted")
        inserts
      end)
      |> Enum.sum()

    {:ok, inserts}
  end

  def delete_addresses() do
    {deletes, _} = Repo.delete_all(Addresses)
    Logger.info("Deleted #{deletes} addresses")

    {:ok, deletes}
  end
end
