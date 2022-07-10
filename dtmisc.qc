//a collection of various pieces of mods and some new code -- dumptruck_ds

/* Miscelanneous QuickC program
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Distributed (unsupported) on 3.12.97
*/

void() play_sound_use =
   {
   if (self.spawnflags & 1)
      {
      if (self.state == 0)
         {
         self.state = 1;
         sound (self, self.impulse, self.noise, self.volume, self.speed);
         }
      else
         {
         self.state = 0;
         sound (self, self.impulse, "misc/null.wav", self.volume, self.speed);
         }
      }
   else
      {
      sound (self, self.impulse, self.noise, self.volume, self.speed);
      }
   };

void() PlaySoundThink =
   {
   local float t;
   t = self.wait * random();
   if (t < self.delay)
      t = self.delay;
   self.nextthink = time + t;
   play_sound_use();
   };

/*QUAKED play_sound_triggered (0.3 0.1 0.6) (-8 -8 -8) (8 8 8) toggle
play a sound when it is used
"toggle" determines whether sound should be stopped when triggered again
"volume" how loud (1 default full volume)
"noise" sound to play
"impulse" channel on which to play sound (0-7) (0 automatic is default)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() play_sound_triggered =
   {
   if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
      return;

   if (!self.noise) //dumptruck_ds
   {
       objerror ("no soundfile set in noise!\n");
       remove(self);
       return;
   }

   precache_sound (self.noise);
   precache_sound ("misc/null.wav");
   if (self.volume == 0)
      self.volume = 1;
   if (self.speed == 0)
      self.speed = 1;
   if (self.speed == -1)
      // self.speed = 0;
      self.speed = ATTN_NONE;
   if (self.spawnflags & 1)
      if (self.impulse == 0)
         self.impulse = 7;
   self.use = play_sound_use;
   };

/*QUAKED play_sound (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
play a sound on a periodic basis
"volume" how loud (1 default full volume)
"noise" sound to play
"wait" random time between sounds (default 20)
"delay" minimum delay between sounds (default 2)
"impulse" channel on which to play sound (0-7) (0 automatic is default)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() play_sound =
   {
   if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
      return;

   local float t;

   if (!self.noise) //dumptruck_ds
   {
      objerror ("no soundfile set in noise!\n");
      remove(self);
      return;
   }


   play_sound_triggered();
   if (self.wait == 0)
      self.wait = 20;
   if (self.delay == 0)
      self.delay = 2;
   self.think = PlaySoundThink;
   t = self.wait * random();
   if (t < self.delay)
      t = self.delay;
   self.nextthink = time + t;
   };


 //johnfitz -- ambient_general (this is from Rubicon Rumble dev kit)

/*QUAKED ambient_general (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
Plays any looped sound

Keys:

"noise" is the wav file to play

"volume" default 1

"speed" attenuation, default 3
*/
void () ambient_general =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

  if (!self.noise) //dumptruck_ds
  {
      objerror ("no soundfile set in noise!\n");
      remove(self);
      return;
  }

	precache_sound (self.noise);
	if (!self.speed)
	{
		self.speed = ATTN_NORM;
	}
  if (self.speed == 0)
     self.speed = 1;
  if (self.speed == -1)
     // self.speed = 0;
     self.speed = ATTN_NONE;
	if (!self.volume)
	{
		self.volume = 0.5;
	}
	ambientsound (self.origin, self.noise, self.volume, self.speed);
	remove(self);
};
//johnfitz

/*QUAKED tele_fog (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)

When triggered, tele_fog shows the teleport particle effects and sounds.

Use this when killtageting an entity if the player can see.

*/

void () play_tfog = //thanks Khreathor -- dumptruck_ds

{
  spawn_tfog(self.origin);
}

void() tele_fog =
{
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
    return;

  self.use = play_tfog;
};

/*QUAKED play_tele (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)

When triggered, tele_fog shows the teleport particle effects and sounds.
Same os tele_fog.

Use this when killtageting an entity if the player can see.

*/
void() play_tele = //same as tele_fog, added for "play_xxxx" consistancy
{
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
    return;

  self.use = play_tfog;
};

