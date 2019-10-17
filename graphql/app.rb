require "sinatra/base"
require "sinatra/json"
require "graphql"
require "yaml"
require "drb/drb"
require "benchmark"

class String
  def underscore
    self.gsub(/::/, "/").
      gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z\d])([A-Z])/, '\1_\2').
      tr("-", "_").
      downcase
  end
end

DRb.start_service

puts "Starting #{ENV["COMMENT_SERVICE"]}"
COMMENT_SERVICE = DRbObject.new_with_uri(ENV["COMMENT_SERVICE"])

puts "Starting #{ENV["USER_SERVICE"]}"
USER_SERVICE = DRbObject.new_with_uri(ENV["USER_SERVICE"])

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

class Mutation
  def create_user(name = "emile")
    USER_SERVICE.create_user(name)
  end
end

module TestAPI
  module Resolver
    def self.call(type, field, obj, args, ctx)
      case type.to_s
      when "User"
        user = User.new
        if user.respond_to?(field.name.to_sym)
          user.public_send(field.name)
        else
          obj[field.name.to_sym]
        end
      when "Mutation"
        x = Mutation.new
        x.public_send(field.name.underscore)
      when "Query"
        x = Query.new
        x.public_send(field.name)
      else
        return obj[field.name.to_sym] if obj.is_a?(Hash)
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
