
entity	s;


void() trigger_reactivate =
{
	self.solid = SOLID_TRIGGER;
};

//=============================================================================

float	SPAWNFLAG_NOMESSAGE = 1;
float	SPAWNFLAG_NOTOUCH = 1;

// the wait time has passed, so set back up for another activation
void() multi_wait =
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};


// the trigger was just touched/killed/used
// self.enemy should be set to the activator so it can be held through a delay
// so wait for the delay time before firing
void() multi_trigger =
{
	if (self.nextthink > time)
	{
		return;		// allready been triggered
	}

	if (self.classname == "trigger_secret")
	{
		if (self.enemy.classname != "player")
			return;
		if (cutscene)
				return;     // Don't activate in cutscene mode
		found_secrets = found_secrets + 1;
		WriteByte (MSG_ALL, SVC_FOUNDSECRET);
	}

	if (self.noise != "")
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

// don't trigger again until reset
	self.takedamage = DAMAGE_NO;

	activator = self.enemy;

	SUB_UseTargets();

	if (self.wait > 0)
	{
		self.think = multi_wait;
		self.nextthink = time + self.wait;
	}
	else
	{	// we can't just remove (self) here, because this is a touch function
		// called wheil C code is looping through area links...
		self.touch = SUB_Null;
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}
};

void() multi_killed = //dumptruck_ds
{
	if (self.is_waiting)	// Supa, restore health and do nothing if we're still waiting to be activated
	{
		self.health		= self.max_health;	// nyah nyah~!
		self.takedamage	= DAMAGE_YES;
		self.solid		= SOLID_BBOX;

		return;
	}

	self.enemy = damage_attacker;
	multi_trigger();
};

void() multi_use = //dumptruck_ds
{
	if (self.is_waiting)	// Supa, if this trigger is waiting to be activated we'll tell it to get ready!
	{
		self.is_waiting = FALSE;	// Get ready!

		return;	// Must be used or triggered again to do anything
	}

	self.enemy = activator;
	multi_trigger();
};

void() multi_touch = //dumptruck_ds
{

	if (other.classname != "player")
		return;

	// from Copper -- dumptruck_ds
	if (other.movetype == MOVETYPE_NOCLIP)
		return;

	if (self.is_waiting)	// Supa, is this trigger waiting to be activated?
		return;

// if the trigger has an angles field, check player's facing direction
	if (self.movedir != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
			return;		// not facing the right way
	}

	self.enemy = other;
	multi_trigger ();
};

/*QUAKED trigger_multiple (.5 .5 .5) ? notouch X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Variable sized repeatable trigger.  Must be targeted at one or more entities.  If "health" is set, the trigger must be killed to activate each time.
If "delay" is set, the trigger waits some time after activating before firing.
"wait" : Seconds between triggerings. (.2 default)
If notouch is set, the trigger is only fired by other entities, not by touching.
NOTOUCH has been obsoleted by trigger_relay!
sounds
1) secret
2) beep beep
3) large switch
set "message" to text string
"is_waiting" : If set to 1, this trigger will do nothing until another trigger activates it
*/
void() trigger_multiple =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (self.is_waiting)
	{
		dprint("Spawned a waiting ");
		dprint(self.classname);
		dprint(" with targetname ");
		dprint(self.targetname);
		dprint(" and target ");
		dprint(self.target);
		dprint("\n");
	}

	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound ("misc/trigger1.wav");
		self.noise = "misc/trigger1.wav";
	}

	if (!self.wait)
		self.wait = 0.2;
	self.use = multi_use;

	InitTrigger ();

	if (self.health)
	{
		if (self.spawnflags & SPAWNFLAG_NOTOUCH)
			objerror ("health and notouch don't make sense\n");
		self.max_health = self.health;
		self.th_die = multi_killed;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
		setorigin (self, self.origin);	// make sure it links into the world
	}
	else
	{
		if ( !(self.spawnflags & SPAWNFLAG_NOTOUCH) )
		{
			self.touch = multi_touch;
		}
	}
};


