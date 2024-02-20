module models.employee;

import std.datetime;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

import models.shop:Shop;

import enums.gender;

struct Employee {
    BsonObjectID _id;
    string shop_id;
    @optional Shop shop;
    string name;
    Gender gender;
    Date birthDate;
    double salary;
    string address;
    string email;
    string phone1;
    string phone2;
    Date admission_date;
    Date demission_date;
    @optional Payroll[int]  payments; // array of payments made by the employee, indexed by payment number
}

struct Payroll {
    BsonObjectID _id;
    Employee employee;
    double salary;
    Date payment_date;
}
