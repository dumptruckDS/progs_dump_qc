/*
========================================================================

COMMON CODE FOR ENTITIES WHICH CAN BE UNLOCKED WITH KEYS

========================================================================


This file was created for progs_dump by Ian "iw" Walshaw, December 2019.

It defines functions which implement the logic of the player using a key
to unlock a locked entity.  These functions are based on parts of the
func_door code from the original game.

In the original game, func_door was the only type of entity which could
be unlocked with a key, however progs_dump also has trigger_usekey,
which previously duplicated the same unlocking logic as func_door.  The
functions in this file were written to eliminate that duplication;
func_door and trigger_usekey have now both been refactored to call these
functions.

This file was created as part of the prep work for implementing
item_key_custom, with the intention of removing as much duplication as
possible in order to make the code easier to modify and extend.


Fields Set By These Functions
-----------------------------

The functions in this file set the following fields, therefore code
calling these functions must not use these fields for other purposes:

    - self.customkeys
    - self.items
    - self.netname
    - self.noise3
    - self.noise4


========================================================================
*/


/*
================
keylock_init

Initialize self for use with the other keylock_* functions.

The following fields will be set to default values if they have not
already been set:

    - self.noise3 (the "key required" sound file).

    - self.noise4 (the "key used" sound file).

The default values are determined by world.worldtype.  -- iw
================
*/
void() keylock_init =
{
	local string default_noise3;
	local string default_noise4;

	if (world.worldtype == WORLDTYPE_BASE)
	{
		default_noise3 = "doors/basetry.wav";
		default_noise4 = "doors/baseuse.wav";
	}
	else if (world.worldtype == WORLDTYPE_METAL)
	{
		default_noise3 = "doors/runetry.wav";
		default_noise4 = "doors/runeuse.wav";
	}
	else
	{
		default_noise3 = "doors/medtry.wav";
		default_noise4 = "doors/meduse.wav";
	}

	if (self.noise3 == "")
		self.noise3 = default_noise3;
	if (self.noise4 == "")
		self.noise4 = default_noise4;

	precache_sound (self.noise3);
	precache_sound (self.noise4);
};


/*
================
keylock_set_silver_key

Make it so that the player will need to use the silver key in order to
unlock self.  -- iw
================
*/
void() keylock_set_silver_key =
{
	self.items = IT_KEY1;
	self.customkeys = 0;  // support for item_key_custom -- iw
	self.netname = SilverKeyName ();
};


/*
================
keylock_set_gold_key

Make it so that the player will need to use the gold key in order to
unlock self.  -- iw
================
*/
void() keylock_set_gold_key =
{
	self.items = IT_KEY2;
	self.customkeys = 0;  // support for item_key_custom -- iw
	self.netname = GoldKeyName ();
};


// support for item_key_custom -- iw
/*
================
keylock_set_custom_key

Make it so that the player will need to use the custom key named
key_name in order to unlock self.  -- iw
================
*/
void(string key_name) keylock_set_custom_key =
{
	self.items = 0;
	self.customkeys = CustomKeyFlag (key_name);
	self.netname = key_name;
};


/*
================
keylock_has_key_set

Return TRUE if one of the keylock_set_*_key functions has been called
for self, otherwise return FALSE.  -- iw
================
*/
float() keylock_has_key_set =
{
// support for item_key_custom -- iw
	return self.items != 0 || self.customkeys != 0;
};


/*
================
keylock_try_to_unlock

Handle the logic of the specified client trying to unlock self.

More specifically, if the client has the correct key to unlock self,
then do the following:

    1. Remove the key from the client's inventory, unless self.cnt is
       non-zero, in which case leave it in the client's inventory.

    2. Print a message to let the player know which key they used.

    3. Play the "key used" sound effect (self.noise4).

    4. Call the function specified as the success_func parameter, which
       should perform whatever entity-specific actions are required for
       self.

Otherwise, if the client does not have the correct key to unlock self,
then do the following:

    1. Centerprint the message "You need the [key name]", unless the
       custom_message parameter is non-empty, in which case centerprint
       that instead.

    2. Play the "key required" sound effect (self.noise3).

The self.cnt functionality is a feature of progs_dump and was not part
of the original game.  -- iw
================
*/
void(entity client, string custom_message,
		void() success_func) keylock_try_to_unlock =
{
	local string s;

// support for item_key_custom -- iw
	if (!HasKeys (client, self.items, self.customkeys))
	{
		if (custom_message != "")
			centerprint (client, custom_message);
		else
			centerprint2 (client, "You need the ", self.netname);
		sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		return;
	}

// the old code in door_touch included a comment from dumptruck_ds
// thanking RennyC re self.cnt
	if (self.cnt)
	{
		s = "You used (and kept) the ";
	}
	else
	{
	// support for item_key_custom -- iw
		RemoveKeys (client, self.items, self.customkeys);
		s = "You used the ";
	}

	sprint (client, s);
	sprint (client, self.netname);
	sprint (client, "\n");

// the old code in door_fire included a comment from dumptruck_ds
// thanking c0burn re changing CHAN_VOICE to CHAN_ITEM
	sound (self, CHAN_ITEM, self.noise4, 1, ATTN_NORM);

	success_func ();
};
