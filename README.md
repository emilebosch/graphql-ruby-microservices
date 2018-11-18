# Simple Ruby Microservice With Graphql

I would recommend against microservices unless you really really really can't do otherwise. But if you have to, this might be the simplest approach.

The simplest possible microservice architecture with ruby and graphql.

Microservices are written in ruby with Distributed Ruby. Meaning you can call easy and fast the underlying microservices.

To run the example:

```
docker-compose build
docker-compose up
open http://localhost:9292/graphiql
```

This is the absolute minimal example. 
Things that you could added:

- Batch loaders
- Reconnecting after downtime of one of the services (this works!)
- Multiplexing and connection pooling the services (https://github.com/mperham/connection_pool)

Notes:

- In case either the comment service dies. It should just return null. This allows for one of the services to go down and the frontend should just be able to deal with that by saying 'comments cant be loaded' instead of exploding on a non-null.
- Services should be able to be added and scaled up, we can either add a bunch of connections to a connectionpool

