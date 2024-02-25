module models.purchase;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

// https://www.shipbob.com/blog/ship-date/

import enums.payment_status;

import models.shop:Shop;
import models.supplier:Supplier;
import models.product:OptionValue, Product;
import models.payment;

struct Purchase {
    BsonObjectID _id;
    string shop_id;
    string supplier_id;
    @optional Shop shop;
    @optional Supplier supplier;
    double value;
    double taxes;
    double total;
    Date purchase_date; // data da compra
    Date entry_date; // data de recebimento do produto (entrada no estoque)
    @optional PurchaseItem[] purchase_items;
    @optional PurchasePayment[] purchase_payments;
}


struct PurchasePayment {
    BsonObjectID _id;
    string payment_type_id;
    PaymentType payment_type;
    double value;
    DateTime deadline_date;  //Pagamento deve ser realizado até essa data e hora (prazo)
    DateTime pay_date;  //Data de efetivação do pagamento
    PaymentStatus status = PaymentStatus.Pending; // 0 - pending
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
    @optional PurchaseItemProduct[] purchase_item_products;
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

