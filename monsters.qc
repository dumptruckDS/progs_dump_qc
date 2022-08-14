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

/*
================
monster_update_total

Call this function to safely update total_monsters when the game is in
progress.  It adds "n" to total_monsters, then notifies all clients of
the change.  -- iw
================
*/
void(float n) monster_update_total =
{
	total_monsters = total_monsters + n;

	WriteByte (MSG_ALL, SVC_UPDATESTAT);
	WriteByte (MSG_ALL, STAT_TOTALMONSTERS);
	WriteLong (MSG_ALL, total_monsters);
};

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

self.delay = 0; //fix for cumulative delays for counters etc. -- dumptruck_ds

self.think1();
//override the random delay some go functions apply
self.nextthink = time + 0.1;
	{
		if !(self.spawnflags & SPAWN_SILENTLY)
		{
			if (self.wait == 0)  //dumptruck_ds: if wait value is > 0 spawn silently or use a spawnflag
			spawn_tfog (self.origin);
			spawn_tdeath(self.origin, self);
		}
	}

}

void() monster_teleport_delay = //new from Qmaster func coding help thread
{
self.think = monster_teleport_go;
	if (self.delay == -1)
		{
			self.nextthink = time + 0.1 + random(); //if delay is set to -1 random delay from 0.1 to 1 second - dumptruck_ds
			return;	
		}
self.nextthink = time + 0.1 + self.delay;
};

/*
================
monster_teleport_check

This detects and eliminates a common map bug: a trigger-spawned monster
which can't be activated either because it has no targetname or because
its targetname isn't targeted by any other entity.  (This map bug would
otherwise make it impossible for the player to get 100% kills.)  -- iw
================
*/
void() monster_teleport_check =
{
	if (!SUB_IsTargeted ())
	{
		dprint ("WARNING: removed untargeted trigger-spawned ");
		dprint (self.classname);
		dprint (" at ");
		dprint (vtos (self.origin));
		dprint ("\n");

		remove (self);
		return;
	}

	// the targetname appears to be OK, so let's finish setting up the
	// trigger-spawned monster -- iw
	self.use = monster_teleport_delay;  // qmaster
	monster_update_total (1);
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
self.think1 = monster_start_fn;

// wait for other entities to finish spawning, then check that
// something targets this -- iw
self.think = monster_teleport_check;
self.nextthink = time + 0.1;

return TRUE;
}

//end of Preach's new fields here

// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten  start
/*
================
by: Philip Martin aka: Kryten
When on top of monsters or players you slide. This is a QuakeC problem.
The function below fixes that problem.
based on code given to Kryten by: Michael Turitzin (MaNiAc)
================
*/
void() monster_touch =
{
	//can cause problems for monsters on top of a player,  so only players
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	if ((!(other.flags & FL_ONGROUND)) && ((other.absmin_z >= self.absmax_z - 2)))
		other.flags = other.flags + FL_ONGROUND;

	//you can add other stuff like pushable players/monsters here
};
// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten  end

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
	if (activator.movetype == MOVETYPE_NOCLIP) // Copper -- dumptruck_ds
		return FALSE;
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
// fall to ground
	if (self.flags & FL_FLY)
		self.flags = self.flags - FL_FLY;
	if (self.flags & FL_SWIM)
		self.flags = self.flags - FL_SWIM;

	if (!self.target)
		return;

	if(self.infight_activator)
	{
		activator = self.infight_activator;
	} 
	else
	{
		activator = self.enemy;
	}
	SUB_UseTargets ();
};

/*
================
monster_pain_use //dumptruck_ds

When a monster reaches pain_threshold, it fires all of its pain_targets
with the current enemy as activator.
================
*/
void() monster_pain_use =
{
	if (!self.pain_target)
		return;

	activator = self.enemy;
	SUB_UsePain ();
};

//============================================================================

