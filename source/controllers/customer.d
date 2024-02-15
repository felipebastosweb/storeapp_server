module controllers.customer;

import std.stdio;
// Vibed
import vibe.d;
import vibe.db.mongo.mongo;

import std.algorithm: map;

import database;
import models.customer;

import translation;

class CustomerController {
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
		render!("user/index.dt", authenticated);
		*/
		auto customers = coll.find().map!(bson => deserializeBson!Customer(bson));
		render!("users_index.dt", customers);
	}
	

	// GET /users/:usernameeeeeeeee
    @method(HTTPMethod.GET)
	@path("/customers/:username")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { string name; }
        auto userNullable = coll.findOne!Customer(Q(req.params["name"]));
		if (! userNullable.isNull) {
			// Acessar os campos da estrutura Customer
			auto user = userNullable.get;
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
		render!("user/index.dt", authenticated);
		*/
		render!("customers_new.dt");
	}
	
    
}