/*QUAKED trigger_once (.5 .5 .5) ? notouch X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Variable sized trigger. Triggers once, then removes itself.  You must set the key "target" to the name of another object in the level that has a matching
"targetname".  If "health" is set, the trigger must be killed to activate.
If notouch is set, the trigger is only fired by other entities, not by touching.
if "killtarget" is set, any objects that have a matching "target" will be removed when the trigger is fired.
if "angle" is set, the trigger will only fire when someone is facing the direction of the angle.  Use "360" for an angle of 0.
sounds
1) secret
2) beep beep
3) large switch
set "message" to text string
*/
void() trigger_once =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.wait = -1;
	trigger_multiple();
};

//=============================================================================

/*QUAKED trigger_relay (.5 .5 .5) (-8 -8 -8) (8 8 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
This fixed size trigger cannot be touched, it can only be fired by other events.  It can contain killtargets, targets, delays, and messages.
*/
void() trigger_relay =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.use = SUB_UseTargets;
};


//=============================================================================

/*QUAKED trigger_secret (.5 .5 .5) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
secret counter trigger
sounds
1) secret
2) beep beep
set "message" to text string
*/
void() trigger_secret =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	total_secrets = total_secrets + 1;
	self.wait = -1;
	if (!self.message)
		self.message = "You found a secret area!";
	if (!self.sounds)
		self.sounds = 1;

	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}

	trigger_multiple ();
};

//=============================================================================


