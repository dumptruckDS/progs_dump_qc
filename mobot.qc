/*
============
MobotSpawnPoint

Returns the entity to spawn at
============
*/
entity() MobotSpawnPoint =
{
	local	entity spot;
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
	spawn_tfog (bot.origin);
	spawn_tdeath (bot.origin, bot);

	if !(self.style)
		self.style = floor(random() * 7) + 1;

	if (self.style == 1) // spawn a Doggo
	{
		bot.origin = spawn_spot.origin + '0 0 4'; // adjust for spawn in ground
		// set size and shape
		bot.solid = SOLID_SLIDEBOX;
		bot.movetype = MOVETYPE_STEP;
		setmodel(bot, "progs/dog.mdl");
		setsize (self, '-32 -32 -24', '32 32 40');
		bot.flags = bot.flags | FL_MONSTER;
		bot.takedamage = DAMAGE_AIM;

		// define his animation
		bot.th_stand = dog_stand1;
		bot.th_walk = dog_walk1;
		bot.th_run = dog_run1;
		bot.th_die = dog_die;
		bot.th_melee = dog_atta1;
		bot.th_missile = dog_leap1;
		bot.th_pain = dog_pain;
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
	bot.th_pain = ogre_pain;
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
	bot.th_pain = demon1_pain;
	bot.health = 300;

	// polish him up
	bot.classname = "monster_demon1";
	bot.ideal_yaw = bot.angles * '0 1 0';
	bot.yaw_speed = 120;
	bot.view_ofs = '0 0 22';
	}

if (self.style == 6) // spawn a Wizard / Scrag
	{
	bot.origin = spawn_spot.origin + '0 0 8'; // adjust for spawn in ground
	// set size and shape
	bot.solid = SOLID_SLIDEBOX;
	bot.movetype = MOVETYPE_STEP;
	setmodel(bot, "progs/wizard.mdl");
	setsize (self, '-16 -16 -24', '16 16 40');
	bot.flags = bot.flags | FL_FLY;
	bot.flags = bot.flags | FL_MONSTER;
	bot.takedamage = DAMAGE_AIM;

	// define his animation
	bot.th_stand = wiz_stand1;
	bot.th_walk = wiz_walk1;
	bot.th_run = wiz_run1;
	bot.th_die = wiz_die;
	bot.th_missile = Wiz_Missile;
	bot.th_pain = Wiz_Pain;
	bot.health = 80;

	// polish him up
	bot.classname = "monster_wizard";
	bot.ideal_yaw = bot.angles * '0 1 0';
	bot.yaw_speed = 120;
	bot.view_ofs = '0 0 22';
	}

if (self.style == 7) // spawn a Shalrath
	{
	bot.origin = spawn_spot.origin + '0 0 4'; // adjust for spawn in ground
	// set size and shape
	bot.solid = SOLID_SLIDEBOX;
	bot.movetype = MOVETYPE_STEP;
	setmodel(bot, "progs/shalrath.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	bot.flags = bot.flags | FL_MONSTER;
	bot.takedamage = DAMAGE_AIM;

	// define his animation
	bot.th_stand = shal_stand;
	bot.th_walk = shal_walk1;
	bot.th_run = shal_run1;
	bot.th_die = shalrath_die;
	bot.th_missile = shal_attack1;
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
	bot.nextthink = time + 0.1 + random();
	bot.think = bot.th_walk;
	monster_update_total (1); // repacement function from iw -- dumptruck_ds

};

void() think_mobot =
	{
		self.count = self.count - 1;

		if (self.count < 0)
		return;

		if (self.count!=0) create_mobot(); //thanks whirledstar for your help on this -- dumptruck_ds

		if !(self.wait)
		self.nextthink = time + 5;
		else
		self.nextthink = time + self.wait;

		self.think = think_mobot; // qthink I didn't realize I could do this! -- dumptruck_ds
	};

/*QUAKED func_monster_spawner (1 0 0) (-32 -32 -24) (32 32 64) Ambush FIXME
*/
void() func_monster_spawner =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (!self.count)
		self.count = 5;
	self.count = self.count + 1; // fixes count display

	self.use = think_mobot;
};
