module controllers.shop;

import std.stdio;
// Vibed
import vibe.d;
//import vibe.http.router;
//import vibe.web.web;
import vibe.db.mongo.mongo;

import std.algorithm: map;
import std.array: array;
import std.json;

import database;

import translation;

import models.shop;

class ShopController {

	private MongoClient client;
	MongoCollection coll;

	this() {
		client = connectMongoDB("127.0.0.1");
		coll = client.getCollection("storeapp.shops");
	}
    
	// GET /
	@method(HTTPMethod.GET)
	@path("/shops")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("user/index.dt", authenticated);
		*/
		auto shops = coll.find().map!(bson => deserializeBson!Shop(bson));
		render!("shops_index.dt", shops);
	}
	
	// GET /
	@method(HTTPMethod.GET)
	@path("/shops/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("shops/index.dt", authenticated);
		*/
		render!("shops_new.dt");
	}
    
}
