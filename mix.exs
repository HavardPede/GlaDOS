defmodule Glados.MixProject do
  use Mix.Project

  def project do
    [
      app: :glados,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),

      # Docs
      name: "Glados",
      source_url: "https://github.com/HavardPede/GlaDOS",
      homepage_url: "localhost:4001",
      docs: [
        # The main page in the docs
        main: "glados",
        logo: "assets/static/images/logo_70x.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Glados.Application, []},
      extra_applications: [:logger, :runtime_tools, :bamboo, :bamboo_smtp]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/helpers"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.9"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 1.0"},
      {:comeonin, "~> 5.2"},
      {:bcrypt_elixir, "~> 2.1"},
      {:bamboo, "~> 1.3"},
      {:bamboo_smtp, "~> 2.0.0"},
      {:timex, "~> 3.5"},
      {:credo, "~>1.1", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:phoenix_live_view, "~> 0.4.0"},
      {:floki, ">= 0.0.0", only: :test},
      {:yaml_elixir, "~> 2.4"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:ok, git: "https://github.com/CrowdHailer/OK/"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
