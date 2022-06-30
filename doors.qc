
float DOOR_START_OPEN = 1;
float DOOR_DONT_LINK = 4;
float DOOR_GOLD_KEY = 8;
float DOOR_SILVER_KEY = 16;
float DOOR_TOGGLE = 32;
float DOOR_DOOM_STYLE_UNLOCK = 64;
/*

Doors are similar to buttons, but can spawn a fat trigger field around them
to open without a touch, and they link together to form simultanious
double/quad doors.

Door.owner is the master door.  If there is only one door, it points to itself.
If multiple doors, all will point to a single one.

Door.enemy chains from the master door through all doors linked in the chain.

*/

/*
=============================================================================

THINK FUNCTIONS

=============================================================================
*/

void() door_go_down;
void() door_go_up;

void() door_blocked =
{
	T_Damage (other, self, self, self.dmg);

// if a door has a negative wait, it would never come back if blocked,
// so let it just squash the object to death real fast
	if (self.wait >= 0)
	{
		if (self.state == STATE_DOWN)
			door_go_up ();
		else
			door_go_down ();
	}
};


void() door_hit_top =
{
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_TOP;
	if (self.spawnflags & DOOR_TOGGLE)
		return;		// don't come down automatically
	self.think = door_go_down;
	self.nextthink = self.ltime + self.wait;
};

void() door_hit_bottom =
{
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_BOTTOM;
};

void() door_go_down =
{
	entity shadow;
	entity oldself;
	
	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	if (self.max_health)
	{
		self.takedamage = DAMAGE_YES;
		self.health = self.max_health;
	}

	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos1, self.speed, door_hit_bottom);
	
	if(self.switchshadstyle) {
		shadow = self.shadowcontroller;
		oldself = self;
		self = shadow;
		
		if(oldself.spawnflags & DOOR_START_OPEN) {
			shadow_fade_out();
			shadow.shadowoff = 1;
		} else {
			shadow_fade_in();
			shadow.shadowoff = 0;
		}
		
		self = oldself;
		
	}
};

void() door_go_up =
{
	entity shadow;
	entity oldself;
	
	if (self.state == STATE_UP)
		return;		// allready going up

	if (self.state == STATE_TOP)
	{	// reset top wait time
		self.nextthink = self.ltime + self.wait;
		return;
	}

	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove (self.pos2, self.speed, door_hit_top);

	SUB_UseTargets();
	
	if(self.switchshadstyle) {
		shadow = self.shadowcontroller;
		oldself = self;
		self = shadow;
		
		if(oldself.spawnflags & DOOR_START_OPEN) {
			shadow_fade_in();
			shadow.shadowoff = 0;
		} else {
			shadow_fade_out();
			shadow.shadowoff = 1;
		}
		
		self = oldself;
	}
};


void() door_group_go_down = {
	local entity oself, starte;
	
	oself = self;
	starte = self;

	do
	{
		door_go_down ();
		self = self.enemy;
	} while ( (self != starte) && (self != world) );
	self = oself;

};

void() door_group_go_up = {
	local entity oself, starte;
	
	oself = self;
	starte = self;

	do
	{
		door_go_up ();
		self = self.enemy;
	} while ( (self != starte) && (self != world) );

	self = oself;
};

/*
=============================================================================

ACTIVATION FUNCTIONS

=============================================================================
*/

void() door_fire =
{

	if (self.owner != self)
		objerror ("door_fire: self.owner != self");

	if (self.estate != STATE_ACTIVE) 
		return;
// self.noise4 is now played in keylock_try_to_unlock -- iw

	self.message = string_null;		// no more message
	

	if (self.spawnflags & DOOR_TOGGLE)
	{
		if (self.state == STATE_UP || self.state == STATE_TOP)
		{
			door_group_go_down();
			return;
		}
	}

	// trigger all paired doors
	door_group_go_up();
};


void() door_use =
{
	local entity oself;

	self.message = "";			// door message are for touch only
	self.owner.message = "";
	self.enemy.message = "";
	oself = self;
	self = self.owner;
	door_fire ();
	self = oself;
};


void() door_trigger_touch =
{
	if (other.health <= 0)
		return;

	if (other.movetype == MOVETYPE_NOCLIP) // from copper -- dumptruck_ds
		return;

	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 1;

	activator = other;

	self = self.owner;
	door_use ();
};


