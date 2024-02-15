module models.address;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

struct Address {
    BsonObjectID _id;
    string location;
    string latitude;
    string longitude;
}
