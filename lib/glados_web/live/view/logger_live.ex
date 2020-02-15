defmodule GladosWeb.Live.View.LoggerLive do
  @moduledoc """
  The liveview session responsible for the logger live view.
  """
  use Phoenix.LiveView
  use OK.Pipe
  alias Glados.{Events, EventCrew, Repo, ShopTransactions}

  def mount(_params, socket) do
    Events.get_event_with_active_shop()
    |> case do
      {:ok, event} ->
        {:ok, crew} = EventCrew.get_crew(event.id)
        socket
        |> assign(
          event: event,
          products: event.products,
          crew: crew,
          page: :shop
        )
      {:error, :no_shops_open} ->
        socket
        |> assign(
          event: nil,
          products: nil,
          crew: nil,
          page: :closed
        )
    end
    |> assign(         
      customer: nil,
      cart: %{},
      total: 0.0,
      search_term: nil,
      transactions: %{}
    )
      |> OK.wrap()
  end

  def render(assigns) do
    Phoenix.View.render(GladosWeb.LoggerView, "index.html", assigns)
  end

  ##
  ## SEARCH
  ##
  def handle_event("search", %{"search_term" => search_term}, %{assigns: %{crew: crew, products: products}} = socket) do
    product_result = {_, product} = search_products(products, search_term)
    crew_result = {_, crew} = search_crew(crew, search_term)
    cond do
      OK.success?(product_result) -> add_product_to_cart(socket, product)
      OK.success?(crew_result) -> set_customer(socket, crew)
      true -> assign(socket, search_term: search_term)
    end
    |> noreply()
  end

  ##
  ## REMOVE FROM CART
  ##
  def handle_event("remove_from_cart", %{"barcode" => barcode}, %{assigns: %{cart: cart}} = socket) do
    socket
    |> assign(cart: Map.delete(cart, barcode))
    |> calculate_total()
    |> noreply()
  end

  ##
  ## RESET STATE
  ##
  def handle_event("reset_state", _values, socket) do
    socket
    |> assign(
      customer: nil,
      cart: %{},
      total: 0.0,
      search_term: nil
    )
    |> noreply
  end

  ##
  ## REMOVE CUSTOMER
  ##
  def handle_event("remove_customer", _values, socket) do
    socket
    |> assign(customer: nil)
    |>  noreply()
  end

  ##
  ## SAVE TRANSACTION
  ##
  def handle_event("save_transaction", _values, socket) do
    construct_transactions(socket)
    ~>> ShopTransactions.save_transactions()
    |> case do
      {:ok, _transactions} -> handle_event("reset_state", nil, socket)
      _ -> noreply(socket)
    end
  end

  ##
  ## CHANGE PAGE
  ##
  def handle_event("change_page", %{"page" => page}, socket) do
    socket
    |> assign(page: String.to_atom(page))
    |> load_page_specific_data(page)
    |> noreply()
  end
  ## ------ PRIVATE FUNCTIONS ------ ##

  ## Check if barcode belongs to one of the products.
  defp search_products(products, barcode) do
    products
    |> Enum.find(& &1.barcode == barcode)
    |> OK.required(:no_product_found)
  end

  ## Check if id_card belongs to any of the crew members
  defp search_crew(crew, id_card) do
    crew
    |> Enum.find(& &1.id_card == id_card)
    |> OK.required(:no_crew_member_found)
  end

  defp add_product_to_cart(%{assigns: %{cart: cart}} = socket, %{barcode: barcode} = product) do
    cart =
      cart
      |> Map.has_key?(barcode)
      |> if do
        current_count = cart[barcode].count
        put_in(cart, [barcode, :count], current_count + 1)
      else
        cart_object = %{
          name: product.name,
          price: product.price,
          id: product.id,
          count: 1
        }
        Map.put(cart, barcode, cart_object)
      end
   
    socket
    |> assign(cart: cart, search_term: nil)
    |> calculate_total()
  end

  defp calculate_total(%{assigns: %{cart: cart}} = socket) do
    new_total =
    Enum.reduce(cart, 0, fn {_product_name, cart_object}, current_total ->
      current_total + (cart_object.count * cart_object.price)
    end)
    |> Kernel./(1)
    assign(socket, total: new_total)
  end

  defp set_customer(socket, customer) do
    socket
    |> assign(customer: customer, search_term: nil)
  end

  defp noreply(value), do: {:noreply, value}

  defp construct_transactions(%{assigns: %{customer: customer, cart: cart, event: event}}) do
    cart
    |> Enum.reduce([], fn {_barcode, %{id: product_id, count: count}}, buffer ->
      attributes = %{
        event_id: event.id,
        user_id: customer.user_id,
        product_id: product_id
      }

      buffer ++ Enum.map(1..count, fn _ ->
       ShopTransactions.change_transaction(attributes)
      end)
    end)
    |> OK.wrap()
  end

  defp load_page_specific_data(%{assigns: %{event: event}} = socket, "transactions") do
    transactions =
    event.id
    |> ShopTransactions.get_event_transactions()
    |> Enum.map(fn {transaction, user_name, user_crew} ->
      transaction
      |> Repo.preload(:product)
      |> Map.merge(%{customer: user_name, crew: user_crew})
    end)
    |> Enum.group_by(fn transaction -> transaction.inserted_at end)
    assign(socket, transactions: transactions)
  end

  defp load_page_specific_data(socket, _), do: socket
end
