module models.customer;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

import models.order:Order;

struct Customer {
    BsonObjectID _id;
    string name;
    string social_name;
    string address;
    string phone1;
    string phone2;
    string email;
    @optional Order[] orders;
}
