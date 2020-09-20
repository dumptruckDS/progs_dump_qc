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
	// spawn_spot = SelectSpawnPoint ();
	bot.origin = spawn_spot.origin + '0 0 1';
	bot.angles = spawn_spot.angles;
	bot.fixangle = TRUE;
	spawn_tfog (bot.origin);
	spawn_tdeath (bot.origin, bot);


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
	bprint("an ogre joins the game\n");

// begin his thinking
	bot.nextthink = time + 0.1 + random();
	bot.think = bot.th_walk;
	monster_update_total (1);

};

void() think_mobot =
	{
		self.count = self.count - 1;
		if (self.count < 0)
			return;

			if (self.count != 0)
			{
				self.nextthink = time + 0.1;
				self.think = create_mobot;
			}
	};

/*QUAKED func_monster_spawner (1 0 0) (-32 -32 -24) (32 32 64) Ambush FIXME
*/
void() func_monster_spawner =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (!self.count)
		self.count = 2;

 	// self.use = create_mobot;
 	self.use = think_mobot;
};