/*QUAKED play_explosion (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)

When triggered, creates a explosion at it's origin. Causes damage.

*/

void () play_explosion_fx = //thanks Khreathor -- dumptruck_ds

{
  self.owner = self;  // GrenadeExplode uses self.owner as the attacker -- iw
  GrenadeExplode();
}

void() play_explosion =
{
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
    return;

  self.use = play_explosion_fx;
};

/*QUAKED play_tbabyexplode (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)

When triggered, creates a Spawn death explosion at it's origin. Causes damage.

*/

void () play_tbaby_fx = //thanks Khreathor -- dumptruck_ds

{
  tbaby_die2();
}
void() play_tbabyexplode =
{
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
    return;
  precache_sound2 ("blob/death1.wav");
  self.use = play_tbaby_fx;
};


/*QUAKED play_spawnexpl (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)

When triggered, creates a Spawn death explosion at it's origin. Causes damage.

*/

void() play_spawnexpl =
{
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
    return;

  precache_sound2 ("blob/death1.wav");
  self.use = play_tbaby_fx;
};

/*QUAKED play_lavasplash (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)

When triggered, plays the lavasplash effect from E1M7.

Use noise key for a custom sound.

*/

void () play_lavasplash_fx = //thanks Khreathor -- dumptruck_ds
{
  if (self.noise != "")
  {
    sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
  }
  else
  {
    sound (self, CHAN_AUTO, "boss1/out1.wav", 1, ATTN_NORM);
  }
WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
WriteCoord (MSG_BROADCAST, self.origin_x);
WriteCoord (MSG_BROADCAST, self.origin_y);
WriteCoord (MSG_BROADCAST, self.origin_z);
};

void () play_lavasplash =
{
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
    return;

  if (self.noise != "") precache_sound (self.noise);
  precache_sound("boss1/out1.wav");
  self.use = play_lavasplash_fx;
};

/*QUAKED meat_shower (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)

When triggered, plays a gib effect.

Use style 0 for normal and 1 for extra large. fly_sound 0 is silent, 1 for regular gib sounds.

*/

void () play_meatspray = //-- dumptruck_ds -- thanks to Spike for helping with errors
{
  if (self.style == 1)
  {
    ThrowGib ("progs/gib1.mdl", random()*-80);
    ThrowGib ("progs/gib2.mdl", random()*-80);
    ThrowGib ("progs/gib3.mdl", random()*-80);
    ThrowGib ("progs/gib1.mdl", random()*-75);
    ThrowGib ("progs/gib2.mdl", random()*-75);
    ThrowGib ("progs/gib3.mdl", random()*-75);
  }
  else
  {
    ThrowGib ("progs/gib1.mdl", random()*-65);
    ThrowGib ("progs/gib2.mdl", random()*-65);
    ThrowGib ("progs/gib3.mdl", random()*-65);
  }
  {
  if (self.fly_sound != 1)
  return;
  }
  {
    if (random() < 0.5)
  		sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NORM);
  	else
  		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
}
};

void() meat_shower =
{
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
    return;

  self.use = play_meatspray;
}

/*QUAKED play_gibs (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)

When triggered, plays a gib effect. Same as meat_shower.

Use style 0 for normal and 1 for extra large. fly_sound 0 is silent, 1 for regular gib sounds.

*/
void() play_gibs =  //same as meat_shower, added for "play_xxxx" consistancy
{
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
    return;

  self.use = play_meatspray;
}

void() mflash_use =
{
  self.effects = self.effects | EF_MUZZLEFLASH;

  if (self.noise != "")
      sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
};

/*QUAKED play_mflash (0 .5 .8) (-8 -8 -8) (8 8 8)
triggable muzzle flash effect entity
*/

