module controllers.purchase;

import std.stdio;
// Vibed
import vibe.d;
import vibe.db.mongo.mongo;

import std.conv;
import std.algorithm: map;

import database;
import models.product;
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
		auto purchases = coll.find().sort(["purchase_date": 1]).map!(bson => deserializeBson!Purchase(bson));
		render!("purchases_index.dt", purchases);
	}
	
	// GET /purchases/new
	@method(HTTPMethod.GET)
	@path("/purchases/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("purchases/index.dt", authenticated);
		*/
        auto purchase = Purchase();
		auto shops = coll_shop.find().map!(bson => deserializeBson!Shop(bson));
		auto suppliers = coll_supplier.find().map!(bson => deserializeBson!Supplier(bson));
		render!("purchases_new.dt", purchase, shops, suppliers);
	}

	// POST /purchases
    @method(HTTPMethod.POST)
	@path("/purchases")
	void create(HTTPServerRequest req, HTTPServerResponse res)
	{
		struct Q { BsonObjectID _id; }
		Purchase purchase;
		purchase._id = BsonObjectID.generate; // Gera um ID aleatório para o usuário
		purchase.shop_id = req.form["shop_id"];
		purchase.shop = coll_shop.findOne!Shop(Q(BsonObjectID.fromString(purchase.shop_id))).get;
		purchase.supplier_id = req.form["supplier_id"];
		purchase.supplier = coll_supplier.findOne!Supplier(Q(BsonObjectID.fromString(purchase.supplier_id))).get;
		purchase.value = to!double(req.form["value"]);
		purchase.taxes = to!double(req.form["taxes"]);
		purchase.total = to!double(req.form["total"]);
		purchase.purchase_date = Date.fromISOExtString(req.form["purchase_date"]);
		coll.insertOne(purchase);
        res.redirect("/purchases");
	}
	
	// GET /purchases/:_id
    @method(HTTPMethod.GET)
	@path("/purchases/:_id")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { BsonObjectID _id; }
        auto purchaseNullable = coll.findOne!Purchase(Q(BsonObjectID.fromString(req.params["_id"])));
		if (! purchaseNullable.isNull) {
			// Acessar os campos da estrutura Customer
			auto purchase = purchaseNullable.get;
			auto item = PurchaseItem();
			item.product = Product();
			item.product.name = "Camiseta Básica";
			item.price = 50;
			item.quantity = 1;
            item.total = 50;
			purchase.purchase_items ~= item;
			render!("purchases_show.dt", purchase);
		} else {

		}
    }
    
}
