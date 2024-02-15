module models.employee;

import std.datetime;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

import models.shop:Shop;

import enums.gender;

struct Employee {
    BsonObjectID _id;
    Shop shop;
    string name;
    Gender gender;
    Date birthDate;
    double salary;
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