void() counter_use =
{
	self.count = self.count - 1;
	if (self.count < 0)
		return;

	if (self.count != 0)
	{
		if (activator.classname == "player"
		&& (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		{
			if (self.count >= 4)
				centerprint (activator, "There are more to go...");
			else if (self.count == 3)
				centerprint (activator, "Only 3 more to go...");
			else if (self.count == 2)
				centerprint (activator, "Only 2 more to go...");
			else
				centerprint (activator, "Only 1 more to go...");
		}
		return;
	}

	if (activator.classname == "player"
	&& (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		centerprint(activator, "Sequence completed!");
	self.enemy = activator;
	multi_trigger ();
};

/*QUAKED trigger_counter (.5 .5 .5) ? nomessage X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Acts as an intermediary for an action that takes multiple inputs.

If nomessage is not set, t will print "1 more.. " etc when triggered and "sequence complete" when finished.

After the counter has been triggered "count" times (default 2), it will fire all of it's targets and remove itself.
*/
void() trigger_counter =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.wait = -1;
	if (!self.count)
		self.count = 2;

	self.use = counter_use;
};

/*
==============================================================================

TELEPORT TRIGGERS with added functions from Zerstrorer and Qmaster
-- dumptruck_ds

==============================================================================
*/

float	PLAYER_ONLY	= 1;
float	SILENT = 2;
float RANDOM = 4;
float TELE_STEALTH = 8;
float MONSTER_ONLY = 16;
float TELE_DD = 32;

void() play_teleport =
{
	local	float v;
	local	string tmpstr;

	v = random() * 5;
	if (v < 1)
		tmpstr = "misc/r_tele1.wav";
	else if (v < 2)
		tmpstr = "misc/r_tele2.wav";
	else if (v < 3)
		tmpstr = "misc/r_tele3.wav";
	else if (v < 4)
		tmpstr = "misc/r_tele4.wav";
	else
		tmpstr = "misc/r_tele5.wav";

	sound (self, CHAN_VOICE, tmpstr, 1, ATTN_NORM);
	remove (self);
};

void(vector org) spawn_tfog =
{
	s = spawn ();
	s.origin = org;
	s.spawnflags = self.spawnflags; //dumptruck_ds
	s.nextthink = time + 0.2;
	s.think = play_teleport;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};


void() tdeath_touch =
{
	if (other == self.owner)
		return;

// frag anyone who teleports in on top of an invincible player
	if (other.classname == "player")
	{
		if (other.invincible_finished > time)
			self.classname = "teledeath2";
		if (self.owner.classname != "player")
		{	// other monsters explode themselves
			T_Damage (self.owner, self, self, 50000);
			return;
		}

	}

	if (other.health)
	{
		T_Damage (other, self, self, 50000);
	}
};


void(vector org, entity death_owner) spawn_tdeath =
{
local entity	death;

	death = spawn();
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin (death, org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	death.owner = death_owner;

	force_retouch = 2;		// make sure even still objects get hit
};

/*-----------------------------------------------*/
/*| more Zerstrorer-- dumptruck_ds  						 |*/
/*| teleport_randomspot - returns a random spot |*/
/*|   to teleport to among all of the           |*/
/*|   "info_teleport_random" entities in the    |*/
/*|   level.  self.count is number of spots     |*/
/*-----------------------------------------------*/
entity() teleport_randomspot =
{
local float		rndm;
// local float		rndm, num1;
local entity	spot,first;

	rndm = rint(random() * (self.count - 1));
	spot = find(world, classname, "info_teleport_random");
	if(!spot)
		dprint("No random teleport points found!\n");
	first = spot;

	while (rndm > 0)
	{
		rndm = rndm - 1;
		spot = find(spot, classname, "info_teleport_random");
	}

	if (spot == world)
	{
		dprint("Random spot found world!!\n");
		spot = first;
	}

	return spot;
};
// end dumptruck_ds
void() teleport_touch =
{
local entity	t;
local vector	org;

	if (self.targetname != "")
	{
		if (self.nextthink < time)
		{
			return;		// not fired yet
		}
	}

	if (self.spawnflags & PLAYER_ONLY)
	{
		if (other.classname != "player")
			return;
	}

	if (self.spawnflags & MONSTER_ONLY) // is this going to work? dumptruck_ds
	{
		if (other.classname == "player")
			return;
	}

	if (other.movetype == MOVETYPE_NOCLIP) // from Copper -- dumptruck_ds
		return;

	if (self.is_waiting == TRUE)	// Supa, is this trigger waiting to be activated?
		return;

	if (self.is_waiting != -1)	// Special case
	if (self.targetname != "")
	{
		if (self.nextthink < time)
		{
			return;		// not fired yet
		}
	}

// only teleport living creatures
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
		return;

	SUB_UseTargets ();

	// put a tfog where the player was
	// ### dhm - if stealth, don't spawn a fog
		if (!(self.spawnflags & TELE_STEALTH))
			spawn_tfog (other.origin);

	//dhm - if this is a random teleporter, pick a random spot!
		if (self.spawnflags & RANDOM)
			t = teleport_randomspot();
		else if ((self.spawnflags & TELE_DD) && other.classname == "player")
			t = find (world, targetname, self.noise);
		else
			t = find (world, targetname, self.target);

		if (!t)
			objerror ("couldn't find target");

// // put a tfog where the player was
// 	spawn_tfog (other.origin);
//
// 	t = find (world, targetname, self.target);
// 	if (!t)
// 		objerror ("couldn't find target");

// spawn a tfog flash in front of the destination
	makevectors (t.mangle);
	org = t.origin + 32 * v_forward;

// ### dhm - if stealth, don't spawn a fog
if (!(self.spawnflags & TELE_STEALTH))
	spawn_tfog (org);

	spawn_tdeath(t.origin, other);

// move the player and lock him down for a little while
	if (!other.health)
	{
		other.origin = t.origin;
		other.velocity = (v_forward * other.velocity_x) + (v_forward * other.velocity_y);
		return;
	}

	setorigin (other, t.origin);
	other.angles = t.mangle;
	if (other.classname == "player")
	{
		other.fixangle = 1;		// turn this way immediately
		other.teleport_time = time + 0.7;
		if (other.flags & FL_ONGROUND)
			other.flags = other.flags - FL_ONGROUND;
		other.velocity = v_forward * 300;
	}
	other.flags = other.flags - other.flags & FL_ONGROUND;

	if ((self.spawnflags & MONSTER_ONLY) && other.classname != "player")
	{
		other.fixangle = 1;		// turn this way immediately
		other.teleport_time = time + 0.7;
		if (other.flags & FL_ONGROUND)
			other.flags = other.flags - FL_ONGROUND;
		other.velocity = v_forward * 300;
	}
	other.flags = other.flags - other.flags & FL_ONGROUND;
};
// this is from Qmaster:

// "I created an info_teleport_changedest
// target = targetname of trigger_teleport to affect
// message = targetname of new info_teleport_destination (or whatever entity
// really) to now teleport to

// So that I can automatically update the teleporter under my coagula map as you
// progress rather than have a bunch of triggers that I need to killtarget.
// Falling is not fatal then, but it does put you back some.  Works as a sorta
// checkpoint system but also builds on my older idea for saving time in coop
// implemented in my Terracity map eons ago.

// looking at vanilla, you would only need to change trig.target to match
// self.message if you were to add this.""

void() teleport_destchange =
{
    local entity trig;

    trig = find(world,targetname,self.target);
    if (!trig || trig.classname != "trigger_teleport") {
        dprint("\b[TELEPORT_DESTCHANGE]\b Cannot find trigger_teleport\n");
        return;
    }

    trig.goalentity = find (world, targetname, self.message);
    if (!trig.goalentity) {
        dprint("\b[TELEPORT_DESTCHANGE]\b Cannot find teleport destination\n");
        return;
    }

    makevectors (trig.goalentity.mangle);
    trig.goalentity.movedir = v_forward;
    trig.goalentity.pos1 = trig.goalentity.origin + 32 * trig.goalentity.movedir;

		trig.target = self.message; //dumptruck_ds see comment above
};

/*QUAKED info_teleport_changedest (0 0.5 0) (-4 -4 -4) (4 4 4) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
Allows a mapper to change the target of a teleport_trigger. Useful in maps where
the player may fall into a void and the mapper wants to update where they "respawn"
as they progress through the level. Could also be used for teleport puzzles and more.
target = trigger_teleport to change
message = new info_teleport_destination's targetname to switch to
targetname = name of this entity so we can use it
*/
void() info_teleport_changedest =
{
		if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
			return;

    self.use = teleport_destchange;
    if (self.targetname == "") {
        dprint("\b[ERROR]\b info_teleport_changedest with no targetname");
        remove(self);
    }

    if (self.target == "") {
        dprint("\b[ERROR]\b info_teleport_changedest with no target");
        remove(self);
    }

    if (self.message == "") {
        dprint("\b[ERROR]\b info_teleport_changedest with no message set for new destination");
        remove(self);
    }
};

/*QUAKED info_teleport_destination (.5 .5 .5) (-8 -8 -8) (8 8 32) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/player.mdl");
}
This is the destination marker for a teleporter.  It should have a "targetname" field with the same value as a teleporter's "target" field.
*/
void() info_teleport_destination =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

// this does nothing, just serves as a target spot
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	self.origin = self.origin + '0 0 27';
	if (!self.targetname)
		objerror ("no targetname");
};

/*QUAKED info_teleport_random (.5 .5 .5) (-8 -8 -8) (8 8 32) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/player.mdl");
}
This is a random destination marker for a teleporter.
*/
void() info_teleport_random =
{
// this does nothing, just serves as a target spot
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	self.origin = self.origin + '0 0 27';
};

void() teleport_use =
{
	if (self.is_waiting)	// Supa, if this trigger is waiting to be activated we'll tell it to get ready!
	{
		self.is_waiting = -1;	// Special case to tell teleport_touch to ignore the usual targetname->nextthink check

		return;	// Must be used or triggered again to do anything
	}

	self.nextthink = time + 0.2;
	force_retouch = 2;		// make sure even still objects get hit
	self.think = SUB_Null;
};

// -------------------------
/*QUAKED trigger_teleport (.5 .5 .5) ? PLAYER_ONLY SILENT RANDOM STEALTH X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Any object touching this will be transported to the corresponding
info_teleport_destination entity. You must set the "target" field,
and create an object with a "targetname" field that matches.

If the trigger_teleport has a targetname, it will only teleport entities
when it has been fired.

SILENT(2) eliminates the teleporter ambient noise (good for hidden monster teleporters.
RANDOM(4) causes the teleporter to send the player to a random destination
 among the info_teleport_random markers in the level.  You MUST place a
 "count" field that is the number of info_teleport_random entities you
 placed.
STEALTH(8) eliminates the particle flash and noise when an entity is teleported.
MONSTER_ONLY(16) will only teleport monsters
*/void() trigger_teleport =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	local vector o;

	InitTrigger ();
	self.touch = teleport_touch;
	// find the destination
	if (!self.target)
		objerror ("no target");
	self.use = teleport_use;

	if (!(self.spawnflags & SILENT))
	{
		precache_sound ("ambience/hum1.wav");
		o = (self.mins + self.maxs)*0.5;
		ambientsound (o, "ambience/hum1.wav",0.5 , ATTN_STATIC);
	}
};

/*
==============================================================================

trigger_setskill

==============================================================================
*/

void() trigger_skill_touch =
{
	// from Copper -- dumptruck_ds
	if (!CheckValidTouch()) return;

	cvar_set ("skill", self.message);
};

/*QUAKED trigger_setskill (.5 .5 .5) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
sets skill level to the value of "message".
Only used on start map.
*/
void() trigger_setskill =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	InitTrigger ();
	self.touch = trigger_skill_touch;
};


/*
==============================================================================

ONLY REGISTERED TRIGGERS

==============================================================================
*/

void() trigger_onlyregistered_touch =
{
	// from Copper -- dumptruck_ds
	if (!CheckValidTouch()) return;
	if (self.attack_finished > time)
	return;

	self.attack_finished = time + 2;
	if (cvar("registered"))
	{
		self.message = "";
		SUB_UseTargets ();
		remove (self);
	}
	else
	{
		if (self.message != "")
		{
			centerprint (other, self.message);
			sound (other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);
		}
	}
};

/*QUAKED trigger_onlyregistered (.5 .5 .5) ?
Only fires if playing the registered version, otherwise prints the message
*/
void() trigger_onlyregistered =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_sound ("misc/talk.wav");
	InitTrigger ();
	self.touch = trigger_onlyregistered_touch;
};

