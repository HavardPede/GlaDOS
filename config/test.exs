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

# Configure the database for GitHub Actions
if System.get_env("GITHUB_ACTIONS") do
  config :app, Glados.Repo,
    username: "postgres",
    password: "postgres"
end
# Print only warnings and errors during test
config :logger, level: :warn
