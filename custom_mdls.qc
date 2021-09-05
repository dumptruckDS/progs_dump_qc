/*

========================================================================

MAPPER-SETTABLE CUSTOM MODELS FOR MONSTERS

========================================================================
*/

/*
================
precache_model_custom
================
*/
void(.string mdl_field, string default_file) precache_model_custom =
{
	if (self.mdl_field != "")
		precache_model (self.mdl_field);
	else
		precache_model (default_file);
};


void(string default_file) precache_head_model = { precache_model_custom (mdl_head, default_file); };
void(string default_file) precache_body_model = { precache_model_custom (mdl_body, default_file); };
void(string default_file) precache_proj_model = { precache_model_custom (mdl_proj, default_file); };
void(string default_file) precache_gib1 = { precache_model_custom (mdl_gib1, default_file); };
void(string default_file) precache_gib2 = { precache_model_custom (mdl_gib2, default_file); };
void(string default_file) precache_gib3 = { precache_model_custom (mdl_gib3, default_file); };


/*
================
precache_model2_custom
================
*/
void(.string mdl_field, string default_file) precache_model2_custom =
{
	if (self.mdl_field != "")
		precache_model2 (self.mdl_field);
	else
		precache_model2 (default_file);
};


void(string default_file) precache_head_model2 = { precache_model2_custom (mdl_head, default_file); };
void(string default_file) precache_body_model2 = { precache_model2_custom (mdl_body, default_file); };
void(string default_file) precache_proj_model2 = { precache_model2_custom (mdl_proj, default_file); };
void(string default_file) precache_exproj_model2 = { precache_model2_custom (mdl_exproj, default_file); };


/*
================
model_custom
================
*/
void(.string mdl_field, string default_file) model_custom =
{
	if (self.mdl_field != "")
	{
		setmodel (self, self.mdl_field);
		// dprint("CUSTOM MODEL LOADED\n");
	}
	else
		setmodel (self, default_file);
};

void(string default_file) body_model = { model_custom (mdl_body, default_file); };
// void(string default_file) head_model = { model_custom (mdl_head, default_file); };
void(string default_file) proj_model = { model_custom (mdl_proj, default_file); };
