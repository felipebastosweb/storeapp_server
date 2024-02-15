module controllers.order;

import std.stdio;
// Vibed
import vibe.d;
import vibe.db.mongo.mongo;

import std.algorithm: map;

import database;
import models.order;

import translation;

class OrderController {
    private MongoClient client;
	MongoCollection coll;

	this() {
		client = connectMongoDB("127.0.0.1");
		coll = client.getCollection("storeapp.customers");
	}
    
	// GET /
	@method(HTTPMethod.GET)
	@path("/orders")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("orders_index.dt", authenticated);
		*/
		auto orders = coll.find().map!(bson => deserializeBson!Order(bson));
		render!("orders_index.dt", orders);
	}
	

	// GET /users/:usernameeeeeeeee
    @method(HTTPMethod.GET)
	@path("/orders/:_id")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { string slug; }
        auto orderNullable = coll.findOne!Order(Q(req.params["slug"]));
		if (! orderNullable.isNull) {
			// Acessar os campos da estrutura Order
			auto order = orderNullable.get;
			render!("orders_show.dt", order);
		} else {

		}
    }
	
	// GET /
	@method(HTTPMethod.GET)
	@path("/orders/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("order_index.dt", authenticated);
		*/
		auto order = Order();
		render!("orders_new.dt", order);
	}
}