void() walkmonster_start_go =
{
	self.origin_z = self.origin_z + 1;	// raise off floor a bit
//Preach's "check" here

// if(time <= 0.5)
if(!(self.spawnflags & 8))
{
	droptofloor();

	if !(self.spawnflags & I_AM_TURRET) // fixes an incorrect dprint -- dumptruck_ds
		{
		if (!walkmove(0,0))
			{
				dprint ("\n\n");
				dprint (self.classname);
				dprint (" in wall at: ");
				dprint (vtos(self.origin));
				dprint ("\n\n");
			}
		}
}

	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 20;
	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_MONSTER;

	if (self.target != "")
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
		{
			self.th_walk ();
		}
		else
		{
			self.pausetime = 99999999;
			self.th_stand ();
		}
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

// spread think times so they don't all happen at same time
// 1998-08-14 Monsters sometimes do not move fix by Lord Sméagol  start
//	self.nextthink = self.nextthink + random()*0.5;
	self.nextthink = time + 0.1 + random()*0.5;
// 1998-08-14 Monsters sometimes do not move fix by Lord Sméagol  end
	// if ((self.spawnflags & 8) && self.spawn_angry == 1) //dumptruck_ds -- using spawn_angry set to 1 in order to spawn in "angry" monsters
	// {
	// 	monster_use();
	// }
	local entity pl; //dumptruck_ds -- this is Shamblernaut's method

	pl = find (world, classname, "player");

	if (self.spawn_angry == 1)
	{
	activator = pl;
	monster_use();
	}
};


void() walkmonster_start =

	//Preach's tutorial
{

	if (cvar("nomonsters")) {
		remove(self);
		return;
	}

	if(monster_teleport(walkmonster_start_go))
    	return;

// delay drop to floor to make sure all doors have been spawned
// spread think times so they don't all happen at same time
	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten
// 1998-08-14 Monsters sometimes do not move fix by Lord Sméagol  start
//	self.nextthink = self.nextthink + random()*0.5;
	self.nextthink = time + 0.1 + random()*0.5;
// 1998-08-14 Monsters sometimes do not move fix by Lord Sméagol  end
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

	if (self.target != "")
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
		{
			self.th_walk ();
		}
		else
		{
			self.pausetime = 99999999;
			self.th_stand ();
		}
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

	self.nextthink = time + 0.1 + random()*0.5;	// 1998-08-14 Monsters sometimes do not move fix by Lord Sméagol

// if ((self.spawnflags & 8) && self.spawn_angry == 1) //dumptruck_ds -- using spawn_angry set to 1 in order to spawn in "angry" monsters
// {
// monster_use();
// }
//dumptruck_ds -- this is Shamblernaut's method
	local entity pl;

	pl = find (world, classname, "player");

	if (self.spawn_angry == 1)
	{
	activator = pl;
	monster_use();
	}

};

void() flymonster_start =
{
	if (cvar("nomonsters")) {
		remove(self);
		return;
	}

	//Preach's tutorial

	if(monster_teleport(flymonster_start_go))
    	return;

	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten
	self.flags = self.flags | FL_FLY;	// 1998-08-14 Monsters sometimes do not move fix by Lord Sméagol

// spread think times so they don't all happen at same time
// 1998-08-14 Monsters sometimes do not move fix by Lord Sméagol  start
//	self.nextthink = self.nextthink + random()*0.5;
	self.nextthink = time + 0.1 + random()*0.5;
// 1998-08-14 Monsters sometimes do not move fix by Lord Sméagol  end
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

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 10';
	self.use = monster_use;

	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;

	if (self.target != "")
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
// 1998-08-14 Monsters sometimes do not move fix by Lord Sméagol  start
//	self.nextthink = self.nextthink + random()*0.5;
	self.nextthink = time + 0.1 + random()*0.5;
// 1998-08-14 Monsters sometimes do not move fix by Lord Sméagol  end
// if ((self.spawnflags & 8) && self.spawn_angry == 1) //dumptruck_ds -- using spawn_angry set to 1 in order to spawn in "angry" monsters
// {
// monster_use();
// }
//dumptruck_ds -- this is Shamblernaut's method
	local entity pl;

	pl = find (world, classname, "player");

	if (self.spawn_angry == 1)
	{
	activator = pl;
	monster_use();
	}
};

void() swimmonster_start =
{
	if (cvar("nomonsters")) {
		remove(self);
		return;
	}
	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten
	self.flags = self.flags | FL_SWIM;	// 1998-08-14 Monsters sometimes do not move fix by Lord Sméagol

	//Preach's tutorial

	if(monster_teleport(swimmonster_start_go))
    	return;

// spread think times so they don't all happen at same time
// 1998-08-14 Monsters sometimes do not move fix by Lord Sméagol  start
//	self.nextthink = self.nextthink + random()*0.5;
	self.nextthink = time + 0.1 + random()*0.5;
// 1998-08-14 Monsters sometimes do not move fix by Lord Sméagol  end
	self.think = swimmonster_start_go;
	total_monsters = total_monsters + 1;
};