//============================================================================

void() hurt_on =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};

void() hurt_touch =
{
	// from Copper -- dumptruck_ds
	if (other.movetype == MOVETYPE_NOCLIP)
		return;

	if (other.takedamage && self.nextthink < time)
	{
		//self.solid = SOLID_NOT;
		T_Damage (other, self, self, self.dmg);
		self.think = hurt_on;
		self.nextthink = time + 1;
	}

	return;
};

/*QUAKED trigger_hurt (.5 .5 .5) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
Any object touching this will be hurt
set dmg to damage amount
defalt dmg = 5
*/
void() trigger_hurt =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	InitTrigger ();
	self.touch = hurt_touch;
	if (!self.dmg)
		self.dmg = 5;
};

//============================================================================

//////////////////////////////////////////////////////////////////////////////
// start dumptruck_ds additions //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

float PUSH_ONCE = 1;
float DT_STARTOFF = 8;  // trigger will start off
float DT_SILENT = 16; // push silently
float DT_NOISE = 32; // use custom sound using noise key/value

void() trigger_push_touch =
{
	if (self.is_waiting) return;
	// from Copper -- dumptruck_ds
	if (other.movetype == MOVETYPE_NOCLIP)
		return;
	if (other.classname == "grenade")
		other.velocity = self.speed * self.movedir * 10;
	else if (other.health > 0)
	{
		other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		if (!(self.spawnflags & DT_SILENT))
		{
			if (other.fly_sound < time)
			if (!(self.spawnflags & DT_NOISE))
			{
				other.fly_sound = time + 1.5;
				sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
			}
			else
			{
			other.fly_sound = time + 1.5;
			sound (other, CHAN_AUTO, self.noise, 1, ATTN_NORM);
			}
		}
	}
	if (self.spawnflags & PUSH_ONCE)
		remove(self);
};

