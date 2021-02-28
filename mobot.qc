// Using "bot" creation code for func_monster_spawner
// most of the code is from a tutorial on creating a bot monster found here:
// https://www.quaddicted.com/webarchive/minion.planetquake.gamespy.com/tutorial/tutor9.htm
// I added the MobotSpawnPoint, retriggering and random gen with help from
// kreathor, 4LT, Paril, Spoike and others on the Quake Mapping Discord.
// ===================================================================
// Big thanks to ryanscissorhands for helping fix telefragging issues!
// ===================================================================

float MOBOT_SPAWNER_RESET = 1;
float MOBOT_DONT_SPAWN_ANGRY = 2;
float MOBOT_DONT_ADD_KILL_COUNT = 4;
float MOBOT_SILENT_SPAWN = 32;

/*
============
MobotSpawnPoint

Returns the entity to spawn at
============
*/
entity() MobotSpawnPoint =
{
	local	entity spot;

	// spot = find (world, classname, "info_monster_spawnpoint");
	spot = find (world, targetname, self.target);

	if (!spot)
		objerror ("couldn't find target");

	return spot;
};

// ------------------------------------------------
void() create_mobot =
// ------------------------------------------------
{

local entity bot, spawn_spot;

// start entity and place it in world
	bot = spawn();
	spawn_spot =  MobotSpawnPoint();
	// spawn_spot = SelectSpawnPoint (); // let's not use deathmatch points for this -- dumptruck_ds
	bot.origin = spawn_spot.origin + '0 0 1';
	bot.angles = spawn_spot.angles;
	bot.fixangle = TRUE;
	bot.proj_speed_mod = 1;
	if (!(self.spawnflags & MOBOT_SILENT_SPAWN)) 			// SILENT
	spawn_tfog (bot.origin);
	spawn_tdeath (bot.origin, bot);

	if (self.style == 1) // spawn a Doggo
	{
		// set size and shape
		bot.solid = SOLID_SLIDEBOX;
		bot.movetype = MOVETYPE_STEP;
		setmodel(bot, "progs/dog.mdl");
		setsize (bot, '-32 -32 -24', '32 32 40');
		bot.flags = bot.flags | FL_MONSTER;
		bot.takedamage = DAMAGE_AIM;

		// define his animation
		bot.th_stand = dog_stand1;
		bot.th_walk = dog_walk1;
		bot.th_run = dog_run1;
		bot.th_die = dog_die;
		bot.th_melee = dog_atta1;
		bot.th_missile = dog_leap1;
		if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
			bot.th_pain = dog_pain;
		else
			bot.th_pain = SUB_NullPain;
		bot.health = 25;

		// polish him up
		bot.classname = "monster_dog";
		bot.ideal_yaw = bot.angles * '0 1 0';
		bot.yaw_speed = 120;
		bot.view_ofs = '0 0 22';
	}

if (self.style == 2) // spawn a Grunt
	{
	// set size and shape
	bot.solid = SOLID_SLIDEBOX;
	bot.movetype = MOVETYPE_STEP;
	setmodel(bot, "progs/soldier.mdl");
	setsize (bot, '-16 -16 -24', '16 16 40');
	bot.flags = bot.flags | FL_MONSTER;
	bot.takedamage = DAMAGE_AIM;

	// define his animation
	bot.th_stand = army_stand1;
	bot.th_walk = army_walk1;
	bot.th_run = army_run1;
	bot.th_die = army_die;
	// bot.th_melee = ogre_melee;
	bot.th_missile = army_atk1;
	if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
	bot.th_pain = army_pain;
	else
	bot.th_pain = SUB_NullPain;
	bot.health = 80;

	// polish him up
	bot.classname = "monster_army";
	bot.ideal_yaw = bot.angles * '0 1 0';
	bot.yaw_speed = 120;
	bot.view_ofs = '0 0 22';
	}

if (self.style == 3) // spawn an Enforcer
	{
	// set size and shape
	bot.solid = SOLID_SLIDEBOX;
	bot.movetype = MOVETYPE_STEP;
	setmodel(bot, "progs/enforcer.mdl");
	setsize (bot, VEC_HULL2_MIN, VEC_HULL2_MAX);
	bot.flags = bot.flags | FL_MONSTER;
	bot.takedamage = DAMAGE_AIM;

	// define his animation
	bot.th_stand = enf_stand1;
	bot.th_walk = enf_walk1;
	bot.th_run = enf_run1;
	bot.th_die = enf_die;
	// bot.th_melee = ogre_melee;
	bot.th_missile = enf_atk1;
	if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
		bot.th_pain = enf_pain;
	else
		bot.th_pain = SUB_NullPain;
	bot.health = 80;

	// polish him up
	bot.classname = "monster_enforcer";
	bot.ideal_yaw = bot.angles * '0 1 0';
	bot.yaw_speed = 120;
	bot.view_ofs = '0 0 22';
	}

if (self.style == 4) // spawn an Ogre
	{
	// set size and shape
	bot.solid = SOLID_SLIDEBOX;
	bot.movetype = MOVETYPE_STEP;
	setmodel(bot, "progs/ogre.mdl");
	setsize (bot, VEC_HULL2_MIN, VEC_HULL2_MAX);
	bot.flags = bot.flags | FL_MONSTER;
	bot.takedamage = DAMAGE_AIM;

	// define his animation
	bot.th_stand = ogre_stand1;
	bot.th_walk = ogre_walk1;
	bot.th_run = ogre_run1;
	bot.th_die = ogre_die;
	bot.th_melee = ogre_melee;
	bot.th_missile = ogre_nail1;
	if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
		bot.th_pain = ogre_pain;
	else
		bot.th_pain = SUB_NullPain;
	bot.health = 200;

	// polish him up
	bot.classname = "monster_ogre";
	bot.ideal_yaw = bot.angles * '0 1 0';
	bot.yaw_speed = 120;
	bot.view_ofs = '0 0 22';
	}

if (self.style == 5) // spawn an Fiend
	{
	// set size and shape
	bot.solid = SOLID_SLIDEBOX;
	bot.movetype = MOVETYPE_STEP;
	setmodel(bot, "progs/demon.mdl");
	setsize (bot, VEC_HULL2_MIN, VEC_HULL2_MAX);
	bot.flags = bot.flags | FL_MONSTER;
	bot.takedamage = DAMAGE_AIM;

	// define his animation
	bot.th_stand = demon1_stand1;
	bot.th_walk = demon1_walk1;
	bot.th_run = demon1_run1;
	bot.th_die = demon_die;
	bot.th_melee = Demon_MeleeAttack;		// one of two attacks
	bot.th_missile = demon1_jump1;			// jump attack
	if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
    bot.th_pain = demon1_pain;
  else
    bot.th_pain = SUB_NullPain;
	bot.health = 300;

	// polish him up
	bot.classname = "monster_demon1";
	bot.ideal_yaw = bot.angles * '0 1 0';
	bot.yaw_speed = 120;
	bot.view_ofs = '0 0 22';
	}

if (self.style == 6) // spawn a Wizard / Scrag
	{
	// set size and shape
	bot.solid = SOLID_SLIDEBOX;
	bot.movetype = MOVETYPE_STEP;
	setmodel(bot, "progs/wizard.mdl");
	setsize (bot, '-16 -16 -24', '16 16 40');
	bot.flags = bot.flags | FL_FLY;
	bot.flags = bot.flags | FL_MONSTER;
	bot.takedamage = DAMAGE_AIM;

	// define his animation
	bot.th_stand = wiz_stand1;
	bot.th_walk = wiz_walk1;
	bot.th_run = wiz_run1;
	bot.th_die = wiz_die;
	bot.th_missile = Wiz_Missile;
	if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
	bot.th_pain = Wiz_Pain;
	else
	bot.th_pain = SUB_NullPain;
	bot.health = 80;

	// polish him up
	bot.classname = "monster_wizard";
	bot.ideal_yaw = bot.angles * '0 1 0';
	bot.yaw_speed = 120;
	bot.view_ofs = '0 0 22';
	bot.mdl_proj = "progs/w_spike.mdl";

	}

	if (self.style == 7) // spawn a Shambler
		{
		// set size and shape
		bot.solid = SOLID_SLIDEBOX;
		bot.movetype = MOVETYPE_STEP;
		setmodel(bot, "progs/shambler.mdl");
		setsize (bot, '-16 -16 -24', '16 16 40');
		bot.flags = bot.flags | FL_MONSTER;
		bot.takedamage = DAMAGE_AIM;

		// define his animation
		bot.th_stand = sham_stand1;
		bot.th_walk = sham_walk1;
		bot.th_run = sham_run1;
		if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
		bot.th_pain = sham_pain;
		else
		bot.th_pain = SUB_NullPain;
		bot.th_die = sham_die;
		bot.th_missile = sham_magic1;
		bot.th_melee = sham_melee;
		bot.health = 600;

		// polish him up
		bot.classname = "monster_shambler";
		bot.ideal_yaw = bot.angles * '0 1 0';
		bot.yaw_speed = 120;
		bot.view_ofs = '0 0 2';
		// bot.view_ofs = '0 0 22';
		}

if (self.style == 8) // spawn a Knight
	{
	// set size and shape
	bot.solid = SOLID_SLIDEBOX;
	bot.movetype = MOVETYPE_STEP;
	setmodel(bot, "progs/knight.mdl");
	setsize (bot, '-16 -16 -24', '16 16 40');
	bot.flags = bot.flags | FL_MONSTER;
	bot.takedamage = DAMAGE_AIM;

	// define his animation
	bot.th_stand = knight_stand1;
	bot.th_walk = knight_walk1;
	bot.th_run = knight_run1;
	bot.th_die = knight_die;
	bot.th_melee = knight_atk1;
	// bot.th_missile = knight_atk1;
	if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
	bot.th_pain = knight_pain;
	else
	bot.th_pain = SUB_NullPain;
	bot.health = 75;

	// polish him up
	bot.classname = "monster_knight";
	bot.ideal_yaw = bot.angles * '0 1 0';
	bot.yaw_speed = 120;
	bot.view_ofs = '0 0 22';
	}

if (self.style == 9) // spawn a HellKnight
	{
	// set size and shape
	bot.solid = SOLID_SLIDEBOX;
	bot.movetype = MOVETYPE_STEP;
	setmodel(bot, "progs/hknight.mdl");
	setsize (bot, '-16 -16 -24', '16 16 40');
	bot.flags = bot.flags | FL_MONSTER;
	bot.takedamage = DAMAGE_AIM;

	// define his animation
	bot.th_stand = hknight_stand1;
	bot.th_walk = hknight_walk1;
	bot.th_run = hknight_run1;
	bot.th_melee = hknight_melee;
	bot.th_die = hknight_die;
	bot.th_missile = hknight_magicc1;
	if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
	bot.th_pain = hknight_pain;
	else
	bot.th_pain = SUB_NullPain;
	bot.health = 250;

	// polish him up
	bot.classname = "monster_hell_knight";
	bot.ideal_yaw = bot.angles * '0 1 0';
	bot.yaw_speed = 120;
	bot.view_ofs = '0 0 22';
	}

if (self.style == 10) // spawn a Spawn
	{
	// set size and shape
	bot.solid = SOLID_SLIDEBOX;
	bot.movetype = MOVETYPE_STEP;
	setmodel(bot, "progs/tarbaby.mdl");
	setsize (bot, '-16 -16 -24', '16 16 40');
	bot.flags = bot.flags | FL_MONSTER;
	bot.takedamage = DAMAGE_AIM;

	// define his animation
	bot.th_stand = tbaby_stand1;
	bot.th_walk = tbaby_walk1;
	bot.th_run = tbaby_run1;
	bot.th_melee = tbaby_jump1;
	bot.th_die = tbaby_die1;
	bot.th_missile = tbaby_jump1;
	bot.health = 80;

	// polish him up
	bot.classname = "monster_tarbaby";
	bot.ideal_yaw = bot.angles * '0 1 0';
	bot.yaw_speed = 120;
	bot.view_ofs = '0 0 2';
	// bot.view_ofs = '0 0 22';
	}

if (self.style == 11) // spawn a Zombie
	{
	// set size and shape
	bot.solid = SOLID_SLIDEBOX;
	bot.movetype = MOVETYPE_STEP;
	setmodel(bot, "progs/zombie.mdl");
	setsize (bot, '-16 -16 -24', '16 16 40');
	bot.flags = bot.flags | FL_MONSTER;
	bot.takedamage = DAMAGE_AIM;

	// define his animation
	bot.th_stand = zombie_start;
	bot.th_walk = zombie_walk1;
	bot.th_run = zombie_decide;
	bot.th_pain = zombie_pain;
	bot.th_die = zombie_die;
	bot.th_missile = zombie_missile;
	bot.health = 61;

	// polish him up
	bot.classname = "monster_zombie";
	bot.ideal_yaw = bot.angles * '0 1 0';
	bot.yaw_speed = 120;
	bot.view_ofs = '0 0 2';
	// bot.view_ofs = '0 0 22';
	}
if (self.style == 12) // spawn a Shalrath
	{
		// set size and shape
		bot.solid = SOLID_SLIDEBOX;
		bot.movetype = MOVETYPE_STEP;
		setmodel(bot, "progs/shalrath.mdl");
		setsize (bot, VEC_HULL2_MIN, VEC_HULL2_MAX);
		bot.flags = bot.flags | FL_MONSTER;
		bot.takedamage = DAMAGE_AIM;

		// define his animation
		bot.th_stand = shal_stand;
		bot.th_walk = shal_walk1;
		bot.th_run = shal_run1;
		bot.th_die = shalrath_die;
		bot.th_missile = shal_attack1;
		bot.homing = 1; //fix for func_monster_spawner setting Voreballs to non-homing
		if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
		bot.th_pain = shalrath_pain;
		else
		bot.th_pain = SUB_NullPain;
		bot.health = 400;

		// polish him up
		bot.classname = "monster_shalrath";
		bot.ideal_yaw = bot.angles * '0 1 0';
		bot.yaw_speed = 120;
		bot.view_ofs = '0 0 22';
	}

// begin his thinking
	bot.nextthink = time + 0.2; // this seems better with monster_use -- dumptruck_ds
	// bot.nextthink = time + 0.1 + random();
	if (!(self.spawnflags & MOBOT_DONT_SPAWN_ANGRY))
	{
		if (bot.classname != "monster_zombie") // required to avoid animation issues -- dumptruck_ds
			bot.think = monster_use;
		else
			bot.think = bot.th_walk;
	}
	else
	{
		bot.think = walkmonster_start_go;
	}
	if (!(self.spawnflags & MOBOT_DONT_ADD_KILL_COUNT))
	{
		monster_update_total (1); // repacement function from iw -- dumptruck_ds
	}
};

