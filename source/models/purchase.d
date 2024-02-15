module models.purchase;

import models.shop:Shop;
import models.supplier:Supplier;
import models.product:OptionValue, Product;

struct Purchase {
    Shop shop;
    Supplier supplier;
    double value;
    double taxes;
    double total;
    PurchaseItem[int] purchase_items;
}

struct PurchaseItem {
    Purchase purchase;
    Product product;
    double quantity;
    double price;
    double total;
    PurchaseItemProduct[int] purchase_item_products;
}

/** 
 * code é um código único para diferenciar os itens (pode ser fra)
 * OptionValue[string] é igual a OptionValue[Option.name]
 */
struct PurchaseItemProduct {
    string code;
    PurchaseItem purchase_item;
    double purchase_price;
    double order_price;
    OptionValue[string] option_values;
}

