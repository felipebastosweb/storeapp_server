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
		auto employees = coll.find().map!(bson => deserializeBson!Employee(bson));
		render!("employees_index.dt", employees);
	}
	

	// GET /users/:usernameeeeeeeee
    @method(HTTPMethod.GET)
	@path("/employees/:slug")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { string name; }
        auto employeeNullable = coll.findOne!Customer(Q(req.params["slug"]));
		if (! employeeNullable.isNull) {
			// Acessar os campos da estrutura Customer
			auto employee = employeeNullable.get;
			render!("employees_show.dt", employee);
		} else {

		}
    }
	
	// GET /
	@method(HTTPMethod.GET)
	@path("/employees/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("employees_index.dt", authenticated);
		*/
		auto employee = Customer();
		render!("employees_new.dt", employee);
	}
}
