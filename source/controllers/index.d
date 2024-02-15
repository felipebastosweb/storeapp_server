module controllers.index;

import vibe.http.router;
import vibe.http.server;
import vibe.web.web;

//import translation;

//@translationContext!TranslationContext
class IndexController {
	/*
	private {
		// stored in the session store
		SessionVar!(bool, "authenticated") ms_authenticated;
	}
	*/
	
	// GET /
	@method(HTTPMethod.GET) @path("/")
	void index()
	{
		/*
		bool authenticated = ms_authenticated;
		render!("home/index.dt", authenticated);
		*/
		
		render!("home_index.dt");
	}
}