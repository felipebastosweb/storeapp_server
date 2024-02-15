module models.brand;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;


struct Brand {
    BsonObjectID _id;
    string name;
    string address;
    string phone;
    string site;
    string email;
    @optional Product[int] products;
}
