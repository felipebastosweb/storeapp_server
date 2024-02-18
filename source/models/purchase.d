module models.purchase;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

import models.shop:Shop;
import models.supplier:Supplier;
import models.product:OptionValue, Product;

struct Purchase {
    BsonObjectID _id;
    string shop_id;
    string supplier_id;
    @optional Shop shop;
    @optional Supplier supplier;
    double value;
    double taxes;
    double total;
    Date purchase_date;
    @optional PurchaseItem[int] purchase_items;
}

struct PurchaseItem {
    BsonObjectID _id;
    string purchase_id;
    string product_id;
    @optional Purchase purchase;
    @optional Product product;
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
    string purchase_item_id;
    @optional PurchaseItem purchase_item;
    double purchase_price;
    double order_price;
    @optional OptionValue[string] option_values;
}

