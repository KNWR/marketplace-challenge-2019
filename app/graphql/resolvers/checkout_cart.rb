class Resolvers::CheckoutCart < GraphQL::Function

  argument :username, !types.String

  type do
    name 'CartCheckoutReturn'

    field :username, types.String
    field :products_purchased, types[Types::ProductType]
    field :current_products, types[Types::ProductType]
    field :subtotal_spent, types.Int
    field :current_subtotal, types.Int
  end

  def call(_obj, args, _ctx)
    user = User.where(username: args[:username]).first
    cart = user.cart

    # preserving data to share about the checkout:
    products_pre_checkout = cart.list_products
    subtotal_pre_checkout = cart.subtotal

    cart.checkout

    OpenStruct.new({
      username: cart.user.username,
      products_purchased: products_pre_checkout,
      current_products: cart.list_products,
      subtotal_spent: subtotal_pre_checkout,
      current_subtotal: cart.subtotal,
      })

    rescue ActiveRecord::RecordInvalid, StandardError => error
      GraphQL::ExecutionError.new("Invalid input! #{error.full_message}")
    rescue StandardError => error
      GraphQL::ExecutionError.new(error.full_message)
    end
end
