/*
=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================
*/

float	intermission_running;
float	intermission_exittime;
entity used_exit;


/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
void() info_intermission =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;
};


void() info_intermissiontext =
{
  if (self.message == "" || self.cnt == 0)
  {
    objerror("endscreen lacks required fields");
  }
}

void(string message) ShowIntermissionMessage =
{
	WriteByte (MSG_ALL, SVC_FINALE);
	WriteString (MSG_ALL, message);
}

void() StartMessageIntermission =
{
  WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 2);
	WriteByte (MSG_ALL, 3);
}

void() Episode1End =
{
  StartMessageIntermission();
	if (!cvar("registered"))
	{
		ShowIntermissionMessage("As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!");
	}
	else
	{
		ShowIntermissionMessage("As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!");
	}
}

void() Episode2End =
{
  StartMessageIntermission();
	ShowIntermissionMessage("The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
}

void() Episode3End =
{
  StartMessageIntermission();
  ShowIntermissionMessage("The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");

}

void() Episode4End =
{
  StartMessageIntermission();
  ShowIntermissionMessage("Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.");
}

float() RunId1Intermissions =
{
  if (world.skip_id1_overrides == 0)
  {
    if (world.model == "maps/e1m7.bsp")
    {
      Episode1End();
      return 1;
    }
    else if (world.model == "maps/e2m6.bsp")
    {
      Episode2End();
      return 1;
    }
    else if (world.model == "maps/e3m6.bsp")
    {
      Episode3End();
      return 1;
    }
    else if (world.model == "maps/e4m7.bsp")
    {
      Episode4End();
      return 1;
    }
  }
  return 0;
}

/*
============
FindIntermission

Returns the entity to view from
============
*/
entity() FindIntermission =
{
	local	entity spot;
	local	float cyc;

// look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot)
	{	// pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

// then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot)
		return spot;

// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;

	objerror ("FindIntermission: no spot");
		return world;// just to suppress the compiler warning
};


string nextmap;
void() GotoNextMap =
{
	if (cvar("samelevel"))	// if samelevel is set, stay on same level
		changelevel (mapname);
	else
		changelevel (nextmap);
};

float(float start) ShowIntermissionTextEntity =
{
	if (!(used_exit.spawnflags & 2))
	{
		local entity end_message;
		for (end_message = world; (end_message = find(end_message, classname, "info_intermissiontext"));)
		{
			if (end_message.cnt == (intermission_running - 1))
			{
				if (start == 1)
				{
					StartMessageIntermission();
				}
				ShowIntermissionMessage(end_message.message);
				return 1;
			}
		}
	}
	return 0;
}

void() ExitIntermission =
{
// skip any text in deathmatch
	if (deathmatch)
	{
		GotoNextMap ();
		return;
	}



	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;
//
// run some text if at the end of an episode
//
	if (intermission_running == 2)
	{
		if (RunId1Intermissions() == 1)
		{
			return;
		}
		else
		{
			if (used_exit.message != "") // favor message on changelevel
			{
				StartMessageIntermission();
				ShowIntermissionMessage(used_exit.message);
				return;
			}
			if (ShowIntermissionTextEntity(1))
			{
					return;
			}
		}

		GotoNextMap();
	}

	if (intermission_running == 3)
	{
		if (!cvar("registered"))
		{	// shareware episode has been completed, go to sell screen
			WriteByte (MSG_ALL, SVC_SELLSCREEN);
			return;
		}
		if (ShowIntermissionTextEntity(0))
		{
			return;
		}
		if ( (serverflags&15) == 15)
		{
			ShowIntermissionMessage("Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
			return;

		}

	}

	if (intermission_running > 3)
	{
		if (ShowIntermissionTextEntity(0))
		{
				return;
		}
	}

	GotoNextMap();
};

/*
============
IntermissionThink

When the player presses attack or jump, change to the next level
============
*/
void() IntermissionThink =
{
	if (time < intermission_exittime)
		return;

	if (!self.button0 && !self.button1 && !self.button2)
		return;

	ExitIntermission ();
};

void() execute_changelevel =
{
	used_exit = self;
	local entity	pos;

	intermission_running = 1;

// enforce a wait time before allowing changelevel
	if (deathmatch)
		intermission_exittime = time + 5;
	else
		intermission_exittime = time + 2;

	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 3);
	WriteByte (MSG_ALL, 3);

	pos = FindIntermission ();

	other = find (world, classname, "player");
	while (other != world)
	{
		other.view_ofs = '0 0 0';
		other.angles = other.v_angle = pos.mangle;
		other.fixangle = TRUE;		// turn this way immediately
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin (other, pos.origin);
		other = find (other, classname, "player");
		fog_setFromEnt(other, pos);
	}
	// Drake -- dumptruck_ds
	if (cutscene)
	{   // If player was in a cutscene when the level ended, restore viewsize.
			pos = find (world, classname, "camera");
			if (pos)
			{
					local   string  val;

					val = ftos (pos.cnt);
					cvar_set ("viewsize", val);
			}
	}

	WriteByte (MSG_ALL, SVC_INTERMISSION);
};


void() changelevel_touch =
{
	if (self.estate != STATE_ACTIVE) return;
	// from Copper -- dumptruck_ds
	if (!CheckValidTouch()) return;

	if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	{
		T_Damage (other, self, self, 50000);
		return;
	}

	if (coop || deathmatch)
	{
		bprint (other.netname);
		bprint (" exited the level\n");
	}

	nextmap = self.map;

	SUB_UseTargets ();
	if ( (self.spawnflags & 16) && (deathmatch == 0) ) //use info_player_start2 -- dumptruck_ds
	{
	sigil_touch2();
	}

	if ( (self.spawnflags & 1) && (deathmatch == 0) )
	{	// NO_INTERMISSION
		GotoNextMap();
		return;
	}


	self.touch = SUB_Null;

// we can't move people right now, because touch functions are called
// in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

void() dt_exit_toggle = //dumptruck_ds based on hipnotic blocker_use
{
	if (self.estate != STATE_ACTIVE)
	{
		self.is_waiting = 0;
		self.estate = STATE_ACTIVE;
	}
	else
	{
		self.is_waiting = 1;
		self.estate = STATE_INACTIVE;
	}
};


float DT_EXITOFF = 8;
/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (self.spawnflags & DT_EXITOFF) //dumptruck_ds
	{
		self.is_waiting = 1;
	}
	SUB_CheckWaiting();

	self.use = dt_exit_toggle;
	if (!self.map)
		objerror ("changelevel trigger doesn't have map");


	InitTrigger ();
	self.flags = self.flags | FL_NOCENTERPRINT;
	self.touch = changelevel_touch;
};
