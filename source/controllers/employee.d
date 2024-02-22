module controllers.employee;
import std.stdio;
// Vibed
import vibe.d;
import vibe.db.mongo.mongo;

import std.algorithm: map;

import database;
import models.employee;

import translation;

class EmployeeController {
    private MongoClient client;
	MongoCollection coll;

	this() {
		client = connectMongoDB("127.0.0.1");
		coll = client.getCollection("storeapp.employees");
	}
    
	// GET /
	@method(HTTPMethod.GET)
	@path("/employees")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("employees_index.dt", authenticated);
		*/
		auto employees = coll.find().sort(["name": 1]).map!(bson => deserializeBson!Employee(bson));
		render!("employees_index.dt", employees);
	}
	
	// GET /employees/new
	@method(HTTPMethod.GET)
	@path("/employees/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("employees_index.dt", authenticated);
		*/
		auto employee = Employee();
		render!("employees_new.dt", employee);
	}
	

	// GET /employees/:_id
    @method(HTTPMethod.GET)
	@path("/employees/:_id")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!Employee(Q(BsonObjectID.fromString(req.params["_id"])));
		if (! docNullable.isNull) {
			// Acessar os campos da estrutura Employee
			auto employee = docNullable.get;
			render!("employees_show.dt", employee);
		} else {

		}
    }
}
