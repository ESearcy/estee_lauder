ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(EsteeLauder.Repo, :manual)
Mox.defmock(ReqMock, for: EsteeLauder.FoodTruck.ReqBehaviour)
