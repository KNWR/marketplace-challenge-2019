Types::CartType = GraphQL::ObjectType.define do

  name 'Cart'

  field :id, !types.ID
  field :subtotal, !types.Float
  field :list_products, types[Types::ProductType]
end
