module models.employee;

import std.datetime;

import models.shop:Shop;

import enums.gender;

struct Employee {
    Shop shop;
    string name;
    Gender gender;
    Date birthDate;
    double salary;
    Date admission_date;
    Date demission_date;
    Payroll[int]  payments; // array of payments made by the employee, indexed by payment number
}

struct Payroll {
    Employee employee;
    double salary;
    Date payment_date;
}