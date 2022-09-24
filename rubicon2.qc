//selections from Rubicon 2 qc by john fitzgibbons
//and AD breakable code modified by Qmaster,iw and dumptruck_ds
float 	BREAKABLE_NO_MONSTERS = 1;
float		BREAK_EXPLODE = 2;
float		BREAK_CUSTOM = 4;
float		START_OFF = 1;
float		SPARKS_BLUE = 2;
float		SPARKS_PALE = 4;

void() make_breakable_debris;

/*
===============================================================================
func_explobox
===============================================================================
*/

void () func_explobox_explode_silent =
{
	self.takedamage = DAMAGE_NO;
	self.origin = ((self.absmin + self.absmax) * 0.5);
	self.classname = "explo_box";
	T_RadiusDamage (self, self, self.dmg, world);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	BecomeExplosion ();

};

void () func_explobox_explode = {
	// sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
	func_explobox_explode_silent();
};

void () func_explobox_die =
{
	self.nextthink = 0.2; //for some reason, time + 0.2 doesn't work
	self.think = func_explobox_explode;
};

/*QUAKED func_explobox (0 .5 .8) ? START_OFF X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

An exploding brush entity.  Works just like misc_explobox.

Keys:

"health" Default 20

"dmg" default 100

*/
void () func_explobox =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setmodel (self, self.model);
	precache_sound ("weapons/r_exp3.wav");
	if (!self.health)
	{
		self.health = 20;
	}
	if (!self.dmg)
	{
		self.dmg = 100;
	}
	self.th_die = func_explobox_die;
	self.takedamage = DAMAGE_AIM;
};


/*
===============================================================================
func_breakable
===============================================================================
*/

.string break_template1;
.string break_template2;
.string break_template3;
.string break_template4;
.string break_template5;
.float brk_obj_count1;
.float brk_obj_count2;
.float brk_obj_count3;
.float brk_obj_count4;
.float brk_obj_count5;


