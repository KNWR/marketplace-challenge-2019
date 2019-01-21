Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :add_product_to_cart, function: Resolvers::AddProductToCart.new
  field :checkout_cart, function: Resolvers::CheckoutCart.new
  field :create_user_and_cart, function: Resolvers::CreateUserAndCart.new
end
