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
import models.product;
import models.payment;

import translation;

class OrderController {
    private MongoClient client;
	MongoCollection coll;
	MongoCollection coll_shop;
	MongoCollection coll_customer;
	MongoCollection coll_product;
	MongoCollection coll_payment_type;

	this() {
		client = connectMongoDB("127.0.0.1");
		coll = client.getCollection("storeapp.orders");
		coll_shop = client.getCollection("storeapp.shops");
		coll_customer = client.getCollection("storeapp.customers");
		coll_product = client.getCollection("storeapp.products");
		coll_payment_type = client.getCollection("storeapp.payment_types");
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
		order.delivery_date = DateTime.fromISOExtString(req.form["delivery_date"]);
		coll.insertOne(order);
        res.redirect("/orders/" ~ order._id.toString());
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
			
			auto new_item = OrderItem();
			auto new_payment = OrderPayment();
			auto products = coll_product.find().map!(bson => deserializeBson!Product(bson));
			auto payment_types = coll_payment_type.find().map!(bson => deserializeBson!PaymentType(bson));
			render!("orders_show.dt", order, new_item, new_payment, products, payment_types);
		} else {

		}
    }
	
	// GET /orders/:_id/edit
	@method(HTTPMethod.GET)
	@path("/orders/:_id/edit")
	void edit_form(HTTPServerRequest req, HTTPServerResponse res)
	{
		/*
		bool authenticated = ms_authenticated;
		render!("shop_index.dt", authenticated);
		*/
		struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Order(Q(BsonObjectID.fromString(req.params["_id"])));
		if (! docNullable.isNull) {
			// Acessar os campos da estrutura Order
			Order order = docNullable.get;
			auto shops = coll_shop.find().map!(bson => deserializeBson!Shop(bson));
			auto customers = coll_customer.find().map!(bson => deserializeBson!Customer(bson));
			render!("orders_edit.dt", order, shops, customers);
		}
	}
	

    // POST /orders/:_id
	@method(HTTPMethod.POST)
	@path("/orders/:_id")
	void change(HTTPServerRequest req, HTTPServerResponse res)
	{
		auto _id = BsonObjectID.fromString(req.form["_id"]);
        // filter
		BsonObjectID[string] filter;
		filter["_id"] = _id;
        // update
		Bson[string][string] update;
		// TODO: change shop
		// TODO: change supplier
		//update["$set"]["name"] = req.form["name"];
		update["$set"]["value"] = req.form["value"];
		update["$set"]["taxes"] = req.form["taxes"];
		update["$set"]["total"] = req.form["total"];
		update["$set"]["request_date"] = req.form["request_date"];
		update["$set"]["delivery_date"] = req.form["delivery_date"];
		coll.updateOne(filter, update);
        res.redirect("/orders/" ~ req.form["_id"]);
	}

    // GET /orders/:_id/delete
    @method(HTTPMethod.GET)
    @path("/orders/:_id/delete")
    void delete_show(HTTPServerRequest req, HTTPServerResponse res)
    {
        /*
        bool authenticated = ms_authenticated;
        render!("orders/index.dt", authenticated);
        */
        struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Order(Q(BsonObjectID.fromString(req.params["_id"])));
        if (! docNullable.isNull) {
            // Acessar os campos da estrutura Order
            Order order = docNullable.get;
            render!("orders_delete.dt", order);
        }
    }

    // DELETE /orders/:_id
    @method(HTTPMethod.DELETE)
    @path("/orders/:_id")
    void remove(HTTPServerRequest req, HTTPServerResponse res)
    {
        /*
        bool authenticated = ms_authenticated;
        render!("orders/index.dt", authenticated);
        */
		auto _id = BsonObjectID.fromString(req.params["_id"]);
		BsonObjectID[string] filter;
		filter["_id"] = _id;
        struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Order(Q(_id));
        if (! docNullable.isNull) {
			auto deleteNullable = coll.deleteOne(filter);
			if (deleteNullable.deletedCount == 1) {
				// Definir status de resposta para "No Content"
				res.statusCode = 204;
				res.writeBody("Erro ao excluir o usuário.");
			} else {
				// Não foi possível excluir o usuário
				res.statusCode = 500;
				res.writeBody("Erro ao excluir o usuário.");
			}
		}
		else {
            res.statusCode = 404;
			res.writeBody("Usuário não encontrado.");
        }
	}
}
