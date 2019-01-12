void() W_SetCurrentAmmo;
/* ALL LIGHTS SHOULD BE 0 1 0 IN COLOR ALL OTHER ITEMS SHOULD
BE .8 .3 .4 IN COLOR */


void() SUB_regen =
{
	self.model = self.mdl;		// restore original model
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
	sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	// play respawn sound
	setorigin (self, self.origin);

	// Supa pickup glow fix begin
	if (deathmatch)
	{
		if (self.classname == "item_artifact_invulnerability")
			self.effects = self.effects | EF_RED;
		if (self.classname == "item_artifact_super_damage")
			self.effects = self.effects | EF_BLUE;
	}
	// Supa pickup glow fix end
};

// Supa, Quoth respawning items support
// Respawn item like in DM if 'ritem' TRUE, override respawn time with 'respawndelay' if set, inc 'cnt' with each respawn and if 'respawncount' is set we'll remove the item if cnt > respawncount
// remember that SUB_Regen is already set on every item that can respawn, all we need to do is give a nextthink time in order to trigger it
.float	ritem,
		respawndelay,
		respawncount;

void(entity whatitem, float defaultdelay) CheckItemRespawn =
{
	if (!whatitem.ritem)	// respawn item if true, otherwise abort
		return;

	whatitem.cnt = whatitem.cnt + 1;	// inc before check to account for zero indexing

	if (whatitem.respawncount				)	// limited respawns
	if (whatitem.respawncount < whatitem.cnt)
		return;

	// okay, we're clear to set up a respawn

	if (whatitem.respawndelay)	// custom respawn delay?
		whatitem.nextthink = time + whatitem.respawndelay;
	else
		whatitem.nextthink = time + defaultdelay;
};


/*QUAKED noclass (0 0 0) (-8 -8 -8) (8 8 8)
prints a warning message when spawned
*/
void() noclass =
{
	dprint ("noclass spawned at");
	dprint (vtos(self.origin));
	dprint ("\n");
	remove (self);
};

void () misc_crystal_think;	// gb

/*
============
DelaySpawnItem

Makes a SPAWNED item ready for pickup on a trigger event
============
*/
void() DelaySpawnItem =
{
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.mdl);
	setsize (self, self.pos1, self.pos2);

	if (self.model == "progs/gb_crystal.mdl")	// gb, the crystal keyitem
	{
		self.think = misc_crystal_think;	// do the light show
		self.nextthink = time + 0.1;

		self.effects = EF_DIMLIGHT;
	}

	if (!(self.spawnflags & 32)) 			// SILENT, gb
		sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);

	self.use = SUB_Null;
};


// Supa, restore old hull and lock movement
void() RefreshHull =
{
	setsize (self, self.dest, self.dest2);

	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
};

/*
============
PlaceItem

plants the object on the floor
============
*/
void() PlaceItem =
{
	local float	oldz;

	if ((self.spawnflags & 128))  //ijed Don't drop spawnflag
	{
		self.mdl = self.model;		// so it can be restored on respawn
		self.flags = FL_ITEM;		// make extra wide
		self.solid = SOLID_TRIGGER;
		self.movetype = MOVETYPE_FLY;
		self.velocity = '0 0 0';
	}
	else
	{
		if (self.classname == "item_health"		||
			self.classname == "item_stimpack"		||
			self.classname == "item_armorshard"	||
			self.classname == "flagbase"			)	// Supa, CTF
		{
			// hacking around hull issues..
			setsize (self, '0 0 0',  '0 0 0');	// void hull for now

			self.think = RefreshHull;
			self.nextthink = time + 0.2;
		}

		self.mdl = self.model;		// so it can be restored on respawn
		self.flags = FL_ITEM;		// make extra wide
		self.solid = SOLID_TRIGGER;
		self.movetype = MOVETYPE_TOSS;
		self.velocity = '0 0 0';

		setorigin (self, self.origin + '0 0 6');

		if (self.model == "progs/gb_crystal.mdl")	// energy crystal keyitem?
		{
			self.awake = 1;	// start bobbing up
			self.ammo_shells = ceil(random(5));	// hopefully an int between 1 and 5
			self.alpha = 0.75;
			self.effects = EF_DIMLIGHT;

			self.think = misc_crystal_think;
			self.nextthink = time + 0.2;
		}

//		oldz = self.origin_z;
		if (!droptofloor())
		{
			print_self ("bonus item", "fell out of level");
			remove(self);
			return;
		}
	}

	if ((self.spawnflags & 64))		// SPAWNED, gb
	{
		self.pos1 = self.mins;
		self.pos2 = self.maxs;

		if (self.model == "progs/gb_crystal.mdl")
		{
			self.think = SUB_Null;	// gb, stop the light show
			self.effects = 0;
		}

		self.model = "";
		self.solid = SOLID_NOT;

		self.use = DelaySpawnItem;
	}
};

/*
============
StartItem

Sets the clipping size and plants the object on the floor
============
*/
void() StartItem =
{
	self.nextthink = time + 0.5;	// gb, was 0.2 -- items start after other solids
	self.think = PlaceItem;
};

/*
=========================================================================

HEALTH BOX

=========================================================================
*/
//
// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//

// DRS: Revised Health System stuff.  Also note that max_health barrier on megahealth is now
//      max_health * 2.
void (entity e, float healamount, float ignore) T_Heal =
{

	healamount = ceil(healamount);
	e.health = e.health + healamount;

	if ((!ignore) && (e.health >= e.max_health))
		e.health = e.max_health;

	if (e.health > rint(e.max_health*2))
		e.health = rint(e.max_health*2);

	// Megahealth = rot down the player's super health
	if (ignore == 1)
	{
// Supa, no longer needed
//		e.items = e.items | IT_SUPERHEALTH;

		if (e.rottime < time)
		e.rottime = time + 5;
	}

	// Supa, check for Rage stop threshold and remove Rage if equal/over it
	if (e.is_raged)
	if (e.health >= RAGE_THRESHOLD_STOP)
		Rage_Toggle(e);
};

/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
Health box. Normally gives 25 points.
Rotten box heals 10-20 points, megahealth will add 100 health
*/

float H_ROTTEN = 1;
float H_MEGA = 2;
.float healamount, healtype;

void() health_touch;

void() MHRot =
{
	if(self.health <= self.max_health)
	{
		self.items = self.items - (other.items & IT_SUPERHEALTH);
		return;
	}

	self.health = self.health - 1;
	self.rottime = time + 1;
};

void() item_health_go =
{
	self.touch = health_touch;

	// Supa, set size to item specified value
	setsize (self, self.dest, self.dest2);

	StartItem();
};

