defmodule RestarTestWeb.AddressesJSON do
  alias RestarTest.Addresses.AddressSchema

  def index(%{addresses: addresses, result: result}) do
    %{addresses: for(address <- addresses, do: data(address)), result: result}
  end

  def index(%{addresses: addresses}) do
    %{addresses: for(address <- addresses, do: data(address))}
  end

  defp data(%AddressSchema{} = address) do
    %{
      full_address: address.full_address,
      prefecture: address.prefecture,
      city: address.city,
      town: address.town,
      chome: address.chome,
      banchi: address.banchi,
      go: address.go,
      building: address.building,
      price: address.price,
      nearest_station: address.nearest_station,
      property_type: address.property_type,
      land_area: address.land_area
    }
  end
end