// void() trigger_push_use =      //dumptruck_ds
// {
//   self.is_waiting = !self.is_waiting;
// }

/*QUAKED trigger_push (.5 .5 .5) ? PUSH_ONCE X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
Pushes the player
*/
void() trigger_push = //dumptruck_ds
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	InitTrigger ();
	precache_sound ("ambience/windfly.wav");
	// if (self.targetname)
	// {               // digs 31.03.2012
	// 	self.is_waiting = TRUE;
	// 	self.use = trigger_push_use;
	// }
	// else self.is_waiting = FALSE;
	self.touch = trigger_push_touch;

	if (!self.speed)
		self.speed = 1000;
};

void() push_toggle = //dumptruck_ds based on hipnotic blocker_use

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

/*QUAKED trigger_push_custom (.5 .5 .5) ? PUSH_ONCE DT_STARTOFF DT_SILENT X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY


dumptruck_ds

trigger_push_custom is a new entity. This can be used to create traps,
jumppads, currents in water and more.

If DT_STARTOFF flag is set, this moves the trigger
brush out of the playable area. This can be targeted
and toggled off and on. If the DT_SILENT flag is set it
won't make the windfly sound. Use DT_CUSTOM spawnflag
and the noise key/value to use a custom push sound. Custom
sounds should be "one off" sounds NOT be looping.

Adapted from Hipnotic's func_togglewall */