// template system from Qmaster -- dumptruck_ds
void() make_breakable_templates_debris = {
	local float i;
	local entity new;

	i = 0;
	if (self.break_template1 != "") {
		while (i < self.brk_obj_count1) {
			new = spawn();
			new.model = self.break_template1;
			new.origin_x = (self.maxs_x - self.mins_x)*random() + self.mins_x;
			new.origin_y = (self.maxs_y - self.mins_y)*random() + self.mins_y;
			new.origin_z = (self.maxs_z - self.mins_z)*random() + self.mins_z;
			setmodel (new, new.model); //dumptruck_ds
			setsize (new, '0 0 0', '0 0 0');
			new.velocity = VelocityForDamage (self.health*2);
			new.movetype = MOVETYPE_BOUNCE;
			new.solid = SOLID_NOT;
			new.avelocity_x = random()*600;
			new.avelocity_y = random()*600;
			new.avelocity_z = random()*600;
			new.think = SUB_Remove;
			new.ltime = time;
			new.nextthink = time + 10 + random()*10;
			new.flags = 0;
			i++;
		}
	}

	i = 0;
	if (self.break_template2 != "") {
		while (i < self.brk_obj_count2) {
			new = spawn();
			new.model = self.break_template2;
			new.origin_x = (self.maxs_x - self.mins_x)*random() + self.mins_x;
			new.origin_y = (self.maxs_y - self.mins_y)*random() + self.mins_y;
			new.origin_z = (self.maxs_z - self.mins_z)*random() + self.mins_z;
			setmodel (new, new.model); //dumptruck_ds
			setsize (new, '0 0 0', '0 0 0');
			new.velocity = VelocityForDamage (self.health*2);
			new.movetype = MOVETYPE_BOUNCE;
			new.solid = SOLID_NOT;
			new.avelocity_x = random()*600;
			new.avelocity_y = random()*600;
			new.avelocity_z = random()*600;
			new.think = SUB_Remove;
			new.ltime = time;
			new.nextthink = time + 10 + random()*10;
			new.flags = 0;
			i++;
		}
	}

	i = 0;
	if (self.break_template3 != "") {
		while (i < self.brk_obj_count3) {
			new = spawn();
			new.model = self.break_template3;
			new.origin_x = (self.maxs_x - self.mins_x)*random() + self.mins_x;
			new.origin_y = (self.maxs_y - self.mins_y)*random() + self.mins_y;
			new.origin_z = (self.maxs_z - self.mins_z)*random() + self.mins_z;
			setmodel (new, new.model); //dumptruck_ds
			setsize (new, '0 0 0', '0 0 0');
			new.velocity = VelocityForDamage (self.health*2);
			new.movetype = MOVETYPE_BOUNCE;
			new.solid = SOLID_NOT;
			new.avelocity_x = random()*600;
			new.avelocity_y = random()*600;
			new.avelocity_z = random()*600;
			new.think = SUB_Remove;
			new.ltime = time;
			new.nextthink = time + 10 + random()*10;
			new.flags = 0;
			i++;
		}
	}

	i = 0;
	if (self.break_template4 != "") {
		while (i < self.brk_obj_count4) {
			new = spawn();
			new.model = self.break_template4;
			new.origin_x = (self.maxs_x - self.mins_x)*random() + self.mins_x;
			new.origin_y = (self.maxs_y - self.mins_y)*random() + self.mins_y;
			new.origin_z = (self.maxs_z - self.mins_z)*random() + self.mins_z;
			setmodel (new, new.model); //dumptruck_ds
			setsize (new, '0 0 0', '0 0 0');
			new.velocity = VelocityForDamage (self.health*2);
			new.movetype = MOVETYPE_BOUNCE;
			new.solid = SOLID_NOT;
			new.avelocity_x = random()*600;
			new.avelocity_y = random()*600;
			new.avelocity_z = random()*600;
			new.think = SUB_Remove;
			new.ltime = time;
			new.nextthink = time + 10 + random()*10;
			new.flags = 0;
			i++;
		}
	}

	i = 0;
	if (self.break_template5 != "") {
		while (i < self.brk_obj_count5) {
			new = spawn();
			new.model = self.break_template5;
			new.origin_x = (self.maxs_x - self.mins_x)*random() + self.mins_x;
			new.origin_y = (self.maxs_y - self.mins_y)*random() + self.mins_y;
			new.origin_z = (self.maxs_z - self.mins_z)*random() + self.mins_z;
			setmodel (new, new.model); //dumptruck_ds
			setsize (new, '0 0 0', '0 0 0');
			new.velocity = VelocityForDamage (self.health*2);
			new.movetype = MOVETYPE_BOUNCE;
			new.solid = SOLID_NOT;
			new.avelocity_x = random()*600;
			new.avelocity_y = random()*600;
			new.avelocity_z = random()*600;
			new.think = SUB_Remove;
			new.ltime = time;
			new.nextthink = time + 10 + random()*10;
			new.flags = 0;
			i++;
		}
	}
};


//Below this is from Rubicon2 -- dumptruck_ds

void() make_breakable_debris = {
	local float i;
	i = 0;
	while (i < self.cnt)
	{
		local	entity new;

		new = spawn();
		new.origin_x = (self.maxs_x - self.mins_x)*random() + self.mins_x;
		new.origin_y = (self.maxs_y - self.mins_y)*random() + self.mins_y;
		new.origin_z = (self.maxs_z - self.mins_z)*random() + self.mins_z;
		// setmodel (new, "progs/debris.mdl"); this was originally just an mdl from Rubicon2, now you set custom model via spawnflag or use the builtin from Rubicon2 -- dumptruck_ds
		setmodel (new, self.mdl_debris); //dumptruck_ds
		setsize (new, '0 0 0', '0 0 0');
		new.velocity = VelocityForDamage (self.health*2);
		new.movetype = MOVETYPE_BOUNCE;
		new.solid = SOLID_NOT;
		new.avelocity_x = random()*600;
		new.avelocity_y = random()*600;
		new.avelocity_z = random()*600;
		new.think = SUB_Remove;
		new.ltime = time;
		new.nextthink = time + 10 + random()*10;
		new.flags = 0;

		// randomly choose size
		if (random() > 0.333)
			new.frame = 1; //larger
		else
			new.frame = 2; //smaller

		// choose skin based on "style" key
		if (self.style == 1)
			new.skin = 1;
		if (self.style == 2)
			new.skin = 2;
		if (self.style == 3) // new debris skins start here - dumptruck_ds
			new.skin = 3;
		if (self.style == 4)
		new.skin = 4;
		if (self.style == 5)
		new.skin = 5;
		if (self.style == 6)
		new.skin = 6;
		if (self.style == 7)
		new.skin = 7;
		if (self.style == 8)
		new.skin = 8;
		if (self.style == 9)
		new.skin = 9;
		if (self.style == 10)
		new.skin = 10;
		if (self.style == 11)
		new.skin = 11;
		if (self.style == 12)
		new.skin = 12;
		if (self.style == 13)
		new.skin = 13;
		if (self.style == 14)
		new.skin = 14;
		if (self.style == 15)
		new.skin = 15;
		if (self.style == 16)
		new.skin = 16;
		if (self.style == 17)
		new.skin = 17;
		if (self.style == 18)
		new.skin = 18;
		if (self.style == 19)
		new.skin = 19;
		if (self.style == 20)
		new.skin = 20;
		if (self.style == 21)
		new.skin = 21;
		if (self.style == 22)
		new.skin = 22;
		if (self.style == 23)
		new.skin = 23;
		if (self.style == 24)
		new.skin = 24;
		if (self.style == 25)
		new.skin = 25;
		if (self.style == 26)
		new.skin = 26;
		if (self.style == 27)
		new.skin = 27;
		if (self.style == 28)
		new.skin = 28;
		if (self.style == 29)
		new.skin = 29;
		if (self.style == 30)
		new.skin = 30;
		if (self.style == 31)// new debris skins end here - dumptruck_ds
		new.skin = 31;

		i = i + 1;
	}
};

