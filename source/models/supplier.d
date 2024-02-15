module models.supplier;

import models.purchase:Purchase;

struct Supplier {
    string name;
    string address;
    string phone;
    string site;
    string email;
    Purchase[int] purchases;
}