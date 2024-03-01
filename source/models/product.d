module models.product;

import vibe.d;
import vibe.data.serialization;
import std.algorithm;
import vibe.db.mongo.mongo;

import enums.measure;

import models.brand:Brand;
import models.purchase:PurchaseItem;

/** 
 * Cores: Preta, Vermelha, Branca, Laranja, etc
 * Tamanhos: 39-40, 41-42, 43-44
 */

struct Option {
    BsonObjectID _id;
    string name;
    string description;
    @optional OptionValue[int] option_values;
}

struct OptionValue {
    BsonObjectID _id;
    string option_id;
    @optional Option option;
    string name;
    @optional ProductWithOption[] product_with_options;
}

struct Product {
    BsonObjectID _id;
    string name;
    string model;
    string description;
    string sku;
    string ean;
    string brand_id; // obter id de  BsonObjectID Brand._Id
    @optional Brand brand;
    string measure_unit; // obter string de enum Measure
    double width = 0;
    double height = 0;
    double length = 0;
    double weight = 0;
    @optional ProductWithOption[] product_with_options;
}

struct ProductWithOption {
    BsonObjectID _id;
    string product_id;
    @optional Product product;
    @optional PurchaseItem[] purchase_items;
    @optional OptionValue[] option_values;
}

