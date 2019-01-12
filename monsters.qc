/* ALL MONSTERS SHOULD BE 1 0 0 IN COLOR */

// name =[framenum,	nexttime, nextthink] {code}
// expands to:
// name ()
// {
//		self.frame=framenum;
//		self.nextthink = time + nexttime;
//		self.think = nextthink
//		<code>
// };

/* From Preach's tutorial here: https://tomeofpreach.wordpress.com/2017/10/08/teleporting-monsters-flag/#more-2281 */

//define Preach's new fields dumptruck_ds

.string tele_model;
.vector tele_mins;
.vector tele_maxs;
.float tele_solid;
.float tele_movetype;

void(vector org) spawn_tfog;
void(vector org, entity death_owner) spawn_tdeath;

void() monster_teleport_go =
{
self.solid = self.tele_solid;
self.movetype = self.tele_movetype;
setmodel(self, self.tele_model);
setsize (self, self.tele_mins, self.tele_maxs);

self.think1();
//override the random delay some go functions apply
self.nextthink = time + 0.1;
	{
		if (self.wait == 0/* || self.classname == "monster_zombie"*/)  //dumptruck_ds: if wait value is >0 spawn silently, hack for zombies broke this, fixed with pos1!
		spawn_tfog (self.origin);
		spawn_tdeath(self.origin, self);
	}

}

void() monster_teleport_delay = //new from Qmaster func coding help thread
{
self.think = monster_teleport_go;
self.nextthink = time + 0.1 + self.delay;
};

float (void() monster_start_fn) monster_teleport =
{
if(!(self.spawnflags & 8))
    return FALSE;

//PREACH: This monster is to be teleported in, so hide it
self.tele_model= self.model;
self.tele_mins = self.mins;
self.tele_maxs = self.maxs;
self.tele_solid = self.solid;
self.tele_movetype = self.movetype;

self.model = "";
self.modelindex = 0;
self.solid = SOLID_NOT;
self.movetype = MOVETYPE_NONE;
//self.use = monster_teleport_go; //qmaster part 2 removes a piece of Preach's code -- dumptruck_ds
self.use = monster_teleport_delay; //qmaster replaces above
self.think1 = monster_start_fn;
total_monsters = total_monsters + 1;
return TRUE;
}

//end of Preach's new fields here

/*
================
monster_use

Using a monster makes it angry at the current activator
================
*/
void() monster_use =
{
	if (self.enemy)
		return;
	if (self.health <= 0)
		return;
	if (activator.items & IT_INVISIBILITY)
		return;
	if (activator.flags & FL_NOTARGET)
		return;
	if (activator.classname != "player")
		return;


// delay reaction so if the monster is teleported, its sound is still
// heard
	self.enemy = activator;
	self.nextthink = time + 0.1;
	self.think = FoundTarget;
};

/*
================
monster_death_use

When a mosnter dies, it fires all of its targets with the current
enemy as activator.
================
*/
void() monster_death_use =
{
	local entity 	ent, otemp, stemp;

// fall to ground
	if (self.flags & FL_FLY)
		self.flags = self.flags - FL_FLY;
	if (self.flags & FL_SWIM)
		self.flags = self.flags - FL_SWIM;

	if (!self.target)
		return;

	activator = self.enemy;
	SUB_UseTargets ();
};


//============================================================================

void() walkmonster_start_go =
{
local string	stemp;
local entity	etemp;

	self.origin_z = self.origin_z + 1;	// raise off floor a bit
//Preach's "check" here

// if(time <= 0.5)
if(!(self.spawnflags & 8))
{
	droptofloor();

	if (!walkmove(0,0))
	{
		dprint ("\n\n");
		dprint (self.classname);
		dprint (" in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n\n");
	}
}

	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 20;
	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_MONSTER;

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
			self.pausetime = 99999999;
			self.th_stand ();
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;

	if ((self.spawnflags && 8) && self.spawn_angry == 1) //dumptruck_ds -- using spawn_angry set to 1 in order to spawn in "angry" monsters
	{
		monster_use();
	}
	// local entity pl; //dumptruck_ds -- this is Shamblernaut's method
	//
	// pl = find (world, classname, "player");
	//
	// if (self.spawn_angry == 1)
	// {
	// activator = pl;
	// monster_use();
	// }
};


void() walkmonster_start =

	//Preach's tutorial
{
	if(monster_teleport(walkmonster_start_go))
    	return;

// delay drop to floor to make sure all doors have been spawned
// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = walkmonster_start_go;
	total_monsters = total_monsters + 1;
	///	Trigger enemy after spawn (khreathor)

};



void() flymonster_start_go =
{
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;

	if (!walkmove(0,0))
	{
		dprint ("flymonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
			self.pausetime = 99999999;
			self.th_stand ();
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

	if ((self.spawnflags && 8) && self.spawn_angry == 1) //dumptruck_ds -- using spawn_angry set to 1 in order to spawn in "angry" monsters
	{
	monster_use();
	}
	// local entity pl; //dumptruck_ds -- this is Shamblernaut's method
	//
	// local entity pl;
	//
	// pl = find (world, classname, "player");
	//
	// if (self.spawn_angry == 1)
	// {
	// activator = pl;
	// monster_use();
	// }


};

void() flymonster_start =
{

	//Preach's tutorial

	if(monster_teleport(flymonster_start_go))
    	return;

// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = flymonster_start_go;
	total_monsters = total_monsters + 1;
};


void() swimmonster_start_go =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	self.takedamage = DAMAGE_AIM;
	total_monsters = total_monsters + 1;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 10';
	self.use = monster_use;

	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		self.th_walk ();
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;

	if ((self.spawnflags && 8) && self.spawn_angry == 1) //dumptruck_ds -- using spawn_angry set to 1 in order to spawn in "angry" monsters
	{
	monster_use();
  }
	// local entity pl; //dumptruck_ds -- this is Shamblernaut's method
	//
	// pl = find (world, classname, "player");
	//
	// if (self.spawn_angry == 1)
	// {
	// activator = pl;
	// monster_use();
	// }
};

void() swimmonster_start =
{

	//Preach's tutorial

	if(monster_teleport(swimmonster_start_go))
    	return;

// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = swimmonster_start_go;
	//total_monsters = total_monsters + 1; //dumptruck_ds fix for monster count bug
};
