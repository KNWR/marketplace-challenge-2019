class Resolvers::AddProductToCart < GraphQL::Function

  argument :username, !types.String
  argument :amount, types.Integer

  def call(_obj, args, _ctx)
    user = User.create(args[:username])
    cart = Cart.create(user: user)

    OpenStruct.new({username: user.username})
  end

end
