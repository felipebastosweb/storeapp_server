module models.customer;

import models.order:Order;

struct Customer {
    string name;
    string address;
    string phone;
    string email;
    Order[int] orders;
}