void() play_mflash =
{
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
    return;

  precache_model ("progs/s_null.spr");
  if (self.noise != "") precache_sound (self.noise);

      setmodel (self, "progs/s_null.spr");
      setorigin (self, self.origin);
      self.movetype = MOVETYPE_NONE;
      self.solid = SOLID_NOT;
      setsize (self, '0 0 0', '0 0 0');
      self.use = mflash_use;
};

//
// play_bfield triggerable effect
//

void() bfield_toggle =
{
    if (!self.state)
    {
        self.state = 1;
        self.effects = self.effects | EF_BRIGHTFIELD;
        sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
    }
    else
    {
        self.state = 0;
        self.effects = self.effects - (self.effects & EF_BRIGHTFIELD);
        sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
    }
};

/*QUAKED play_bfield (0 .5 .8) (-8 -8 -8) (8 8 8)
a triggerable, spherical field of yellow particles
state 1 = start on
*/

void() play_bfield =
{
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
    return;

  precache_model ("progs/s_null.spr");
  if (self.noise != "") precache_sound (self.noise);

      setmodel (self, "progs/s_null.spr");
      setorigin( self, self.origin);
      self.movetype = MOVETYPE_NONE;
      self.solid = SOLID_NOT;
      setsize (self, '0 0 0', '0 0 0');
      if (self.state)
        self.effects = self.effects | EF_BRIGHTFIELD;
      self.use = bfield_toggle;
};

//
// play_brlight triggerable effect
//

void() brlight_toggle = //dumptruck_ds -- thanks to c0burn
{
    if (!self.state)
    {
        self.state = 1;
        self.effects = self.effects | EF_BRIGHTLIGHT;
        sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
    }
    else
    {
        self.state = 0;
        self.effects = self.effects - (self.effects & EF_BRIGHTLIGHT);
        sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
    }
};

/*QUAKED play_brlight (0 .5 .8) (-8 -8 -8) (8 8 8)
a triggerable bright lighting effect
state 1 = start on
*/

void() play_brlight =
{
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
    return;

  precache_model ("progs/s_null.spr");
  if (self.noise != "") precache_sound (self.noise);

      setmodel (self, "progs/s_null.spr");
      setorigin (self, self.origin);
      self.movetype = MOVETYPE_NONE;
      self.solid = SOLID_NOT;
      setsize (self, '0 0 0', '0 0 0');
      if (self.state)
        self.effects = self.effects | EF_BRIGHTLIGHT;
      self.use = brlight_toggle;
};
//
// play_dimlight triggerable effect
//
void() dim_toggle =
{
    if (!self.state)
    {
        self.state = 1;
        self.effects = self.effects | EF_DIMLIGHT;
        sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
    }
    else
    {
        self.state = 0;
        self.effects = self.effects - (self.effects & EF_DIMLIGHT);
        sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
    }
};

/*QUAKED play_dimlight (0 .5 .8) (-8 -8 -8) (8 8 8)
a triggerable lighting effect
state 1 = start on
*/

void() play_dimlight =
{
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
    return;

  precache_model ("progs/s_null.spr");
  if (self.noise != "") precache_sound (self.noise);

      setmodel (self, "progs/s_null.spr");
      // setorigin (self, self.origin);
      self.movetype = MOVETYPE_NONE;
      self.solid = SOLID_NOT;
      setsize (self, '0 0 0', '0 0 0');
      if (self.state)
        self.effects = self.effects | EF_DIMLIGHT;
      setorigin (self, self.origin);
      self.use = dim_toggle;
};

