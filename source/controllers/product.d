module controllers.product;

import std.stdio;
// Vibed
import vibe.d;
import vibe.db.mongo.mongo;

import std.algorithm: map;

import database;
import models.product;
import models.brand;

import translation;

class ProductController {
    private MongoClient client;
	MongoCollection coll;
	MongoCollection coll_brand;

	this() {
		client = connectMongoDB("127.0.0.1");
		coll = client.getCollection("storeapp.products");
		coll_brand = client.getCollection("storeapp.brands");
    }
    
	// GET /
	@method(HTTPMethod.GET)
	@path("/products")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("product/index.dt", authenticated);
		*/
		auto products = coll.find().map!(bson => deserializeBson!Product(bson));
		render!("products_index.dt", products);
	}
	

	// GET /users/:usernameeeeeeeee
    @method(HTTPMethod.GET)
	@path("/products/:sku")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { string sku; }
        auto productNullable = coll.findOne!Product(Q(req.params["sku"]));
		if (! productNullable.isNull) {
			// Acessar os campos da estrutura Product
			auto product = productNullable.get;
			render!("products_show.dt", product);
		} else {

		}
    }
	
	// GET /
	@method(HTTPMethod.GET)
	@path("/products/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("product_index.dt", authenticated);
		*/
        auto product = Product();
		auto brands = coll_brand.find().map!(bson => deserializeBson!Brand(bson));
		render!("products_new.dt", product, brands);
	}
}
