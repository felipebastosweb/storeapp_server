module models.supplier;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

import models.purchase:Purchase;

struct Supplier {
    BsonObjectID _id;
    string name;
    string address;
    string phone;
    string site;
    string email;
    @optional Purchase[int] purchases;
}
