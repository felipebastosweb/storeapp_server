module controllers.shop;

import std.stdio;
// Vibed
import vibe.d;
//import vibe.http.router;
//import vibe.web.web;
import vibe.db.mongo.mongo;

import std.algorithm: map;
import std.array: array;
import std.json;

import database;

import translation;

import models.shop;

class ShopController {

	private MongoClient client;
	MongoCollection coll;

	this() {
		client = connectMongoDB("127.0.0.1");
		coll = client.getCollection("storeapp.shops");
	}
    
	// GET /
	@method(HTTPMethod.GET)
	@path("/shops")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("shops_index.dt", authenticated);
		*/
		auto shops = coll.find().map!(bson => deserializeBson!Shop(bson));
		render!("shops_index.dt", shops);
	}

    // GET /users/:usernameeeeeeeee
    @method(HTTPMethod.GET)
	@path("/shops/:slug")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { string slug; }
        auto productNullable = coll.findOne!Customer(Q(req.params["slug"]));
		if (! productNullable.isNull) {
			// Acessar os campos da estrutura Customer
			auto product = productNullable.get;
			render!("products_show.dt", product);
		} else {

		}
    }
	
	// GET /
	@method(HTTPMethod.GET)
	@path("/shops/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("shops/index.dt", authenticated);
		*/
        auto shop = Shop();
		render!("shops_new.dt", shop);
	}
    
}
