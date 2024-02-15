module models.product;

import vibe.d;
import vibe.data.serialization;
import vibe.db.mongo.mongo;

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
    Option option;
    string name;
    @optional ProductWithOption[] product_with_options;
}

struct MeasureUnit {
    string name;
}

struct Product {
    BsonObjectID _id;
    string name;
    string description;
    Brand brand;
    ProductMeasure[int] product_measure;
    ProductWithOption[] product_with_options;
}

struct ProductWithOption {
    BsonObjectID _id;
    Product product;
    PurchaseItem[int] purchase_items;
    OptionValue[int] option_values;
}

struct ProductMeasure {
    BsonObjectID _id;
    Product product;
    MeasureUnit measure_unit;
    double width;
    double height;
    double length;
    double weight;
}
