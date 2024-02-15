module controllers.user;

import std.stdio;
// Vibed
import vibe.d;
import vibe.db.mongo.mongo;

import std.algorithm: map;

import database;

import translation;

import models.user;

/**/
//@translationContext!TranslationContext
class UserController {
	
	private MongoClient client;
	MongoCollection coll;

	this() {
		client = connectMongoDB("127.0.0.1");
		coll = client.getCollection("storeapp.users");
	}
    
	// GET /
	@method(HTTPMethod.GET)
	@path("/users")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("user/index.dt", authenticated);
		*/
		auto users = coll.find().map!(bson => deserializeBson!User(bson));
		render!("users_index.dt", users);
	}
	

	// GET /users/:usernameeeeeeeee
    @method(HTTPMethod.GET)
	@path("/users/:username")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { string username; }
        auto userNullable = coll.findOne!User(Q(req.params["username"]));
		if (! userNullable.isNull) {
			// Acessar os campos da estrutura User
			auto user = userNullable.get;
			render!("users_show.dt", user);
		} else {

		}
    }
	
	// GET /
	@method(HTTPMethod.GET)
	@path("/users/new")
	void new_form()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("user/index.dt", authenticated);
		*/
		auto user = User();
		render!("users_new.dt", user);
	}
	
	/*
	// POST /login (username and password are automatically read as form fields)
	@method(HTTPMethod.POST) @path("/login")
	void postLogin(string username, string password)
	{
		enforceHTTP(username == "user" && password == "secret",
			HTTPStatus.forbidden, "Invalid user name or password.");
		ms_authenticated = true;
		redirect("/");
	}
	
	// POST /logout
	@method(HTTPMethod.POST) @path("/logout")
	void postLogout()
	{
		ms_authenticated = false;
		terminateSession();
		redirect("/");
	}
	*/
}
