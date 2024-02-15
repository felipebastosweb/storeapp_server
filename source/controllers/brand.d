module controllers.brand;

import std.stdio;
// Vibed
import vibe.d;
import vibe.db.mongo.mongo;

import std.algorithm: map;

import database;
import models.brand;

import translation;

class BrandController {
    private MongoClient client;
	MongoCollection coll;

	this() {
		client = connectMongoDB("127.0.0.1");
		coll = client.getCollection("storeapp.brands");
	}
    
	// GET /
	@method(HTTPMethod.GET)
	@path("/brands")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("user/index.dt", authenticated);
		*/
		auto brands = coll.find().map!(bson => deserializeBson!Brand(bson));
		render!("brands_index.dt", customers);
	}
	

	// GET /users/:usernameeeeeeeee
    @method(HTTPMethod.GET)
	@path("/brands/:slug")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { string slug; }
        auto userNullable = coll.findOne!Brand(Q(req.params["slug"]));
		if (! userNullable.isNull) {
			// Acessar os campos da estrutura Customer
			auto brand = userNullable.get;
			render!("brands_show.dt", brand);
		} else {

		}
    }
	
	// GET /
	@method(HTTPMethod.GET)
	@path("/brands/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("user/index.dt", authenticated);
		*/
		render!("brands_new.dt");
	}
    
}