void() trigger_push_custom =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	InitTrigger();
	precache_sound ("ambience/windfly.wav");
	self.use = push_toggle;
	self.touch = trigger_push_touch;
	if ( self.spawnflags & DT_STARTOFF )
		 {
		 self.state = 0;
		 setorigin( self, self.origin + '8000 8000 8000' );
		 }
	else
		{
		 self.state = 1;
	 	}
	if ( self.noise != "" )
    {
    precache_sound(self.noise);
	  }
		if (!self.speed)
			self.speed = 1000;

};


//============================================================================

void() trigger_monsterjump_touch =
{
	if ( other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER )
		return;

// set XY even if not on ground, so the jump will clear lips
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;

	if ( !(other.flags & FL_ONGROUND) )
		return;

	other.flags = other.flags - FL_ONGROUND;

	other.velocity_z = self.height;
};

/*QUAKED trigger_monsterjump (.5 .5 .5) ? X X X DT_STARTOFF X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Walking monsters that touch this will jump in the direction of the trigger's angle
"speed" default to 200, the speed thrown forward
"height" default to 200, the speed thrown upwards

If DT_STARTOFF flag is set, this moves the trigger
brush out of the playable area. This can be targeted
and toggled off and on.
*/
void() trigger_monsterjump =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.use = push_toggle;
	if ( self.spawnflags & DT_STARTOFF ) // dumptruck_ds
		 {
		 self.state = 0;
		 setorigin( self, self.origin + '8000 8000 8000' );
		 }
	else
		{
		 self.state = 1;
	 	}
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	if (self.angles == '0 0 0')
		self.angles = '0 360 0';
	InitTrigger ();
	self.touch = trigger_monsterjump_touch;
};
//////////////////////////////////////////////////////////////////////////////
// end dumptruck_ds additions //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

//This is necros' trigger_void from Lost Chapters pack, modified by dumptruck_ds

float 	MONSTER_SAFE = 1;
float 	PLAYER_SAFE = 2;

void() trigger_void_touch =
{
	if (other.movetype == MOVETYPE_NOCLIP) // from Copper -- dumptruck_ds
		return FALSE;

	if (self.spawnflags & MONSTER_SAFE && other.flags & FL_MONSTER) return; //ignore monsters
	if (self.spawnflags & PLAYER_SAFE && other.flags & FL_CLIENT) return; // ignore players

	if (other.takedamage)
	{
		other.invincible_finished = 0; // kills even with Pentagram, this took forever to figure out!! -- dumptruck_ds
		T_Damage (other, self, self, other.health + 1000 /*, DTH_TRIGGER_VOID, 1, 1*/);

		if (other.flags & FL_MONSTER)
		remove(other);
	}

	if (other.classname == "gib" ||
	other.classname == "grenade" ||
	other.classname == "spike" ||
	other.classname == "missile")
	remove(other);

	if (other.flags & FL_ITEM)
	remove(other);

	force_retouch = 2;
};

/*QUAKED trigger_void (.5 .5 .5) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
Use this for a 'void' area.  removes monsters, gibs, ammo, etc...  also kills player.
*/
void() trigger_void =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	InitTrigger ();
	self.touch = trigger_void_touch;
};

/*==============================================================================
GIVE AND TAKE STUFF (WIP)

This is Axe only at the moment. Need to research removing all weapons.
==============================================================================*/

void() take_weapon_use =  //thanks to ShanJaq and Spike for their help on this.

