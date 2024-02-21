module controllers.customer;

import std.stdio;
// Vibed
import vibe.d;
import vibe.db.mongo.mongo;

import std.algorithm: map;

import database;
import models.customer;

import translation;

class CustomerController {
	private MongoClient client;
	MongoCollection coll;

	this() {
		client = connectMongoDB("127.0.0.1");
		coll = client.getCollection("storeapp.customers");
	}
    
	// GET /
	@method(HTTPMethod.GET)
	@path("/customers")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("customer_index.dt", authenticated);
		*/
		auto customers = coll.find().map!(bson => deserializeBson!Customer(bson));
		render!("customers_index.dt", customers);
	}
	

	// GET /customers/:_id
    @method(HTTPMethod.GET)
	@path("/customers/:_id")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { string _id; }
        auto docNullable = coll.findOne!Customer(Q(req.params["_id"]));
		if (! docNullable.isNull) {
			// Acessar os campos da estrutura Customer
			auto customer = docNullable.get;
			render!("customers_show.dt", customer);
		} else {

		}
    }
	
	// GET /customers/new
	@method(HTTPMethod.GET)
	@path("/customers/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("customer_index.dt", authenticated);
		*/
		auto customer = Customer();
		render!("customers_new.dt", customer);
	}
    
	// POST /customers
    @method(HTTPMethod.POST)
	@path("/customers")
	void create(HTTPServerRequest req, HTTPServerResponse res)
	{
		Customer customer;
		customer._id = BsonObjectID.generate; // Gera um ID aleatório para o usuário
		customer.name = req.form["name"];
		customer.social_name = req.form["social_name"];
		customer.address = req.form["address"];
		customer.email = req.form["email"];
		customer.phone1 = req.form["phone1"];
		customer.phone2 = req.form["phone2"];
		coll.insertOne(customer);
        res.redirect("/customers");
	}
    
	// GET /customers/:_id/edit
	@method(HTTPMethod.GET)
	@path("/customers/:_id/edit")
	void edit_form(HTTPServerRequest req, HTTPServerResponse res)
	{
		/*
		bool authenticated = ms_authenticated;
		render!("customer/index.dt", authenticated);
		*/
		struct Q { string _id; }
        auto docNullable = coll.findOne!Customer(Q(req.params["_id"]));
		if (! docNullable.isNull) {
			// Acessar os campos da estrutura Brand
			Customer customer = docNullable.get;
			render!("customers_edit.dt", customer);
		}
	}

    // POST /customers/:_id
	@method(HTTPMethod.POST)
	@path("/customers/:_id")
	void change(HTTPServerRequest req, HTTPServerResponse res)
	{
		auto _id = BsonObjectID.fromString(req.params["_id"]);
        // filter
		BsonObjectID[string] filter;
		filter["_id"] = _id;
        // update
		Bson[string][string] update;
		update["$set"]["name"] = req.form["name"];
		update["$set"]["social_name"] = req.form["social_name"];
		update["$set"]["address"] = req.form["address"];
		update["$set"]["email"] = req.form["email"];
		update["$set"]["phone1"] = req.form["phone1"];
		update["$set"]["phone2"] = req.form["phone2"];
		coll.updateOne(filter, update);
        res.redirect("/customers");
	}
    
}
