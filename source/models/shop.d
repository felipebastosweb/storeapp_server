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
    string user_id;
    @optional User user;
    string name;
    string fantasy_name;
    string federal_registration_number;
    string zone_registration_number;
    string municipal_registration_number;
    Date date_registration_status;
    string address;
    string site;
    string email;
    string phone1;
    string phone2;
    @optional Employee[] employees;
    @optional Purchase[] purchases;
    @optional Order[] orders;
}