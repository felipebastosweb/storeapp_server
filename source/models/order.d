module models.order;

import std.datetime;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

import models.shop:Shop;
import models.customer:Customer;

struct Order {
    BsonObjectID _id;
    Shop shop;
    string customer_id;
    @optional Customer customer;
    double total;
    DateTime request_date;
    @optional OrderItem[int] order_items;
}

struct OrderItem {
    BsonObjectID _id;
    string order_id;
    @optional Order order;
    double quantity;
    double price;
    double total;
    
}
