use Mix.Config

# Configure your database
config :glados, Glados.Repo,
  username: "postgres",
  password: "postgres",
  database: "glados_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :glados, GladosWeb.Endpoint,
  http: [port: 4002],
  server: false

config :glados,
  password_encryption: Glados.Accounts.MockEncryption

# Print only warnings and errors during test
config :logger, level: :warn