{
	// from Copper -- dumptruck_ds
	if (!CheckValidTouch()) return;

	if (!(other.flags & FL_CLIENT))
	return;

		{
			multi_trigger();
			other.items &= ~IT_SHOTGUN;
			other.currentammo = !other.ammo_shells;
			other.ammo_shells = !other.ammo_shells;
			other.items = other.items - ( other.items & IT_SHELLS);
			W_SetCurrentAmmo();
			W_BestWeapon();
		}
/*
	if (self.spawnflags & 8)

		{
			multi_trigger();
			other.items &= ~IT_SUPER_SHOTGUN;
			other.currentammo = !other.ammo_shells;
			other.ammo_shells = !other.ammo_shells;
			other.items = other.items - ( other.items & IT_SHELLS);
			W_SetCurrentAmmo();
			W_BestWeapon();
		}

	if (self.spawnflags & 16)

		{
			multi_trigger();
			other.items &= ~IT_NAILGUN;
			other.currentammo = !other.ammo_nails;
			other.ammo_nails = !other.ammo_nails;
			other.items = other.items - ( other.items & IT_NAILS);
			W_SetCurrentAmmo();
			W_BestWeapon();
		}

	if (self.spawnflags & 32)

		{
			multi_trigger();
			other.items &= ~IT_SUPER_NAILGUN;
			other.currentammo = !other.ammo_nails;
			other.ammo_nails = !other.ammo_nails;
			other.items = other.items - ( other.items & IT_NAILS);
			W_SetCurrentAmmo();
			W_BestWeapon();
		}

	if (self.spawnflags & 64)

		{
			multi_trigger();
			other.items &= ~IT_GRENADE_LAUNCHER;
			other.currentammo = !other.ammo_rockets;
			// if (!self.keep_ammo)
			// {
					// other.ammo_rockets = !other.ammo_rockets;
			// 		other.items = other.items - ( other.items & IT_ROCKETS);
			// 		W_SetCurrentAmmo();
			// }
			// else W_BestWeapon();
			W_BestWeapon();
			dprint ("best weapon 64\n");
		}

	if (self.spawnflags & 128)

		{
			multi_trigger();
			other.items &= ~IT_ROCKET_LAUNCHER;
			other.currentammo = !other.ammo_rockets;
			// if (!self.keep_ammo)
			// {
			// 		other.ammo_rockets = !other.ammo_rockets;
			// 		other.items = other.items - ( other.items & IT_ROCKETS);
			// 		W_SetCurrentAmmo();
			// }
			// else W_BestWeapon();
			W_BestWeapon();
			dprint ("best weapon 128\n");

		}

	if (self.spawnflags & 256)

		{
			multi_trigger();
			other.items &= ~IT_LIGHTNING;
			other.currentammo = !other.ammo_cells;
			other.ammo_cells = !other.ammo_cells;
			other.items = other.items - ( other.items & IT_CELLS);
			W_SetCurrentAmmo();
			W_BestWeapon();
		}
*/
};
/*QUAKED trigger_take_weapon (.5 .5 .5) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Removes shotgun upon touch. You can also set "reset_items" in the worldspawn entity to accomplish an axe only start.
*/
void() trigger_take_weapon =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.wait = -1;
	trigger_multiple();
	self.touch = take_weapon_use;
};

void(float newtrack) changemusic =
{
  *world_sounds = newtrack;  //changing the field via a pointer
  //world.sounds has now been changed via our pointer, newly connecting players (like those connecting after the game is loaded) will get sent the new cd track's number.

  //let everyone currently on the server know.
  WriteByte(MSG_ALL, SVC_CDTRACK);
  WriteByte(MSG_ALL, newtrack);  //initial track
  WriteByte(MSG_ALL, newtrack);  //looped track... should generally be set the same as the initial track as most engines ignore it entirely so it might as well be sane for those that care.
};

//thanks to jleww via changemusic.rar --dumptruck_ds

