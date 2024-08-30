defmodule EsteeLauder.FoodTrucks.FoodTruck do
  use Ecto.Schema
  import Ecto.Changeset

  schema "food_trucks" do
    field :address, :string
    field :applicant, :string
    field :approved, :string
    field :expiration_date, :string
    field :facility_type, :string
    field :fire_prevention_districts, :string
    field :food_items, :string
    field :latitude, :string
    field :location, :string
    field :location_description, :string
    field :longitude, :string
    field :noi_sent, :string
    field :police_districts, :string
    field :prior_permit, :string
    field :received, :string
    field :schedule, :string
    field :status, :string
    field :supervisor_districts, :string
    field :x, :string
    field :y, :string
    field :zip_codes, :string
    field :block, :string
    field :blocklot, :string
    field :cnn, :string
    field :dayshours, :string
    field :locationid, :string
    field :lot, :string
    field :permit, :string
    field :neighbors_old, :string

    timestamps()
  end

  @doc false
  def changeset(food_truck, attrs) do
    food_truck
    |> cast(attrs, [
      :address,
      :applicant,
      :approved,
      :expiration_date,
      :facility_type,
      :fire_prevention_districts,
      :food_items,
      :latitude,
      :location,
      :location_description,
      :longitude,
      :noi_sent,
      :police_districts,
      :prior_permit,
      :received,
      :schedule,
      :status,
      :supervisor_districts,
      :x,
      :y,
      :zip_codes,
      :block,
      :blocklot,
      :cnn,
      :dayshours,
      :locationid,
      :lot,
      :permit
    ])
  end

  @doc " I had to do this because the column names are not the same as the struct fields"
  def transform_keys(attrs) do
    %{
      "Address" => :address,
      "Applicant" => :applicant,
      "Approved" => :approved,
      "ExpirationDate" => :expiration_date,
      "FacilityType" => :facility_type,
      "Fire Prevention Districts" => :fire_prevention_districts,
      "FoodItems" => :food_items,
      "Latitude" => :latitude,
      "Location" => :location,
      "LocationDescription" => :location_description,
      "Longitude" => :longitude,
      "NOISent" => :noi_sent,
      "Police Districts" => :police_districts,
      "PriorPermit" => :prior_permit,
      "Received" => :received,
      "Schedule" => :schedule,
      "Status" => :status,
      "Supervisor Districts" => :supervisor_districts,
      "X" => :x,
      "Y" => :y,
      "Zip Codes" => :zip_codes,
      "block" => :block,
      "blocklot" => :blocklot,
      "cnn" => :cnn,
      "dayshours" => :dayshours,
      "locationid" => :locationid,
      "lot" => :lot,
      "permit" => :permit,
      "Neighborhoods (old)" => :neighbors_old
    }
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      value = Map.get(attrs, k)
      Map.put(acc, v, value)
    end)
  end
end