void() think_mobot =
	{
		dprint("mobot thinking\n");
		local entity  nearby; // telefrag check thanks to ryanscissorhands for this code! -- dumptruck_ds

		nearby = findradius(self.origin, 128); // findradius (vector origin, float radius in Quake units)

		while (nearby)
		{
			if (nearby.takedamage)
			{
				dprint("monster waiting to spawn\n");
				self.think = think_mobot; // qss crash fix from paavohuhtala -- dumptruck_ds
				self.nextthink = time + 1; //delay the spawn by some amount;
				return;
			}
			nearby = nearby.chain;
		}

		self.count = self.count - 1;

		if (self.count < 0)
		{
			return;
		}
		if (self.count!=0)
		{
			if !(self.wait)
			self.nextthink = time + 5;
			else
			self.nextthink = time + self.wait;

			if (self.style2 == 1)
			{
				self.style = floor(random() * 12) + 1; // random monster!! -- dumptruck_ds
				create_mobot(); //thanks whirledtsar for your help on this -- dumptruck_ds
			}
			else
				create_mobot();
		}
		else {
			if (self.spawnflags & MOBOT_SPAWNER_RESET)
			{
			  self.count = self.cnt;
				self.think = SUB_Null;
			}
		}

		self.think = think_mobot; // qthink I didn't realize I could do this! -- dumptruck_ds
	};

/*QUAKED func_monster_spawner (.75 0 .75) (-8 -8 -8) (8 8 8) REUSABLE X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
Spawns monsters to targeted info_monster_spawnpoint
bot
Choose Style
• 1 (Dog (Default)
• 2 (Grunt)
• 3 (Enforcer)
• 4 (Ogre)
• 5 (Fiend)
• 6 (Wizard)
• 7 (Shambler)
• 8 (Knight)
• 9 (HellKnight)
• 10 (Spawn)
• 11 (Zombie)
• 12 (Shalrath)

Style 2 set to 1 overrides Style and chooses a random monster (excluding Zombies and Vores)

Default time between spawns is 5 seconds; 12 for Zombies and Vores to reduce telefrags

Can set Berserk to 1 to skip most pain animations.

Can only use default health, models and sounds.
*/
void() func_monster_spawner =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if !(self.target)
		{
			objerror("func_monster_spawner needs a target");
			remove(self);
			return;
	 	}

	if !(self.style)
		self.style = 1;

	if (!self.count)
		self.count = 5;
	self.count = self.count + 1; // fixes count display
	self.cnt = self.count; // hold original count

	self.use = think_mobot;
};