void() item_health =
{
//	self.touch = health_touch;

	// Move the origin into the middle of the item for the purpose of
	// both using this item as a location as well, so that other things
	// appearing at its location look sensible, and also so that if this
	// appears at another location, it will position itself sensibly there.
	//
	// Simple version of the above: Place it in the editor so that the box
	// is in the right place, and this line takes care of the rest!
	self.originhack = '16 16 0';
	// Supa, non-BSP models will void this

	if (self.spawnflags & H_MEGA)  //ijed Revised health item for worldtype set models
	{
		precache_sound("items/r_item2.wav");
		self.noise = "items/r_item2.wav";
		self.healamount = 100;
		self.healtype = 1;

		if (world.worldtype == 0)
		{
			precache_model("progs/health0m.mdl");  //ijed Medievel MegaJar
			setmodel(self, "progs/health0m.mdl");
//			setsize (self, '0 0 0', '32 32 56');

			self.dest	=	'0 0 0';
			self.dest2	=	'32 32 32';
			self.originhack = '0 0 0';

			setorigin (self, self.origin + '16 16 0');	// Supa, mangle^Wcorrect the origin for great justice^W^W^Wto account for the original bmodel offset
		}
		else if (world.worldtype == 1)
		{
			precache_model("maps/b_bh100.bsp");  //ijed runic is original for now
			setmodel(self, "maps/b_bh100.bsp");
//			setsize (self, '0 0 0', '32 32 56');

			self.dest	=	'0 0 0';
			self.dest2	=	'32 32 32';
		}
		else if (world.worldtype == 2)
		{
			precache_model("progs/health2m.mdl");  //ijed Base version finally in
			setmodel(self, "progs/health2m.mdl");
//			setsize (self, '0 0 0', '32 32 56');

			self.dest	=	'0 0 0';
			self.dest2	=	'32 32 32';
			self.originhack = '0 0 0';

			setorigin (self, self.origin + '16 16 0');	// Supa, mangle^Wcorrect the origin for great justice^W^W^Wto account for the original bmodel offset
		}
	}
	else
	{
		precache_sound("items/r_item1.wav");
		self.noise = "items/r_item1.wav";
		self.healtype = 0;

		if (self.spawnflags & H_ROTTEN)
			self.healamount = floor(random() * 10 + 10);  //ijed Randomised rotten health
		else
			self.healamount = 25;

		if (world.worldtype == 0)
		{
			precache_model ("progs/health0.mdl");  //ijed medievel health flask
			setmodel (self, "progs/health0.mdl");
//			setsize (self, '0 0 0', '32 32 56');

			self.dest	=	'-16 -16 0';
			self.dest2	=	'16 16 32';
			self.originhack = '0 0 0';

			setorigin (self, self.origin + '16 16 0');
		}
		else if (world.worldtype == 1)
		{
			precache_model ("progs/health0.mdl");  //ijed Waiting for runic model
			setmodel (self, "progs/health0.mdl");
//			setsize (self, '0 0 0', '32 32 56');

			self.dest	=	'0 0 0';
			self.dest2	=	'32 32 32';
			self.originhack = '0 0 0';

			setorigin (self, self.origin + '16 16 0');
		}
		else if (world.worldtype == 2)
		{
			precache_model ("progs/health2.mdl"); //ijed Square base health pack
			setmodel (self, "progs/health2.mdl");
//			setsize (self, '0 0 0', '32 32 56');

			self.dest	=	'0 0 0';
			self.dest2	=	'32 32 32';
			self.originhack = '0 0 0';

			setorigin (self, self.origin + '16 16 0');
		}
	}

	self.go = item_health_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_stimpack (.3 .3 1) (-16 -16 0) (16 16 32)
*/

// DRS: Stimpack.  Easy as pie.  Mmmm....Pie...*drools*
void() item_stimpack =
{
//	self.touch = health_touch;

	if (world.worldtype == 0)
	{
		precache_model ("progs/health0s.mdl");  //ijed Medievel health vial
		setmodel (self, "progs/health0s.mdl");
//		setsize (self, '-16 -16 0', '16 16 56');
	}
	else if (world.worldtype == 1)
	{
		precache_model ("progs/health0s.mdl");  //ijed Runic Placeholder
		setmodel (self, "progs/health0s.mdl");
//		setsize (self, '-16 -16 0', '16 16 56');
	}
	else if (world.worldtype == 2)
	{
		precache_model ("progs/health2s.mdl");  //ijed Tech Placeholder
		setmodel (self, "progs/health2s.mdl");
//		setsize (self, '-16 -16 0', '16 16 56');
	}

	self.dest	=	'-16 -16 0';
	self.dest2	=	'16 16 32';

	precache_sound("items/r_item1.wav");
	self.noise = "items/r_item1.wav";
	self.healamount = 5;	// RMQ team vote, was 2
	self.healtype = 2;	// 2 is no megahealth rot.
				// Set to 1 if rot desired.  Set to 0 to lock to maxheath

	self.go = item_health_go;
	if(!CheckGroup()) self.go();
};

void() health_touch =
{
	local float amount;
	local string s;

	if (other.classname != "player")
		return;

//dprint(ftos(other.max_health));  ijed Disabled for now because was blocking other messages
//dprint(" Max Health\n");
	if(self.healtype == 0 && other.health >= other.max_health)
		return;

	amount = self.healamount;

	if (self.healtype > 0) // Megahealth? Ignore max_health...
	{
		if (other.health >= rint(other.max_health*2))
			return;

		T_Heal(other, amount, self.healtype);
	}
	else T_Heal(other, amount, 0);

	sprint(other, "You receive ");
	s = ftos(amount);
	sprint(other, s);
	sprint(other, " health\n");

	// health touch sound
	if (self.healtype > 0)	// MH
		sound(other, CHAN_ITEM, self.noise, 1, ATTN_NONE);	// gb, was NORM
	else
		sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

	stuffcmd (other, "bf\n");
	self.model = string_null;
	self.solid = SOLID_NOT;

	/*
	// if (deathmatch != 2) // deathmatch 2 is the silly old rules
	if (deathmatch == 1)
	{
//		if (deathmatch)	// Supa
		self.nextthink = time + 20;
		self.think = SUB_regen;
	}
	if (deathmatch == 3)	// gb
	{
//		if (deathmatch)	// Supa
		self.nextthink = time + 15;
     	self.think = SUB_regen;
	}
	*/

	// Supa, SP respawning items support
	if (!deathmatch)
		CheckItemRespawn(self, 20);

	// Supa, gametype specific respawn times
	if (gametype)
	switch (gametype)
	{
		case FFA:		{self.nextthink = time + 20;	}	break;
		case DUEL:		{self.nextthink = time + 20;	}	break;
		case TDM:		{self.nextthink = time + 20;	}	break;
		case TDM_FF:	{self.nextthink = time + 20;	}	break;
		case CTF:		{self.nextthink = time + 20;	}	break;
		case CTF_FF:	{self.nextthink = time + 20;	}	break;
		default:
		{
			bprint("health_touch: Gametype initialisation failed!\n");
		}
		break;
	}

   	self.think = SUB_regen;

	activator = other;

	SUB_UseTargets(); // fire all targets / killtargets
};

/*
===============================================================================

ARMOR

===============================================================================
*/

void() armor_touch;
void() shard_touch;

void() armor_touch =
{
	local	float	type, value, bit;

	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;

	if (self.classname == "item_armor1")
	{
		type = 0.3;
		value = 100;
		bit = IT_ARMOR1;
	}
	if (self.classname == "item_armor2")
	{
		type = 0.6;
		value = 150;
		bit = IT_ARMOR2;
	}
	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		value = 200;
		bit = IT_ARMOR3;
	}
	if (other.armortype*other.armorvalue >= type*value)
		return;

	other.armortype = type;
	other.armorvalue = value;
	other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;

	self.solid = SOLID_NOT;
	self.model = string_null;

	/*
	if (deathmatch == 1)
	{
		self.nextthink = time + 20;
		self.think = SUB_regen;
	}
	if (deathmatch == 3)	// gb
	{
		self.nextthink = time + 30;
		self.think = SUB_regen;
	}
	*/

	// Supa, SP respawning items support
	if (!deathmatch)
		CheckItemRespawn(self, 30);

	// Supa, gametype specific respawn times
	if (gametype)
	switch (gametype)
	{
		case FFA:		{self.nextthink = time + 30;	}	break;
		case DUEL:		{self.nextthink = time + 30;	}	break;
		case TDM:		{self.nextthink = time + 30;	}	break;
		case TDM_FF:	{self.nextthink = time + 30;	}	break;
		case CTF:		{self.nextthink = time + 30;	}	break;
		case CTF_FF:	{self.nextthink = time + 30;	}	break;
		default:
		{
			bprint("armor_touch: Gametype initialisation failed!\n");
		}
		break;
	}

   	self.think = SUB_regen;

	sprint(other, "You got armor\n");

	// armor touch sound
	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);	// gb, NONE?
	stuffcmd (other, "bf\n");

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() shard_touch =
{
	local	float	bit;

	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;

	if ((other.items & IT_ARMOR1)	||
		(other.items & IT_ARMOR2)	||
		(other.items & IT_ARMOR3)	)	// has armor
	{
		// Supa, check bounds, original armourvalue + 25
		if (other.items & IT_ARMOR1 && other.armorvalue >= 125)	return;
		if (other.items & IT_ARMOR2 && other.armorvalue >= 175)	return;
		if (other.items & IT_ARMOR3 && other.armorvalue >= 225)	return;

		other.armorvalue = other.armorvalue + 5;	// was 2, RMQ team

		// Supa, now cap armourvalue to bounds
		if		(other.items & IT_ARMOR1 && other.armorvalue >= 125)	other.armorvalue = 125;
		else if (other.items & IT_ARMOR2 && other.armorvalue >= 175)	other.armorvalue = 175;
		else if (other.items & IT_ARMOR3 && other.armorvalue >= 225)	other.armorvalue = 225;
	}
	else
	{
		other.armortype = 0.3;	// GA
		other.armorvalue = 5;	// 2
		bit = IT_ARMOR1;
		other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;
	}
	self.solid = SOLID_NOT;
	self.model = string_null;

	/*
	if (deathmatch == 1)
	{
		self.nextthink = time + 20;
		self.think = SUB_regen;
	}
	if (deathmatch == 3)	// gb
	{
		self.nextthink = time + 30;
		self.think = SUB_regen;
	}
	*/

	// Supa, SP respawning items support
	if (!deathmatch)
		CheckItemRespawn(self, 30);

	// Supa, gametype specific respawn times
	if (gametype)
	switch (gametype)
	{
		case FFA:		{self.nextthink = time + 30;	}	break;
		case DUEL:		{self.nextthink = time + 30;	}	break;
		case TDM:		{self.nextthink = time + 30;	}	break;
		case TDM_FF:	{self.nextthink = time + 30;	}	break;
		case CTF:		{self.nextthink = time + 30;	}	break;
		case CTF_FF:	{self.nextthink = time + 30;	}	break;
		default:
		{
			bprint("shard_touch: Gametype initialisation failed!\n");
		}
		break;
	}

	// Supa, oh ack oh ack oh ack
	//  the LavaMonitor logic is utterly breaking knight-dropped armour shards because the
	//  various item pickup functions have no way to tell if the item was spawned as a result
	//  of a deathdrop, which would mean the item is set to check for lava Very Often and
	//  thusly has a nextthink of Very Soon which *BREATHE* means that the shard will trigger
	//  a respawn almost immediately, since it still has a nextthink set which was intended for
	//  the LavaMontior!!!1111 *THUNK*

	if (self.classname != "armorshard")	// classname set for Knight deathdrop shards
		self.think = SUB_regen;

	sprint(other, "You got armor\n");

	// armor touch sound, pickup flash
	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);	// gb, NONE?
	stuffcmd (other, "bf\n");

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() item_armor_go =
{
	if (self.classname == "item_armorshard")
		self.touch = shard_touch;
	else
		self.touch = armor_touch;

	setsize (self, '-16 -16 0', '16 16 56');

	StartItem ();
};

/*QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armor1 =
{
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 0;

	self.go = item_armor_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_armor2 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armor2 =
{
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 1;

	self.go = item_armor_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_armorInv (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armorInv =
{
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 2;

	self.go = item_armor_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_armorshard (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armorshard =
{
	if (world.worldtype == 0)  //ijed Sets shard model to worldtype model
	{
		precache_model ("progs/armorshard0.mdl");
		setmodel (self, "progs/armorshard0.mdl");
	}
	else if (world.worldtype == 1)
	{
		precache_model ("progs/armorshard1.mdl");
		setmodel (self, "progs/armorshard1.mdl");
	}
	else if (world.worldtype == 2)
	{
		precache_model ("progs/armorshard2.mdl");
		setmodel (self, "progs/armorshard2.mdl");
	}

//	self.touch = shard_touch;
//	setsize (self, '-16 -16 0', '16 16 56');
//	StartItem ();

	// Supa, store old hull for placeitem
	self.dest	= '-16 -16 0';
	self.dest2	= '16 16 56';

	self.go = item_armor_go;
	if(!CheckGroup()) self.go();
};

/*
===============================================================================

WEAPONS

===============================================================================
*/