void() trigger_changemusic_touch =
{
	// from Copper -- dumptruck_ds
	if (!CheckValidTouch()) return;

	if (!(other.flags & FL_CLIENT))
	{
		return;
	}
	changemusic(self.sounds);
	self.touch = SUB_Null;
	self.nextthink = (time + 0.1);
	self.think = SUB_Remove;
};
/*QUAKED trigger_changemusic (.5 .5 .5) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
A trigger brush that changes the currently playing music track. The number of the track to play goes in the sounds key (just like worldspawn). */
void() trigger_changemusic =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;
		if (!self.sounds)
		{
			objerror("ERROR: trigger_changemusic needs valid track number in sounds field");
			return;
		}
	InitTrigger();
	self.touch = trigger_changemusic_touch;
};

void() trigger_cdtrack_use = //point entity version uses count for music track number for backwards compatibly in Adoria mod -- dumptruck_ds
{
	changemusic(self.count);
};
/*QUAKED trigger_cdtrack (.7 .7 .7) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
A point entity that changes the currently playing music track when triggered. The number of the track to play goes in the count key. e.g. 32 for track32.ogg  See manual trigger_changemusic for more information on formats and more.

NOTE: the track number uses the count key here but trigger_changemusic uses the sound key for the same info.
*/
void() trigger_cdtrack =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;
		if (!self.count)
		{
			objerror("ERROR: trigger_cdtrack needs valid track number in count field");
			return;
		}
	InitTrigger();
	self.use = trigger_cdtrack_use;
};
///////////////////////////////////////////////////////////////
//trigger_look (a.k.a. trigger_onlookat from NullPointPaladin!)
///////////////////////////////////////////////////////////////
void() onlookat_touch =
{
	// from Copper -- dumptruck_ds
	if (!CheckValidTouch()) return;

  if (self.nextthink > time)
  {
        return;        // allready been triggered
  }

    //added player view offset to make this more accurate to the player crosshairs
    local vector player_offset;
    player_offset = other.origin + other.view_ofs;

    makevectors(other.v_angle);

    //using speed to determine the reach of the trace
    if(!self.speed)
        self.speed = 500;
    traceline(player_offset, (player_offset + (v_forward * self.speed)), FALSE, other);

    if ((trace_ent.targetname == self.target))
    {
        // Play message if available
        if (self.message != "")
        {
            centerprint (other, self.message);
        }
        self.use = multi_trigger;
        SUB_UseTargets();

				if (self.noise != "")
				sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
				else
				sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);

        // added wait
        if (self.wait > 0)
        {
            self.think = multi_wait;
            self.nextthink = time + self.wait;
        }
        else
        {    // we can't just remove (self) here, because this is a touch function
            // called wheil C code is looping through area links...
            self.touch = SUB_Null;
            self.nextthink = time + 0.1;
            self.think = SUB_Remove;
        }
    }
};
/*QUAKED trigger_look (.5 .5 .5) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
This will trigger when a player is within the brush trigger and looks directly at a target entity.
Use the first target key for the "looked at entity" and use the subsequent targets (2-4) to trigger other events.

speed = Distance from player to search for trigger, adjust if the target is too far from the trigger  (default 500 units)
wait = Time between re-triggering (default 0)
sounds = 0-3 are standard Quake trigger choices, 4 allows a custom sound, requires a path set in noise1 key
noise1 = Path to custom sound. Use with sounds key set to 4  (e.g. fish/bite.wav)

See manual for complete details. See pd_cutscenes sample map for example
*/
void() trigger_look =
{
    if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
        return;

    //play all the sounds available for a normal trigger
    if (self.sounds == 0)
    {
        precache_sound ("misc/null.wav");
        self.noise = "misc/null.wav";
    }
    else if (self.sounds == 1)
    {
        precache_sound ("misc/secret.wav");
        self.noise = "misc/secret.wav";
    }
    else if (self.sounds == 2)
    {
        precache_sound ("misc/talk.wav");
        self.noise = "misc/talk.wav";
    }
    else if (self.sounds == 3)
    {
        precache_sound ("misc/trigger1.wav");
        self.noise = "misc/trigger1.wav";
    }
    else if (self.sounds == 4)
    {
			if (!self.noise1) //dumptruck_ds
			{
				objerror ("no soundfile set in noise1!\n");
				remove(self);
				return;
			}
			else
        precache_sound (self.noise1);
				self.noise = self.noise1;
    }

    InitTrigger();
    self.touch = onlookat_touch;
};
