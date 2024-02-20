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
        auto shopNullable = coll.findOne!Shop(Q(req.params["slug"]));
		if (! shopNullable.isNull) {
			// Acessar os campos da estrutura Customer
			auto shop = shopNullable.get;
			render!("shops_show.dt", shop);
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

	// POST /shops
    @method(HTTPMethod.POST)
	@path("/shops")
	void create(HTTPServerRequest req, HTTPServerResponse res)
	{
		Shop shop;
		shop._id = BsonObjectID.generate; // Gera um ID aleatório para o usuário
		shop.name = req.form["name"];
		shop.description = req.form["description"];
		shop.address = req.form["address"];
		shop.email = req.form["email"];
		shop.site = req.form["site"];
		shop.phone1 = req.form["phone1"];
		shop.phone2 = req.form["phone2"];
		coll.insertOne(shop);
        res.redirect("/shops");
	}
    
	// GET /shops/:_id/edit
	@method(HTTPMethod.GET)
	@path("/shops/:_id/edit")
	void edit_form(HTTPServerRequest req, HTTPServerResponse res)
	{
		/*
		bool authenticated = ms_authenticated;
		render!("shop_index.dt", authenticated);
		*/
		struct Q { BsonObjectID _id = BsonObjectID.fromString(req.params["_id"]); }
        auto shopNullable = coll.findOne!Shop(Q());
		if (! shopNullable.isNull) {
			// Acessar os campos da estrutura Brand
			Shop shop = shopNullable.get;
			render!("shops_edit.dt", shop);
		}
	}

    // POST /shops/:_id
	@method(HTTPMethod.POST)
	@path("/shops/:_id")
	void change(HTTPServerRequest req, HTTPServerResponse res)
	{
		auto _id = BsonObjectID.fromString(req.params["_id"]);
        // filter
		BsonObjectID[string] filter;
		filter["_id"] = _id;
        // update
		Bson[string][string] update;
		update["$set"]["name"] = req.form["name"];
		update["$set"]["description"] = req.form["description"];
		update["$set"]["address"] = req.form["address"];
		update["$set"]["site"] = req.form["site"];
		update["$set"]["email"] = req.form["email"];
		update["$set"]["phone1"] = req.form["phone1"];
		update["$set"]["phone2"] = req.form["phone2"];
		coll.updateOne(filter, update);
        res.redirect("/shops");
	}
    
}
