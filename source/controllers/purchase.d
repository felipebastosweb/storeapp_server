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
import models.product;
import models.payment;

import translation;

class PurchaseController {
    private MongoClient client;
    MongoCollection coll;
    MongoCollection coll_shop;
    MongoCollection coll_supplier;
    MongoCollection coll_product;
    MongoCollection coll_payment_type;

    this() {
        client = connectMongoDB("127.0.0.1");
        coll = client.getCollection("storeapp.purchases");
        coll_shop = client.getCollection("storeapp.shops");
        coll_supplier = client.getCollection("storeapp.suppliers");
        coll_product = client.getCollection("storeapp.products");
        coll_payment_type = client.getCollection("storeapp.payment_types");
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
        auto purchases = coll.find()/*.sort(["purchase_date": 1])*/.map!(bson => deserializeBson!Purchase(bson));
        //writeln(purchases);
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
        SysTime today = Clock.currTime();
        purchase.purchase_date = cast(Date)today;
        purchase.entry_date = cast(Date)today;
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
        purchase._id = BsonObjectID.generate; // Gera um ID aleatório para a compra
        purchase.shop_id = req.form["shop_id"];
        purchase.supplier_id = req.form["supplier_id"];
        purchase.shop = coll_shop.findOne!Shop(Q(BsonObjectID.fromString(purchase.shop_id))).get;
        purchase.supplier = coll_supplier.findOne!Supplier(Q(BsonObjectID.fromString(purchase.supplier_id))).get;
        purchase.value = to!double(req.form["value"]);
        purchase.taxes = to!double(req.form["taxes"]);
        purchase.total = to!double(req.form["total"]);
        purchase.purchase_date = Date.fromISOExtString(req.form["purchase_date"]);
        purchase.entry_date = Date.fromISOExtString(req.form["entry_date"]);
        purchase.canceled = "canceled" in req.form ? to!bool(req.form["canceled"]) : false;
        coll.insertOne(purchase);
        res.redirect("/purchases");
    }
    
