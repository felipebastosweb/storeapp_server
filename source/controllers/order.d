module controllers.order;

import std.stdio;
// Vibed
import vibe.d;
import vibe.db.mongo.mongo;

import std.algorithm: map;

import database;
import models.order;
import models.shop;
import models.customer;

import translation;

class OrderController {
    private MongoClient client;
	MongoCollection coll;
	MongoCollection coll_shop;
	MongoCollection coll_customer;

	this() {
		client = connectMongoDB("127.0.0.1");
		coll = client.getCollection("storeapp.orders");
		coll_shop = client.getCollection("storeapp.shops");
		coll_customer = client.getCollection("storeapp.customers");
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
	
	/*
	// GET /orders/:_id
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
	*/

	// GET /orders/new
	@method(HTTPMethod.GET)
	@path("/orders/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("order_index.dt", authenticated);
		*/
		auto order = Order();
		auto shops = coll_shop.find().map!(bson => deserializeBson!Shop(bson));
		auto customers = coll_customer.find().map!(bson => deserializeBson!Customer(bson));
		render!("orders_new.dt", order, shops, customers);
	}
}
