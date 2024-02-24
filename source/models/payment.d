module models.payment;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

struct PaymentType {
    BsonObjectID _id;
    string name;
}
