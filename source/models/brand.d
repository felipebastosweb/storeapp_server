module models.brand;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

import models.product:Product;

struct Brand {
    BsonObjectID _id;
    string name;
    string address;
    string phone1;
    string phone2;
    string site;
    string email;
    @optional Product[int] products;
}
