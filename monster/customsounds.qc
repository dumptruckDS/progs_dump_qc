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
precache_sound_custom
================
*/
void(.string snd_field, string default_file) precache_sound_custom =
{
	if (self.snd_field != "")
		precache_sound (self.snd_field);
	else
		precache_sound (default_file);
};


void(string default_file) precache_sound_attack = { precache_sound_custom (snd_attack, default_file); };
void(string default_file) precache_sound_death = { precache_sound_custom (snd_death, default_file); };
void(string default_file) precache_sound_hit = { precache_sound_custom (snd_hit, default_file); };
void(string default_file) precache_sound_idle = { precache_sound_custom (snd_idle, default_file); };
void(string default_file) precache_sound_land = { precache_sound_custom (snd_land, default_file); };
void(string default_file) precache_sound_misc = { precache_sound_custom (snd_misc, default_file); };
void(string default_file) precache_sound_misc1 = { precache_sound_custom (snd_misc1, default_file); };
void(string default_file) precache_sound_misc2 = { precache_sound_custom (snd_misc2, default_file); };
void(string default_file) precache_sound_misc3 = { precache_sound_custom (snd_misc3, default_file); };
void(string default_file) precache_sound_move = { precache_sound_custom (snd_move, default_file); };
void(string default_file) precache_sound_pain = { precache_sound_custom (snd_pain, default_file); };
void(string default_file) precache_sound_sight = { precache_sound_custom (snd_sight, default_file); };


/*
================
precache_sound2_custom
================
*/
void(.string snd_field, string default_file) precache_sound2_custom =
{
	if (self.snd_field != "")
		precache_sound2 (self.snd_field);
	else
		precache_sound2 (default_file);
};


void(string default_file) precache_sound2_attack = { precache_sound2_custom (snd_attack, default_file); };
void(string default_file) precache_sound2_death = { precache_sound2_custom (snd_death, default_file); };
void(string default_file) precache_sound2_hit = { precache_sound2_custom (snd_hit, default_file); };
void(string default_file) precache_sound2_idle = { precache_sound2_custom (snd_idle, default_file); };
void(string default_file) precache_sound2_land = { precache_sound2_custom (snd_land, default_file); };
void(string default_file) precache_sound2_misc = { precache_sound2_custom (snd_misc, default_file); };
void(string default_file) precache_sound2_misc1 = { precache_sound2_custom (snd_misc1, default_file); };
void(string default_file) precache_sound2_misc2 = { precache_sound2_custom (snd_misc2, default_file); };
void(string default_file) precache_sound2_misc3 = { precache_sound2_custom (snd_misc3, default_file); };
void(string default_file) precache_sound2_move = { precache_sound2_custom (snd_move, default_file); };
void(string default_file) precache_sound2_pain = { precache_sound2_custom (snd_pain, default_file); };
void(string default_file) precache_sound2_sight = { precache_sound2_custom (snd_sight, default_file); };


/*
================
sound_custom
================
*/
void(.string snd_field, entity e, float chan, string default_file,
		float vol, float atten) sound_custom =
{
	if (e.snd_field != "")
		sound (e, chan, e.snd_field, vol, atten);
	else
		sound (e, chan, default_file, vol, atten);
};


void(entity e, float chan, string default_file, float vol, float atten) sound_attack = { sound_custom (snd_attack, e, chan, default_file, vol, atten); };
void(entity e, float chan, string default_file, float vol, float atten) sound_death = { sound_custom (snd_death, e, chan, default_file, vol, atten); };
void(entity e, float chan, string default_file, float vol, float atten) sound_hit = { sound_custom (snd_hit, e, chan, default_file, vol, atten); };
void(entity e, float chan, string default_file, float vol, float atten) sound_idle = { sound_custom (snd_idle, e, chan, default_file, vol, atten); };
void(entity e, float chan, string default_file, float vol, float atten) sound_land = { sound_custom (snd_land, e, chan, default_file, vol, atten); };
void(entity e, float chan, string default_file, float vol, float atten) sound_misc = { sound_custom (snd_misc, e, chan, default_file, vol, atten); };
void(entity e, float chan, string default_file, float vol, float atten) sound_misc1 = { sound_custom (snd_misc1, e, chan, default_file, vol, atten); };
void(entity e, float chan, string default_file, float vol, float atten) sound_misc2 = { sound_custom (snd_misc2, e, chan, default_file, vol, atten); };
void(entity e, float chan, string default_file, float vol, float atten) sound_misc3 = { sound_custom (snd_misc3, e, chan, default_file, vol, atten); };
void(entity e, float chan, string default_file, float vol, float atten) sound_move = { sound_custom (snd_move, e, chan, default_file, vol, atten); };
void(entity e, float chan, string default_file, float vol, float atten) sound_pain = { sound_custom (snd_pain, e, chan, default_file, vol, atten); };
void(entity e, float chan, string default_file, float vol, float atten) sound_sight = { sound_custom (snd_sight, e, chan, default_file, vol, atten); };
