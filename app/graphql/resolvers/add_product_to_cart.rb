class Resolvers::AddProductToCart < GraphQL::Function

  argument :username, !types.String
  argument :product_id , !types.ID
  argument :amount, types.Int

  type Types::CartType

  def call(_obj, args, _ctx)
    user = User.where(username: args[:username]).first
    cart = user.cart
    product = Product.find(args[:id])
    args[:amount].exists? ? cart.add(product, args[:amount]) : cart.add(product)
    cart.add(product)

    OpenStruct.new({
      username: cart.user.username,
      products: cart.list_products,
      subtotal: cart.subtotal,
      })

  rescue ActiveRecord::RecordInvalid, StandardError => error
    GraphQL::ExecutionError.new("Invalid input! #{error.full_message}")
  rescue StandardError => error
    GraphQL::ExecutionError.new(error.full_message)
  end
end