void () func_breakable_die = {
	//dumptruck_ds -- set the spawnflag for cosmetic explosion effect; use "dmg" value to hurt the player
	{
		local entity ent; //thanks to Qmaster!!! He helped me sort out noise1 playing from 0 0 0 with this temp entity - dumptruck_ds

		ent = spawn();
		ent.origin = ((self.absmin + self.absmax) * 0.5);
		setsize (ent, '0 0 0', '0 0 0');
		ent.solid = SOLID_NOT;
		ent.think = SUB_Remove;
		// ent.ltime = time;
		ent.nextthink = time + 60;

		sound(ent, CHAN_AUTO, self.noise1, 1, ATTN_NORM);
		// remove (self);
	}

	// this is to ensure that any debris from another func_breakable
	// which is resting on top of this func_breakable is not left
	// floating in mid-air after this entity is removed -- iw
	SUB_DislodgeRestingEntities ();

	if (self.spawnflags & BREAK_EXPLODE) {
		if (self.spawnflags & BREAK_CUSTOM) {
			make_breakable_templates_debris ();
		} else {
			make_breakable_debris ();
		}
		func_explobox_explode_silent();  // to let us use noise2
		// sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM); this is broken as of 1.1.0 no custom explosion sound for now -- dumptruck_ds
		remove (self);
	} else {
		self.origin = ((self.absmin + self.absmax) * 0.5);
		setorigin (self, self.origin);
		DropStuff();
		if (self.spawnflags & BREAK_CUSTOM) {
			if (self.switchshadstyle) lightstyle(self.switchshadstyle, "m");
			make_breakable_templates_debris ();
			remove (self);
		} else {
			if (self.switchshadstyle) lightstyle(self.switchshadstyle, "m");
			make_breakable_debris ();
			remove (self);
		}
	}
};

void () func_breakable_killed =
{
	activator = damage_attacker;
	SUB_UseTargets ();
	func_breakable_die ();
};

void () func_breakable_use =
{
	activator = other;
	SUB_UseTargets ();
	func_breakable_die ();
};

