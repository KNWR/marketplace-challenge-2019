Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :add_product_to_cart, function: Resolvers::AddProductToCart.new
end
