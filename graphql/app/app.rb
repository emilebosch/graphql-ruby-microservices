require "sinatra/base"
require "sinatra/json"
require "graphql"
require "yaml"

require "drb/drb"
require "benchmark"

DRb.start_service

COMMENT_SERVICE = DRbObject.new_with_uri(ENV["COMMENT_SERVICE"])
USER_SERVICE = DRbObject.new_with_uri(ENV["USER_SERVICE"])

puts "Starting #{ENV["COMMENT_SERVICE"]}"
puts "Starting #{ENV["USER_SERVICE"]}"

class User
  def comments
    COMMENT_SERVICE.get_comments
  end
end

class Query
  def comment
    COMMENT_SERVICE.get_comments(1)
  end

  def users
    USER_SERVICE.get_users
  end
end

module TestAPI
  module Resolver
    def self.call(type, field, obj, args, ctx)
      case type.to_s
      when "User"
        x = User.new
        if x.respond_to? field.name.to_sym
          x.public_send(field.name)
        else
          obj[field.name.to_sym]
        end
      when "Query"
        x = Query.new
        x.public_send(field.name)
      else
        if obj.is_a? Hash
          return obj[field.name.to_sym]
        end
        obj.public_send(field.name)
      end
    rescue
      return nil
    end
  end

  class App < Sinatra::Base
    post "/graphql" do
      body = JSON.parse(request.body.read)
      variables = body["variables"]
      query = body["query"]
      operation_name = body["operationName"]
      context = {}
      schema = File.open(File.expand_path("graphql/schema.graphql", __dir__)).read
      built_schema = GraphQL::Schema.from_definition(schema, default_resolve: Resolver)
      result = built_schema.execute(query, variables: variables, context: context, operation_name: operation_name)
      json result
    end
  end
end
