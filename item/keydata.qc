/*
========================================================================

FUNCTIONS WHICH DEAL WITH KEY ITEM BITFLAGS AND NAMES

========================================================================


This file was created for progs_dump by Ian "iw" Walshaw, January 2020.

It defines functions which deal with the bitflags and names which refer
to the key items, including the new item_key_custom.

These functions are a dependency of the updated code for the key items
(in items.qc) and also the updated code for unlockable entities (in
keylock.qc).


========================================================================
*/


string() SilverKeyName;
string() GoldKeyName;
float(string key_name) CustomKeyFlag;
entity(string key_name) SpawnCustomKeyDef;
entity(string key_name) FindCustomKeyDef;
float(entity client, float item_flags, float customkey_flags) HasKeys;
void(entity client, float item_flags, float customkey_flags) GiveKeys;
void(entity client) GiveAllKeys;
void(entity client, float item_flags, float customkey_flags) RemoveKeys;


// The highest bitflag that will be assigned to a custom key.
float FINAL_CUSTOM_KEY = 4194304;

// The highest bitflag that has been assigned to a custom key.
float highest_custom_key;


/*
============
SilverKeyName

Return the name that should be used for the silver key as per
world.worldtype.  -- iw
============
*/
string() SilverKeyName =
{
	if (world.worldtype == WORLDTYPE_BASE)
		return "silver keycard";
	if (world.worldtype == WORLDTYPE_METAL)
		return "silver runekey";
	return "silver key";
};


/*
============
GoldKeyName

Return the name that should be used for the gold key as per
world.worldtype.  -- iw
============
*/
string() GoldKeyName =
{
	if (world.worldtype == WORLDTYPE_BASE)
		return "gold keycard";
	if (world.worldtype == WORLDTYPE_METAL)
		return "gold runekey";
	return "gold key";
};


/*
================
CustomKeyFlag

Return the bitflag that should be used to represent the custom key named
key_name.

More specifically, if this is the first time that this function has been
called for the specified key_name, then return a bitflag which has not
previously been returned by this function for any key_name.  Otherwise,
return the same bitflag that was previously returned for the specified
key_name.  -- iw
================
*/
float(string key_name) CustomKeyFlag =
{
	local entity key_def;

	key_def = FindCustomKeyDef (key_name);
	if (key_def == world)
		key_def = SpawnCustomKeyDef (key_name);
	return key_def.customkeys;
};


/*
================
SpawnCustomKeyDef

Spawn and return a new custom_key_def entity which will define the
custom key named key_name.

The value of the entity's customkeys field will be a bitflag which has
not yet been used to represent a custom key.  -- iw
================
*/
entity(string key_name) SpawnCustomKeyDef =
{
	local entity key_def;

	if (highest_custom_key == FINAL_CUSTOM_KEY)
		error ("too many custom keys");

	if (highest_custom_key == 0)
		highest_custom_key = 1;
	else
		highest_custom_key = highest_custom_key * 2;

	key_def = spawn ();
	key_def.classname = "custom_key_def";
	key_def.netname = key_name;
	key_def.customkeys = highest_custom_key;

	return key_def;
};


/*
================
FindCustomKeyDef

If a custom_key_def entity exists which defines the custom key named
key_name, then find and return it, otherwise return world.

If a custom_key_def entity is returned, then the value of its customkeys
field will be the bitflag that should be used to represent the custom
key named key_name.  -- iw
================
*/
entity(string key_name) FindCustomKeyDef =
{
	local entity key_def;

	key_def = find (world, classname, "custom_key_def");
	while (key_def != world)
	{
		if (key_def.netname == key_name)
			return key_def;
		key_def = find (key_def, classname, "custom_key_def");
	}
	return world;
};


/*
================
HasKeys

Return TRUE if the specified client has all of the non-custom keys
represented by the item_flags and all of the custom keys represented by
the customkey_flags, otherwise return FALSE.  -- iw
================
*/
float(entity client, float item_flags, float customkey_flags) HasKeys =
{
	return (client.items & item_flags) == item_flags &&
			(client.customkeys & customkey_flags) == customkey_flags;
};


/*
================
GiveKeys

Give the specified client all of the non-custom keys represented by the
item_flags and all of the custom keys represented by the
customkey_flags.  -- iw
================
*/
void(entity client, float item_flags, float customkey_flags) GiveKeys =
{
	client.items = client.items | item_flags;
	client.customkeys = client.customkeys | customkey_flags;
};


/*
================
GiveAllKeys

Give the specified client the silver key, the gold key, and all of the
custom keys that have been defined for the current map.  -- iw
================
*/
void(entity client) GiveAllKeys =
{
	GiveKeys (client, IT_KEY1 | IT_KEY2, highest_custom_key * 2 - 1);
};


/*
================
RemoveKeys

Remove all of the non-custom keys represented by the item_flags and all
of the custom keys represented by the customkey_flags from the specified
client's inventory.  -- iw
================
*/
void(entity client, float item_flags, float customkey_flags) RemoveKeys =
{
	client.items = client.items -
			(client.items & item_flags);
	client.customkeys = client.customkeys -
			(client.customkeys & customkey_flags);
};
