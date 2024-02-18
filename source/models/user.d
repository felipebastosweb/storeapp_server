module models.user;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

import models.shop:Shop;

struct User {
    BsonObjectID _id;
    string username;
    string password;
    string email;
    string phone;
    @optional Shop[] shops;
    @optional Role[] roles;
}

struct Role {
    BsonObjectID _id;
    string name;
    string description;
    @optional User[] users;
    @optional Permission[] permissions;
}

struct Permission {
    BsonObjectID _id;
    string name;
    string description;
}
