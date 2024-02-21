module controllers.purchase;

import std.stdio;
// Vibed
import vibe.d;
import vibe.db.mongo.mongo;

import std.algorithm: map;

import database;
import models.purchase;
import models.shop;
import models.supplier;

import translation;

class PurchaseController {
    private MongoClient client;
	MongoCollection coll;
	MongoCollection coll_shop;
	MongoCollection coll_supplier;

	this() {
		client = connectMongoDB("127.0.0.1");
		coll = client.getCollection("storeapp.purchases");
		coll_shop = client.getCollection("storeapp.shops");
		coll_supplier = client.getCollection("storeapp.suppliers");
	}
    
	// GET /
	@method(HTTPMethod.GET)
	@path("/purchases")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("user/index.dt", authenticated);
		*/
		auto purchases = coll.find().map!(bson => deserializeBson!Purchase(bson));
		render!("purchases_index.dt", purchases);
	}
	
	// GET /
	@method(HTTPMethod.GET)
	@path("/purchases/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("user/index.dt", authenticated);
		*/
        auto purchase = Purchase();
		auto shops = coll_shop.find().map!(bson => deserializeBson!Shop(bson));
		auto suppliers = coll_supplier.find().map!(bson => deserializeBson!Supplier(bson));
		render!("purchases_new.dt", purchase, shops, suppliers);
	}
	

	// GET /users/:_id
    @method(HTTPMethod.GET)
	@path("/purchases/:_id")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { BsonObjectID _id; }
        auto purchaseNullable = coll.findOne!Purchase(Q(BsonObjectID.fromString(req.params["_id"])));
		if (! purchaseNullable.isNull) {
			// Acessar os campos da estrutura Customer
			auto purchase = purchaseNullable.get;
			render!("purchases_show.dt", purchase);
		} else {

		}
    }
    
}
