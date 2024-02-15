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
	@path("/customers")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("customers_index.dt", authenticated);
		*/
		auto customers = coll.find().map!(bson => deserializeBson!Customer(bson));
		render!("customers_index.dt", customers);
	}
	

	// GET /users/:usernameeeeeeeee
    @method(HTTPMethod.GET)
	@path("/customers/:slug")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { string name; }
        auto customerNullable = coll.findOne!Customer(Q(req.params["slug"]));
		if (! customerNullable.isNull) {
			// Acessar os campos da estrutura Customer
			auto customer = customerNullable.get;
			render!("customers_show.dt", customer);
		} else {

		}
    }
	
	// GET /
	@method(HTTPMethod.GET)
	@path("/customers/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("customer_index.dt", authenticated);
		*/
		auto customer = Customer();
		render!("customers_new.dt", customer);
	}
}
