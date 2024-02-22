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

	
	unittest {
		User user;
		user._id = BsonObjectID.generate; // Gera um ID aleatório para o usuário
		user.username = "user";
		user.password = "<PASSWORD>";
		user.email = "<EMAIL>";
		user.phone = "<EMAIL>";
		
		assertEqual(user.validatePassword("<WRONG PASSWORD>"), false);
		assertEqual(user.validatePassword("1234567890"), false);
		assertEqual(user.validatePassword("<CORRECT PASSWORD>", true));
		
		/*
		// Não consegui implementar a autenticação do MongoDB no unittest por causa do MongoDB.Driver.dll
		MongoClientSettings settings = new MongoClientSettings();
		settings.ServerSelectionTimeout = TimeSpan.FromSeconds(1);
		MongoClient client = new MongoClient(settings);
		client.Connecting += (sender, e) => ms_connected = true;
		client.ServerOpening += (sender, e) => ms_opened = true;
		assertTrue(client.WaitForServerReady());
		assertTrue(ms_connected);
		assertFalse(ms_opened);
		*/

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
		auto users = coll.find().sort(["username": 1]).map!(bson => deserializeBson!User(bson));
		render!("users_index.dt", users);
	}
	
	// GET /users/new
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

	// POST /users (username and password are automatically read as form fields)
	@method(HTTPMethod.POST)
	@path("/users")
	void register(HTTPServerRequest req, HTTPServerResponse res)
	{
		/**
		Você pode definir a codificação do formulário como enctype="multipart/form-data" se estiver
		enviando arquivos, ou como enctype="application/x-www-form-urlencoded" para dados normais do formulário.
		*/
		User user;
		user._id = BsonObjectID.generate; // Gera um ID aleatório para o usuário
		user.username = req.form["username"];
		user.password = req.form["password"];
		user.email = req.form["email"];
		user.phone = req.form["phone"];
		coll.insertOne(user);
        res.redirect("/users");

		/*
		try {
			coll.insert(serializeBson!user);
            res.redirect("/users");
		} catch (MongoError e) {
			// If there was an error, show the form again with an error message
			res.setStatusCode(409);  // Conflict
		}
		enforceHTTP(username == "user" && password == "secret",
			HTTPStatus.forbidden, "Invalid user name or password.");
		ms_authenticated = true;
		redirect("/");
		*/

	}

	// GET /users/:_id
    @method(HTTPMethod.GET)
	@path("/users/:_id")
    void show(HTTPServerRequest req, HTTPServerResponse res)
    {
		struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!User(Q(BsonObjectID.fromString(req.params["_id"])));
		if (! docNullable.isNull) {
			// Acessar os campos da estrutura User
			auto user = docNullable.get;
			render!("users_show.dt", user);
		} else {

		}
    }
	
	
	// GET /users/:_id/edit
	@method(HTTPMethod.GET)
	@path("/users/:_id/edit")
	void edit_form(HTTPServerRequest req, HTTPServerResponse res)
	{
		/*
		bool authenticated = ms_authenticated;
		render!("user/index.dt", authenticated);
		*/
		struct Q { BsonObjectID _id; }
        auto docNullable = coll.findOne!User(Q(BsonObjectID.fromString(req.params["_id"])));
		if (! docNullable.isNull) {
			// Acessar os campos da estrutura User
			User user = docNullable.get;
			render!("users_edit.dt", user);
		}
	}

		// POST /users (username and password are automatically read as form fields)
	@method(HTTPMethod.POST)
	@path("/users/:_id")
	void change(HTTPServerRequest req, HTTPServerResponse res)
	{
		/**
		Você pode definir a codificação do formulário como enctype="multipart/form-data" se estiver
		enviando arquivos, ou como enctype="application/x-www-form-urlencoded" para dados normais do formulário.
		*/
		auto _id = BsonObjectID.fromString(req.params["_id"]); // pega o valor do parâmetro "_id" e remove caracteres perigosos
		BsonObjectID[string] filter;
		filter["_id"] = _id;

		Bson[string][string] update;
		update["$set"]["username"] = req.form["username"];
		update["$set"]["password"] = req.form["password"];
		update["$set"]["email"] = req.form["email"];
		update["$set"]["phone"] = req.form["phone"];
		coll.updateOne(filter, update);
        res.redirect("/users");
		
		/*
		TODO: Por questão de segurança armazenar o ID em sessão e só tentar alterar se o ID for o mesmo buscado no banco de dados
		para evitar que o usuário tente alterar um documento com ID de outro usuário hackeando assim o sistema
		*/
	}
	
	/*
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
