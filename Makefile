run:
	iex -S mix phx.server

setup_static:
	cd assets && node install

cleandb:
	mix ecto.reset

migratedb:
	mix ecto.migrate

build:
	mix compile