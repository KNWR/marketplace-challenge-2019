# Marketplace Challenge 2019

Rails: 5.1.4
Ruby: 2.5.1

E-commerce API with GraphQL and Rails. How it works: You can purchase products by adding them to a "shopping cart", and then checking out that cart. Fun –– I've worked with Rails for work, but this was my first-time touching GraphQL. Best way of learning is doing.

Built w/:
- Ruby 2.5.1
- Ruby on Rails 5.1.4
- Sqlite3
- GraphQL

To run locally (assuming you have ruby set up), download the repo, cd into it, run:
`bundle install`
`rails s`

You can test queries at localhost:3000/graphiql


## How it works

What you have to do in rails console (run `rails c`) (i.e. can't do via the API):
- create users (User objects)
- create products
- You can run rake db:seed to get a few items ready and in a cart

- Models: Cart, Product, User, CartProduct

## via the GraphQL API, you can:

Query calls:

### get_product
- returns information about a particular product
- required argument: `id` -- i.e. the Product id

```
{
  get_product(id: "1") {
    # unique id number
    id
    # what the product's called
    title
    # amount of the product available in stock
    inventory_count
    # price of the product
    price
  }
}
```

### get_cart
- returns information about a cart
- required argument: `username` (String) -- the username of the owner of the cart

```
{
  get_cart(username: "LarryDavid") {
    # unique id number
    id
    # how much all the products in the cart together cost to purchase
    subtotal
    # a list of the products in the cart
    list_products
  }
}
```

### get_all_products
- get information on all of the types of products in the system
- there's the option to see the subset of those products which are only `in-stock` ... mandatory argument whether true or false
```
{
  # with in_stock: true, the server would return all products
  get_all_products(in_stock: false) {
    # title of the product
    title
    # id of the product
    id
    # how much of the product is in stock
    inventory_count
    # the price
    price
  }
}
```

Mutate calls:

### create_user_and_cart
- create a user object and the cart object that belongs to it
- it returns an OpenStruct, i.e. a just a loose ruby native hash-like structure
- where here, after creating the object, the server packages back the username inputted

```
mutation {
  create_user_and_cart(username: "Tobias Lutke") {
  }
}
```

### add_product_to_cart
- add a product to a user's cart
- if there is not enough of the product in inventory (product.inventory_count) to
- meet the order, an error is raised, rescued by GraphQL, and passed along to the API consumer
- argument (required): `username` -- this tells us whose cart the product is to be added to
- argument: `product_id` -- this tells us what kind of product we're adding to the cart

```
mutation {
  add_product_to_cart(username: "Tobias Lutke", product_id: 2) {
    # owner of the cart
    username
    # list of the products now in the cart
    list_products {
      title
    }
    # current subtotal price of all items in the cart after adding the item
    subtotal
  }
}
```

### checkout_cart
- This is how we buy items. if there is sufficient inventory, it decrements the inventory of the products being purchased by the purchase amount (`cart_product.amount`), removes all cart_products from the part, and creates an association between the `cart_products` and user (`cart.user`). If the order is for more than is in inventory of particular items, it removes those items from the cart, but leaves the other items in the cart, does NOT purchase them, and raises an error message rescued and delivered via GraphQL
- argument: `username`, to indicate whose cart to check out
```
mutation {
  checkout_cart(username: "Tobias Lutke") {
    username
    # products purchased in submitting the checkout action
    products_purchased
    # items now in the cart (should be none)
    products
    # amount of money spent in submitting the checkout action
    subtotal_spent
    # subtotal of the cart now - should be 0, as items removed when purchased
    subtotal
  }
}
```
## Tradeoffs:
- If I were to do this again, I'd write it as a service; most if not all of the business logic lives in the Cart model anyway
- For speed, did not do these, would do them with more time:
--- Used Shopify's Ruby style guide
--- Used a more up to date version of GraphQL
--- Set up factorybot & databse_cleaner -- initially had it, waffled on it because wanted to move fast (and broke things) ... but spent so much time on fixing tests when the code worked, would have been better to have this set up cleanly
--- Started the project with Postgresql to be able to demo live on Heroku
--- Used context storage in GraphQL –– this would allow storing of session variables and user id, to avoid having to indicate
--- Security! Using a gem like bcrypt or JWT (if a serious project) so that you can't just perform actions on any user's cart
--- Included unit tests for the API itself. As is, tested it with Graphiql
