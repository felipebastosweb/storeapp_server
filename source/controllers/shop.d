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
import models.user;

class ShopController {

    private MongoClient client;
    MongoCollection coll;
    MongoCollection coll_user;

    this() {
        client = connectMongoDB("127.0.0.1");
        coll = client.getCollection("storeapp.shops");
        coll_user = client.getCollection("storeapp.users");
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
        SysTime today = Clock.currTime();
        shop.date_registration_status = cast(Date)today;
        auto users = coll_user.find().map!(bson => deserializeBson!User(bson));
        render!("shops_new.dt", shop, users);
    }

    // GET /shops/:_id
    @method(HTTPMethod.GET)
    @path("/shops/:_id")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
        struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Shop(Q(BsonObjectID.fromString(req.params["_id"])));
        if (! docNullable.isNull) {
            // Acessar os campos da estrutura Customer
            auto shop = docNullable.get;
            render!("shops_show.dt", shop);
        } else {

        }
    }

    // POST /shops
    @method(HTTPMethod.POST)
    @path("/shops")
    void create(HTTPServerRequest req, HTTPServerResponse res)
    {
        struct Q { BsonObjectID _id; }
        Shop shop;
        shop._id = BsonObjectID.generate; // Gera um ID aleatório para a loja
        shop.user_id = req.form["user_id"];
        shop.user = coll_user.findOne!User(Q(BsonObjectID.fromString(shop.user_id))).get;
        shop.name = req.form["name"];
        shop.fantasy_name = req.form["fantasy_name"];
        shop.federal_registration_number = req.form["federal_registration_number"];
        shop.zone_registration_number = req.form["zone_registration_number"];
        shop.municipal_registration_number = req.form["municipal_registration_number"];
        shop.date_registration_status = Date.fromISOExtString(req.form["date_registration_status"]);
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
        struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Shop(Q(BsonObjectID.fromString(req.params["_id"])));
        if (! docNullable.isNull) {
            // Acessar os campos da estrutura Brand
            Shop shop = docNullable.get;
            auto users = coll_user.find().map!(bson => deserializeBson!User(bson));
            render!("shops_edit.dt", shop, users);
        }
    }

    // POST /shops/:_id
    @method(HTTPMethod.POST)
    @path("/shops/:_id")
    void change(HTTPServerRequest req, HTTPServerResponse res)
    {
        struct Q { BsonObjectID _id; }
        auto _id = BsonObjectID.fromString(req.params["_id"]);
        // filter
        BsonObjectID[string] filter;
        filter["_id"] = _id;
        // update
        Bson[string][string] update;
        update["$set"]["user_id"] = req.form["user_id"];
		auto user = coll_user.findOne!User(Q(BsonObjectID.fromString(req.form["user_id"]))).get;
        update["$set"]["user"] = user.serializeToBson();
        update["$set"]["name"] = req.form["name"];
        update["$set"]["fantasy_name"] = req.form["fantasy_name"];
        update["$set"]["federal_registration_number"] = req.form["federal_registration_number"];
        update["$set"]["zone_registration_number"] = req.form["zone_registration_number"];
        update["$set"]["municipal_registration_number"] = req.form["municipal_registration_number"];
        update["$set"]["date_registration_status"] = req.form["date_registration_status"];
        update["$set"]["address"] = req.form["address"];
        update["$set"]["site"] = req.form["site"];
        update["$set"]["email"] = req.form["email"];
        update["$set"]["phone1"] = req.form["phone1"];
        update["$set"]["phone2"] = req.form["phone2"];
        coll.updateOne(filter, update);
        res.redirect("/shops");
    }
    
    // GET /shops/:_id/delete
    @method(HTTPMethod.GET)
    @path("/shops/:_id/delete")
    void delete_show(HTTPServerRequest req, HTTPServerResponse res)
    {
        /*
        bool authenticated = ms_authenticated;
        render!("shops/index.dt", authenticated);
        */
        struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Shop(Q(BsonObjectID.fromString(req.params["_id"])));
        if (! docNullable.isNull) {
            // Acessar os campos da estrutura shop
            Shop shop = docNullable.get;
            render!("shops_delete.dt", shop);
        }
    }

    // DELETE /shops/:_id
    @method(HTTPMethod.DELETE)
    @path("/shops/:_id")
    void remove(HTTPServerRequest req, HTTPServerResponse res)
    {
        /*
        bool authenticated = ms_authenticated;
        render!("shops/index.dt", authenticated);
        */
        auto _id = BsonObjectID.fromString(req.params["_id"]);
        BsonObjectID[string] filter;
        filter["_id"] = _id;
        struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Shop(Q(_id));
        // try to delete just 1 time
        if (! docNullable.isNull) {
            auto deleteNullable = coll.deleteOne(filter);
            if (deleteNullable.deletedCount == 1) {
                // Definir status de resposta para "No Content"
                res.statusCode = 204;
                res.writeBody("Erro ao excluir a loja.");
            } else {
                // Não foi possível excluir a loja
                res.statusCode = 500;
                res.writeBody("Erro ao excluir a loja.");
            }
        }
        else {
            res.statusCode = 404;
            res.writeBody("Loja não encontrada.");
        }
    }
}