// LA: use global max ammo constants
void() bound_other_ammo =
{
	if (other.ammo_shells > MAX_SHELLS)	//ijed Was 100
		other.ammo_shells = MAX_SHELLS;
	if (other.ammo_nails > MAX_NAILS)
		other.ammo_nails = MAX_NAILS;
	if (other.ammo_rockets > MAX_ROCKETS)	//ijed Was 100
		other.ammo_rockets = MAX_ROCKETS;
	if (other.ammo_cells > MAX_CELLS)
		other.ammo_cells = MAX_CELLS;
};

float(float w) RankForWeapon =
{
	if (self.waterlevel <= 1 && w == IT_RAILGUN)
		return 1;
	if (self.waterlevel <= 1 && w == IT_LIGHTNING)
		return 2;
	if (w == IT_ROCKET_LAUNCHER)
		return 3;
	if (w == IT_SUPER_NAILGUN)
		return 4;
	if (w == IT_GRENADE_LAUNCHER)
		return 5;
	if (w == IT_SUPER_SHOTGUN)
		return 6;
	if (w == IT_NAILGUN)
		return 7;
	return 8;
};

/*
=============
Deathmatch_Weapon

Deathmatch weapon change rules for picking up a weapon

.float		ammo_shells, ammo_nails, ammo_rockets, ammo_cells;
=============
*/
void(float old, float new) Deathmatch_Weapon =
{
	local float or, nr;

// change self.weapon if desired
	or = RankForWeapon (self.weapon);
	nr = RankForWeapon (new);
	if ( nr < or )
		self.weapon = new;
};

/*
=============
weapon_touch
=============
*/
float() W_BestWeapon;

void() weapon_touch =
{
	local	float	hadammo, best, new, new2, old;
	local	entity	stemp;
	local	float	leave;

	if (other.health <= 0)
		return;
	if (!(other.flags & FL_CLIENT))
		return;

// if the player was using his best weapon, change up to the new one if better
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

//	if (deathmatch == 2 || deathmatch == 3 || coop)	// gb, deathmatch 3 support
	// gb, deathmatch 3 support
	if (gametype == FFA	||
		coop			)
		leave = 1;
	else
		leave = 0;

	if (self.classname == "weapon_nailgun")
	{
		if (leave && (other.items & IT_NAILGUN) )
			return;
		hadammo = other.ammo_nails;
		new = IT_NAILGUN;
		other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.classname == "weapon_blaster")	// ijed, replaces NG with the Blaster
	{
		if (leave && (other.items2 & IT_BLASTER))
			return;

		hadammo = other.ammo_rockets;
		new = IT_NAILGUN;
		new2 = IT_BLASTER;
		other.ammo_cells = other.ammo_cells + 12;
	}
	else if (self.classname == "weapon_supernailgun")
	{
		if (leave && (other.items & IT_SUPER_NAILGUN) )
			return;
		hadammo = other.ammo_rockets;
		new = IT_SUPER_NAILGUN;
		other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.classname == "weapon_impacthammer")	// gb, E1 Impact Hammer
	{
		if (leave && (other.items2 & IT_IMPACT) )	// !
			return;
		hadammo = other.ammo_rockets;
		new = IT_SUPER_SHOTGUN;
		new2 = IT_IMPACT;	// !!

		other.ammo_shells = other.ammo_shells + 5;
	}
	else if (self.classname == "weapon_supershotgun")
	{
		if (leave)
		if (other.items & IT_SUPER_SHOTGUN	)
		if (!(other.items2 & IT_IMPACT)		)	// !
		if (!(other.items2 & IT_SHREDDER)	)
			return;

		hadammo = other.ammo_rockets;
		new = IT_SUPER_SHOTGUN;
		other.ammo_shells = other.ammo_shells + 5;
	}
	else if (self.classname == "weapon_shredder")	// Supa, replaces SSG with the Shredder
	{
		if (leave && (other.items2 & IT_SHREDDER))
			return;

		hadammo = other.ammo_rockets;
		new = IT_SUPER_SHOTGUN;
		new2 = IT_SHREDDER;
		other.ammo_shells = other.ammo_shells + 9;
	}
	else if (self.classname == "weapon_rocketlauncher")
	{
		if (leave && (other.items & IT_ROCKET_LAUNCHER) )
			return;
		hadammo = other.ammo_rockets;
		new = IT_ROCKET_LAUNCHER;
		other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.classname == "weapon_grenadelauncher")
	{
		if (leave && (other.items & IT_GRENADE_LAUNCHER) )
			return;
		hadammo = other.ammo_rockets;
		new = IT_GRENADE_LAUNCHER;
		other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.classname == "weapon_lightning")
	{
		if (leave && (other.items & IT_LIGHTNING) )
			return;
		hadammo = other.ammo_rockets;
		new = IT_LIGHTNING;
		other.ammo_cells = other.ammo_cells + 15;
	}
	else if (self.classname == "weapon_railgun")
	{
		if (leave && (other.items & IT_RAILGUN) )
			return;
		hadammo = other.ammo_rockets;
		new = IT_RAILGUN;
		other.ammo_cells = other.ammo_cells + 12;
	}
	else if (self.classname == "weapon_axe")	// gb, E1 old axe, not chainsaw
	{
		if (leave && (other.items2 & IT_OLDAXE) )	// !
			return;
		new = IT_AXE;
		new2 = IT_OLDAXE;	// !!
	}
	else if (self.classname == "weapon_chainsaw")
	{
		if (leave && (other.items & IT_AXE) && !(other.items2 & IT_OLDAXE) )	// !
			return;
		new = IT_AXE;
	}
	else if (self.classname == "weapon_shotgun")
	{
		if (leave && (other.items & IT_SHOTGUN) )
			return;
		hadammo = other.ammo_rockets;
		new = IT_SHOTGUN;
		other.ammo_shells = other.ammo_shells + 5;
	}
	else
		objerror ("weapon_touch: unknown classname");

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other, "\n");

	// weapon touch sound
	if (self.classname == "weapon_axe")	// gb
		sound (other, CHAN_ITEM, "weapons/pkup_axe.wav", 1, ATTN_NORM);	// gb, NONE?
	else if (self.classname == "weapon_chainsaw")	// gb
		sound (other, CHAN_ITEM, "weapons/pkup_saw.wav", 1, ATTN_NORM);	// gb, NONE?
	else
		sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);	// gb, NONE?

	stuffcmd (other, "bf\n");

	bound_other_ammo ();

	// change to the weapon
	old = other.items;
	other.items = other.items | new;

	// gb, rmq stuff
	other.items2 = other.items2 | new2;	// add weapons from .items2

	// gb, need this to ensure chainsaw and oldaxe are mutually exclusive
	// ! the code gives you the axe once self.items2 & IT_OLDAXE; hence no need to do this the other way around
	if (self.classname == "weapon_chainsaw" && (other.items2 & IT_OLDAXE))	// picking up chainsaw, AND have oldaxe?
		other.items2 = other.items2 - IT_OLDAXE;			// remove oldaxe if so

	// gb, same for Impact Hammer and SSG
	if (self.classname == "weapon_supershotgun")
	{
		if (other.items2 & IT_IMPACT)	// picking up SSG, AND have Impact?
			other.items2 -= IT_IMPACT;				// remove Impact if so

		// Supa, removes Shredder on pickup if you had one
		if (other.items2 & IT_SHREDDER)
			other.items2 -= IT_SHREDDER;
	}

	// Supa, same for the Blaster and Nailgun
	if (self.classname == "weapon_nailgun" && (other.items2 & IT_BLASTER))
		other.items2 -= IT_BLASTER;

	stemp = self;
	self = other;

//	if (!deathmatch)	// QIP fix by Maddes - do that in SP, too
//		self.weapon = new;
//	else
		Deathmatch_Weapon (old, new);

	W_SetCurrentAmmo();

	self = stemp;

	if (leave)
	{
		if (self.state == 0)
		{
			activator = other;
			SUB_UseTargets ();
			self.state = 1;
		}
		return;
	}

// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;

	/*
	if (deathmatch == 1)
		self.nextthink = time + 30;
	*/

	// Supa, SP respawning items support
	if (!deathmatch)
		CheckItemRespawn(self, 15);

	// Supa, gametype specific respawn times
	if (gametype)
	switch (gametype)
	{
//		case FFA:		{self.nextthink = time + 15;}	break;
		case DUEL:		{self.nextthink = time + 15;}	break;
		case TDM:		{self.nextthink = time + 15;}	break;
		case TDM_FF:	{self.nextthink = time + 15;}	break;
		case CTF:		{self.nextthink = time + 5;	}	break;
		case CTF_FF:	{self.nextthink = time + 5;	}	break;
		default:
		{
			bprint("weapon_touch: Gametype initialisation failed!\n");
		}
		break;
	}

	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() weapon_go =
{
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_axe (0 .5 .8) (-16 -16 0) (16 16 32)
*/
// gb
void() weapon_axe =
{
	precache_model ("progs/g_axe.mdl");
	setmodel (self, "progs/g_axe.mdl");
	self.weapon = IT_AXE;
	self.netname = "Axe";

	self.go = weapon_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED weapon_chainsaw (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_chainsaw =
{
	precache_model ("progs/g_saw.mdl");
	setmodel (self, "progs/g_saw.mdl");
	self.weapon = IT_AXE;
	self.netname = "Chainsaw";

	self.go = weapon_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED weapon_shotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_shotgun =
{
	precache_model ("progs/g_gun.mdl");
	setmodel (self, "progs/g_gun.mdl");
	self.weapon = IT_SHOTGUN;
	self.netname = "Shotgun";

	self.go = weapon_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED weapon_impacthammer (0 .5 .8) (-16 -16 0) (16 16 32)
*/
// gb
void() weapon_impacthammer =
{
	precache_model ("progs/g_shot.mdl");
	setmodel (self, "progs/g_shot.mdl");
	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Impact Hammer";

	self.go = weapon_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supershotgun =
{
	precache_model ("progs/g_shot.mdl");
	setmodel (self, "progs/g_shot.mdl");
	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Double-barrelled Shotgun";

	self.go = weapon_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED weapon_shredder (0 .5 .8) (-16 -16 0) (16 16 32)
*/
// Supa
void() weapon_shredder =
{
	precache_model ("progs/g_shredder.mdl");
	setmodel (self, "progs/g_shredder.mdl");
	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Shredder! Find some meat!";	// 'You got the Shredder! Find some meat!'

	self.go = weapon_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_nailgun =
{
	precache_model ("progs/g_nail.mdl");
	setmodel (self, "progs/g_nail.mdl");
	self.weapon = IT_NAILGUN;
	self.netname = "nailgun";

	self.go = weapon_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED weapon_blaster (0 .5 .8) (-16 -16 0) (16 16 32)
*/
// ijed
void() weapon_blaster =
{
	precache_model ("progs/g_blaster.mdl");
	setmodel (self, "progs/g_blaster.mdl");
	self.weapon = IT_NAILGUN;
	self.netname = "Blaster! Time for searing laser death!";

	self.go = weapon_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supernailgun =
{
	precache_model ("progs/g_nail2.mdl");
	setmodel (self, "progs/g_nail2.mdl");
	self.weapon = IT_SUPER_NAILGUN;
	self.netname = "Super Nailgun";

	self.go = weapon_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_grenadelauncher =
{
	precache_model ("progs/g_rock.mdl");
	setmodel (self, "progs/g_rock.mdl");
	self.weapon = 3;
	self.netname = "Grenade Launcher";

	self.go = weapon_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_rocketlauncher =
{
	precache_model ("progs/g_rock2.mdl");
	setmodel (self, "progs/g_rock2.mdl");
	self.weapon = 3;
	self.netname = "Rocket Launcher";

	self.go = weapon_go;
	if(!CheckGroup()) self.go();
};


/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_railgun;	// Supa, totally-not-a-railgun, doot de doo doo..

void() weapon_lightning =
{
	/*
	if (mapname == "dm6")	// Supa, totally-not-a-railgun, replace LG on DM6
	{
		self.classname = "weapon_railgun";
		weapon_railgun();

		return;
	}
	*/

	precache_model ("progs/g_light.mdl");
	setmodel (self, "progs/g_light.mdl");
	self.weapon = 3;
	self.netname = "Thunderbolt";

	self.go = weapon_go;
	if(!CheckGroup()) self.go();
};

// Supa, totally-not-a-railgun
void() weapon_railgun =
{
	precache_model ("progs/g_caut.mdl");	//ijed test version in
	setmodel (self, "progs/g_caut.mdl");
	self.weapon = 3;
	self.netname = "Cauteriser";  //ijed Well, it is now :)

	self.go = weapon_go;
	if(!CheckGroup()) self.go();
};


/*
===============================================================================

AMMO

===============================================================================
*/

// LA: Re-written so that ammo boxes are not removed until fully depleted in SP
// Leaving MP behaviour as before, because I think it's more correct there.
void() ammo_touch =
{
	local entity	stemp;
	local float		best;
	local float picked; // some ammo was picked up
	local float remaining; // there is some ammo still in the box

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

// if the player was using his best weapon, change up to the new one if better
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	picked = remaining = 0;

// shells
	if (self.ammo_shells > 0)
	{
		if (other.ammo_shells < MAX_SHELLS)
		{
			other.ammo_shells = other.ammo_shells + self.ammo_shells;
			picked = 1;
			if (other.ammo_shells > MAX_SHELLS)
			{
				self.ammo_shells = other.ammo_shells - MAX_SHELLS;
				remaining = 1;
			}
		}
		else
		{
			remaining = 1; // since player is full, there is obviously some left in the box
		}
	}

// nails
	if (self.ammo_nails > 0)
	{
		if (other.ammo_nails < MAX_NAILS)
		{
			other.ammo_nails = other.ammo_nails + self.ammo_nails;
			picked = 1;
			if (other.ammo_nails > MAX_NAILS)
			{
				self.ammo_nails = other.ammo_nails - MAX_NAILS;
				remaining = 1;
			}
		}
		else
		{
			remaining = 1; // since player is full...
		}
	}

// rockets
	if (self.ammo_rockets > 0)
	{
		if (other.ammo_rockets < MAX_ROCKETS)
		{
			other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
			picked = 1;
			if (other.ammo_rockets > MAX_ROCKETS)
			{
				self.ammo_rockets = other.ammo_rockets - MAX_ROCKETS;
				remaining = 1;
			}
		}
		else
		{
			remaining = 1; // since player is full...
		}
	}

// cells
	if (self.ammo_cells > 0)
	{
		if (other.ammo_cells < MAX_CELLS)
		{
			other.ammo_cells = other.ammo_cells + self.ammo_cells;
			picked = 1;
			if (other.ammo_cells > MAX_CELLS)
			{
				self.ammo_cells = other.ammo_cells - MAX_CELLS;
				remaining = 1;
			}
		}
		else
		{
			remaining = 1; // since player is full...
		}
	}

	if (!picked) return;  // Didn't pick anything up? Then sod off...

	if (deathmatch) remaining = 0; // in DM, take the whole box anyway

	bound_other_ammo ();

	if (remaining)
	{
		sprint (other, "You got some ");
	}
	else
	{
		sprint (other, "You got the ");
	}
	sprint (other, self.netname);
	sprint (other, "\n");

	// ammo touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);	// gb, NONE?
	stuffcmd (other, "bf\n");

	// change to a better weapon if appropriate

	if ( other.weapon == best )
	{
		stemp = self;
		self = other;
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo ();
		self = stemp;
	}

	// if changed current ammo, update it
	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;

	if (!remaining)
	{
		// remove it in single player, or setup for respawning in deathmatch
		self.model = string_null;
		self.solid = SOLID_NOT;

		/*
		if (deathmatch == 1)
		{
			self.nextthink = time + 30;
		}
		else if (deathmatch == 3)
		{
			self.nextthink = time + 15;	// gb, deathmatch 3 support
			self.think = SUB_regen;
		}
		*/

		// Supa, SP respawning items support
		if (!deathmatch)
			CheckItemRespawn(self, 20);

		// Supa, gametype specific respawn times
		if (gametype)
		switch (gametype)
		{
			case FFA:		{self.nextthink = time + 20;	}	break;
			case DUEL:		{self.nextthink = time + 20;	}	break;
			case TDM:		{self.nextthink = time + 20;	}	break;
			case TDM_FF:	{self.nextthink = time + 20;	}	break;
			case CTF:		{self.nextthink = time + 20;	}	break;
			case CTF_FF:	{self.nextthink = time + 20;	}	break;
			default:
			{
				bprint("ammo_touch: Gametype initialisation failed!\n");
			}
			break;
		}

		self.think = SUB_regen;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() ammo_go =
{
	self.touch = ammo_touch;
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

float WEAPON_BIG2 = 1;

/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_shells =
{
	if (self.spawnflags & WEAPON_BIG2)
	{
		//precache_model ("maps/b_shell1.bsp");
		//setmodel (self, "maps/b_shell1.bsp");
		precache_model ("progs/ammo_shells2.mdl");
		setmodel (self, "progs/ammo_shells2.mdl");
		self.ammo_shells = 30;	//ijed was 40
	}
	else
	{
		//precache_model ("maps/b_shell0.bsp");
		//setmodel (self, "maps/b_shell0.bsp");
		//ijed New model
		precache_model ("progs/ammo_shells1.mdl");
		setmodel (self, "progs/ammo_shells1.mdl");

		self.ammo_shells = 15;	//ijed Was 20
	}
	self.netname = "shells";

//	self.originhack = '16 16 0';
	self.go = ammo_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_spikes =
{
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("progs/ammo_nails1.mdl");
		setmodel (self, "progs/ammo_nails1.mdl");
		//precache_model ("maps/b_nail1.bsp");
		//setmodel (self, "maps/b_nail1.bsp");
		self.ammo_nails = 50;
	}
	else
	{
		//precache_model ("maps/b_nail0.bsp");
		//setmodel (self, "maps/b_nail0.bsp");
		//ijed New model
		precache_model ("progs/ammo_nails1.mdl");
		setmodel (self, "progs/ammo_nails1.mdl");
		self.ammo_nails = 25;
	}
	self.netname = "nails";

//	self.originhack = '16 16 0';
	self.go = ammo_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_rockets =
{
	if (self.spawnflags & WEAPON_BIG2)
	{
		//precache_model ("maps/b_rock1.bsp");
		//setmodel (self, "maps/b_rock1.bsp");
		precache_model ("progs/ammo_rockets2.mdl");
		setmodel (self, "progs/ammo_rockets2.mdl");
		self.ammo_rockets = 10;
	}
	else
	{
		precache_model ("progs/ammo_rockets1.mdl");
		setmodel (self, "progs/ammo_rockets1.mdl");
		self.ammo_rockets = 5;
	}
	self.netname = "rockets";

//	self.originhack = '16 16 0';
	self.go = ammo_go;
	if(!CheckGroup()) self.go();
};


/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_cells =
{
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("progs/ammo_cells2.mdl");
		setmodel (self, "progs/ammo_cells2.mdl");
		self.ammo_cells = 12;
	}
	else
	{
		precache_model ("progs/ammo_cells1.mdl");
		setmodel (self, "progs/ammo_cells1.mdl");
		self.ammo_cells = 6;
	}
	self.netname = "cells";

//	self.originhack = '16 16 0';
	self.go = ammo_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!
*/

// LA: Unfortunately, we have to keep this function for id1 support
// which means updating what it drops to the ammo_touch overhaul
// we skipped adding it to the randomizer, however, as no-one should be using it any more
float WEAPON_SHOTGUN = 1;
float WEAPON_ROCKET = 2;
float WEAPON_SPIKES = 4;
float WEAPON_BIG = 8;
void() item_weapon =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_SHOTGUN)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_shell1.bsp");
			setmodel (self, "maps/b_shell1.bsp");
			self.ammo_shells = 20; // 40
		}
		else
		{
			precache_model ("maps/b_shell0.bsp");
			setmodel (self, "maps/b_shell0.bsp");
			self.ammo_shells = 10; // 20
		}
		self.netname = "shells";
	}

	if (self.spawnflags & WEAPON_SPIKES)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_nail1.bsp");
			setmodel (self, "maps/b_nail1.bsp");
			self.ammo_nails = 50; // 40
		}
		else
		{
			precache_model ("maps/b_nail0.bsp");
			setmodel (self, "maps/b_nail0.bsp");
			self.ammo_nails = 25; // 20
		}
		self.netname = "nails"; // "spikes"
	}

	if (self.spawnflags & WEAPON_ROCKET)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_rock1.bsp");
			setmodel (self, "maps/b_rock1.bsp");
			self.ammo_rockets = 10;
		}
		else
		{
			precache_model ("maps/b_rock0.bsp");
			setmodel (self, "maps/b_rock0.bsp");
			self.ammo_rockets = 5;
		}
		self.netname = "rockets";
	}

	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


/*
===============================================================================

KEYS

===============================================================================
*/

float KEY_ITEM1 = 1;
float KEY_ITEM2 = 2;
float KEY_ITEM3 = 4;
float KEY_ITEM4 = 8;

void() key_touch =
{
	local entity	stemp;
	local float		best;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
	if ((other.items & self.items)
	|| (other.items2 & self.items2))
		return;

	sprint (other, "\bYou got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	other.items = other.items | self.items;
	other.items2 = other.items2 | self.items2;

	if (!coop)
	{
		self.solid = SOLID_NOT;
		self.model = string_null;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

// DRS
void() keyitem_touch =
{
	// Can't take if not a player.
	if(other.classname != "player")
		return;

	if(other.health < 1) // dead players can't take.
		return;

	if(other.keyitems & self.keyitems) // can't pick up more than one.
		return;

	sprint(other, "\bYou got ");
	sprint(other, self.netname);
	sprint(other, "\n");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NONE);	// gb, was NORM
	stuffcmd (other, "bf\n");
	other.keyitems = other.keyitems | self.keyitems;

	if (self.model == "progs/gb_crystal.mdl")	// gb, stop the light show when picked up
	{
		self.effects = 0;
		self.think = SUB_Null;
	}

	if (!coop)
	{
		self.solid = SOLID_NOT;
		self.model = string_null;
	}

	activator = other;
	SUB_UseTargets();	// fire all targets / killtargets
};

void() key_setsounds =
{
	if (world.worldtype == 0)
	{
		precache_sound ("misc/medkey.wav");
		self.noise = "misc/medkey.wav";
	}
	if (world.worldtype == 1)
	{
		precache_sound ("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}
	if (world.worldtype == 2)
	{
		precache_sound2 ("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};


void() item_key_go =
{
	self.touch = key_touch;
	key_setsounds(); // Would be faster and smaller to inline this
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_key1 (0 .5 .8) (-16 -16 -24) (16 16 32)
SILVER key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void() item_key1 =
{
	if (world.worldtype == 0)
	{
		precache_model ("progs/key_med.mdl");
		setmodel (self, "progs/key_med.mdl");
		self.netname = "silver key";
	}
	else if (world.worldtype == 1)
	{
		precache_model ("progs/key_rune.mdl");
		setmodel (self, "progs/key_rune.mdl");
		self.netname = "silver runekey";
	}
	else if (world.worldtype == 2)
	{
		precache_model2 ("progs/key_card.mdl");
		setmodel (self, "progs/key_card.mdl");
		self.netname = "silver keycard";
	}
	self.skin = 1;		//silver key skin
//	key_setsounds();
//	self.touch = key_touch;
	self.items = IT_KEY1;

	self.go = item_key_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_key2 (0 .5 .8) (-16 -16 -24) (16 16 32)
GOLD key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void() item_key2 =
{
	if (world.worldtype == 0)
	{
		precache_model ("progs/key_med.mdl");
		setmodel (self, "progs/key_med.mdl");
		self.netname = "gold key";
	}
	if (world.worldtype == 1)
	{
		precache_model ("progs/key_rune.mdl");
		setmodel (self, "progs/key_rune.mdl");
		self.netname = "gold runekey";
	}
	if (world.worldtype == 2)
	{
		precache_model2 ("progs/key_card.mdl");
		setmodel (self, "progs/key_card.mdl");
		self.netname = "gold keycard";
	}
	self.skin = 2;		//gold key skin
//	key_setsounds();
//	self.touch = key_touch;

	self.items = IT_KEY2;

	self.go = item_key_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_key3 (0 .5 .8) (-16 -16 -24) (16 16 32)
BRONZE key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void() item_key3 =
{
	if (world.worldtype == 0)
	{
		precache_model ("progs/key_med.mdl");
		setmodel (self, "progs/key_med.mdl");
		self.netname = "bronze key";
	}
	if (world.worldtype == 1)
	{
		precache_model ("progs/key_rune.mdl");
		setmodel (self, "progs/key_rune.mdl");
		self.netname = "bronze runekey";
	}
	if (world.worldtype == 2)
	{
		precache_model2 ("progs/key_card.mdl");
		setmodel (self, "progs/key_card.mdl");
		self.netname = "bronze keycard";
	}
	self.skin = 0;		//bronze key skin
//	key_setsounds();
//	self.touch = key_touch;

	self.items2 = IT_KEY3;		//items2 -otp

	self.go = item_key_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_key4 (0 .5 .8) (-16 -16 -24) (16 16 32)
PLATINUM key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void() item_key4 =
{
	if (world.worldtype == 0)
	{
		precache_model ("progs/key_med.mdl");
		setmodel (self, "progs/key_med.mdl");
		self.netname = "platinum key";
	}
	if (world.worldtype == 1)
	{
		precache_model ("progs/key_rune.mdl");
		setmodel (self, "progs/key_rune.mdl");
		self.netname = "platinum runekey";
	}
	if (world.worldtype == 2)
	{
		precache_model2 ("progs/key_card.mdl");
		setmodel (self, "progs/key_card.mdl");
		self.netname = "platinum keycard";
	}
	self.skin = 3;		//platinum key skin
//	key_setsounds();
//	self.touch = key_touch;

	self.items2 = IT_KEY4;		//items2 -otp

	self.go = item_key_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_key (0 .5 .8) (-16 -16 -24) (16 16 32) KEYITEM_2 KEYITEM_3 KEYITEM_4 x x SILENT SPAWNED DONTDROP NOEASY NOMEDIUM NOHARD NODM
User definable extended key. Can use a .mdl or be a brush model (like a func_wall etc).

This keyitem''s name must be set in worldspawn (!!!) like this:

"keyitem1"	"beast key"

Set the corresponding spawnflag here (leave blank for keyitem1).
Set the same spawnflag on the trigger_lock that expects this keyitem.
You can have up to 4 keyitems defined like this.

Keys can migrate between levels, so a clever mapper can make secret keys that
can unlock an obvious area in a succeeding map.
(Just make sure you set the name!)

Set "keyitemX_keep" "1" in worldspawn to prevent doors from removing that key from the player's inventory

In game, you can see collected keyitems in the inventory (type "inventory" in console).

"noise"		sound to play on pickup, defaults to misc/medkey.wav
"deathtype"	name of the .mdl to use, unless this is a brush model
"skin"		sets the skin if using .mdl file, skin 0 is the first
"view_ofs"	'x y z' height adjustment for non-rotational models, try '0 0 24'.
"target"	as usual
*/

// DRS
// 201012211149EST Supa, fixing alias model key bbox issues
// 201101011730EST Supa, fixing the breakage created by the previous fix -_-
// LA: Adding randomizer hook. The name of this _go function isn't ideal, but it's the most logical choice
// 201109122322EST Supa, implementing item_key-related world.keyitemX_keep flags
void() item_customkey_go =
{
	local vector szmin, szmax;
	local string whatmdl;

	if (!self.model)	// alias model? A bmodel key will already start with .model set
	{
		szmin = '-16 -16 -24';
		szmax = '16 16 32';

		whatmdl = self.deathtype;
	}
	else				// bmodel key
		whatmdl = self.model;

	szmin_z = szmin_z + self.view_ofs_z;
	szmax_z = szmax_z + self.view_ofs_z;

	setmodel (self, whatmdl);

	//ijed Allow selection of frames from map via cnt value
	if (frame)
		self.frame = self.frame;

	if (self.deathtype)	// only setsize on alias models, bmodel keys already have absmin/absmax set
		setsize (self, szmin, szmax);

	self.touch = keyitem_touch;

	StartItem ();
};



void() item_key =
{
	// no sound?  Default to medkey.wav
	if (!self.noise)
		self.noise = "misc/medkey.wav";

	// precache sounds.
	if (self.noise)
		precache_sound2 (self.noise);

	if (!self.model)	// alias model key?
	{
		if (!self.deathtype) // default to medeval silver key if no mapper model set.
			self.deathtype = "progs/w_s_key.mdl";

		precache_model (self.deathtype);
	}

	// set key and key name
	if		(self.spawnflags & 1)	{self.netname = world.keyitem2;		self.keyitems = KEY_ITEM2;	}
	else if	(self.spawnflags & 2)	{self.netname = world.keyitem3;		self.keyitems = KEY_ITEM3;	}
	else if	(self.spawnflags & 4)	{self.netname = world.keyitem4;		self.keyitems = KEY_ITEM4;	}
	else							{self.netname = world.keyitem1;		self.keyitems = KEY_ITEM1;	}

	if (!self.netname)
		self.netname = "the Mystery Key";

	self.go = item_customkey_go;
	if(!CheckGroup()) self.go();
};


// for worldcraft compat.
void() func_key =
{
	item_key();
};

void() showkeyitems =
{
	local string s1, s2, s3, s4, s5, s6, s7;

	s1 = "\bKey Items\b\n";

	if(self.keyitems & KEY_ITEM1)
		s2 = world.keyitem1;
	else s2 = "\n";

	if(self.keyitems & KEY_ITEM2)
		s3 = world.keyitem2;
	else s3 = "\n";

	if(self.keyitems & KEY_ITEM3)
		s4 = world.keyitem3;
	else s4 = "\n";

	if(self.keyitems & KEY_ITEM4)
		s5 = world.keyitem4;
	else s5 = "\n";

	s6 = "";
	s7 = "\n";

	frik_big_centerprint(self, s1, s2, s3, s4, s5, s6, s7);
};


/*
===============================================================================

END OF LEVEL RUNES

===============================================================================
*/

void() sigil_touch =
{
local entity	stemp;
local float		best;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
	if (self.spawnflags & 16)
		return;					// set spawnflag 16 for fake rune, wasn't being used for anything else... -rj

	centerprint (other, "You got the rune!");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NONE);	// gb, was NORM
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	serverflags = serverflags | (self.spawnflags & 15);
	self.classname = "";		// so rune doors won't find it

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() item_sigil_go =
{
	self.touch = sigil_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
End of level sigil, pick up to end episode and return to jrstart.
*/

void() item_sigil =
{
	if (!self.spawnflags)
		objerror ("no spawnflags");

	precache_sound ("misc/runekey.wav");
	self.noise = "misc/runekey.wav";

	if (self.spawnflags & 1)
	{
		precache_model ("progs/end1.mdl");
		setmodel (self, "progs/end1.mdl");
	}
	if (self.spawnflags & 2)
	{
		precache_model2 ("progs/end2.mdl");
		setmodel (self, "progs/end2.mdl");
	}
	if (self.spawnflags & 4)
	{
		precache_model2 ("progs/end3.mdl");
		setmodel (self, "progs/end3.mdl");
	}
	if (self.spawnflags & 8)
	{
		precache_model2 ("progs/end4.mdl");
		setmodel (self, "progs/end4.mdl");
	}

	self.go = item_sigil_go;
	if(!CheckGroup()) self.go();
};

/*
===============================================================================

POWERUPS

===============================================================================
*/

void() powerup_touch;


void() powerup_touch =
{
	local entity	stemp;
	local float	best;
#ifdef HOOK
	local float	leave;	// gb

//	if (deathmatch == 2 || deathmatch == 3 || coop)	// gb, deathmatch 3 support
	if (gametype == FFA ||
		coop			)	// gb, deathmatch 3 support
		leave = 1;
	else
		leave = 0;

	if (leave										)
	if (other.hook_equip	!= 0					)	// gb
	if (self.classname		== "item_grappling_hook"	)	// Supa, only exit if applicable
		return;
#endif
	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	// Supa, SP respawning items support
	self.mdl	= self.model;
	self.think	= SUB_regen;

	if (!deathmatch)
	{
		local float spawndelay;

		if		(self.classname == "item_artifact_invulnerability"	||
				 self.classname == "item_artifact_invisibility"		)	spawndelay = 300;
		else if (self.classname == "item_grappling_hook"			)	spawndelay = 30;
		else															spawndelay = 60;

		CheckItemRespawn(self, spawndelay);
	}
	else
	{
		if ((self.classname == "item_artifact_invulnerability") ||
		    (self.classname == "item_artifact_invisibility"))
			self.nextthink = time + 60*5;
#ifdef HOOK
		if (self.classname == "item_grappling_hook")
		{
			if (leave)
				self.nextthink = -1;
			else
				self.nextthink = time + 30;
		}
#endif
		else
			self.nextthink = time + 60;
	}

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NONE);	// gb, was NORM
	stuffcmd (other, "bf\n");
#ifdef HOOK
	if ( !(leave && self.classname == "item_grappling_hook") )
	{
#endif
		self.solid = SOLID_NOT;
		other.items = other.items | self.items;
		self.model = string_null;
#ifdef HOOK
	}
#endif

	// do the apropriate action

	if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = 1;
		other.radsuit_finished = time + 30;
	}

	if (self.classname == "item_artifact_invulnerability")
	{
		// Supa, new pent, turn off rage and regen on pickup
		if (self.is_raged)
			Rage_Toggle(self);

//		other.invincible_time = 1;
//		other.invincible_finished = time + 30;	// Supa, new pent behavior
		self.effects = self.effects - (self.effects & EF_RED);	// gb
	}

	if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = 1;
		other.invisible_finished = time + 30;
	}

	if (self.classname == "item_artifact_super_damage")
	{
		other.super_time = 1;

		if (other.super_damage_finished > time)	other.super_damage_finished += 10;			// add 10s to the timer if already on a Quad run
		else									other.super_damage_finished = time + 10;	// Supa, was 30

		self.effects = self.effects - (self.effects & EF_BLUE);	// gb
	}

	//if (self.classname == "item_artifact_res")
	//{
	//}

#ifdef HOOK
	if (self.classname == "item_grappling_hook")
	{
		other.hook_equip = 1;
	}
#endif
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() item_artifact_go =
{
	if (deathmatch)	// CRUFT
	{
		if		(self.classname == "item_artifact_invulnerability")	self.effects = self.effects | EF_RED;	// gb, powerup glow
		else if (self.classname == "item_artifact_super_damage")	self.effects = self.effects | EF_BLUE;
	}

	self.touch = powerup_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invulnerable for 30 seconds
*/
void() item_artifact_invulnerability =
{
	if (gametype == DUEL)	// Supa
		remove(self);

	precache_model ("progs/invulner.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	self.noise = "items/protect.wav";
	setmodel (self, "progs/invulner.mdl");
	self.netname = "Pentagram of Protection";
	self.items = IT_INVULNERABILITY;
//	setsize (self, '-16 -16 -24', '16 16 32');

	self.go = item_artifact_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from water or slime for 30 seconds
*/
void() item_artifact_envirosuit =
{
	precache_model ("progs/suit.mdl");
	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");
	self.noise = "items/suit.wav";
	setmodel (self, "progs/suit.mdl");
	self.netname = "Biosuit";
	self.items = IT_SUIT;
//	setsize (self, '-16 -16 -24', '16 16 32');

	self.go = item_artifact_go;
	if(!CheckGroup()) self.go();
};


/*QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invisible for 30 seconds
*/
void() item_artifact_invisibility =
{
	/*
	if (mapname == "dm3")	// Supa, totally-not-a-railgun, replace ROS on DM3
	{
		self.classname = "weapon_railgun";
		weapon_railgun();

		return;
	}
	*/

	precache_model ("progs/invisibl.mdl");
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");
	self.noise = "items/inv1.wav";
	setmodel (self, "progs/invisibl.mdl");
	self.netname = "Ring of Shadows";
	self.items = IT_INVISIBILITY;
//	setsize (self, '-16 -16 -24', '16 16 32');

	self.go = item_artifact_go;
	if(!CheckGroup()) self.go();
};


/*QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
The next attack from the player will do 4x damage
*/
void() item_artifact_super_damage =
{
	if (gametype == DUEL)	// Supa
		remove(self);

	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	self.noise = "items/damage.wav";
	setmodel (self, "progs/quaddama.mdl");
	self.netname = "Quad Damage";
	self.items = IT_QUAD;
//	setsize (self, '-16 -16 -24', '16 16 32');

	self.go = item_artifact_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_artifact_res (0 .5 .8) (-16 -16 -24) (16 16 32)
Goodbye, quicksave
*/
void() item_artifact_res =
{
	//if (gametype == DUEL || DEATHMATCH)
	//	remove(self);

	precache_model ("progs/res.mdl");
	precache_sound ("items/res.wav");
	self.noise = "items/res.wav";

	setmodel (self, "progs/res.mdl");

	self.netname = "Ward of Rebirth";
	self.items = IT_REBIRTH;

	//self.effects = self.effects | EF_BRIGHTLIGHT;

	self.go = item_artifact_go;
	if(!CheckGroup()) self.go();
};

#ifdef HOOK
/*QUAKED item_grappling_hook (0 .5 .8) (-16 -16 -24) (16 16 32)
Simply gives player the grappling hook.
*/
void() GrapplePrecaches =	// 20120522 Supa, I hate doing the same two things in two different places and you should too
{
	precache_model ("progs/hook.mdl");
	precache_model ("progs/chain.mdl");
	precache_sound ("shambler/smack.wav");
//	precache_sound ("blob/land1.wav");
//	precache_sound ("hook/chain1.wav");
//	precache_sound ("hook/chain2.wav");

	precache_sound ("hook/reelin1.wav");
	precache_sound ("hook/reelin2.wav");
	precache_sound ("hook/retract1.wav");
	precache_sound ("hook/pickup1.wav");
};

void() item_grappling_hook =	// gb
{
	GrapplePrecaches();

	self.noise = "hook/pickup1.wav";
	setmodel (self, "progs/hook.mdl");
	self.netname = "Grappling Hook";
//	self.items = IT_SUIT;
//	setsize (self, '-16 -16 -24', '16 16 32');

	self.go = item_artifact_go;
	if(!CheckGroup()) self.go();
};
#endif



/*
===============================================================================

PLAYER BACKPACKS

===============================================================================
*/

void() BackpackTouch =
{
	local	string	s;
	local	float	best, old, new;
	local	entity	stemp;
	local	float	acount;
#ifdef HOOK
	local	float	hadnohook;
#endif
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	acount = 0;
	sprint (other, "You get ");

	if (self.items)
	if ((other.items & self.items) == 0)
	{
		acount = 1;
		sprint (other, "the ");
		sprint (other, self.netname);
	}

// if the player was using his best weapon, change up to the new one if better
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

// change weapons
	other.ammo_shells = other.ammo_shells + self.ammo_shells;
	other.ammo_nails = other.ammo_nails + self.ammo_nails;
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	other.ammo_cells = other.ammo_cells + self.ammo_cells;
#ifdef HOOK
	if (other.hook_equip == 0)
		hadnohook = 1;
	else
		hadnohook = 0;

	other.hook_equip = other.hook_equip + self.hook_equip;	// gb
#endif
	new = self.items;
	if (!new)
		new = other.weapon;
	old = other.items;
	other.items = other.items | new;

	if (self.items2)	// Supa, give replacement weapon if present
		other.items2 = other.items2 | self.items2;

	bound_other_ammo ();
#ifdef HOOK
	if (self.hook_equip && hadnohook)
	{
		if (acount)
			sprint(other, ", ");

		acount = 1;
		sprint(other, "the Grappling Hook");
	}
#endif
	if (self.ammo_shells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.ammo_shells);
		sprint (other, s);
		if (self.ammo_shells == 1)
		{
		sprint (other, " shell");
		}
		else
		{
		sprint (other, " shells");
		}
	}
	if (self.ammo_nails)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.ammo_nails);
		sprint (other, s);
		if (self.ammo_nails  == 1)
		{
		sprint (other, " nail");
		}
		else
		{
		sprint (other, " nails");
		}
	}
	if (self.ammo_rockets)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.ammo_rockets);
		sprint (other, s);
		if (self.ammo_rockets  == 1)
		{
		sprint (other, " rocket");
		}
		else
		{
		sprint (other, " rockets");
		}
	}
	if (self.ammo_cells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.ammo_cells);
		sprint (other, s);
		if (self.ammo_cells  == 1)
		{
		sprint (other, " cell");
		}
		else
		{
		sprint (other, " cells");
		}
	}
	if (self.armorvalue)
	{
		local	float	bit;

		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.armorvalue);
		sprint (other, s);
		sprint (other, " armor");

		if ((other.items & IT_ARMOR1) ||
		(other.items & IT_ARMOR2) ||
		(other.items & IT_ARMOR3))	// has armor
		{

			other.armorvalue = other.armorvalue + self.armorvalue;
		}
		else
		{
			other.armortype = 0.3;	// GA
			other.armorvalue = self.armorvalue;
			bit = IT_ARMOR1;
			other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;
		}
	}
	if (self.healamount)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		s = ftos(self.healamount);
		sprint (other, s);
		sprint (other, " health");

//		if (other.health >= rint (other.max_health * 2))
//			return;

		if (other.health < rint (other.max_health * 2))	// Supa, immortal spamming backpack of doom bug
			T_Heal(other, self.healamount, self.healtype);
	}

	sprint (other, "\n");

	// backpack touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);	// set to NONE like ammo and weapons?

	stuffcmd (other, "bf\n");

	SUB_UseTargets();	// gb, item_backpack should do this when picked up

	// remove the backpack, change self to the player
	remove(self); // FIXME: if item_backpack uses this function, then it can't currently respawn! (LA)
	self = other;

	// change to the weapon
//	if (!deathmatch)	// QIP
//		self.weapon = new;
//	else
		Deathmatch_Weapon (old, new);

	W_SetCurrentAmmo ();
};

/*
===============
DropBackpack
===============
*/
void() DropBackpack =
{
	local entity	item;

	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells))
		return;	// nothing in it

	item = spawn();
	item.classname = "backpack";
	item.origin = self.origin - '0 0 24';

	item.items = self.weapon;
	if (item.items == IT_AXE)
		item.netname = "Chainsaw";	// gb
	else if (item.items == IT_SHOTGUN)
		item.netname = "Shotgun";
	else if (item.items == IT_SUPER_SHOTGUN)
	{	// Supa
		if (self.items2 & IT_SHREDDER)	{item.netname = "Shredder! Find some meat!";	item.items2 = IT_SHREDDER;	}
		else							item.netname = "Double-barrelled Shotgun";
	}
	else if (item.items == IT_NAILGUN)
		item.netname = "Nailgun";
	else if (item.items == IT_SUPER_NAILGUN)
		item.netname = "Super Nailgun";
	else if (item.items == IT_GRENADE_LAUNCHER)
		item.netname = "Grenade Launcher";
	else if (item.items == IT_ROCKET_LAUNCHER)
		item.netname = "Rocket Launcher";
	else if (item.items == IT_LIGHTNING)
		item.netname = "Thunderbolt";
	else if (item.items == IT_RAILGUN)
		item.netname = "Cauteriser";
	else
		item.netname = "";

	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;
#ifdef HOOK
	item.hook_equip = self.hook_equip;	// gb
#endif
	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;

//	item.nextthink = time + 120;	// remove after 2 minutes
//	item.think = SUB_Remove;

	// Supa, lava burns items away
	item.cnt = time + 120;	// remove after 2 minutes
	item.nextthink = time + 0.1;
	item.think = LavaMonitor;
};

// LA: Backpacks for mappers to include, by request.
void() item_backpack_go =
{
	setmodel (self, "progs/backpack.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	self.touch = BackpackTouch;
	StartItem ();
};

/*QUAKED item_backpack (.3 .3 1) (-16 -16 0) (16 16 56) ? ? ? ? ? SILENT SPAWNED FLOATING
Backpack full of whatever the mapper desires

ammo_shells: Shells
ammo_nails: Nails
ammo_rockets: Rockets
ammo_cells: Cells
armorvalue: Armor. Added to current armor class, or Green otherwise.
healamount: Health. Will go above maximum health.

You can include an item with .items and .netname, but please don't...
*/

void() item_backpack =
{
	precache_model ("progs/backpack.mdl");
	precache_sound ("weapons/lock4.wav");

	self.go = item_backpack_go;
	if(!CheckGroup()) self.go();
};


#ifdef MONSTERS

/*
===============
DeathDrop
===============
*/

// Generic death drop function - gb
// LA: Largely cleaned up logic
void() DeathDrop =
{
	local entity	item;
	local float 	r;

//	if (random() > 0.3)	// global frequency of death drops
//		return;

	// Supa quick fix to avoid spawning unneeded item placeholders
	if 		(self.classname == "monster_knight"	)	{if (random() > 0.2)	return;}	//ijed Made this lower because there's more of them
	else if (self.classname == "monster_hell_knight")	{if (random() > 0.3)	return;}

	item = spawn();
//	item.origin = self.origin - '0 0 24';
	setorigin(item, self.origin);	// Supa Armourshard fix

	// first, decide who drops what

	if (self.classname == "monster_army")	// likes to pack useless equipment
	{
		// get dropped item type
		r = random();
		if		(r < 0.2)	item.classname = "armorpack";	// ammo + 5 armor
		else if (r < 0.3)	item.classname = "healthpack";	// ammo + 5 health
		else				item.classname = "ammopack";	// ammo only

		// get ammo type and count
		if (self.spawnflags & 4)	self.ammo_nails = ceil(random() * 12) + 3;	// NAIL_GRUNT gives 4-15 nails instead
		else						self.ammo_shells = ceil(random() * 3); // 1-3 shells
	}
	else if (self.classname == "monster_enforcer")	// wears armor, scoffs at health; LA: extra ammo for wargear flags
	{
		r = random();
		if (r < 0.2)	item.classname = "armorpack";
		else			item.classname = "ammopack";

		// get ammo type and count
		self.ammo_cells = ceil(random() * 3 + 1); // 2-4 cells
		if (self.spawnflags & 4) self.ammo_cells = self.ammo_cells + 1; // HYPERBLASTER gives +1 cell, for 3-5 total

		if (self.spawnflags & 8)	self.ammo_rockets = ceil(random() * 2); // HUNTERKILLERS means a guaranteed rocket drop, equal chance 1 or 2
		else						self.ammo_rockets = floor(random() * 2.2);	// 0 or 1 rockets, with small (9%) chance of 2
	}
	else if (self.classname == "monster_ogre")	// armor? health? HA!
	{
		item.classname = "ammopack";

		// get ammo type and count
		if (self.spawnflags & 4)		self.ammo_nails = ceil(random() * 11) + 4;	// NAIL_OGRE gives 5-15 nails instead
		else if (self.spawnflags & 16)	self.ammo_rockets = ceil(random() * 3 + 1); // ROCKET_OGRE gives 2-4 rockets instead
		else							self.ammo_rockets = ceil(random() * 2); // 1-2 rockets
	}
	else if (self.classname == "monster_knight")	// backpacks not invented yet
	{
		item.classname = "armorshard";
	}
	else if (self.classname == "monster_hell_knight")	// same
	{
		item.classname = "armorshard";
	}

	// now build the required item
	// you must precache sounds, models in the monster spawn functions
	// - except backpack.mdl ijed Going to have the grunts visually carry the backpack as an experiment

	if (item.classname == "armorshard")	// Supa Minor little fix
	{
		if (world.worldtype == 0)  //ijed Sets shard model to worldtype model, precached inside the knights qc
			setmodel (item, "progs/armorshard0.mdl");
		else if (world.worldtype == 1)
			setmodel (item, "progs/armorshard1.mdl");
		else if (world.worldtype == 2)  //ijed Tech armour shards?  ~OUM?
			setmodel (item, "progs/armorshard2.mdl");

		setsize (item, '-16 -16 0', '16 16 56');
		item.touch = shard_touch;
	}
	else if (item.classname == "armorpack")	// pack w/ ammo + shard
	{
		setmodel (item, "progs/backpack.mdl");
		setsize (item, '-16 -16 0', '16 16 56');
		item.touch = BackpackTouch;
		item.ammo_shells = self.ammo_shells;
		item.ammo_nails = self.ammo_nails;
		item.ammo_rockets = self.ammo_rockets;
		item.ammo_cells = self.ammo_cells;
		item.armorvalue = 5;	// 2
	}
	else if (item.classname == "healthpack")
	{
		setmodel (item, "progs/backpack.mdl");
		setsize (item, '-16 -16 0', '16 16 56');
		item.touch = BackpackTouch;
		item.ammo_shells = self.ammo_shells;
		item.ammo_nails = self.ammo_nails;
		item.ammo_rockets = self.ammo_rockets;
		item.ammo_cells = self.ammo_cells;
		item.healamount = 5;	// 2
		item.healtype = 2;
	}
	else if (item.classname == "ammopack")	// old fashioned
	{
		setmodel (item, "progs/backpack.mdl");
		setsize (item, '-16 -16 0', '16 16 56');
		item.touch = BackpackTouch;
		item.ammo_shells = self.ammo_shells;
		item.ammo_nails = self.ammo_nails;
		item.ammo_rockets = self.ammo_rockets;
		item.ammo_cells = self.ammo_cells;
	}

	// unless keys
	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;

	// unless keys
	item.movetype = MOVETYPE_TOSS;

	// unless keys
//	item.nextthink = time + 120;	// remove after 2 minutes
//	item.think = SUB_Remove;

	// Supa, oops, forgot this one..
	item.cnt = time + 120;	// remove after 2 minutes
	item.nextthink = time + 0.1;
	item.think = LavaMonitor;
};

#endif

/*
===============
DropWeapon
===============
*/

// gb, thanks Shyft, modified
void() DropWeapon =
{
	local entity	item;

	item = spawn();
	item.origin = self.origin + v_forward*8 + '0 0 32';

	item.items = self.weapon;
	self.items = self.items - self.weapon;

	// don't be an asshole, give them ammo, too - gb
	if (item.items == IT_AXE)
	{
		item.netname = "Chainsaw";
	}
	else if (item.items == IT_SHOTGUN)
	{
		item.netname = "Shotgun";

		if (self.ammo_shells > 0)	{item.ammo_shells = ceil(self.ammo_shells / 2);		self.ammo_shells = floor(self.ammo_shells / 2);	}
	}
	else if (item.items == IT_SUPER_SHOTGUN)
	{
		if (self.items2 & IT_SHREDDER)	{item.netname = "Shredder! Find some meat!";	self.items2 -= IT_SHREDDER;}
		else							item.netname = "Double-barrelled Shotgun";

		if (self.ammo_shells > 0)	{item.ammo_shells = ceil(self.ammo_shells / 2);		self.ammo_shells = floor(self.ammo_shells / 2);	}
	}
	else if (item.items == IT_NAILGUN)
	{
		item.netname = "Nailgun";

		if (self.ammo_nails > 0)	{item.ammo_nails = ceil(self.ammo_nails / 2);		self.ammo_nails = floor(self.ammo_nails / 2);	}
	}
	else if (item.items == IT_SUPER_NAILGUN)
	{
		item.netname = "Super Nailgun";

		if (self.ammo_nails > 0)	{item.ammo_nails = ceil(self.ammo_nails / 2);		self.ammo_nails = floor(self.ammo_nails / 2);	}
	}
	else if (item.items == IT_GRENADE_LAUNCHER)
	{
		item.netname = "Grenade Launcher";

		if (self.ammo_rockets > 0)	{item.ammo_rockets = ceil(self.ammo_rockets / 2);	self.ammo_rockets = floor(self.ammo_rockets / 2);	}
	}
	else if (item.items == IT_ROCKET_LAUNCHER)
	{
		item.netname = "Rocket Launcher";

		if (self.ammo_rockets > 0)	{item.ammo_rockets = self.ammo_rockets;		self.ammo_rockets = 0;	}
	}
	else if (item.items == IT_LIGHTNING)
	{
		item.netname = "Thunderbolt";

		if (self.ammo_cells > 0)	{item.ammo_cells = self.ammo_cells;			self.ammo_cells = 0;	}
	}
	else if (item.items == IT_RAILGUN)
	{
		item.netname = "Cauteriser";

		if (self.ammo_cells > 0)	{item.ammo_cells = self.ammo_cells;			self.ammo_cells = 0;	}
	}

	makevectors (self.v_angle);

	if (self.v_angle_x)
		item.velocity = v_forward*600 + v_up*100 + v_right*10;
	else
	{
        item.velocity = aim(self, 10000);
        item.velocity = item.velocity * 200;
        item.velocity_z = 200;
	}

	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');

	item.classname = "weaponpack";	// gb, bots and priority ...
	item.touch = BackpackTouch;

	// gb
	self.weapon = W_BestWeapon();
	W_SetCurrentAmmo();
	// gb
	sound (self, CHAN_AUTO, "weapons/ax1.wav", 1, ATTN_NORM);
};




// Supa, Quad Drop begin
void() DroppedQuad_Touch =
{
	local float quadtime;

	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;

	sprint (other, "You got the Quad Damage\n");

	// in order to work around the quad accumulation, we'll have to decay quad time remaining over time, even when it hasn't been picked up
	quadtime = ceil(self.nextthink - time);		// remember that next quad spawns at self.nextthink

	bprint (other.netname);
	bprint (" picked up a Quad with ");
	bprint (ftos(quadtime));
	bprint (" seconds remaining!\n");

	sound (other, CHAN_VOICE, "items/damage.wav", 1, ATTN_NONE);
	stuffcmd (other, "bf\n");

	other.super_time = 1;

	if (other.super_damage_finished < self.nextthink)	// Don't override the timer if they already have a Quad with enough time left
		other.super_damage_finished = self.nextthink;

	other.items = other.items | IT_QUAD;

	self.solid = SOLID_NOT;
	self.model = string_null;

	self.think = SUB_Remove;
	self.nextthink = time;	// next frame
};

void() DropQuad =
{
	local entity item;

	item = spawn();
	item.classname = "item_artifact_super_damage";
	item.origin = self.origin - '0 0 24';

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	item.effects = EF_BLUE;

	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/quaddama.mdl");
	setsize (item, '-16 -16 -24', '16 16 32');
	item.touch = DroppedQuad_Touch;

	item.nextthink = self.super_damage_finished;		// make sure the dropped quad dies by the time the next quad spawns
	item.think = SUB_Remove;

	bprint(self.netname);
	bprint(" dropped a Quad with ");
	bprint(ftos(ceil(item.nextthink - time)));
	bprint(" seconds remaining!\n");
};
// Quad Drop end

/* ==========================================================================

	CHARMS

gb, 20120429 - Charm system
========================================================================== */


void() charm_touch =
{
	local	float	leave;

	if (other.health <= 0)
		return;
	if (!(other.flags & FL_CLIENT))
		return;

//	if (deathmatch == 2 || deathmatch == 3 || coop)	// gb, deathmatch 3 support
	// gb, deathmatch 3 support
	if (gametype == FFA	||
		coop			)
		leave = 1;
	else
		leave = 0;

	if (self.classname == "item_charm_rage")
	{
		if (leave && (other.charms & CH_RAGE) )
			return;

		other.charms = other.charms | CH_RAGE;
	}

	else if (self.classname == "item_charm_movement")
	{
		if (leave && (other.charms & CH_EXT_MOVE) )
			return;

		other.charms = other.charms | CH_EXT_MOVE;
	}

	else if (self.classname == "item_charm_absorber")
	{
		if (leave && (other.charms & CH_ABSORBER) )
			return;

		other.charms = other.charms | CH_ABSORBER;
	}
	else
		objerror ("charm_touch: unknown classname");

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other, "\n");

	// charm touch sound
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);	// gb, NONE?

	stuffcmd (other, "bf\n");

	if (leave)
	{
		if (self.state == 0)
		{
			activator = other;
			SUB_UseTargets ();
			self.state = 1;
		}
		return;
	}

// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;

	// Supa, SP respawning items support
	if (!deathmatch)
		CheckItemRespawn(self, 15);

	// Supa, gametype specific respawn times
	if (gametype)
	switch (gametype)
	{
//		case FFA:		{self.nextthink = time + 15;}	break;
		case DUEL:		{self.nextthink = time + 15;}	break;
		case TDM:		{self.nextthink = time + 15;}	break;
		case TDM_FF:	{self.nextthink = time + 15;}	break;
		case CTF:		{self.nextthink = time + 5;	}	break;
		case CTF_FF:	{self.nextthink = time + 5;	}	break;
		default:
		{
			bprint("charm_touch: Gametype initialisation failed!\n");
		}
		break;
	}

	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() charm_go =
{
	self.touch = charm_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_charm_rage (0 .5 .8) (-16 -16 0) (16 16 32)
The Rage Charm. Activates Rage ability when collected.
(health regen and 2x damage when near death)
*/
void() item_charm_rage =
{
	precache_model ("progs/h_player.mdl");
	setmodel (self, "progs/h_player.mdl");
	self.netname = "Charm: \bRage";

	self.go = charm_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_charm_movement (0 .5 .8) (-16 -16 0) (16 16 32)
The Extended Movement Charm. Activates special moves when collected.
(Walljump, dash, pogo, stairglide)
*/
void() item_charm_movement =
{
	precache_model ("progs/h_player.mdl");
	setmodel (self, "progs/h_player.mdl");
	self.netname = "Charm: \bExtended Movement";

	self.go = charm_go;
	if(!CheckGroup()) self.go();
};

/*QUAKED item_charm_absorber (0 .5 .8) (-16 -16 0) (16 16 32)
The Kinetic Absorber charm. Counteracts fall damage when collected.
*/
void() item_charm_absorber =
{
	precache_model ("progs/h_player.mdl");
	setmodel (self, "progs/h_player.mdl");
	self.netname = "Charm: \bKinetic Absorber";

	self.go = charm_go;
	if(!CheckGroup()) self.go();
};
