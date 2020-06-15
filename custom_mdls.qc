/*
========================================================================

MAPPER-SETTABLE CUSTOM SOUND EFFECTS FOR MONSTERS

========================================================================


This file was created for progs_dump by Ian "iw" Walshaw, January 2020.

TODO: iw to add descriptive comments to this file.


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
void(string default_file) precache_proj_model = { precache_model_custom (mdl_projectile, default_file); };


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
void(string default_file) precache_proj_model2 = { precache_model2_custom (mdl_projectile, default_file); };


/*
================
model_custom
================
*/
void(.string mdl_field, string default_file) model_custom =
{
	if (self.mdl_field != "")
{		setmodel (self, self.mdl_field);
		dprint("CUSTOM MODEL LOADED\n");
}	else
{		setmodel (self, default_file);
		dprint("CUSTOM MODEL NOT LOADED\n");
}};

void(string default_file) body_model = { model_custom (mdl_body, default_file); };
