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
		render!("brands_index.dt", brands);
	}
	

	// GET /users/:usernameeeeeeeee
    @method(HTTPMethod.GET)
	@path("/brands/:slug")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { string slug; }
        auto brandNullable = coll.findOne!Brand(Q(req.params["slug"]));
		if (! brandNullable.isNull) {
			// Acessar os campos da estrutura Customer
			auto brand = brandNullable.get;
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
