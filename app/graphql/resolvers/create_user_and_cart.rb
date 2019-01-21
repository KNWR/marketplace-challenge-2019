class Resolvers::CreateUserAndCart < GraphQL::Function

  argument :username, !types.String

  type types.String

  def call(_obj, args, _ctx)
    user = User.create(username: args[:username])
    cart = Cart.create(user: user)

    # OpenStruct.new({username: user.username})
    user.username

  rescue ActiveRecord::RecordInvalid, StandardError => error
    GraphQL::ExecutionError.new("Invalid input! #{error.full_message}")
  rescue StandardError => error
    GraphQL::ExecutionError.new(error.full_message)
  end
end
