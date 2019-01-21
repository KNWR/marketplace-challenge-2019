Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

  field :get_product, Types::ProductType do
    argument :id, !types.ID
    resolve ->(obj, args, ctx) {
      Product.find(args[:id])
      # need a way to handle if it doesn't exist
      # i.e. a nicer error message
      # atm pretty crappy -- exposes too much user doesn't need to see
    }
  end

end
