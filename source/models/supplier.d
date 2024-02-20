module models.supplier;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

import models.purchase:Purchase;

struct Supplier {
    BsonObjectID _id;
    string name;
    string description;
    string address;
    string phone1;
    string phone2;
    string site;
    string email;
    @optional Purchase[] purchases;
}
