require "./app"
require "rack-graphiql"

map "/graphiql" do
  run Rack::GraphiQL.new(endpoint: "/graphql")
end

run TestAPI::App
