module models.product;

import models.brand:Brand;
import models.purchase:PurchaseItem;

/** 
 * Cores: Preta, Vermelha, Branca, Laranja, etc
 * Tamanhos: 39-40, 41-42, 43-44
 */

struct Option {
    string name;
    string description;
    OptionValue[int] option_values;
}

struct OptionValue {
    Option option;
    string name;
}

struct MeasureUnit {
    string name;
}

struct Product {
    string name;
    string description;
    Brand brand;
    PurchaseItem[int] purchase_items;
    ProductMeasure[int] product_measure;
    OptionValue[int] option_values;
}

struct ProductMeasure {
    Product product;
    MeasureUnit measure_unit;
    double width;
    double height;
    double length;
    double weight;
}