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
		auto orders = coll.find().sort(["request_date": 1]).map!(bson => deserializeBson!Order(bson));
		render!("orders_index.dt", orders);
	}
	
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
	
	// POST /orders
    @method(HTTPMethod.POST)
	@path("/orders")
	void create(HTTPServerRequest req, HTTPServerResponse res)
	{
		struct Q { BsonObjectID _id; }
		Order order;
		order._id = BsonObjectID.generate; // Gera um ID aleatório para o usuário
		order.shop_id = req.form["shop_id"];
		order.shop = coll_shop.findOne!Shop(Q(BsonObjectID.fromString(order.shop_id))).get;
		order.customer_id = req.form["customer_id"];
		order.customer = coll_customer.findOne!Customer(Q(BsonObjectID.fromString(order.customer_id))).get;
		order.value = to!double(req.form["value"]);
		order.taxes = to!double(req.form["taxes"]);
		order.total = to!double(req.form["total"]);
		order.request_date = DateTime.fromISOExtString(req.form["request_date"]);
		coll.insertOne(order);
        res.redirect("/orders");
	}

	
	// GET /orders/:_id
    @method(HTTPMethod.GET)
	@path("/orders/:_id")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Order(Q(BsonObjectID.fromString(req.params["_id"])));
		if (! docNullable.isNull) {
			// Acessar os campos da estrutura Customer
			auto order = docNullable.get;
			/*
			auto item = OrderItem();
			item.product = Product();
			item.product.name = "Camiseta Básica";
			item.price = 50;
			item.quantity = 1;
            item.total = 50;
			order.order_items ~= item;
			*/
			render!("orders_show.dt", order);
		} else {

		}
    }
	

}
