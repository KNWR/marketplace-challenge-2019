# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.create(title: "Jerry's Superman Action Figure", price: 115.00, inventory_count: 1)
Product.create(title: "Portrait of Kramer", price: 10000, inventory_count: 3)
Cart.create
