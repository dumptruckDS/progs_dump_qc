//Selections from hiptrig.qc NOT the entire file

/* Trigger QuickC program
   By Jim Dose'  12/2/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/

float USE_SILV_KEY = 8;
float USE_GOLD_KEY = 16;

void() keytrigger_use =
{
	if (activator.classname != "player")
		return;
	if (self.attack_finished > time)
		return;

	self.attack_finished = time + 2;

// FIXME: blink key on player's status bar
	if ( (self.items & activator.items) != self.items )

	{
		if (self.message != "")
			centerprint (activator, self.message);
		else
			centerprint2 (activator, "You need the ", self.netname);
		sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		return;
	}

	if (!self.cnt) //dumptruck_ds thanks RennyC -- set cnt 1 to leave key in player inventory
	activator.items = activator.items - self.items;

	// we can't just remove (self) here, because this is a touch function
	// called while C code is looping through area links...
	self.touch = SUB_Null;
	self.use = SUB_Null;
	self.nextthink = time + 0.1;
	self.think = SUB_Remove;
	self.message = "";

	sound (self, CHAN_ITEM, self.noise4, 1, ATTN_NORM); //dumptruck_ds CHAN_VOICE becomes CHAN_ITEM

	SUB_UseTargets();
};

void() keytrigger_touch =
{
	activator = other;
	keytrigger_use();
};

/*QUAKED trigger_usekey (0 .5 0) ? x x x USE_SILV_KEY USE_GOLD_KEY
Variable sized single use trigger that requires a key to trigger targets.  Must be targeted at one or more entities.

"cnt"     if 1, leave a used key in the player's inventory (0 default).
"message" is printed when the trigger is touched without having the right key.
*/

void() trigger_usekey =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (world.worldtype == WORLDTYPE_MEDIEVAL)
	{
		precache_sound ("doors/medtry.wav");
		precache_sound ("doors/meduse.wav");
		self.noise3 = "doors/medtry.wav";
		self.noise4 = "doors/meduse.wav";
	}
	else if (world.worldtype == WORLDTYPE_METAL)
	{
		precache_sound ("doors/runetry.wav");
		precache_sound ("doors/runeuse.wav");
		self.noise3 = "doors/runetry.wav";
		self.noise4 = "doors/runeuse.wav";
	}
	else if (world.worldtype == WORLDTYPE_BASE)
	{
		precache_sound ("doors/basetry.wav");
		precache_sound ("doors/baseuse.wav");
		self.noise3 = "doors/basetry.wav";
		self.noise4 = "doors/baseuse.wav";
	}
	else
		dprint ("no worldtype set!\n");

	if (!(self.spawnflags & (USE_SILV_KEY | USE_GOLD_KEY))) //dumptruck_ds thanks c0burn //iw further tweaked
	{
		objerror ("no key specified!");
		return;
	}

	if (self.spawnflags & USE_SILV_KEY) //dumptruck_ds
	{
		self.items = IT_KEY1;
		self.netname = SilverKeyName ();
	}
	if (self.spawnflags & USE_GOLD_KEY) //dumptruck_ds
	{
		self.items = IT_KEY2;
		self.netname = GoldKeyName ();
	}

	self.use = keytrigger_use;
	self.touch = keytrigger_touch;

	InitTrigger ();
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
if ( !self.state )
	{
		self.state = 1;
	setorigin( self, self.origin - '8000 8000 8000');
	}
else
	{
		self.state = 0;
	setorigin( self, self.origin + '8000 8000 8000');
	}
};

void() trigger_gravity_touch =
{
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

/*QUAKED trigger_setgravity (.5 .5 .5) ?
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
*/
void() trigger_setgravity =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	InitTrigger ();
	self.use = grav_toggle; // dumptruck_ds
	self.touch = trigger_gravity_touch;
	if ( self.spawnflags & DT_GRAVTOFF ) //dumptruck_ds
		 {
		 self.state = 0;
		 setorigin( self, self.origin + '8000 8000 8000' );
		 }
	else
		{
		 self.state = 1;
	 }  //end dumptruck_ds
	if (!self.gravity)
		self.gravity = -1;
	else
	      self.gravity = ((self.gravity - 1) / 100);
};
