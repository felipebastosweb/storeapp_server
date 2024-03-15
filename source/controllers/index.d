module controllers.index;

import std.stdio;
import std.algorithm: map;

import vibe.db.mongo.mongo;

import models.user;

import vibe.http.router;
import vibe.http.server;
import vibe.web.web;

//import translation;

//@translationContext!TranslationContext
class IndexController {
    private MongoClient client;
    MongoCollection coll_users;
    /*
    private {
        // stored in the session store
        SessionVar!(bool, "authenticated") ms_authenticated;
    }
    */
    this() {
        client = connectMongoDB("127.0.0.1");
    }
    
    // GET /
    @method(HTTPMethod.GET) @path("/")
    void index()
    {
        /*
        bool authenticated = ms_authenticated;
        render!("home/index.dt", authenticated);
        */
        auto total_users = client.getCollection("storeapp.users").estimatedDocumentCount();
        auto total_shops = client.getCollection("storeapp.shops").estimatedDocumentCount();
        auto total_brands = client.getCollection("storeapp.brands").estimatedDocumentCount();
        auto total_suppliers = client.getCollection("storeapp.suppliers").estimatedDocumentCount();
        auto total_products = client.getCollection("storeapp.products").estimatedDocumentCount();
        auto total_customers = client.getCollection("storeapp.customers").estimatedDocumentCount();
        auto total_purchases = client.getCollection("storeapp.purchases").estimatedDocumentCount();
        auto total_orders = client.getCollection("storeapp.orders").estimatedDocumentCount();
        //writeln(count(total_users));
        //render!("home_index.dt", total_users);
        render!("home_index.dt", total_users, total_shops, total_brands,
            total_suppliers, total_products, total_customers, total_purchases, total_orders);
    }
}