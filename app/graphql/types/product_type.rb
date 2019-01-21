Types::ProductType = GraphQL::ObjectType.define do

  name 'Product'

  field :id, !types.ID
  field :inventory_count, !types.Int
  field :price, !types.Float
  field :title, !types.String
end