void() door_killed =
{
	local entity oself;

	oself = self;
	self = self.owner;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;	// wil be reset upon return
	door_use ();
	self = oself;
};


/*
================
door_unlock

Perform the actions which should be performed when self is successfully
unlocked with a key.

This function exists so that it can be passed as an argument to the new
keylock_try_to_unlock function.  This code was previously part of the
door_touch function.  -- iw
================
*/
void() door_unlock =
{
	if (!(self.spawnflags & DOOR_DOOM_STYLE_UNLOCK))
	{
		self.touch = SUB_Null;
		if (self.enemy)
			self.enemy.touch = SUB_Null;	// get paired door
	}
	door_use ();
};


/*
================
door_touch

Prints messages and opens key doors
================
*/
void() door_touch =
{
	// if (other.classname != "player")
	// 	return;
	// from Copper -- dumptruck_ds
	if (!CheckValidTouch()) return;

	if (self.owner.attack_finished > time)
		return;

	self.owner.attack_finished = time + 2;

	if (self.owner.message != "")
	{
		centerprint (other, self.owner.message);
		sound (other, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

// key door stuff
	if (!keylock_has_key_set ())
		return;

	keylock_try_to_unlock (other, "", door_unlock);
};



/*
=============================================================================
ENTITY STATE FUNCTIONS
=============================================================================
*/

void(entity e, float closealldoors) door_estate_lock = {
	local entity oself, next;

	if (e.owner.estate == STATE_INACTIVE) return;

	// blocks linked doors from updating the same owner repeatedly
	if (e.owner.last_setstate == self && e.owner.last_setstate_frame == framecount) return;

	oself = self;
	self = e.owner;
	
	self.estate = STATE_INACTIVE;

	self.last_setstate = oself;
	self.last_setstate_frame = framecount;

	self.prevstate = self.state;
	
	if (self.state == STATE_UP || self.state == STATE_TOP) {
		if (
			// don't close wait -1 nor toggleable doors...
			!(self.wait == -1 || (self.spawnflags & DOOR_TOGGLE)) 
			// ...unless the trigger_setstate has a "Close all doors" spawnflag on
			|| closealldoors
		) 
			door_group_go_down();
		
	}

	if (self.max_health) {
		next = self;
		do {
			//e.health = 0;
			next.takedamage = DAMAGE_NO;
			next = next.enemy;
		} while ( (next != self) && (next != world) );
	}

	self = oself;

}

void(entity e, float openalldoors) door_estate_unlock = {
	local entity oself, next;
	
	if (e.owner.estate == STATE_ACTIVE) return;

	// blocks linked doors from updating the same owner repeatedly
	if (e.owner.last_setstate == self && e.owner.last_setstate_frame == framecount) return;

	oself = self;
	self = e.owner;

	self.last_setstate = oself;
	self.last_setstate_frame = framecount;

	if (self.prevstate == STATE_UP || self.prevstate == STATE_TOP) {
		if (
			(self.wait == -1 || (self.spawnflags & DOOR_TOGGLE))
			&& openalldoors
		) door_group_go_up();
	}

	if (self.max_health) {
		next = self;
		do {
			next.health = next.max_health;
			next.takedamage = DAMAGE_YES;
			next = next.enemy;
		} while ( (next != self) && (next != world) );
	}

	self.estate = STATE_ACTIVE;
	self = oself;
}


/*
=============================================================================

SPAWNING FUNCTIONS

=============================================================================
*/


entity(vector fmins, vector fmaxs) spawn_field =
{
	local entity	trigger;
	local	vector	t1, t2;

	trigger = spawn();
	trigger.movetype = MOVETYPE_NONE;
	trigger.solid = SOLID_TRIGGER;
	trigger.owner = self;
	trigger.touch = door_trigger_touch;

	t1 = fmins;
	t2 = fmaxs;
	setsize (trigger, t1 - '60 60 8', t2 + '60 60 8');
	return (trigger);
};


float (entity e1, entity e2) EntitiesTouching =
{
	if (e1.mins_x > e2.maxs_x)
		return FALSE;
	if (e1.mins_y > e2.maxs_y)
		return FALSE;
	if (e1.mins_z > e2.maxs_z)
		return FALSE;
	if (e1.maxs_x < e2.mins_x)
		return FALSE;
	if (e1.maxs_y < e2.mins_y)
		return FALSE;
	if (e1.maxs_z < e2.mins_z)
		return FALSE;
	return TRUE;
};


/*
=============
LinkDoors


=============
*/
void() LinkDoors =
{
	local entity	t, starte;
	local vector	cmins, cmaxs;

	if (self.enemy)
		return;		// already linked by another door
	if (self.spawnflags & 4)
	{
		self.owner = self.enemy = self;
		return;		// don't want to link this door
	}

	cmins = self.mins;
	cmaxs = self.maxs;

	starte = self;
	t = self;

	do
	{
		self.owner = starte;			// master door

		if (self.health)
			starte.health = self.health;
		if (self.targetname != "")
			starte.targetname = self.targetname;
		if (self.message != "")
			starte.message = self.message;

		t = find (t, classname, self.classname);
		if (!t)
		{
			self.enemy = starte;		// make the chain a loop

		// shootable, fired, or key doors just needed the owner/enemy links,
		// they don't spawn a field

			self = self.owner;

			if (self.health)
				return;
			if (self.targetname != "")
				return;
			if (keylock_has_key_set ())
				return;

			self.owner.trigger_field = spawn_field(cmins, cmaxs);

			return;
		}

		if (EntitiesTouching(self,t))
		{
			if (t.enemy)
				objerror ("cross connected doors");

			self.enemy = t;
			self = t;

			if (t.mins_x < cmins_x)
				cmins_x = t.mins_x;
			if (t.mins_y < cmins_y)
				cmins_y = t.mins_y;
			if (t.mins_z < cmins_z)
				cmins_z = t.mins_z;
			if (t.maxs_x > cmaxs_x)
				cmaxs_x = t.maxs_x;
			if (t.maxs_y > cmaxs_y)
				cmaxs_y = t.maxs_y;
			if (t.maxs_z > cmaxs_z)
				cmaxs_z = t.maxs_z;
		}
	} while (1 );

};


/*QUAKED func_door (0 .5 .8) ? START_OPEN x DOOR_DONT_LINK GOLD_KEY SILVER_KEY TOGGLE X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

if two doors touch, they are assumed to be connected and operate as a unit.

TOGGLE causes the door to wait in both the start and end states for a trigger event.

START_OPEN causes the door to move to its destination when spawned, and operate in reverse.  It is used to temporarily or permanently close off an area when triggered (not useful for touch or takedamage doors).

Key doors are always wait -1.

"message"	is printed when the door is touched if it is a trigger door and it hasn't been fired yet
"angle"	determines the opening direction
"targetname" if set, no touch field will be spawned and a remote button or trigger field activates the door.
"health"	if set, door must be shot open
"speed"	movement speed (100 default)
"wait"	wait before returning (3 default, -1 = never return)
"lip"	lip remaining at end of move (8 default)
"dmg"	damage to inflict when blocked (2 default)
"cnt"	if 1, leave a used key in the player's inventory (0 default)
"keyname"	if set, this is the keyname of the item_key_custom which unlocks this entity
"noise1"	sound file for the "stop moving" sound (if set, overrides "sounds")
"noise2"	sound file for the "move" sound (if set, overrides "sounds")
"noise3"	sound file for the "key required" sound (default is per worldtype)
"noise4"	sound file for the "key used" sound (default is per worldtype)
"sounds"
0)	no sound
1)	stone
2)	base
3)	stone chain
4)	screechy metal
*/

void() func_door =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	local string default_noise1;
	local string default_noise2;
	entity shadow;
	entity oldself;

// self.noise3 and self.noise4 can now be overridden by the mapper, but
// will be set to default values in keylock_init if necessary -- iw
	keylock_init ();

// self.noise1 and self.noise2 can now be overridden by the mapper -- iw
	default_noise1 = "misc/null.wav";
	default_noise2 = "misc/null.wav";
	if (self.sounds == 1)
	{
		default_noise1 = "doors/drclos4.wav";
		default_noise2 = "doors/doormv1.wav";
	}
	if (self.sounds == 2)
	{
		default_noise1 = "doors/hydro2.wav";
		default_noise2 = "doors/hydro1.wav";
	}
	if (self.sounds == 3)
	{
		default_noise1 = "doors/stndr2.wav";
		default_noise2 = "doors/stndr1.wav";
	}
	if (self.sounds == 4)
	{
		default_noise1 = "doors/ddoor2.wav";
		default_noise2 = "doors/ddoor1.wav";
	}

	if (self.noise1 == "")
		self.noise1 = default_noise1;
	if (self.noise2 == "")
		self.noise2 = default_noise2;

	precache_sound (self.noise1);
	precache_sound (self.noise2);

	SetMovedir ();

	self.max_health = self.health;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);
	setmodel (self, self.model);
	//self.classname = "door";

	self.blocked = door_blocked;
	self.use = door_use;

	if (self.spawnflags & DOOR_SILVER_KEY){
		keylock_set_silver_key ();
		
		if (self.keyname != "") {
			self.netname = self.keyname;
			self.keyname = "";
		}
	}
	if (self.spawnflags & DOOR_GOLD_KEY){
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

	if (!self.speed)
		self.speed = 100;
	if (!self.wait)
		self.wait = 3;
	if (!self.lip)
		self.lip = 8;
	if (!self.dmg)
		self.dmg = 2;

	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);

// DOOR_START_OPEN is to allow an entity to be lighted in the closed position
// but spawn in the open position
	if (self.spawnflags & DOOR_START_OPEN)
	{
		setorigin (self, self.pos2);
		self.pos2 = self.pos1;
		self.pos1 = self.origin;
	}

	self.state = STATE_BOTTOM;

	if (self.health)
	{
		self.takedamage = DAMAGE_YES;
		self.th_die = door_killed;
	}

	if (self.spawnflags & DOOR_DOOM_STYLE_UNLOCK)
		self.cnt = 1;

	if (keylock_has_key_set ())
	{
		if (!(self.spawnflags & DOOR_DOOM_STYLE_UNLOCK))
		{
			self.wait = -1;
		}
	}
	self.touch = door_touch;

// LinkDoors can't be done until all of the doors have been spawned, so
// the sizes can be detected properly.
	self.think = LinkDoors;
	self.nextthink = self.ltime + 0.1;
	
	// creates a shadow controller entity for the door if it has switchable shadows
	if(self.switchshadstyle) {
		
		shadow = spawn();
		
		self.shadowcontroller = shadow;
		
		shadow.classname = "misc_shadowcontroller";
		shadow.switchshadstyle = self.switchshadstyle;
		shadow.speed = vlen(self.pos2 - self.pos1) / self.speed;
		
		if(self.spawnflags & DOOR_START_OPEN) shadow.spawnflags = 1;
		else shadow.spawnflags = 0;
		
		
		oldself = self;
		
		self = shadow;
		misc_shadowcontroller();
		
		self = oldself;
	}
};