    // GET /purchases/:_id
    @method(HTTPMethod.GET)
    @path("/purchases/:_id")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
        struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Purchase(Q(BsonObjectID.fromString(req.params["_id"])));
        if (! docNullable.isNull) {
            // Acessar os campos da estrutura Customer
            auto purchase = docNullable.get;
            /*
            auto item = PurchaseItem();
            item.product = Product();
            item.product.name = "Camiseta Básica";
            item.price = 50;
            item.quantity = 1;
            item.total = 50;
            purchase.purchase_items ~= item;
            purchase.purchase_items ~= item;
            */
            auto new_item = PurchaseItem();
            auto new_payment = PurchasePayment();
            auto products = coll_product.find().map!(bson => deserializeBson!Product(bson));
            auto payment_types = coll_payment_type.find().map!(bson => deserializeBson!PaymentType(bson));
            render!("purchases_show.dt", purchase, new_item, new_payment, products, payment_types);
        }
        else {

        }
    }

    
    // GET /purchases/:_id/edit
    @method(HTTPMethod.GET)
    @path("/purchases/:_id/edit")
    void edit_form(HTTPServerRequest req, HTTPServerResponse res)
    {
        /*
        bool authenticated = ms_authenticated;
        render!("shop_index.dt", authenticated);
        */
        struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Purchase(Q(BsonObjectID.fromString(req.params["_id"])));
        if (! docNullable.isNull) {
            // Acessar os campos da estrutura Purchase
            Purchase purchase = docNullable.get;
            auto shops = coll_shop.find().map!(bson => deserializeBson!Shop(bson));
            auto suppliers = coll_supplier.find().map!(bson => deserializeBson!Supplier(bson));
            render!("purchases_edit.dt", purchase, shops, suppliers);
        }
    }

    // POST /purchases/:_id
    @method(HTTPMethod.POST)
    @path("/purchases/:_id")
    void change(HTTPServerRequest req, HTTPServerResponse res)
    {
        struct Q { BsonObjectID _id; }
        auto _id = BsonObjectID.fromString(req.params["_id"]);
        // filter
        BsonObjectID[string] filter;
        filter["_id"] = _id;
        // update
        Bson[string][string] update;
        // TODO: change shop
        update["$set"]["shop_id"] = req.form["shop_id"];
        auto shop = coll_shop.findOne!Shop(Q(BsonObjectID.fromString(req.form["shop_id"]))).get;
        update["$set"]["shop"] = shop.serializeToBson();
        // TODO: change supplier
        update["$set"]["supplier_id"] = req.form["supplier_id"];
        auto supplier = coll_supplier.findOne!Supplier(Q(BsonObjectID.fromString(req.form["supplier_id"]))).get;
        update["$set"]["supplier"] = supplier.serializeToBson();
        // TODO: bug value in modeel is double and in base is string
        // Quando era editado a compra estava dando erro tipo string quando esperado double
        update["$set"]["value"] = to!double(req.form["value"]);
        update["$set"]["taxes"] = to!double(req.form["taxes"]);
        update["$set"]["total"] = to!double(req.form["total"]);
        // Agora, não dá erro mas não localiza o doc
        update["$set"]["purchase_date"] = req.form["purchase_date"];
        update["$set"]["entry_date"] = req.form["entry_date"];
        update["$set"]["canceled"] = "canceled" in req.form ? to!bool(req.form["canceled"]) : false;
        coll.updateOne(filter, update);
        res.redirect("/purchases");
    }
    
    /*
    // GET /purchases/:_id/purchase-items/new
    @method(HTTPMethod.GET)
    @path("/purchases/:_id/purchase-items/new")
    void item_new_form(HTTPServerRequest req, HTTPServerResponse res)
    {
        struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Purchase(Q(BsonObjectID.fromString(req.params["_id"])));
        if (! docNullable.isNull) {
            // Acessar os campos da estrutura Purchase
            auto purchase_item = PurchaseItem();
            Purchase purchase = docNullable.get;
            auto products = coll_product.find().map!(bson => deserializeBson!Product(bson));
            render!("purchases_item_new.dt", purchase, purchase_item, products);
        }
    }
    */

    // POST /purchases/:_id/add-item
    @method(HTTPMethod.POST)
    @path("/purchases/:_id/add-item")
    void add_item(HTTPServerRequest req, HTTPServerResponse res)
    {
        struct Q { BsonObjectID _id; }
        auto _id = BsonObjectID.fromString(req.params["_id"]);
        // filter
        BsonObjectID[string] filter;
        filter["_id"] = _id;
        auto docNullable = coll.findOne!Purchase(Q(BsonObjectID.fromString(req.params["_id"])));
        if (! docNullable.isNull) {
            auto purchase = docNullable.get;
            auto product = coll_product.findOne!Product(Q(BsonObjectID.fromString(req.form["product_id"]))).get;
            auto item = PurchaseItem();
            item._id = BsonObjectID.generate;
            item.product_id = req.form["product_id"];
            item.product = product;
            item.price = to!double(req.form["price"]);
            item.quantity = to!double(req.form["quantity"]);
            item.total = to!double(req.form["total"]);
            // add the item to the order
            purchase.purchase_items ~= item;
            // BUG: recalculates the value based on item totals
            purchase.value = purchase.value + item.total;
            // TODO: apply the fees to the order
            purchase.total = purchase.value + purchase.taxes;
            // TODO: update items
            Bson[string][string] update;
            update["$set"]["value"] = purchase.value;
            // fees that apply to the order
            update["$set"]["taxes"] = purchase.taxes;
            update["$set"]["total"] = purchase.total;
            update["$set"]["purchase_items"] = purchase.purchase_items.serializeToBson();
            coll.updateOne(filter, update);
            res.redirect("/purchases");
        }
    }
    
    // POST /purchases/:_id/change-item:_item_id
    @method(HTTPMethod.POST)
    @path("/purchases/:_id/change-item/:_item_id")
    void change_item(HTTPServerRequest req, HTTPServerResponse res)
    {
        struct Q { BsonObjectID _id; }
        auto _id = BsonObjectID.fromString(req.params["_id"]);
        // filter
        BsonObjectID[string] filter;
        filter["_id"] = _id;
        auto docNullable = coll.findOne!Purchase(Q(BsonObjectID.fromString(req.params["_id"])));
        if (! docNullable.isNull) {
            auto purchase = docNullable.get;
            foreach (item; purchase.purchase_items) {
                if (item._id == BsonObjectID.fromString(req.params["_item_id"]))
                {
                    item.quantity = to!double(req.form["quantity"]);
                    if (item.quantity < 1) {
                        // BUG: remove item from purchase_items list
                        //purchase.purchase_items.remove(item);
                    }
                    else {
                        item.price = to!double(req.form["price"]);
                        item.total = item.quantity * item.price;
                    }
                }
            }
            // TODO: set total and value of purchase accordingly
            // TODO: update the purchase
            Bson[string][string] update;
            // sum of all item's totals
            update["$set"]["value"] = purchase.value;
            // fees that apply to the order
            update["$set"]["taxes"] = purchase.taxes;
            update["$set"]["total"] = purchase.total;
            update["$set"]["purchase_items"] = purchase.purchase_items.serializeToBson();
            coll.updateOne(filter, update);
            res.redirect("/purchases");
        }
    }

    // POST /purchases/:_id/purchase-payments
    @method(HTTPMethod.POST)
    @path("/purchases/:_id/purchase-payments")
    void change_payments(HTTPServerRequest req, HTTPServerResponse res)
    {
        auto _id = BsonObjectID.fromString(req.params["_id"]);
        // filter
        BsonObjectID[string] filter;
        filter["_id"] = _id;
        // TODO: find purchase
        // TODO: set payments
        // update payments
        Bson[string][string] update;
        update["$set"]["purchase_payments"] = req.form["purchase_payments"];
        coll.updateOne(filter, update);
        res.redirect("/purchases");
    }
    
    // GET /purchases/:_id/delete
    @method(HTTPMethod.GET)
    @path("/purchases/:_id/delete")
    void delete_show(HTTPServerRequest req, HTTPServerResponse res)
    {
        /*
        bool authenticated = ms_authenticated;
        render!("purchases/index.dt", authenticated);
        */
        struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Purchase(Q(BsonObjectID.fromString(req.params["_id"])));
        if (! docNullable.isNull) {
            // Acessar os campos da estrutura Supplier
            Purchase purchase = docNullable.get;
            render!("purchases_delete.dt", purchase);
        }
    }

    // DELETE /purchases/:_id
    @method(HTTPMethod.DELETE)
    @path("/purchases/:_id")
    void remove(HTTPServerRequest req, HTTPServerResponse res)
    {
        /*
        bool authenticated = ms_authenticated;
        render!("purchases/index.dt", authenticated);
        */
        auto _id = BsonObjectID.fromString(req.params["_id"]);
        BsonObjectID[string] filter;
        filter["_id"] = _id;
        struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Purchase(Q(_id));
        if (! docNullable.isNull) {
            auto deleteNullable = coll.deleteOne(filter);
            if (deleteNullable.deletedCount == 1) {
                // Definir status de resposta para "No Content"
                res.statusCode = 204;
                res.writeBody("Erro ao excluir a compra.");
            } else {
                // Não foi possível excluir a compra
                res.statusCode = 500;
                res.writeBody("Erro ao excluir a compra.");
            }
        }
        else {
            res.statusCode = 404;
            res.writeBody("Usuário não encontrado.");
        }
    }
}