/*QUAKED func_breakable (0 .5 .8) ? NO_MONSTERS X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

"Breakable - See manual for full details

Defaults to built-in .mdl file with 32 styles, cnt is number of pieces of debris to spawn (built-in only)
Or use spawnflag 4 and break_template1-4 to set path of custom .mdl or .bsp models.
brk_object_count1-4 sets the number of pieces of each break_template when using custom .mdl or bsp models.
If noise1 is not set it will default to various sounds in sounds/break folder
Use spawnflag 2 for an explosion, dmg is amount of damage inflicted"

spawnflags(flags)
1 : "No Monster Damage" : 0 : "Only the player can break"
2 : "Explosion" : 0 : "Produces explosion effect and sound"
4 : "Use custom mdls or bsp models" : 0 : "Uses models specified in break_template1, 2, etc"

style(choices) : "Built-in debris style" : 0
0 : "Green Metal (default)"
1 : "Red Metal"
2 : "Concrete"
3 : "Pine wood"
4 : "Brown wood"
5 : "Red wood"
6 : "Stained Glass Yellow Flames"
7 : "Stained Glass Red Rays"
8 : "Stained Glass Yellow Dragon"
9 : "Stained Glass Blue Dragon"
10 : "Stained Glass Red Dragon"
11 : "Light Copper"
12 : "Dark Copper"
13 : "Tan Bricks Large"
14 : "Brown Bricks Large"
15 : "Green Bricks Large"
16 : "Generic Light Brown"
17 : "Red Brown Computer"
18 : "Grey Black Computer"
19 : "Blue Green Metal"
20 : "Blue Green Runic Wall"
21 : "Brown Metal"
22 : "Dark Brown Metal"
23 : "Medium Brown Metal"
24 : "Blue Metal"
25 : "Green Stonework"
26 : "Blue Stonework"
27 : "Brown Bricks"
28 : "Tan Blue Bricks"
29 : "Red Bricks"
30 : "Blue Bricks"
31 : "Metal Rivets"

noise1(string) : "Break noise (overrides default sounds)"
cnt(integer) : "Number of pieces of debris to spawn" : 5
health(integer) : "Health of breakable" : 20
dmg(integer) : "Amount of Explosive Damage" : 20
break_template1(string) : "Template 1 model path, e.g. maps/break/brk.bsp or progs/brick.mdl"
break_template2(string) : "Template 2 model path, e.g. maps/break/brk.bsp or progs/brick.mdl"
break_template3(string) : "Template 3 model path, e.g. maps/break/brk.bsp or progs/brick.mdl"
break_template4(string) : "Template 4 model path, e.g. maps/break/brk.bsp or progs/brick.mdl"
break_template5(string) : "Template 5 model path, e.g. maps/break/brk.bsp or progs/brick.mdl"
brk_obj_count1(integer) : "Template 1 spawn count"
brk_obj_count2(integer) : "Template 2 spawn count"
brk_obj_count3(integer) : "Template 3 spawn count"
brk_obj_count4(integer) : "Template 4 spawn count"
brk_obj_count5(integer) : "Template 5 spawn count"
*/

void() break_template_setup = {
	if (self.break_template1 != "") precache_model(self.break_template1);
	if (self.break_template2 != "") precache_model(self.break_template2);
	if (self.break_template3 != "") precache_model(self.break_template3);
	if (self.break_template4 != "") precache_model(self.break_template4);
	if (self.break_template5 != "") precache_model(self.break_template5);
};

void () func_breakable = {
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	break_template_setup();

	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setmodel (self, self.model);
	self.mdl_debris = "progs/debris.mdl";
	precache_model (self.mdl_debris);
	precache_sound ("blob/hit1.wav");

	if (self.noise1 != "") precache_sound(self.noise1);
// adding new default sounds for "simple" breakables in 1.2.0 -- dumptruck_ds
// here's genreic metal breaking
	if (self.style == 0 || self.style == 11 || self.style == 12 || self.style == 17 || self.style == 18 || self.style == 19
		|| self.style == 24 || self.style == 31)
		if !(self.noise1)
	{
		precache_sound("break/metal2.wav");
		self.noise1 = "break/metal2.wav";
	}
	if (self.style == 3 || self.style == 4 || self.style == 5)
		if !(self.noise1)
	{
		precache_sound("break/wood1.wav");
		precache_sound("break/wood2.wav");
		if (random() > 0.6) // wood only randomized
		self.noise1 = "break/wood1.wav";
		else
		self.noise1 = "break/wood2.wav";
	}
	// glass sounds -- this is more of a shattering sound anyway
	if (self.style == 6 || self.style == 7 || self.style == 8 || self.style == 9 || self.style == 10)
		if !(self.noise1)
	{
		precache_sound("break/metal1.wav");
		self.noise1 = "break/metal1.wav";
	}
	if (self.style == 1 || self.style == 2 || self.style == 13 || self.style == 14
		|| self.style == 15 || self.style == 16 || self.style == 20 || self.style == 21
		|| self.style == 22 || self.style == 23)
		if !(self.noise1)
	{
		precache_sound("break/stones1.wav");
		precache_sound("break/bricks1.wav");
		if (random() > 0.6) // wood only randomized
		self.noise1 = "break/bricks1.wav";
		else
		self.noise1 = "break/stones1.wav";
	}
	if (self.style == 25 || self.style == 26 || self.style == 27 || self.style == 28 || self.style == 29 || self.style == 30)
		if !(self.noise1)
	{
		precache_sound("break/stones1.wav");
		precache_sound("break/bricks1.wav");
		if (random() > 0.6) // wood only randomized
		self.noise1 = "break/stones1.wav";
		else
		self.noise1 = "break/bricks1.wav";
	}
	// else
	// 	(self.noise1 = "blob/hit1.wav");

	if (!self.health)
		self.health = 20;
	if (!self.cnt)
		self.cnt = 5; // was 6 dumptruck_ds

	if (self.targetname != "")
	{
		self.use = func_breakable_use;
	}
	else
	{
		self.takedamage = DAMAGE_YES;
		self.th_die = func_breakable_killed;
	}

	if (self.switchshadstyle) lightstyle(self.switchshadstyle, "a");
};

