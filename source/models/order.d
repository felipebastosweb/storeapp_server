module models.order;

import std.datetime;

import models.shop:Shop;
import models.customer:Customer;

struct Order {
    Shop shop;
    Customer customer;
    double total;
    DateTime request_date;
}