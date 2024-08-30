defmodule EsteeLauder.FoodTruck.ReqBehaviour do
  @callback new(keyword()) :: any()
  @callback get(any()) ::
              {:ok, %Req.Response{status: integer(), body: binary()}} | {:error, any()}
end