/*
===============================================================================
trigger_ladder
===============================================================================
*/

void() ladder_touch =
{
	// from Copper -- dumptruck_ds
	if (!CheckValidTouch()) return;

	// prevent the player "sticking" to a ladder if they are standing on
	// the platform at the top of the ladder with the bottom of their
	// bounding box flush with the top of the trigger -- iw
	if (other.absmin_z + 1 >= self.absmax_z - 1)
		return;

	// if the trigger has an angles field, check player's facing direction
	if (self.movedir != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
			return;		// not facing the right way
	}
	other.onladder = 1;
}

/*QUAKED trigger_ladder (.5 .5 .5) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
invisible ladder entity. when player is touching this entity, he can climb by pushing 'jump'

Keys:

"angle" the direction player must be facing to climb ladder
*/
void() trigger_ladder =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	// ignore an "up" or "down" angle (doesn't make sense for a ladder)
	if (self.angles_y == -1 || self.angles_y == -2)
	{
		dprint ("WARNING: trigger_ladder ignored bad 'angle' value: ");
		dprint (ftos (self.angles_y));
		dprint ("\n");

		self.angles_y = 0;
	}

	InitTrigger ();
	self.touch = ladder_touch;

	SUB_CheckWaiting();
};
/*
===============================================================================
func_laser
===============================================================================
*/
float LASER_SOLID = 2;
.string		message2;
.float		alpha;


void() laser_helper_think =
{
	if (!self.owner || self.owner.classname != "func_laser")
	{
		remove(self);
		return;
	}


	if (!(self.owner.spawnflags & START_OFF))
		self.owner.alpha = self.alpha * 0.8 + self.alpha * random() * 0.4;

	self.nextthink = time + 0.05;
};

void() func_laser_touch =
{
	// from Copper -- dumptruck_ds
	if (other.movetype == MOVETYPE_NOCLIP)
			return;

	if (other.takedamage && self.attack_finished < time)
	{
		T_Damage (other, self, self, self.dmg);
		self.attack_finished = time + 0.1;
	}

};

void () func_laser_use =
{
	if (self.spawnflags & START_OFF)
	{
		setorigin(self, '0 0 0');
		self.spawnflags = self.spawnflags - START_OFF;

		// changed for progs_dump: the laser sound is now emitted from
		// the func_laser itself instead of from the activator -- iw
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

		if (activator.classname == "player" && self.message != "")
		{
			centerprint (activator, self.message);
		}
	}
	else
	{
		// changed for progs_dump: the laser sound is now emitted from
		// the func_laser itself instead of from the activator -- iw
		sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);

		setorigin(self, '0 0 9000');
		self.spawnflags = self.spawnflags + START_OFF;

		if (activator.classname == "player" && self.message2 != "")
		{
			centerprint (activator, self.message2);
		}
	}
};

