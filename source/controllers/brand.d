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
    
	// GET /brands
	@method(HTTPMethod.GET)
	@path("/brands")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("user/index.dt", authenticated);
		*/
		auto brands = coll.find().sort(["name": 1]).map!(bson => deserializeBson!Brand(bson));
		render!("brands_index.dt", brands);
	}
	
	// GET /brands/new
	@method(HTTPMethod.GET)
	@path("/brands/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("user/index.dt", authenticated);
		*/
		auto brand = Brand();
		render!("brands_new.dt", brand);
	}
	
	// POST /brands
    @method(HTTPMethod.POST)
	@path("/brands")
	void create(HTTPServerRequest req, HTTPServerResponse res)
	{
		Brand brand;
		brand._id = BsonObjectID.generate; // Gera um ID aleatório para o usuário
		brand.name = req.form["name"];
		brand.description = req.form["description"];
		//brand.address = req.form["address"];
		brand.email = req.form["email"];
		brand.site = req.form["site"];
		brand.phone1 = req.form["phone1"];
		brand.phone2 = req.form["phone2"];
		coll.insertOne(brand);
        res.redirect("/brands");
	}

	// GET /brands/:_id
    @method(HTTPMethod.GET)
	@path("/brands/:_id")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { BsonObjectID _id; }
        auto brandNullable = coll.findOne!Brand(Q(BsonObjectID.fromString(req.params["_id"])));
		if (! brandNullable.isNull) {
			// Acessar os campos da estrutura Customer
			auto brand = brandNullable.get;
			render!("brands_show.dt", brand);
		} else {

		}
    }

    
	// GET /brands/:_id/edit
	@method(HTTPMethod.GET)
	@path("/brands/:_id/edit")
	void edit_form(HTTPServerRequest req, HTTPServerResponse res)
	{
		/*
		bool authenticated = ms_authenticated;
		render!("brand/index.dt", authenticated);
		*/
		struct Q { BsonObjectID _id; }
        auto brandNullable = coll.findOne!Brand(Q(BsonObjectID.fromString(req.params["_id"])));
		if (! brandNullable.isNull) {
			// Acessar os campos da estrutura Brand
			Brand brand = brandNullable.get;
			render!("brands_edit.dt", brand);
		}
	}

    // POST /brands/:_id
	@method(HTTPMethod.POST)
	@path("/brands/:_id")
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
        res.redirect("/brands");
	}
    
}
