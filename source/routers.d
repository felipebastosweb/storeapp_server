module routers;

import vibe.vibe;

import controllers.index;
import controllers.user;
import controllers.shop;
import controllers.customer;
import controllers.brand;
import controllers.supplier;
import controllers.product;
import controllers.purchase;
import controllers.order;

URLRouter getRouter() {
    auto router = new URLRouter;
    router.get("/public/*", serveStaticFiles(""));
    router.registerWebInterface(new IndexController);
    router.registerWebInterface(new UserController);
    router.registerWebInterface(new ShopController);
    router.registerWebInterface(new CustomerController);
    router.registerWebInterface(new BrandController);
    router.registerWebInterface(new SupplierController);
    router.registerWebInterface(new ProductController);
    router.registerWebInterface(new PurchaseController);
    router.registerWebInterface(new OrderController);
    return router;
}