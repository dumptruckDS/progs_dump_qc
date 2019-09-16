/*
========================================================================

NEW SPAWNFLAGS FOR ALL ENTITIES

========================================================================


This file was created for progs_dump by Ian "iw" Walshaw, August 2019.

It defines functions which can be called to implement the following new
spawnflags:

	4096   Not in Coop
	8192   Not in Single Player
	32768  Not on Hard Only
	65536  Not on Nightmare Only

(Spawnflag 16384 is not used here because it's already used for
something else in progs_dump.)

The new spawnflags complement and complete the set of built-in
spawnflags provided by the engine, which of course are:

	256    Not on Easy
	512    Not on Normal
	1024   Not on Hard or Nightmare
	2048   Not in Deathmatch

In conjunction with the old spawnflags, the new spawnflags make it
possible to exclude any entity from any combination of game modes and/or
skill levels.


"Not in Coop" and "Not in Single Player"
----------------------------------------

These spawnflags were inspired by Quoth 2 (Kell and Necros, 2008), which
included two additional spawnflags for all entities: "Not in Coop" and
"Coop Only".  In contrast to Quoth 2, the spawnflags implemented here
are "Not in Coop" and "Not in Single Player", for symmetry with the
built-in "Not in Deathmatch" spawnflag.


"Not on Hard Only" and "Not on Nightmare Only"
----------------------------------------------

The set of built-in spawnflags doesn't allow a mapper to treat the Hard
and Nightmare skill levels differently, because it only includes one
spawnflag, 1024, which excludes an entity from both Hard and Nightmare.
The new "Not on Hard Only" and "Not on Nightmare Only" spawnflags allow
the mapper to exclude an entity from one of these skill levels without
affecting the other.


========================================================================
*/


// The new spawnflags.  (16384 is already used elsewhere.)
float SPAWNFLAG_NOT_IN_COOP   = 4096;   // Not in Coop
float SPAWNFLAG_NOT_IN_SP     = 8192;   // Not in Single Player
float SPAWNFLAG_NOT_ON_SKILL2 = 32768;  // Not on Hard Only
float SPAWNFLAG_NOT_ON_SKILL3 = 65536;  // Not on Nightmare Only

// The number of entities inhibited by each of the new spawnflags.
float total_not_in_coop;
float total_not_in_sp;
float total_not_on_skill2;
float total_not_on_skill3;

// TRUE if the developer summary has been printed.
float done_inhibition_summary;


/*
================
InitNewSpawnflags

This function is intended to be called from the top of the worldspawn
function (in world.qc).  -- iw
================
*/
void() InitNewSpawnflags =
{
	// Initialize the global variables.
	total_not_in_coop = 0;
	total_not_in_sp = 0;
	total_not_on_skill2 = 0;
	total_not_on_skill3 = 0;
	done_inhibition_summary = FALSE;

	// In the original code, the value of the skill cvar was not copied
	// into the skill global until the first call to StartFrame.
	// However, the new SUB_Inhibit function will need to check what the
	// skill is before then, so, the value is copied here.  -- iw
	skill = cvar ("skill");
};


/*
================
SUB_Inhibit

This function is intended to be called from the top of every spawn
function, like this:

	if (SUB_Inhibit ())
		return;

If the entity's spawnflags mean that it should be inhibited in the
current game mode or on the current skill level, this function will
remove the entity and return TRUE, otherwise this function will take no
action and return FALSE.  -- iw
================
*/
float() SUB_Inhibit =
{
	if (coop && (self.spawnflags & SPAWNFLAG_NOT_IN_COOP))
	{
		total_not_in_coop = total_not_in_coop + 1;
		remove (self);
		return TRUE;
	}

	if (!coop && !deathmatch && (self.spawnflags & SPAWNFLAG_NOT_IN_SP))
	{
		total_not_in_sp = total_not_in_sp + 1;
		remove (self);
		return TRUE;
	}

	// The built-in skill level spawnflags are ignored in Deathmatch, so
	// we ignore the new ones in Deathmatch, too.  -- iw
	if (!deathmatch)
	{
		if (skill == 2 && (self.spawnflags & SPAWNFLAG_NOT_ON_SKILL2))
		{
			total_not_on_skill2 = total_not_on_skill2 + 1;
			remove (self);
			return TRUE;
		}

		if (skill == 3 && (self.spawnflags & SPAWNFLAG_NOT_ON_SKILL3))
		{
			total_not_on_skill3 = total_not_on_skill3 + 1;
			remove (self);
			return TRUE;
		}
	}

	return FALSE;
};


/*
================
PrintInhibitionTotal

This just dprints the summary line about the total number of entities
inhibited by one of the new spawnflags (see PrintInhibitionSummary
below).  -- iw
================
*/
void(float total, string spawnflag_name) PrintInhibitionTotal =
{
	if (total == 0)
		return;

	dprint ("... ");
	dprint (ftos (total));
	dprint (" with '");
	dprint (spawnflag_name);
	dprint ("' spawnflag\n");
};


/*
================
PrintInhibitionSummary

This function is intended to be called from the top of the StartFrame
function (in world.qc), like this:

	if (!done_inhibition_summary)
		PrintInhibitionSummary ();

The engine already logs a developer message about the number of entities
inhibited by the built-in spawnflags; this function logs a message about
the number of entities inhibited by the new spawnflags.  -- iw
================
*/
void() PrintInhibitionSummary =
{
	dprint (ftos (total_not_in_coop + total_not_in_sp +
			total_not_on_skill2 + total_not_on_skill3));
	dprint (" additional entities inhibited by the progs.dat\n");

	PrintInhibitionTotal (total_not_in_coop, "Not in Coop");
	PrintInhibitionTotal (total_not_in_sp, "Not in Single Player");
	PrintInhibitionTotal (total_not_on_skill2, "Not on Hard Only");
	PrintInhibitionTotal (total_not_on_skill3, "Not on Nightmare Only");

	done_inhibition_summary = TRUE;
};
