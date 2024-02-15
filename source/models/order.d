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
    Customer customer;
    double total;
    DateTime request_date;
    @optional Order[int] orders;
}

struct OrderItem {
    BsonObjectID _id;
    Order order;
    double quantity;
    double price;
    double total;
    
}