/*
=============================================================================

SECRET DOORS

=============================================================================
*/

void() fd_secret_move1;
void() fd_secret_move2;
void() fd_secret_move3;
void() fd_secret_move4;
void() fd_secret_move5;
void() fd_secret_move6;
void() fd_secret_done;

float SECRET_OPEN_ONCE = 1;		// stays open
float SECRET_1ST_LEFT = 2;		// 1st move is left of arrow
float SECRET_1ST_DOWN = 4;		// 1st move is down from arrow
float SECRET_NO_SHOOT = 8;		// only opened by trigger
float SECRET_YES_SHOOT = 16;	// shootable even if targeted


void () fd_secret_use =
{
	local float temp;

	self.health = 10000;

	// exit if still moving around...
	if (self.origin != self.oldorigin)
		return;

	self.message = string_null;		// no more message

	SUB_UseTargets();				// fire all targets / killtargets

	if (!(self.spawnflags & SECRET_NO_SHOOT))
	{
		self.th_pain = SUB_NullPain;
		self.takedamage = DAMAGE_NO;
	}
	self.velocity = '0 0 0';

	// Make a sound, wait a little...

	sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.nextthink = self.ltime + 0.1;

	temp = 1 - (self.spawnflags & SECRET_1ST_LEFT);	// 1 or -1
	makevectors(self.mangle);

	if (!self.t_width)
	{
		if (self.spawnflags & SECRET_1ST_DOWN)
			self. t_width = fabs(v_up * self.size);
		else
			self. t_width = fabs(v_right * self.size);
	}

	if (!self.t_length)
		self. t_length = fabs(v_forward * self.size);

	if (self.spawnflags & SECRET_1ST_DOWN)
		self.dest1 = self.origin - v_up * self.t_width;
	else
		self.dest1 = self.origin + v_right * (self.t_width * temp);

	self.dest2 = self.dest1 + v_forward * self.t_length;
	SUB_CalcMove(self.dest1, self.speed, fd_secret_move1);
	sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
};

