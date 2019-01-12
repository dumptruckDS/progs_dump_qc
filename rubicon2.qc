//selections from Rubicon 2 qc by john fitzgibbons
float 	BREAKABLE_NO_MONSTERS = 1;
float		BREAK_EXPLODE = 2;
float		BREAK_CUSTOM = 4;

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

/*QUAKED func_explobox (0 .5 .8) ? START_OFF
An exploding brush entity.  Works just like misc_explobox.

Keys:

"health" Default 20

"dmg" default 100

*/
void () func_explobox =
{
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

		if (self.spawnflags & BREAK_CUSTOM) {
			make_breakable_templates_debris ();
		} else {
			make_breakable_debris ();
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

/*QUAKED func_breakable (0 .5 .8) ? NO_MONSTERS
A visible object that can be destroyed by shooting it. If it has a targetname, it will not be directly damageable.

BREAKABLE_NO_MONSTERS: object ignores damage from monsters

"health" Default 20

"cnt" number of pieces of debris to spawn. default 5. (was 6 -- dumptruck_ds)

"style" The style of the debris:
0 = green metal (default)
1 = red metal
2 = concrete
*/

void() break_template_setup = {
	if (self.break_template1 != "") precache_model(self.break_template1);
	if (self.break_template2 != "") precache_model(self.break_template2);
	if (self.break_template3 != "") precache_model(self.break_template3);
	if (self.break_template4 != "") precache_model(self.break_template4);
	if (self.break_template5 != "") precache_model(self.break_template5);
};

void () func_breakable = {
	break_template_setup();

	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setmodel (self, self.model);
	self.mdl_debris = "progs/debris.mdl";
	precache_model (self.mdl_debris);

	if (self.noise1 != "") precache_sound(self.noise1);

	else
		objerror("noise1 not set in entity");

	if (!self.health)
		self.health = 20;
	if (!self.cnt)
		self.cnt = 5; // was 6 dumptruck_ds

	if (self.targetname)
	{
		self.use = func_breakable_use;
	}
	else
	{
		self.takedamage = DAMAGE_YES;
		self.th_die = func_breakable_killed;
	}

};

/*
===============================================================================
trigger_ladder
===============================================================================
*/

void() ladder_touch =
{
	if (other.classname != "player")
		return;

	// if the trigger has an angles field, check player's facing direction
	if (self.movedir != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
			return;		// not facing the right way
	}
	other.onladder = 1;
	other.gravity = 0.0000001; //zero doesnt seem to work
}

/*QUAKED trigger_ladder (.5 .5 .5) ?
invisible ladder entity. when player is touching this entity, he can climb by pushing 'jump'

Keys:

"angle" the direction player must be facing to climb ladder
*/
void() trigger_ladder =
{
	InitTrigger ();
	self.touch = ladder_touch;
};