/*QUAKED func_laser (0 .5 .8) ? START_OFF LASER_SOLID X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

A toggleable laser, hurts to touch, can be used to block players

START_OFF: Laser starts off.

LASER_SOLID: Laser blocks movement while turned on.

Keys:

"dmg" damage to do on touch. default 1

"alpha" approximate alpha you want the laser drawn at. default 0.5. alpha will vary by 20% of this value.

"message" message to display when activated

"message2" message to display when deactivated

*/
void () func_laser =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	local entity helper;

	setmodel (self, self.model);

	precache_sound ("buttons/switch02.wav");
	precache_sound ("buttons/switch04.wav");

	if (self.spawnflags & LASER_SOLID)
	{
		self.solid = SOLID_BSP; //so you can shoot between lasers in a single bmodel
		self.movetype = MOVETYPE_PUSH; //required becuase of SOLID_BSP
	}
	else
	{
		self.solid = SOLID_TRIGGER;
		self.movetype = MOVETYPE_NONE;
	}

	if (!self.alpha)
		self.alpha = 0.5;

	if (!self.dmg)
		self.dmg = 1;

	self.use = func_laser_use;
	self.touch = func_laser_touch;

	if (self.spawnflags & START_OFF)
		setorigin(self, '0 0 9000');
		{
		if (self.noise != "") precache_sound(self.noise);

		else
			(self.noise = "buttons/switch02.wav");
		}
		{
		if (self.noise1 != "") precache_sound(self.noise1);

		else
			(self.noise1 = "buttons/switch04.wav");
		}




	//spawn a second entity to handle alpha changes, since MOVETYPE_PUSH doesn't support think functions
	helper = spawn();
	helper.alpha = self.alpha;
	helper.owner = self;
	helper.nextthink = 0.05;
	helper.think = laser_helper_think;
};

/*
===============================================================================
misc_sparks
===============================================================================
*/

void()	sparks_fade1 = [0, sparks_fade2] {self.alpha = 0.8; self.nextthink = time + 0.05;};
void()	sparks_fade2 = [0, sparks_fade3] {self.alpha = 0.6; self.nextthink = time + 0.05;};
void()	sparks_fade3 = [0, sparks_fade4] {self.alpha = 0.4; self.nextthink = time + 0.05;};
void()	sparks_fade4 = [0, SUB_Remove]   {self.alpha = 0.2; self.nextthink = time + 0.05;};

void() sparks_use =
{
	if (self.spawnflags & START_OFF)
		self.spawnflags = self.spawnflags - START_OFF;
	else
		self.spawnflags = self.spawnflags + START_OFF;
};

void() make_sparks;

void() spark_turnofflight =
{
	SUB_UseTargets();
	self.think = make_sparks;
	self.nextthink = time + (random() + 0.5)*self.wait - 0.15;
}

void() make_sparks =
{

	if (self.spawnflags & START_OFF)
	{
		self.nextthink = time + 0.1;
		self.think = make_sparks;
	}
	else
	{
		local float i;
		i = -0.25*self.cnt + random()*0.5*self.cnt;
		while (i < self.cnt)
		{

			local entity spark;
			spark = spawn();
			spark.owner = self;
			setmodel (spark, "progs/spark.mdl");
			setorigin (spark, self.origin);
			spark.movetype = MOVETYPE_BOUNCE;
			spark.solid = SOLID_TRIGGER;
			spark.gravity = 0.3;
			spark.velocity_x = -40 + random() * 80;
			spark.velocity_y = -40 + random() * 80;
			spark.velocity_z = -40 + random() * 80;
			spark.avelocity = '3000 3000 3000';
			spark.nextthink = time + 0.5 + 1.5*random();
			spark.think = sparks_fade1;
			spark.classname = "spark";

			if (random() < 0.33)
				spark.skin = 0;
			else if (random() < 0.5)
				spark.skin = 1;
			else
				spark.skin = 2;

			if (self.spawnflags & SPARKS_PALE)
				spark.skin = spark.skin + 6;
			else if (self.spawnflags & SPARKS_BLUE)
				spark.skin = spark.skin + 3;

			setsize (spark, '0 0 0', '0 0 0');
			i = i + 1;
		}
		if (self.sounds == 1)
			{
				if (self.noise != "")
					{
					sound (self, CHAN_AUTO, self.noise, 1, ATTN_STATIC);
					}
				else
					sound (self, CHAN_AUTO, "enforcer/enfstop.wav", 1, ATTN_STATIC);
			}
		SUB_UseTargets();
		self.nextthink = time + 0.1 + random() * 0.1;
		self.think = spark_turnofflight;

	}

};

