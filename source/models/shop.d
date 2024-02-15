module models.shop;

import models.user:User;

struct Shop {
    User owner;
    string name;
    string fantasy_name;
    string address;
    string phone;
    string email;
    string site;
}