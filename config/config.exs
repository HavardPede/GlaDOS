# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :glados,
  ecto_repos: [Glados.Repo]

config :glados, Glados.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.domeneshop.no",
  port: 587,
  username: System.get_env("USERNAME"),
  password: System.get_env("PASSWORD"),
  # can be `:always` or `:never`
  tls: :if_available,
  # or {":system", ALLOWED_TLS_VERSIONS"} w/ comma seprated values (e.g. "tlsv1.1,tlsv1.2")
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  # can be `true`
  ssl: false,
  retries: 1

# Configures the endpoint
config :glados, GladosWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gknN1DOBtmVSX9B+XMG47VV8xYIBqbIvggd4Dlk6Rx7zI1cIwTtcx9hTUZW3Y8JV",
  render_errors: [view: GladosWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Glados.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
