module models.user;

import vibe.data.serialization;
import vibe.db.mongo.mongo;

import models.shop:Shop;

struct User {
    BsonObjectID _id;
    string username;
    string password;
    string email;
    @optional Shop[int] shops;
    @optional Role[int] roles;
}

struct Role {
    string name;
    string description;
    @optional User[int] users;
    @optional Permission[int] permissions;
}

struct Permission {
    string name;
    string description;
}