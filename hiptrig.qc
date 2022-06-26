//Selections from hiptrig.qc NOT the entire file

/* Trigger QuickC program
   By Jim Dose'  12/2/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/

float USE_SILV_KEY = 8;
float USE_GOLD_KEY = 16;

/*
================
keytrigger_unlock

Perform the actions which should be performed when self is successfully
unlocked with a key.

This function exists so that it can be passed as an argument to the new
keylock_try_to_unlock function.  This code was previously part of the
keytrigger_use function.  -- iw
================
*/
void() keytrigger_unlock =
{
	// we can't just remove (self) here, because this is a touch function
	// called while C code is looping through area links...
	self.touch = SUB_Null;
	self.use = SUB_Null;
	self.nextthink = time + 0.1;
	self.think = SUB_Remove;
	self.message = "";

	SUB_UseTargets();
};

void() keytrigger_use =
{
  // from Copper -- dumptruck_ds
  if (!CheckValidTouch()) return;

	if (self.attack_finished > time)
		return;

	self.attack_finished = time + 2;
	keylock_try_to_unlock (activator, self.message, keytrigger_unlock);
};

void() keytrigger_touch =
{
	activator = other;
	keytrigger_use();
};

/*QUAKED trigger_usekey (0 .5 0) ? X X X USE_SILV_KEY USE_GOLD_KEY X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Variable sized single use trigger that requires a key to trigger targets.  Must be targeted at one or more entities.

"cnt"     if 1, leave a used key in the player's inventory (0 default).
"keyname" if set, this is the keyname of the item_key_custom which unlocks this entity.
"message" is printed when the trigger is touched without having the right key.
"noise1"  sound file for the "key required" sound (default is per worldtype).
"noise2"  sound file for the "key used" sound (default is per worldtype).
*/

void() trigger_usekey =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

// the keylock_* functions use self.noise3 and self.noise4 internally,
// but trigger_usekey doesn't use the self.noise1 or self.noise2 fields
// for anything, so we allow the mapper to specify custom sound files by
// setting self.noise1 and self.noise2, but we move those values into
// self.noise3 and self.noise4 -- iw
	self.noise3 = self.noise1;
	self.noise4 = self.noise2;
	self.noise1 = "";
	self.noise2 = "";

	keylock_init ();

	if (self.spawnflags & USE_SILV_KEY) {//dumptruck_ds
		keylock_set_silver_key ();

		if (self.keyname != "") {
			self.netname = self.keyname;
			self.keyname = "";
		}
	}
	if (self.spawnflags & USE_GOLD_KEY) {//dumptruck_ds
		keylock_set_gold_key ();
		
		if (self.keyname != "") {
			self.netname = self.keyname;
			self.keyname = "";
		}
	}

// support for item_key_custom -- iw
	if (self.keyname != "")
	{
		keylock_set_custom_key (self.keyname);
		self.keyname = "";  // this should not be referenced again
	}

	if (!keylock_has_key_set ())
	{
		objerror ("no key specified!");
		return;
	}

	self.use = keytrigger_use;
	self.touch = keytrigger_touch;

	InitTrigger ();
	SUB_CheckWaiting();
};

// void() remove_touch =
// {
// 	if (other.flags & self.cnt)
// 		return;
// 	other.touch = SUB_Null;
// 	other.model = "";
// 	remove(self);
// };
//
// /*QUAKED trigger_remove (.5 .5 .5) ? ignoremonsters ignoreplayers
// Variable sized trigger that removes the thing
// that touches it.  Does not affect monsters or
// players.
// */
// void() trigger_remove =
// {
// 	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
// 		return;
//
// 	self.cnt = FL_CLIENT|FL_MONSTER;
// 	if (self.spawnflags & 1)
// 		self.cnt = self.cnt - FL_MONSTER;
// 	if (self.spawnflags & 2)
// 		self.cnt = self.cnt - FL_CLIENT;
// 	InitTrigger ();
// 	self.touch = remove_touch;
// };

/*
==============================================================================

trigger_setgravity

==============================================================================
*/
float DT_GRAVTOFF = 8;  // trigger will start off

void() grav_toggle = //dumptruck_ds based on hipnotic blocker_use
{
	if (self.estate != STATE_ACTIVE)
		self.estate = STATE_ACTIVE;
	else
		self.estate = STATE_INACTIVE;

};

void() trigger_gravity_touch =
{
  // from Copper -- dumptruck_ds
  // if (!CheckValidTouch()) return;

	if (self.estate != STATE_ACTIVE) return;

	local float grav;

//	This is commented out so that the changing gravity will
//	affect everything, if you don't want to use all affecting
//	gravity changes, then uncomment these two lines.
//	if (other.classname != "player")
//		return;

	if (self.gravity == -1)
		grav = 1;
	else
		grav = self.gravity;

	// the player's gravity is now managed in PlayerPreThink(), however
	// other entities don't have special gravity management, so their
	// gravity is still set directly -- iw
	if (other.classname == "player")
		other.wantedgravity = grav;
	else
		other.gravity = grav;
};

/*QUAKED trigger_setgravity (.5 .5 .5) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
set the gravity of a player

"gravity" what to set the players gravity to
 - 0 (default) normal gravity
 - 1 no gravity
 - 2 almost no gravity
 - 10 is a good setting
 - ...
 - 101 normal gravity
 - 102 slightly higher gravity
 - ...
 - 1000 very high gravity

 NOTE: the amount of gravity can only be changed by touching another
 trigger_setgravity with a different setting. The gravity key defaults to 0
 which is normal gravity. Lower numbers (e.g. 25) equal lower gravity. Setting
 100 is normal gravity. Numbers above 100 will make the player “heavier”, i.e.
 harder to jump. If you want multiple trigger setgravity triggers in one room or
 area, make sure the brushes are not touching each other. This can cause the
 triggers not to work properly.

*/
void() trigger_setgravity =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	InitTrigger ();

	self.use = grav_toggle; // dumptruck_ds
	self.touch = trigger_gravity_touch;

	if ( self.spawnflags & DT_GRAVTOFF ) //dumptruck_ds
		self.estate = STATE_INACTIVE;

	if (!self.gravity)
		self.gravity = -1;
	else
	    self.gravity = ((self.gravity - 1) / 100);

	SUB_CheckWaiting();
};
