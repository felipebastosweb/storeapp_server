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
    
	// GET /suppliers
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

    
	// GET /suppliers/new
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
    

	// POST /suppliers
    @method(HTTPMethod.POST)
	@path("/suppliers")
	void create(HTTPServerRequest req, HTTPServerResponse res)
	{
		Supplier supplier;
		supplier._id = BsonObjectID.generate; // Gera um ID aleatório para o usuário
		supplier.name = req.form["name"];
		supplier.description = req.form["description"];
		supplier.address = req.form["address"];
		supplier.email = req.form["email"];
		supplier.site = req.form["site"];
		supplier.phone1 = req.form["phone1"];
		supplier.phone2 = req.form["phone2"];
		coll.insertOne(supplier);
        res.redirect("/suppliers");
	}
    
	// GET /suppliers/:_id/edit
	@method(HTTPMethod.GET)
	@path("/suppliers/:_id/edit")
	void edit_form(HTTPServerRequest req, HTTPServerResponse res)
	{
		/*
		bool authenticated = ms_authenticated;
		render!("supplier/index.dt", authenticated);
		*/
		struct Q { BsonObjectID _id = BsonObjectID.fromString(req.params["_id"]); }
        auto docNullable = coll.findOne!Supplier(Q());
		if (! docNullable.isNull) {
			// Acessar os campos da estrutura Brand
			Supplier supplier = docNullable.get;
			render!("suppliers_edit.dt", supplier);
		}
	}

    // POST /suppliers/:_id
	@method(HTTPMethod.POST)
	@path("/suppliers/:_id")
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
        res.redirect("/suppliers");
	}
}
