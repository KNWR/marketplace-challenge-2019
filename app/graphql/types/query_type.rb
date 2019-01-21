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

  field :get_cart, Types::CartType do
    argument :id, !types.ID
    resolve ->(obj, args, ctx) {
      Cart.find(args[:id])
    }
  end

  field :get_all_products, !types[Types::ProductType] do
    argument :in_stock, types.Boolean
    resolve -> (obj, args, ctx) {
      args[:in_stock] ? Product.where("inventory_count > ?", 0) : Product.all
    }
  end



end