/*QUAKED misc_sparks (0 .5 .8) (-8 -8 -8) (8 8 8) START_OFF SPARKS_BLUE SPARKS_PALE X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Produces a burst of yellow sparks at random intervals. If targeted, it will toggle between on or off.  If it targets a light, that light will flash allong with each burst of sparks. Note: targeted lights should be set to START_OFF.

SPARKS_BLUE: sparks are blue in color

SPARKS_PALE: sparks are pale yellow in color

Keys:

"wait" is the average delay between bursts (variance is 1/2 wait). Default is 2.

"cnt" is the average number of sparks in a burst (variance is 1/4 cnt). Default is 15.

"sounds"
0)	no sound
1)	sparks
*/
void() misc_sparks =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model ("progs/spark.mdl");
	if (!self.noise)
	precache_sound ("dump/spark.wav");
	else
	precache_sound (self.noise);

	if (!self.movedir)
		self.movedir = '0 0 -30';
	if (!self.wait)
		self.wait = 2;
	if (!self.cnt)
		self.cnt = 15;

	self.use = sparks_use;
	self.nextthink = time + random()*0.1;
	self.think = make_sparks;
};

/*
===============================================================================
misc_particles a.k.a. misc_splash
===============================================================================
*/
void() splash_use =
{
	if (self.spawnflags & START_OFF)
		self.spawnflags = self.spawnflags - START_OFF;
	else
		self.spawnflags = self.spawnflags + START_OFF;
};

void() splash_think =
{
	if (self.spawnflags & START_OFF)
	{
		self.nextthink = time + 0.1;
		self.think = splash_think;
	}
	else
	{
		local vector vec;
		local float variance;
		variance = vlen(self.movedir) / 2;
		vec_x = self.movedir_x - variance + random() * variance * 2;
		vec_y = self.movedir_y - variance + random() * variance * 2;
		vec_z = self.movedir_z - variance + random() * variance * 2;
		particle (self.origin, vec, self.color, self.volume);
		self.nextthink = time + self.wait;
	}
};

//
//misc_particles
//
// renamed from misc_splash (Rubcion 2)  --dumptruck_ds
//

/*QUAKED misc_particles (0 .5 .8) (-8 -8 -8) (8 8 8) START_OFF X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Produces a continuous particle splash for waterfalls and other effects

"color" color of particles.  0 through 15, corresponds to a row of the quake palette. (default 0)

"movedir" average movement vector of particles (default 0 0 4)

"wait" time between particle generation cycles.  (default 0.1)

"volume" density of particles. (default 10)


*/
void() misc_particles =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (!self.wait)
		self.wait = 0.1;
	if (!self.movedir)
		self.movedir = '0 0 4';
	if (!self.volume)
		self.volume = 10;
	self.color = self.color * 16;

	self.use = splash_use;
	self.nextthink = time + self.wait;
	self.think = splash_think;
};

//##########################################
//#### Particle Sprayer                 ####
//##########################################

//this is from Custents not Rubicon2  -- dumptruck_ds
//renamed from func to misc

/*QUAKED misc_particlespray (0 .5 .8) (-8 -8 -8) (8 8 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
Shoots particles either when triggered, or contiuously when not triggered by anything.
"color" is the palette color of the particles

"count" is the number of particles to make each time

"delay" is the delay between each triggering

"noise" is the name of the wav file to play when triggered

"movedir" is the vector distance that the particles will travel before disappearing. (in x y z)

"duration" is the amount of time that the it will continue to release particles so that it can release a long stream of particles with only one triggering.
*/

.float	endtime;
.float	duration;

void() partspray_think =
{
	particle (self.origin, self.movedir, self.color, self.count);

	if(!self.targetname || self.endtime > time)
		self.nextthink = time + self.delay;

	if(self.noise != "")
	sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	else
	sound(self, CHAN_AUTO, "misc/null.wav", 1, ATTN_NORM);

};

void() partspray_use =
{
	self.endtime = time + self.duration;
	partspray_think();
};

void() misc_particlespray =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if ( !self.color )
		self.color = 47;
	if ( self.count <= 0 )
		self.count = 15;
	if(self.delay <= 0)
		self.delay = 0.1;
	self.classname = "particlespray";
	if (self.noise != "")
  precache_sound(self.noise);
	precache_sound ("misc/null.wav");
	self.think = partspray_think;
	if(!self.targetname)
		self.nextthink = time + 0.1 + self.delay;
	else
		self.use = partspray_use;
};
