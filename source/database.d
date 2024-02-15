module database;

import vibe.vibe;
//import vibe.db.mongo.mongo;

import models.user;

class MongoDriver {

    private static MongoClient client;
    private MongoDatabase db;
    private MongoCollection collection;

    this() {
        client = connectMongoDB("127.0.0.1");
        db = client.getDatabase("storeapp");
    }

    MongoDatabase getDb() {
        return db;
    }

    MongoDatabase setDatabase(string name) {
	    db = client.getDatabase("storeapp");
        return db;
    }

    MongoCollection getCollection(string name) {
        collection = client.getCollection("storeapp." ~ name);
        //collection = db[name];
        return collection;
    }
}

///
unittest {
    MongoClient client = connectMongoDB("127.0.0.1");
	auto users = client.getCollection("storeapp.users");
    auto user = User("felipebastosweb", "felipe", "felipebastosweb@gmail.com");
    users.insertOne(user.serializeToBson());
    
    
    auto client = connectMongoDB("127.0.0.1");
	auto db = client.getDatabase("storeapp");
	auto users = db["users"].find();
	writeln(users);
	/*
	auto shops = client.getCollection("storeapp.shops");
    auto shop = Shop("Elienai Bastos Moraes", "Bastos Style", "Rua Padre Antônio Vieira, 159 - Capelinha, Salvador - BA");
    shops.insertOne(shop.serializeToBson());
	*/

    //writeln(shops.find());
        
}

class BaseRepository {
    this() {

    }
}

///
unittest {
    auto client = connectMongoDB("127.0.0.1");
	auto shops = client.getCollection("storeapp.shops");
    auto shop = Shop("Elienai ", "Bastos Style", "Rua Padre Antônio Vieira, 159 - Capelinha, Salvador - BA");
    shops.insertOne(shop.serializeToBson());
}