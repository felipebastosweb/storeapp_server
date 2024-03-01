module controllers.product;

import std.stdio;
// Vibed
import vibe.d;
import vibe.db.mongo.mongo;

import std.conv;
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
    
	// GET /products
	@method(HTTPMethod.GET)
	@path("/products")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("product/index.dt", authenticated);
		*/
		auto products = coll.find().sort(["name": 1]).map!(bson => deserializeBson!Product(bson));
		render!("products_index.dt", products);
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
		auto brands = coll_brand.find().sort(["name": 1]).map!(bson => deserializeBson!Brand(bson));
		render!("products_new.dt", product, brands);
	}
	
	// POST /products
    @method(HTTPMethod.POST)
	@path("/products")
	void create(HTTPServerRequest req, HTTPServerResponse res)
	{
		struct Q { BsonObjectID _id; }
		Product product;
		product._id = BsonObjectID.generate; // Gera um ID aleatório para o usuário
		product.name = req.form["name"];
		product.description = req.form["description"];
		product.model = req.form["model"];
		product.sku = req.form["sku"];
		product.ean = req.form["ean"];
		product.measure_unit = req.form["measure_unit"];
		product.width = to!double(req.form["width"]);
		product.height = to!double(req.form["height"]);
		product.length = to!double(req.form["length"]);
		product.weight = to!double(req.form["weight"]);
		product.brand_id = req.form["brand_id"];
		product.brand = coll_brand.findOne!Brand(Q(BsonObjectID.fromString(product.brand_id))).get;
		coll.insertOne(product);
        res.redirect("/products");
	}

	// GET /users/:_id
    @method(HTTPMethod.GET)
	@path("/products/:_id")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Product(Q(BsonObjectID.fromString(req.params["_id"])));
		if (! docNullable.isNull) {
			// Acessar os campos da estrutura Product
			auto product = docNullable.get;
			render!("products_show.dt", product);
		} else {

		}
    }
	
    // GET /products/:_id/delete
    @method(HTTPMethod.GET)
    @path("/products/:_id/delete")
    void delete_show(HTTPServerRequest req, HTTPServerResponse res)
    {
        /*
        bool authenticated = ms_authenticated;
        render!("product/index.dt", authenticated);
        */
        struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Product(Q(BsonObjectID.fromString(req.params["_id"])));
        if (! docNullable.isNull) {
            // Acessar os campos da estrutura Product
            Product product = docNullable.get;
            render!("products_delete.dt", product);
        }
    }

    // DELETE /products/:_id
    @method(HTTPMethod.DELETE)
    @path("/products/:_id")
    void remove(HTTPServerRequest req, HTTPServerResponse res)
    {
        /*
        bool authenticated = ms_authenticated;
        render!("product/index.dt", authenticated);
        */
		auto _id = BsonObjectID.fromString(req.params["_id"]);
		BsonObjectID[string] filter;
		filter["_id"] = _id;
        struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Product(Q(_id));
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
