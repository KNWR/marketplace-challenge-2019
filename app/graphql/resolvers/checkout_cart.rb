class Resolvers::CheckoutCart < GraphQL::Function

  argument :username, !types.String

  def call(_obj, _args, _ctx)
    user = User.where(username: args[:username])
    cart = user.cart
    cart.checkout

    OpenStruct.new({
      username: cart.user.username,
      products: cart.list_products,
      subtotal: cart.subtotal,
      })
  end

end
