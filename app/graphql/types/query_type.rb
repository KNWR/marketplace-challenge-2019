Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

  field :get_product, Types::ProductType do
    argument :id, !types.ID
    resolve ->(obj, args, ctx) {
      Product.find(args[:id])
    }
  end

  field :get_cart, Types::CartType do

    argument :username, !types.String
    resolve ->(obj, args, ctx) {
      cart = User.where(username: args[:username]).first.cart
    }
  end

  field :get_all_products, !types[Types::ProductType] do
    argument :in_stock, !types.Boolean
    resolve -> (obj, args, ctx) {
      args[:in_stock] ? Product.where("inventory_count > ?", 0) : Product.all
    }
  end
end
