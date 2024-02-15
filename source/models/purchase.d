module models.purchase;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

import models.shop:Shop;
import models.supplier:Supplier;
import models.product:OptionValue, Product;

struct Purchase {
    BsonObjectID _id;
    Shop shop;
    Supplier supplier;
    double value;
    double taxes;
    double total;
    @optional PurchaseItem[int] purchase_items;
}

struct PurchaseItem {
    BsonObjectID _id;
    Purchase purchase;
    Product product;
    double quantity;
    double price;
    double total;
    @optional PurchaseItemProduct[int] purchase_item_products;
}

/** 
 * code é um código único para diferenciar os itens (pode ser fra)
 * OptionValue[string] é igual a OptionValue[Option.name]
 */
struct PurchaseItemProduct {
    BsonObjectID _id;
    string code;
    PurchaseItem purchase_item;
    double purchase_price;
    double order_price;
    @optional OptionValue[string] option_values;
}

