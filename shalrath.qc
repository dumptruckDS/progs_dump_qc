/*
==============================================================================

SHAL-RATH

==============================================================================
*/
$cd id1/models/shalrath
$origin 0 0 24
$base base
$skin skin
$scale 0.7

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6 death7

$frame	walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame	walk11 walk12

void(entity attacker, float damage) shalrath_pain;
void() ShalMissile;
void() shal_stand     =[      $walk1,       shal_stand    ] {ai_stand();};

void() shal_walk1     =[      $walk2,       shal_walk2    ] {
if (random() < 0.2)
	sound_idle (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
ai_walk(6);};
void() shal_walk2     =[      $walk3,       shal_walk3    ] {ai_walk(4);};
void() shal_walk3     =[      $walk4,       shal_walk4    ] {ai_walk(0);};
void() shal_walk4     =[      $walk5,       shal_walk5    ] {ai_walk(0);};
void() shal_walk5     =[      $walk6,       shal_walk6    ] {ai_walk(0);};
void() shal_walk6     =[      $walk7,       shal_walk7    ] {ai_walk(0);};
void() shal_walk7     =[      $walk8,       shal_walk8    ] {ai_walk(5);};
void() shal_walk8     =[      $walk9,       shal_walk9    ] {ai_walk(6);};
void() shal_walk9     =[      $walk10,       shal_walk10    ] {ai_walk(5);};
void() shal_walk10    =[      $walk11,       shal_walk11    ] {ai_walk(0);};
void() shal_walk11    =[      $walk12,       shal_walk12    ] {ai_walk(4);};
void() shal_walk12    =[      $walk1,       shal_walk1    ] {ai_walk(5);};

void() shal_run1     =[      $walk2,       shal_run2    ] {
if (random() < 0.2)
	sound_idle (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
ai_run(6);};
void() shal_run2     =[      $walk3,       shal_run3    ] {ai_run(4);};
void() shal_run3     =[      $walk4,       shal_run4    ] {ai_run(0);};
void() shal_run4     =[      $walk5,       shal_run5    ] {ai_run(0);};
void() shal_run5     =[      $walk6,       shal_run6    ] {ai_run(0);};
void() shal_run6     =[      $walk7,       shal_run7    ] {ai_run(0);};
void() shal_run7     =[      $walk8,       shal_run8    ] {ai_run(5);};
void() shal_run8     =[      $walk9,       shal_run9    ] {ai_run(6);};
void() shal_run9     =[      $walk10,       shal_run10    ] {ai_run(5);};
void() shal_run10    =[      $walk11,       shal_run11    ] {ai_run(0);};
void() shal_run11    =[      $walk12,       shal_run12    ] {ai_run(4);};
void() shal_run12    =[      $walk1,       shal_run1    ] {ai_run(5);};

void() shal_attack1     =[      $attack1,       shal_attack2    ] {
sound_attack (self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);
ai_face();
};
void() shal_attack2     =[      $attack2,       shal_attack3    ] {ai_face();};
void() shal_attack3     =[      $attack3,       shal_attack4    ] {ai_face();};
void() shal_attack4     =[      $attack4,       shal_attack5    ] {ai_face();};
void() shal_attack5     =[      $attack5,       shal_attack6    ] {ai_face();};
void() shal_attack6     =[      $attack6,       shal_attack7    ] {ai_face();};
void() shal_attack7     =[      $attack7,       shal_attack8    ] {ai_face();};
void() shal_attack8     =[      $attack8,       shal_attack9    ] {ai_face();};
void() shal_attack9     =[      $attack9,       shal_attack10   ] {ShalMissile();};
void() shal_attack10    =[      $attack10,      shal_attack11   ] {ai_face();};
void() shal_attack11    =[      $attack11,      shal_run1   ] {};
//////////////////////////
/// new frames for turret mode START
//////////////////////////
void() shal_turret_attack1     =[      $attack1,       shal_turret_attack2    ] {
sound_attack (self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);
ai_face();
};
void() shal_turret_attack2     =[      $attack2,       shal_turret_attack3    ] {ai_face();};
void() shal_turret_attack3     =[      $attack3,       shal_turret_attack4    ] {ai_face();};
void() shal_turret_attack4     =[      $attack4,       shal_turret_attack5    ] {ai_face();};
void() shal_turret_attack5     =[      $attack5,       shal_turret_attack6    ] {ai_face();};
void() shal_turret_attack6     =[      $attack6,       shal_turret_attack7    ] {ai_face();};
void() shal_turret_attack7     =[      $attack7,       shal_turret_attack8    ] {ai_face();};
void() shal_turret_attack8     =[      $attack8,       shal_turret_attack9    ] {ai_face();};
void() shal_turret_attack9     =[      $attack9,       shal_turret_attack10   ] {ShalMissile();};
void() shal_turret_attack10    =[      $attack10,      shal_turret_attack11   ] {ai_face();};
void() shal_turret_attack11    =[      $attack11,      shal_turret_attack12   ] {ai_face();};
void() shal_turret_attack12    =[      $walk1,      	 shal_turret_attack13		] {ai_face();};
void() shal_turret_attack13  	 =[      $walk1,      	 shal_turret_attack14		] {ai_face();};
void() shal_turret_attack14    =[      $walk1,      	 shal_turret_attack15 	] {ai_face();};
void() shal_turret_attack15    =[      $walk1,      	 shal_seek_stand1		    ] {ai_run(0);};
void() shal_seek_stand1   		 =[      $walk1,      	 shal_seek_stand2		    ] {ai_run(0);};
void() shal_seek_stand2    		 =[      $walk1,      	 shal_seek_stand1    		] {ai_run(0);};
//////////////////////////
/// new frames for turret mode END
//////////////////////////
void() shal_pain1       =[      $pain1, shal_pain2      ] {};
void() shal_pain2       =[      $pain2, shal_pain3      ] {};
void() shal_pain3       =[      $pain3, shal_pain4      ] {};
void() shal_pain4       =[      $pain4, shal_pain5      ] {};
void() shal_pain5       =[      $pain5, shal_run1      ] {};

void() shal_death1      =[      $death1,        shal_death2     ] {};
void() shal_death2      =[      $death2,        shal_death3     ] {};
void() shal_death3      =[      $death3,        shal_death4     ] {};
void() shal_death4      =[      $death4,        shal_death5     ] {};
void() shal_death5      =[      $death5,        shal_death6     ] {};
void() shal_death6      =[      $death6,        shal_death7     ] {};
void() shal_death7      =[      $death7,        shal_death7    ] {};


void(entity attacker, float damage) shalrath_pain =
{
	if (self.pain_finished > time)
		return;

	sound_pain (self, CHAN_AUTO, "shalrath/pain.wav", 1, ATTN_NORM); //CHAN_AUTO was voice - dumptruck_ds
	self.pain_finished = time + 3;
	if (self.spawnflags & I_AM_TURRET)
	return;
	else
	shal_pain1();
};

void() shalrath_die =
{
// check for gib
	if (self.health < -90)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		if (self.mdl_head != "") //dumptruck_ds custom_mdls
		{
			ThrowHead (self.mdl_head, self.health);
		}
		else
		{
			ThrowHead ("progs/h_shal.mdl", self.health);
		}
		// ThrowGib ("progs/gib1.mdl", self.health);
		// ThrowGib ("progs/gib2.mdl", self.health);
		// ThrowGib ("progs/gib3.mdl", self.health);
		if (self.mdl_gib1 != "") // custom models -- dumptruck_ds
		{
			ThrowGib (self.mdl_gib1, self.health);
		}
		else
		{
			ThrowGib ("progs/gib1.mdl", self.health);
		}
		if (self.mdl_gib2 != "")
		{
			ThrowGib (self.mdl_gib2, self.health);
		}
		else
		{
			ThrowGib ("progs/gib2.mdl", self.health);
		}
		if (self.mdl_gib3 != "")
		{
			ThrowGib (self.mdl_gib3, self.health);
		}
		else
		{
			ThrowGib ("progs/gib3.mdl", self.health);
		}
		DropStuff();
		return;
	}
	// insert death sounds here
	sound_death (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);
	DropStuff();
	shal_death1();
	self.solid = SOLID_NOT;
};

/*
================
ShalMissile
================
*/
void() ShalMissileTouch;
void() ShalMissile =
{
	local	entity 	missile;
	local	vector	dir;
	local	float	dist, flytime;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
	dist = vlen (self.enemy.origin - self.origin);
	flytime = dist * 0.002 * (1/self.proj_speed_mod);
	if (flytime < 0.1)
		flytime = 0.1;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound_misc (self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;

	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;

	if (self.mdl_proj != "") // dumptruck_ds custom_mdls
	{
			setmodel (missile, self.mdl_proj);
		}
		else
		{
			setmodel (missile, "progs/v_spike.mdl");
	}

	if (!missile.skin_proj) // dumptruck_ds
	{
			missile.skin = self.skin_proj;
		}
		else
		{
			missile.skin = 0;
	}

	// setmodel (missile, "progs/v_spike.mdl");

	setsize (missile, '0 0 0', '0 0 0');

	missile.origin = self.origin + '0 0 10';
	SetSpeed(missile, dir, 400 * self.proj_speed_mod);
	missile.avelocity = self.avelocity; // custom spin on projectile --dumptruck_ds
	if !(missile.avelocity)
		missile.avelocity = '300 300 300';
	if (self.homing > 0) // If homing is off, don't bother doing any thinking
	{
		missile.homing = self.homing;
		missile.nextthink = flytime + time;
		missile.think = MissileHome;
	}
	if (skill == 3)
		missile.proj_basespeed = 350 * self.proj_speed_mod;
	else
		missile.proj_basespeed = 250 * self.proj_speed_mod;
	missile.enemy = self.enemy;
	missile.touch = ShalMissileTouch;
};


// void() ShalMissileTouch = --moved to misc.qc for voreball shooter --dumptruck_ds
// {
// 	if (other == self.owner)
// 		return;		// don't explode on owner
//
// 	if (other.classname == "monster_zombie")
// 		T_Damage (other, self, self, 110);
// 	T_RadiusDamage (self, self.owner, 40, world);
// 	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
//
// 	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
// 	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
// 	WriteCoord (MSG_BROADCAST, self.origin_x);
// 	WriteCoord (MSG_BROADCAST, self.origin_y);
// 	WriteCoord (MSG_BROADCAST, self.origin_z);
//
// 	self.velocity = '0 0 0';
// 	self.touch = SUB_Null;
// 	setmodel (self, "progs/s_explod.spr");
// 	self.solid = SOLID_NOT;
// 	s_explode1 ();
// };

//=================================================================

/*QUAKED monster_shalrath (1 0 0) (-32 -32 -24) (32 32 48) AMBUSH X X TRIGGER_SPAWNED X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ({ "path" : "progs/shalrath.mdl",	"frame": 23 });
}
Vore.

Default health = 400

snd_death(string) : "Path to custom death sound"
snd_pain(string) : "Path to custom pain sound"
snd_sight(string) : "Path to custom sight sound"
snd_attack(string) : "Path to custom attack sound (VORE SNARL)"
snd_idle(string) : "Path to custom idle sound"
snd_misc(string) : "Path to custom attack2 sound (VOREBALL FIRE)"

mdl_head(string) : "Path to custom head model"
mdl_body(string) : "Path to custom body model"
mdl_proj(string) : "Path to custom projectile model"
skin_head(float) : "Skin index of custom head model"
skin_proj(float) : "Skin index of custom projectile model"
mdl_gib1(string) : "Path to custom 1st gib model"
mdl_gib2(string) : "Path to custom 2nd gib model"
mdl_gib3(string) : "Path to custom 3rd gib model"

effects(choices) : "Add a visual effect to an entity"
0 : "None (Default)"
1 : "Brightfield (yellow particles)"
4 : "Bright light"
8 : "Dim light"

berserk(choices) "Skips certain pain animations similar to skill 3 (Makes a semi-nightmare monster!)"
0 : "Off (Default)"
1 : "Berserk (skip pain animations)"

delay(float) : "Delay spawn in for this amount of time"

wait(choices) : "Play an effect when trigger spawned?"
0 : "Teleport Effects (Default)"
1 : "Spawn Silently"

spawn_angry(Choices)
0 : "Only when trigger spawned, default behavior - not angry"
1 : "Only when trigger spawned, set to 1 to spawn angry at player"

infight_mode(Choices)
0 : "Default behavior, only with different classnames"
1 : "Infight with monsters with the same classname but a different mdl_body"
2 : "Infight with monsters with the same classname and model but a different skin"
3 : "Infight no matter what"

health(integer) : "Set this to a custom health amount"
pain_target(string) : "Fire this target when pain_threshold is reached"
pain_threshold(integer) : "Fire pain_target when health drops below this amount"
sight_trigger(integer) : "1 = Fire target upon seeing the player instead of death"
skin(integer) : "Skin index (default 0) Use this when your custom model has more than one skin to select"
obit_name(string) : "When used with obit_method, this will set part of the text for a custom obituary. e.g. a Super Soldier! Using the examples here, the obituary would read: Player was eviscerated by a Super Solider!"
obit_method(string) : "When used with obit_name, will set part of the text for a custom obituary. e.g. eviscerated - If empty, defaults to killed."
damage_mod(float) : "USE WITH CAUTION! Multiply all damage from this monster by this number (e.g. 4 = Quad damage)"
homing(float) : "Amount that the projectile should home in target. 1 is default, 0 is none."

*/
void() monster_shalrath =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (deathmatch)
	{
		remove(self);
		return;
	}
	//dumptruck_ds custom_mdls
	precache_body_model2 ("progs/shalrath.mdl");
	precache_head_model2 ("progs/h_shal.mdl");
	precache_proj_model2 ("progs/v_spike.mdl");
// dumptruck_ds
	precache_sound2_attack ("shalrath/attack.wav");
	precache_sound2_misc ("shalrath/attack2.wav");
	precache_sound2_death ("shalrath/death.wav");
	precache_sound2_idle ("shalrath/idle.wav");
	precache_sound2_pain ("shalrath/pain.wav");
	precache_sound2_sight ("shalrath/sight.wav");

	precache_gib1 ("progs/gib1.mdl");
	precache_gib2 ("progs/gib2.mdl");
	precache_gib3 ("progs/gib3.mdl");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	body_model ("progs/shalrath.mdl");
	// setmodel (self, "progs/shalrath.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);

	if (!self.health) //thanks RennyC -- dumptruck_ds
	self.health = 400;

	if (!self.proj_speed_mod)
	{
		self.proj_speed_mod = 1;
	}

	if (!self.homing) // default to normal
	{
		self.homing = 1;
	}
	else if (self.homing < 0) // disable with negative
	{
		self.homing = 0;
	}

	self.th_stand = shal_stand;
	self.th_walk = shal_walk1;
	if (self.spawnflags & I_AM_TURRET)
	{
		self.th_run = shal_seek_stand1;
	}
	else
	{
		self.th_run = shal_run1;
	}

	self.th_die = shalrath_die;
	if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
	self.th_pain = shalrath_pain;
	else
	self.th_pain = SUB_NullPain;
	self.th_missile = shal_attack1;
	self.th_turret = shal_turret_attack1;
	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random ()*0.1;

};

/* Scenic Dead Monster Patch stuff here from DeadStuff mod -- dumptruck_ds */

/*QUAKED monster_dead_shalrath (0 0.5 0.8) (-32 -32 -24) (32 32 64) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ({"path":"progs/shalrath.mdl","frame":22});
}
*/
void() monster_dead_shalrath =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/shalrath.mdl");
	setmodel(self, "progs/shalrath.mdl");
	self.frame = $death7;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-41.41 -40.06 -49.38','34.52 24.32 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}

};
