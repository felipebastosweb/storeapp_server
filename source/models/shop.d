module models.shop;

import std.datetime;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

import models.user:User;
import models.purchase;
import models.order;
import models.employee;

struct Shop {
    BsonObjectID _id;
    User owner;
    string name;
    string fantasy_name;
    string slug;
    string federal_registration_number;
    string zone_registration_number;
    string municipal_registration_number;
    DateTime date_registration_status;
    string address;
    string site;
    string email;
    string phone1;
    string phone2;
    @optional Employee[int] employees;
    @optional Purchase[int] purchases;
    @optional Order[int] orders;
}