/* misc gore */
/* Scenic Dead Monster Patch stuff here from DeadStuff mod -- dumptruck_ds */
/*
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
deadstuff version 1.0 - tony collen - manero@canweb.net - EfNet IRC #QuakeEd or #Trinity
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

/*QUAKED gib_head_demon (0 0.5 0.8) (-16 -16 0) (16 16 56) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/h_demon.mdl");
}
*/
void() gib_head_demon =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/h_demon.mdl");
	setmodel(self, "progs/h_demon.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-13.64 -16.77 -0.11','17.44 16.22 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

/*QUAKED gib_head_dog (0 0.5 0.8) (-16 -16 0) (16 16 56) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/h_dog.mdl");
}
*/
void() gib_head_dog =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/h_dog.mdl");
	setmodel(self, "progs/h_dog.mdl");
        self.frame = 0;  //was 1 -- dumptruck_ds

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-9.66 -11.89 -0.2','6.57 7.96 13.29');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

/*QUAKED gib_head_army (0 0.5 0.8) (-16 -16 0) (16 16 56) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/h_guard.mdl");
}
*/
void() gib_head_army =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/h_guard.mdl");
	setmodel(self, "progs/h_guard.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-9.67 -8.27 -0.28','4.05 4.8 13.41');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

/*QUAKED gib_head_hell_knight (0 0.5 0.8) (-16 -16 0) (16 16 56) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/h_hellkn.mdl");
}*/
void() gib_head_hell_knight =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/h_hellkn.mdl");
	setmodel(self, "progs/h_hellkn.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-7.9 -12.97 -0.63','10.55 8.87 21.06');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

/*QUAKED gib_head_knight (0 0.5 0.8) (-16 -16 0) (16 16 56) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/h_knight.mdl");
}*/
void() gib_head_knight =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/h_knight.mdl");
	setmodel(self, "progs/h_knight.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-8.17 -7.47 -0.13','8.36 6.5 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

/*QUAKED gib_head_enforcer (0 0.5 0.8) (-16 -16 0) (16 16 56) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/h_mega.mdl");
}
*/
void() gib_head_enforcer =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/h_mega.mdl");
	setmodel(self, "progs/h_mega.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-10.63 -10.23 -0.05','9.27 8.25 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

/*QUAKED gib_head_ogre (0 0.5 0.8) (-16 -16 0) (16 16 56) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/h_ogre.mdl");
}*/
void() gib_head_ogre =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/h_ogre.mdl");
	setmodel(self, "progs/h_ogre.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-12.35 -15.7 -0.17','10.67 13.88 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

/*QUAKED gib_head_player (0 0.5 0.8) (-16 -16 0) (16 16 56) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/h_player.mdl");
}*/
void() gib_head_player =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/h_player.mdl");
	setmodel(self, "progs/h_player.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-9.67 -12.38 -2.1','11.49 50.7 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

/*QUAKED gib_head_shalrath (0 0.5 0.8) (-16 -16 0) (16 16 56) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/h_shal.mdl");
}*/
void() gib_head_shalrath =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/h_shal.mdl");
	setmodel(self, "progs/h_shal.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-19.85 -19.09 -1.44','13.72 16.8 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

/*QUAKED gib_head_shambler (0 0.5 0.8) (-16 -16 0) (16 16 56) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/h_shams.mdl");
}*/
void() gib_head_shambler =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

        precache_model("progs/h_shams.mdl");
        setmodel(self, "progs/h_shams.mdl");
        self.frame = 0; //was 1, caused an error -- dumptruck_ds

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-15.15 -20.638 -0.45','21.44 21.76 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

/*QUAKED gib_head_wizard (0 0.5 0.8) (-16 -16 0) (16 16 56) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/h_wizard.mdl");
}*/
void() gib_head_wizard =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/h_wizard.mdl");
	setmodel(self, "progs/h_wizard.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-10.41 -8.66 -0.54','6.52 10.82 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

/*QUAKED gib_misc_1 (0 0.5 0.8) (-8 -8 -8) (8 8 8) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/gib1.mdl");
}*/
void() gib_misc_1 =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/gib1.mdl");
	setmodel(self, "progs/gib1.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-3.57 -8.06 -3.34','3.69 8.31 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

/*QUAKED gib_misc_2 (0 0.5 0.8) (-8 -8 -8) (8 8 8) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/gib2.mdl");
}*/
void() gib_misc_2 =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/gib2.mdl");
	setmodel(self, "progs/gib2.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-12.68 -14.83 -6.19','13.53 14.57 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

/*QUAKED gib_misc_3 (0 0.5 0.8) (-8 -8 -8) (8 8 8) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ("progs/gib3.mdl");
}*/
void() gib_misc_3 =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/gib3.mdl");
	setmodel(self, "progs/gib3.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-18.95 -15.92 -3.13','13.17 15.66 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};
/* END Scenic Dead Monster Patch stuff here from DeadStuff mod -- dumptruck_ds */

// /*==============================================================================
// func_fall from RennyC
//
// A brush that drops and fades away when touched or triggered.
//
// dumptruck_ds
// noise = sound to play when triggered
// wait = wait this long before falling
// ==============================================================================*/
float DONT_FADE = 1;
float SILENT = 2;

void() func_fall_think =
{
    if (self.cnt == TRUE && self.attack_finished < time)
    {
        self.solid = SOLID_BBOX;
        // self.solid = SOLID_NOT;
        self.movetype = MOVETYPE_TOSS;

        if (!(self.spawnflags & DONT_FADE))
        {

          if (self.alpha > 0.1)
              self.alpha = self.alpha - 0.03;
          else
          {
              remove(self);
              return;
          }
        }
    }
    self.nextthink = time + 0.1;
};

void() fall_touch =
{
    if (other.classname == "player")
    {
        if (!(other.flags & FL_ONGROUND))
            other.flags = other.flags | FL_ONGROUND;
    }

    else if (other.flags & FL_MONSTER)
    T_Damage (other, self, other, 50000);

    else
        return;

    if (self.cnt == TRUE)
        return;

    self.attack_finished = time + self.wait;
    self.cnt = TRUE;

    if (!(self.spawnflags & SILENT))
    {
      if (self.noise != "")
        sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
      else
        sound (self, CHAN_AUTO, "buttons/switch21.wav", 1, ATTN_NORM);
    }
};

void() fall_use =  // thanks again RennyC for help on revisions --dumptruck_ds
    {
      self.attack_finished = time + self.wait;
      self.cnt = TRUE;

      if (self.noise != "")
          sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
      else
          sound (self, CHAN_AUTO, "buttons/switch21.wav", 1, ATTN_NORM);
    };

/*QUAKED func_fall (0 .5 .8) ? DONT_FADE X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
A brush that drops and fades away when touched and/or triggered.
Add some spice to your jumping puzzles or other scripted sequences!
Monsters will not trigger func_fall but will be gibbed if one falls on them.
NOTE: When a func_fall brush touches another brush or entity it will stop, which can look odd in certain situations.
noise = sound to play when triggered, the default is a switch sound.
wait = wait this long before falling.
Use the DONT_FADE spawnflag if desired.

Falling brush upon touch
*/

void() func_fall =
{
    if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
        return;

    precache_sound("buttons/switch21.wav");
    if (self.noise != "") precache_sound (self.noise);


    self.alpha = 1;
    self.cnt = FALSE;
    self.solid = SOLID_BSP;
    self.movetype = MOVETYPE_PUSH;
    self.think = func_fall_think;
    self.nextthink = time;
    self.touch = fall_touch;
    self.use = fall_use;
    setmodel (self, self.model);
};

//=START PARTICLE-STREAM==================================================
// from Zerstrorer mod -- dumptruck_ds

void(vector start, vector end, float color1, float color2, float pdensity) Particle_Beam =
{
local vector	spray, next;
local float		dist, loop, clr;

	clr = color1;
	spray = start - end;
	dist = vlen(spray);
	loop = dist / 24;
	spray = normalize(spray);
	next = spray * 24;
	while(loop > 0)
	{
		particle (end, spray, clr, pdensity);
		end = end + next;
		loop = loop - 1;
		if (clr == color1)
			clr = color2;
		else
			clr = color1;
	}
};


void() particle_use =
{
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	Particle_Beam(self.origin, self.enemy.origin, self.dmg, self.cnt, 15); // was 40 - too many particles for my taste --dumptruck_ds
};

void() particle_stream_start =
{
local entity	pspot;

	pspot = find(world, targetname, self.target);
	if(!pspot)
	{
		dprint("Particle stream can't find target!");
		return;
	}

	self.enemy = pspot;
};

/*QUAKED misc_particle_stream (0 .5 .8) (-8 -8 -8) (8 8 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
A particle stream!  It appears when triggered.  This entity is
one end of the stream, target another entity as the other end-point.
I used the info_notnull, but you should be able to target anything
(like monsters).

"target"   This entities origin is the end-point of the stream
"dmg"  1st Color  -  Use if you want a single color stream
"cnt"  2nd Color  -  Mixes particles of both colors
"noise"  Sound to play when triggered
*/
void() misc_particle_stream =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if(!self.target)
		objerror("misc_particle_stream with not target!");

	if(!self.dmg)
		self.dmg = 73;
	if(!self.cnt)
		self.cnt = self.dmg;
	if(!self.noise)
		self.noise = "misc/null.wav";

  precache_sound(self.noise);

	self.use = particle_use;
	self.think = particle_stream_start;
	self.nextthink = time + 0.2;
};
//  from custents, modified by dumptruck_ds
//##########################################
//#### HEAL TRIGGER                     ####
//##########################################
// Original entity submitted by Jan Martin Mathiassen, aka. TGR

void() heal_touch =
{
  if (self.estate != STATE_ACTIVE)
    return;
  if (other.movetype == MOVETYPE_NOCLIP) // from Copper -- dumptruck_ds
    return FALSE;
	if(self.spawnflags & HEAL_PLAYER_ONLY && other.classname != "player")
		return;
	if(self.spawnflags & HEAL_MONSTER_ONLY && !(other.flags & FL_MONSTER))
		return;
	if(other.classname != "player" && !(other.flags & FL_MONSTER))
		return;

	if(other.heal_timer > time)
		return;

	if ((other.takedamage) && (other.health < self.health_max))
	{

    if (self.noise != "")
        sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
    else
        sound (self, CHAN_AUTO, "items/r_item1.wav", 1, ATTN_NORM);

		if ((other.health + self.heal_amount) > self.health_max)
		{
			// if(self.spawnflags & HEAL_OBEY_MAX)
			// 	T_Heal (other, (self.health - other.health), 0);
			// else
				T_Heal (other, (self.health_max - other.health), 1);
		}
		else
		{
			// if(self.spawnflags & HEAL_OBEY_MAX)
			// 	T_Heal (other, self.cnt, 0);
			// else
				T_Heal (other, self.heal_amount, 1);
		}

		other.heal_timer = time + self.wait;
	}
};

void() heal_toggle=
{
	if(self.touch == SUB_Null)
		self.touch = heal_touch;
	else
		self.touch = SUB_Null;
};

/*QUAKED trigger_heal (.5 .5 .5) ? HEAL_START_ON HEAL_PLAYER_ONLY HEAL_MONSTER_ONLY X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Any object touching this will be healed
heal_amount -- the amount to heal each time (default 5)
wait -- the time between each healing (default 1)
health_max -- the upper limit for the healing (default 100, max 250)
sounds -- set to 1 to enable the noise1 field for custom healing sound
noise -- path to custom sound file
*/
void() trigger_heal =
  {
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
  return;
  //play custom sound for healing if noise key exists
  precache_sound("items/r_item1.wav");
  if (self.noise != "") precache_sound (self.noise);

	InitTrigger ();

	if (self.wait == 0)
		self.wait = 1;
	if (self.heal_amount == 0)
		self.heal_amount = 5;
	if (self.health_max == 0)
		self.health_max = 100;
	else if (self.health_max > 250)
		self.health_max = 250;

	// if(self.targetname)
	// {
	// 	self.use = heal_toggle;
	// 	if(self.spawnflags & HEAL_START_ON)
	// 		self.touch = heal_touch;
	// 	else
	// 		self.touch = SUB_Null;
	// }
	// else
		self.touch = heal_touch;

  SUB_CheckWaiting();
};
