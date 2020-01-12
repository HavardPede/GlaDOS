defmodule Glados.Mailer do
  @moduledoc """
  The mailer module for Glados, that sends out emails. Uses the Bamboo library.
  """
  use Bamboo.Mailer, otp_app: :glados
end
