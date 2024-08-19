defmodule RestarTest.Addresses.AddressSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "addresses" do
    field :full_address, :string
    field :prefecture, :string
    field :city, :string
    field :town, :string
    field :chome, :integer
    field :banchi, :integer
    field :go, :integer
    field :building, :string
    field :price, :integer
    field :nearest_station, :string
    field :property_type, :string
    field :land_area, :integer

    timestamps()
  end

  @fields [
    :full_address,
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

  @doc """
  Compute full_address before casting and validating.

  In the scope of the test, this changeset isn't used, but if this application were being extended
  we would want something like this.
  """
  def changeset(address, attrs) do
    full_address =
      "#{attrs.prefecture}#{attrs.city}#{attrs.town}#{attrs.chome}丁目#{attrs.banchi}-#{attrs.go}"

    attrs = Map.put(attrs, :full_address, full_address)

    address
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
