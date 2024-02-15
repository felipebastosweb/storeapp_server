module models.customer;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

import models.order:Order;

struct Customer {
    BsonObjectID _id;
    string name;
    string address;
    string phone;
    string email;
    @optional Order[int] orders;
}
