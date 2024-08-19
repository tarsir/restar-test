defmodule RestarTest.Repo.Migrations.CreateAddressesTable do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :full_address, :string, null: false
      add :prefecture, :string, null: false
      add :city, :string, null: false
      add :town, :string, null: false
      add :chome, :integer, null: false
      add :banchi, :integer, null: false
      add :go, :integer, null: false
      add :building, :string, null: false
      add :price, :integer, null: false
      add :nearest_station, :string, null: false
      add :property_type, :string, null: false
      add :land_area, :integer, null: false

      timestamps()
    end

    create index(:addresses, [:prefecture, :city])
  end
end