void(entity attacker, float damage) fd_secret_pain = { fd_secret_use(); };

// Wait after first movement...
void () fd_secret_move1 =
{
	self.nextthink = self.ltime + 1.0;
	self.think = fd_secret_move2;
	sound(self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
};

// Start moving sideways w/sound...
void () fd_secret_move2 =
{
	sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	SUB_CalcMove(self.dest2, self.speed, fd_secret_move3);
};

// Wait here until time to go back...
void () fd_secret_move3 =
{
	sound(self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
	if (!(self.spawnflags & SECRET_OPEN_ONCE))
	{
		self.nextthink = self.ltime + self.wait;
		self.think = fd_secret_move4;
	}
};

// Move backward...
void () fd_secret_move4 =
{
	sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	SUB_CalcMove(self.dest1, self.speed, fd_secret_move5);
};

// Wait 1 second...
void () fd_secret_move5 =
{
	self.nextthink = self.ltime + 1.0;
	self.think = fd_secret_move6;
	sound(self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
};

void () fd_secret_move6 =
{
	sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	SUB_CalcMove(self.oldorigin, self.speed, fd_secret_done);
};

void () fd_secret_done =
{
	if (!self.targetname || self.spawnflags&SECRET_YES_SHOOT)
	{
		self.health = 10000;
		self.takedamage = DAMAGE_YES;
		self.th_pain = fd_secret_pain;
	}
	sound(self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
};

void () secret_blocked =
{
	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 0.5;
	T_Damage (other, self, self, self.dmg);
};

/*
================
ouch

Prints messages
================
*/
void() secret_touch =
{

	// from Copper -- dumptruck_ds
	if (!CheckValidTouch()) return;

	if (self.attack_finished > time)
		return;

	self.attack_finished = time + 2;

	if (self.message != "")
	{
		centerprint (other, self.message);
		sound (other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);
	}
};


/*QUAKED func_door_secret (0 .5 .8) ? open_once 1st_left 1st_down no_shoot always_shoot X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Basic secret door. Slides back, then to the side. Angle determines direction.
wait  = # of seconds before coming back
1st_left = 1st move is left of arrow
1st_down = 1st move is down from arrow
always_shoot = even if targeted, keep shootable
t_width = override WIDTH to move back (or height if going down)
t_length = override LENGTH to move sideways
"dmg" damage to inflict when blocked (2 default)

If a secret door has a targetname, it will only be opened by it's botton or trigger, not by damage.
"sounds"
1) medieval
2) metal
3) base
*/

void () func_door_secret =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (self.sounds == 0)
		self.sounds = 3;
	if (self.sounds == 1)
	{
		precache_sound ("doors/latch2.wav");
		precache_sound ("doors/winch2.wav");
		precache_sound ("doors/drclos4.wav");
		self.noise1 = "doors/latch2.wav";
		self.noise2 = "doors/winch2.wav";
		self.noise3 = "doors/drclos4.wav";
	}
	if (self.sounds == 2)
	{
		precache_sound ("doors/airdoor1.wav");
		precache_sound ("doors/airdoor2.wav");
		self.noise2 = "doors/airdoor1.wav";
		self.noise1 = "doors/airdoor2.wav";
		self.noise3 = "doors/airdoor2.wav";
	}
	if (self.sounds == 3)
	{
		precache_sound ("doors/basesec1.wav");
		precache_sound ("doors/basesec2.wav");
		self.noise2 = "doors/basesec1.wav";
		self.noise1 = "doors/basesec2.wav";
		self.noise3 = "doors/basesec2.wav";
	}

	if (!self.dmg)
		self.dmg = 2;

	// Magic formula...
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	//self.classname = "door";
	setmodel (self, self.model);
	setorigin (self, self.origin);

	self.touch = secret_touch;
	self.blocked = secret_blocked;
	self.speed = 50;
	self.use = fd_secret_use;
	if ( !self.targetname || self.spawnflags&SECRET_YES_SHOOT)
	{
		self.health = 10000;
		self.takedamage = DAMAGE_YES;
		self.th_pain = fd_secret_pain;
		self.th_die = fd_secret_use;
	}
	self.oldorigin = self.origin;
	if (!self.wait)
		self.wait = 5;		// 5 seconds before closing
};
