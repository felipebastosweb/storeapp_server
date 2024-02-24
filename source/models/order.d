module models.order;

import std.datetime;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

import enums.payment_status;

import models.shop:Shop;
import models.customer:Customer;
import models.product;
import models.payment:PaymentType;

struct Order {
    BsonObjectID _id;
    string shop_id;
    @optional Shop shop;
    string customer_id;
    @optional Customer customer;
    double value;
    double taxes;
    double total;
    DateTime request_date;
    @optional OrderItem[] order_items;
    @optional OrderPayment[] order_payments;
}

struct OrderItem {
    BsonObjectID _id;
    string order_id;
    @optional Order order;
    string product_id;
    @optional Product product;
    double value;
    double quantity;
    double total;
    
}

struct OrderPayment {
    BsonObjectID _id;
    string payment_type_id;
    PaymentType payment_type;
    double value;
    DateTime deadline_date;  //Pagamento deve ser realizado até essa data e hora (prazo)
    DateTime pay_date;  //Data de efetivação do pagamento
    PaymentStatus status = PaymentStatus.Pending; // 0 - pending
}