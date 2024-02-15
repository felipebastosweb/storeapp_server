module translation;

import vibe.web.web;

import std.typetuple;

struct TranslationContext {
	alias languages = TypeTuple!("en_US", "pt_BR");
	//mixin translationModule!"welcome";
}
