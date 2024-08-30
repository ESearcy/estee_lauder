# EsteeLauder

Welcome to my sample application. Here I have implemented the coding challange outlined

```
  The Challenge

  As the doo-da man says, "you've got to play your hand", and in this case your hand is to implement this food truck app.

  Our team loves to eat. They are also a team that loves variety, so they also like to discover new places to eat.

  In fact, we have a particular affection for food trucks. One of the great things about Food Trucks in San Francisco is that the city releases a list of them as open data.


  Your assignment is to make it possible for our teams to do something with this food trucks data.

  This is a freeform assignment. You can write a web API that returns a set of food trucks. You can write a web frontend that visualizes the nearby food trucks for a given place. You can create a CLI that lets us get the names of all the taco trucks in the city. You're not limited by these ideas at all, but hopefully those are enough help spark your own creativity.

  San Francisco's food truck open dataset is located here and there is an endpoint with a CSV dump of the latest data here. We've also included a copy of the data in this repo as well.
```

## Setup Steps

1. Install ASDF package manager

2. Install project specific Elixir & Erlang

   ```
   asdf local elixir 1.17.2-otp-27
   asdf local erlang 27.0
   ```

   (optional) install phx_new for elixir/erlang combo
   mix archive.install hex phx_new

3. Start dependent services using docker-compose
   Postgres: Our DB
   OLTP collector: our app published traces here
   Jeager-all-in-one: Observability tool to collect traces and metrics, and visualize them

```
docker compose up -d
```

## Start the App

now that all of our services are up and running, we setup and start our app

```
mix ecto.setup - we're not actually using the db, but we wanna make sure the app is all setup.
iex -S mix phx.server
```

## General Design

This intial design of using a cache instead of perminant db storage was to give me a bit more freedom to play around with and understand the data while I worked on the challenge.
Since there are no requirements about the user interfacing with the data, persisting state didn't seem like a valuable use of time. that said, I do have "next steps" at the end of this.

dev tools & apps:

- docker-compose: used for setting up db & dev tools.
- postgres: our db
- jeager-all-in-one: this lets us collect and view traces from our application. this is extremely helpful for debugging locally. for prod we'd use lightstep or something similar instead of jeager-all-in-one
- vs-code: not required but is what I use

To complete this challange I decided to go with a cachex based approach for managing the food truck data.

- Cachex is backed by ETS, allowing for an easy-to-use interface sitting upon extremely well tested tools. (from hex docs). I also just like the interface.
- The number of records from the api didn't seem excessive (490), so storing in memory didn't seem like it would be an issue.
- I could have gone with ecto for storing the records but since we already have direct access to the true data, but worrying about data sync and consistency within our db seemed like overkill.
- For tests, I've loaded the latest data from the foodtruck endpoint and dumped it to a local file. this dump can optionally be used for local development too.

For Presenting the data, I went with a simple liveview page

- This can be accessed here: http://localhost:4000/
- The Developer Jeager UI is also available here: http://localhost:16686/search. this can be used to explore the traces collected by the app while you're using it.
