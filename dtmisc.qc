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

 /*QUAKED ambient_general (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
Plays any looped sound

Keys:

"noise" is the wav file to play

"volume" default 1

"speed" attenuation, default 3
*/
void () ambient_general =
{
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
  self.use = play_tfog;
}

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
  self.use = play_meatspray;
}
/* misc gore */
/* Scenic Dead Monster Patch stuff here from DeadStuff mod -- dumptruck_ds */
/*
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
deadstuff version 1.0 - tony collen - manero@canweb.net - EfNet IRC #QuakeEd or #Trinity
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

void() gib_head_demon =
{
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

void() gib_head_dog =
{
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

void() gib_head_army =
{
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

void() gib_head_hell_knight =
{
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

void() gib_head_knight =
{
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

void() gib_head_enforcer =
{
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

void() gib_head_ogre =
{
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

void() gib_head_player =
{
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

void() gib_head_shalrath =
{
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

void() gib_head_shambler =
{
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

void() gib_head_wizard =
{
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

void() gib_misc_1 =
{
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

void() gib_misc_2 =
{
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

void() gib_misc_3 =
{
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
/*==============================================================================
func_fall from RennyC

dumptruck_ds
noise = sound to play when triggered
wait = wait this long before falling
==============================================================================*/

void() func_fall_think =
{
    if (self.cnt == TRUE && self.attack_finished < time)
    {
        self.solid = SOLID_NOT;
        self.movetype = MOVETYPE_TOSS;

        if (self.alpha > 0.1)
            self.alpha = self.alpha - 0.03;
        else
        {
            remove(self);
            return;
        }
    }
    self.nextthink = time + 0.1;
};

void() fall_touch =
{
    if (other.classname != "player" || self.cnt == TRUE)
        return;

    self.attack_finished = time + self.wait;
    self.cnt = TRUE;
    sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
};

/*QUAKED func_fall (0 .5 .8) ?
Falling brush upon touch
*/

void() func_fall =
{
    precache_sound(self.noise);

    self.alpha = 1;
    self.cnt = FALSE;
    self.solid = SOLID_BSP;
    self.movetype = MOVETYPE_PUSH;
    self.think = func_fall_think;
    self.nextthink = time;
    self.touch = fall_touch;
    setmodel (self, self.model);
};
