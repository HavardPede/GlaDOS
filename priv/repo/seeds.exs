# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Glados.Repo.insert!(%Glados.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Glados.Repo.insert!(%Glados.Accounts.User{
  id: Ecto.UUID.generate(),
  name: "ESLG Admin",
  email: "esportslangaming@gmail.com",
  username: "admin",
  address: "Hvalerhallen",
  postcode: 1684,
  phone_number: "1337",
  auth_level: 5,
  verified: true,
  dob: ~D[1337-11-22],
  encrypted_password: "$2b$12$2oGYRc//D928Ula0AnXYxOLkd151A/OXtYSJlJE0NCuOEFGhkfWKm"
})

Glados.Repo.insert!(%Glados.Accounts.User{
  id: Ecto.UUID.generate(),
  name: "ESLG Logger",
  email: "noreply@eslgcrew.no",
  username: "logger",
  address: "Hvalerhallen",
  postcode: 1684,
  phone_number: "1337",
  auth_level: 2,
  verified: true,
  dob: ~D[1337-11-22],
  encrypted_password: "$2b$12$wLo0AedbQBDyHsP3OpqykuNxKeSLty2HyKD/qNDspMsHFTX/.n18O"
})
