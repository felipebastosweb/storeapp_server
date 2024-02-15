module controllers.supplier;

import std.stdio;
// Vibed
import vibe.d;
import vibe.db.mongo.mongo;

import std.algorithm: map;

import database;
import models.supplier;

import translation;

class SupplierController {
    private MongoClient client;
	MongoCollection coll;

	this() {
		client = connectMongoDB("127.0.0.1");
		coll = client.getCollection("storeapp.suppliers");
	}
    
	// GET /
	@method(HTTPMethod.GET)
	@path("/suppliers")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("suppliers_index.dt", authenticated);
		*/
		auto suppliers = coll.find().map!(bson => deserializeBson!Supplier(bson));
		render!("suppliers_index.dt", suppliers);
	}

    
	// GET /
	@method(HTTPMethod.GET)
	@path("/suppliers/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("suppliers/index.dt", authenticated);
		*/
		auto supplier = Supplier();
		render!("suppliers_new.dt", supplier);
	}
}
