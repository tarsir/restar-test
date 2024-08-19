defmodule RestarTestWeb.AddressesController do
  use RestarTestWeb, :controller

  alias RestarTest.Addresses.AddressApi

  @doc """
  List the addresses stored in the database.
  """
  def index(conn, _) do
    addresses = AddressApi.list_addresses()
    render(conn, :index, addresses: addresses)
  end

  @doc """
  Insert the addresses in the given CSV file to the database.
  """
  def process_upload(conn, %{"file" => file} = upload_params) do
    result =
      case AddressApi.insert_addresses_from_file(file.path) do
        {:ok, n} when is_integer(n) ->
          %{status: "success", message: "#{n} addresses inserted"}

        _ ->
          %{status: "failure", message: "unexpected failure"}
      end

    addresses = AddressApi.list_addresses()

    render(conn, :index, result: result, addresses: addresses)
  end

  @doc """
  Clear all addresses stored in the database.
  """
  def clear(conn, _) do
    result =
      case AddressApi.delete_addresses() do
        {:ok, n} when is_integer(n) ->
          %{status: "success", message: "#{n} addresses deleted"}

        _ ->
          %{status: "failure", message: "unexpected failure"}
      end

    addresses = AddressApi.list_addresses()

    render(conn, :index, result: result, addresses: addresses)
  end
end
