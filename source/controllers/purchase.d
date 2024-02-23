module controllers.purchase;

import std.stdio;
// Vibed
import vibe.d;
import vibe.db.mongo.mongo;

import std.conv;
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
			render!("purchases_show.dt", purchase);
		} else {

		}
    }
    
	// GET /purchases/:_id/edit
	@method(HTTPMethod.GET)
	@path("/purchases/:_id/edit")
	void edit_form(HTTPServerRequest req, HTTPServerResponse res)
	{
		/*
		bool authenticated = ms_authenticated;
		render!("purchases_index.dt", authenticated);
		*/
		struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Purchase(Q(BsonObjectID.fromString(req.params["_id"])));
		if (! docNullable.isNull) {
			// Acessar os campos da estrutura Purchase
			Purchase purchase = docNullable.get;
			render!("purchases_edit.dt", purchase);
		}
	}

    // POST /purchases/:_id
	@method(HTTPMethod.POST)
	@path("/purchases/:_id")
	void change(HTTPServerRequest req, HTTPServerResponse res)
	{
		auto _id = BsonObjectID.fromString(req.params["_id"]);
        // filter
		BsonObjectID[string] filter;
		filter["_id"] = _id;
        // update
		Bson[string][string] update;
		update["$set"]["value"] = req.form["value"];
		update["$set"]["taxes"] = req.form["taxes"];
		update["$set"]["total"] = req.form["total"];
        update["$set"]["supplier_id"] = req.form["supplier_id"];
		update["$set"]["supplier"] = coll_supplier.findOne!Supplier(Q(BsonObjectID.fromString(req.form["supplier_id"]))).get;
		coll.updateOne(filter, update);
        res.redirect("/purchases");
	}
    
    // POST /purchases/:_id/purchase-items
	@method(HTTPMethod.POST)
	@path("/purchases/:_id/purchase-items")
	void add_item(HTTPServerRequest req, HTTPServerResponse res)
	{
		auto _id = BsonObjectID.fromString(req.params["_id"]);
        // filter
		BsonObjectID[string] filter;
		filter["_id"] = _id;
        // update
		Bson[string][string] update;
		update["$set"]["value"] = req.form["value"];
		update["$set"]["taxes"] = req.form["taxes"];
		update["$set"]["total"] = req.form["total"];
        update["$set"]["supplier_id"] = req.form["supplier_id"];
		update["$set"]["supplier"] = coll_supplier.findOne!Supplier(Q(BsonObjectID.fromString(req.form["supplier_id"]))).get;
        // TODO: Add Item to List here
		coll.updateOne(filter, update);
        res.redirect("/purchases");
	}
    
}
