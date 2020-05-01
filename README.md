# Simple Ruby Microservice With Graphql

I would recommend against microservices unless you really really really can't do otherwise. But if you have to, this might be the simplest approach.

The microservices itself are written in ruby with Distributed Ruby. Meaning you can call easy and fast the underlying microservices without any http layer.

The setup is as follows:

- User service for fetching users
- Comment service for fetching comments
- Graphql service as an umbrella

All the services run in docker containers for easy building and deployment.

To run the example:

```sh
docker-compose build
docker-compose up -d
open http://localhost:9292/graphiql
```

Then query the api:

```graphql
{
  users {
    name
    comments {
      text
    }
  }
}
```

This is the absolute minimal example.
Things that you could added:

- Batch loading
- Automatically eject slow services
- Reconnecting after downtime of one of the services (this works!)
- Multiplexing and connection pooling the services (https://github.com/mperham/connection_pool)

## Scenarios:

Simulate a service going down by putting the comment service down.

```
docker-compose stop comment_service
```

And query the data again:

```graphql
{
  users {
    name
    comments {
      comment
    }
  }
}
```

You'll see that you can still query the users but not the comments. The graphql just returns null for the comments. Query the services node to see which of the services is down.

After thats put it back up:

```sh
docker-compose start comment_service
```

After all that:

```sh
docker-compose stop
```

Notes:

- In case either the comment service dies. It should just return null. This allows for one of the services to go down and the frontend should just be able to deal with that by saying 'comments cant be loaded' instead of exploding on a non-null.
- Services should be able to be added and scaled up, we can either add a bunch of connections to a connectionpool
- You might not want to use Drb since it can be a bottleneck and can be quite unsafe. Maybe look at protobuf or another rpc layer.
- Please microservice responsibly
