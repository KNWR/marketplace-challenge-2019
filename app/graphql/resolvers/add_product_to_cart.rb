class Resolvers::AddProductToCart < GraphQL::Function

  argument :username, !types.String
  argument :product_id , !types.ID
  argument :amount, types.Integer

  type Types::CartType
  def call(_obj, args, _ctx)
    user = User.where(username: args[:username])
    cart = user.cart
    product = Product.find(args[:id])
    args[:amount].exists? ? cart.add(product, args[:amount]) : cart.add(product)
    cart.add(product)

    OpenStruct.new({
      username: cart.user.username,
      products: cart.list_products,
      subtotal: cart.subtotal,
      })
  end

end
