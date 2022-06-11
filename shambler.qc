/*
==============================================================================

SHAMBLER

==============================================================================

================
ShamRocket
================
*/
void() ShamRocket =
{
	local	entity missile;
	local float projspeed = 900 * self.proj_speed_mod;

	sound_attack (self, CHAN_AUTO, "boss1/throw.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";

// set missile speed  -- dumptruck_ds below

	SetSpeed(missile, normalize(self.enemy.origin - self.origin), projspeed);
    missile.angles = vectoangles(missile.velocity);
	missile.avelocity = self.cust_avelocity; //custom spin of projectile
	if !(missile.avelocity)
	missile.avelocity = '200 100 300';

	missile.touch = T_MissileTouch;

// set missile duration
	if (self.homing > 0)
	{
		SetupHoming(missile, projspeed);
	}
	else
	{
		missile.nextthink = time + 5;
		missile.think = SUB_Remove;
	}
	missile.skin = self.skin_proj; //dumptruck_ds

	if (self.mdl_proj != "") // dumptruck_ds
	{
			setmodel (missile, self.mdl_proj);
		}
		else
		{
			setmodel (missile, "progs/lavaball.mdl");
	}

	if (!missile.skin_proj) // dumptruck_ds
	{
			missile.skin = self.skin_proj;
		}
		else
		{
			missile.skin = 0;
	}
	setsize (missile, '0 0 0', '0 0 0');
	makevectors (self.angles); //thanks Voidforce -- dumptruck_ds
	setorigin (missile, self.origin + v_forward*8 + '0 0 24');
};


$cd id1/models/shams
$origin 0 0 24
$base base
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7
$frame walk8 walk9 walk10 walk11 walk12

$frame	run1 run2 run3 run4 run5 run6

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7
$frame smash8 smash9 smash10 smash11 smash12

$frame swingr1 swingr2 swingr3 swingr4 swingr5
$frame swingr6 swingr7 swingr8 swingr9

$frame swingl1 swingl2 swingl3 swingl4 swingl5
$frame swingl6 swingl7 swingl8 swingl9

$frame magic1 magic2 magic3 magic4 magic5
$frame magic6 magic7 magic8 magic9 magic10 magic11 magic12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6
$frame death7 death8 death9 death10 death11

void() sham_stand1	=[	$stand1,	sham_stand2	] {ai_stand();};
void() sham_stand2	=[	$stand2,	sham_stand3	] {ai_stand();};
void() sham_stand3	=[	$stand3,	sham_stand4	] {ai_stand();};
void() sham_stand4	=[	$stand4,	sham_stand5	] {ai_stand();};
void() sham_stand5	=[	$stand5,	sham_stand6	] {ai_stand();};
void() sham_stand6	=[	$stand6,	sham_stand7	] {ai_stand();};
void() sham_stand7	=[	$stand7,	sham_stand8	] {ai_stand();};
void() sham_stand8	=[	$stand8,	sham_stand9	] {ai_stand();};
void() sham_stand9	=[	$stand9,	sham_stand10] {ai_stand();};
void() sham_stand10	=[	$stand10,	sham_stand11] {ai_stand();};
void() sham_stand11	=[	$stand11,	sham_stand12] {ai_stand();};
void() sham_stand12	=[	$stand12,	sham_stand13] {ai_stand();};
void() sham_stand13	=[	$stand13,	sham_stand14] {ai_stand();};
void() sham_stand14	=[	$stand14,	sham_stand15] {ai_stand();};
void() sham_stand15	=[	$stand15,	sham_stand16] {ai_stand();};
void() sham_stand16	=[	$stand16,	sham_stand17] {ai_stand();};
void() sham_stand17	=[	$stand17,	sham_stand1	] {ai_stand();};

void() sham_walk1		=[      $walk1,        sham_walk2 ] {ai_walk(10);};
void() sham_walk2       =[      $walk2,        sham_walk3 ] {ai_walk(9);};
void() sham_walk3       =[      $walk3,        sham_walk4 ] {ai_walk(9);};
void() sham_walk4       =[      $walk4,        sham_walk5 ] {ai_walk(5);};
void() sham_walk5       =[      $walk5,        sham_walk6 ] {ai_walk(6);};
void() sham_walk6       =[      $walk6,        sham_walk7 ] {ai_walk(12);};
void() sham_walk7       =[      $walk7,        sham_walk8 ] {ai_walk(8);};
void() sham_walk8       =[      $walk8,        sham_walk9 ] {ai_walk(3);};
void() sham_walk9       =[      $walk9,        sham_walk10] {ai_walk(13);};
void() sham_walk10      =[      $walk10,       sham_walk11] {ai_walk(9);};
void() sham_walk11      =[      $walk11,       sham_walk12] {ai_walk(7);};
void() sham_walk12      =[      $walk12,       sham_walk1 ] {ai_walk(7);
if (random() > 0.8)
	sound_idle (self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE);};

void() sham_run1       =[      $run1,        sham_run2      ] {ai_run(20);};
void() sham_run2       =[      $run2,        sham_run3      ] {ai_run(24);};
void() sham_run3       =[      $run3,        sham_run4      ] {ai_run(20);};
void() sham_run4       =[      $run4,        sham_run5      ] {ai_run(20);};
void() sham_run5       =[      $run5,        sham_run6      ] {ai_run(24);};
void() sham_run6       =[      $run6,        sham_run1      ] {ai_run(20);
if (random() > 0.8)
	sound_idle (self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE);
};

void() sham_smash1     =[      $smash1,       sham_smash2    ] {
sound_attack (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM);
ai_charge(2);};
void() sham_smash2     =[      $smash2,       sham_smash3    ] {ai_charge(6);};
void() sham_smash3     =[      $smash3,       sham_smash4    ] {ai_charge(6);};
void() sham_smash4     =[      $smash4,       sham_smash5    ] {ai_charge(5);};
void() sham_smash5     =[      $smash5,       sham_smash6    ] {ai_charge(4);};
void() sham_smash6     =[      $smash6,       sham_smash7    ] {ai_charge(1);};
void() sham_smash7     =[      $smash7,       sham_smash8    ] {ai_charge(0);};
void() sham_smash8     =[      $smash8,       sham_smash9    ] {ai_charge(0);};
void() sham_smash9     =[      $smash9,       sham_smash10   ] {ai_charge(0);};
void() sham_smash10    =[      $smash10,      sham_smash11   ] {
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;
	ai_charge(0);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;

	ldmg = (random() + random() + random()) * 40;
	T_Damage (self.enemy, self, self, ldmg);
	sound_hit (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);

	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
};
void() sham_smash11    =[      $smash11,      sham_smash12   ] {ai_charge(5);};
void() sham_smash12    =[      $smash12,      sham_run1	   ] {ai_charge(4);};
/////////////////////////////////////
// new frames for projectile style
////////////////////////////////////
void() sham_proj1     =[      $smash1,       sham_proj2    ] {ai_face();};
void() sham_proj2     =[      $smash2,       sham_proj3    ] {ai_face();};
void() sham_proj3     =[      $smash3,       sham_proj4    ] {ai_face();};
void() sham_proj4     =[      $smash4,       sham_proj5    ] {ai_face();};
void() sham_proj5     =[      $smash5,       sham_proj6    ] {ai_face();};
void() sham_proj6     =[      $smash6,       sham_proj7    ] {ai_face();};
void() sham_proj7     =[      $smash7,       sham_proj8    ] {ai_face();};
void() sham_proj8     =[      $smash8,       sham_proj9    ] {ai_face();};
void() sham_proj9     =[      $smash9,       sham_proj10   ] {ai_face();};
void() sham_proj10    =[      $smash10,      sham_proj11   ]
{
ShamRocket();
sound_attack (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM); ai_face();
};
void() sham_proj11    =[      $smash11,      sham_proj12   ] {ai_face();};
void() sham_proj12    =[      $smash12,      sham_run1	   ] {ai_face();};
/// projectile frames for turret mode
void() sham_turret_proj1     =[      $smash1,       sham_turret_proj2    ] {ai_face();};
void() sham_turret_proj2     =[      $smash2,       sham_turret_proj3    ] {ai_face();};
void() sham_turret_proj3     =[      $smash3,       sham_turret_proj4    ] {ai_face();};
void() sham_turret_proj4     =[      $smash4,       sham_turret_proj5    ] {ai_face();};
void() sham_turret_proj5     =[      $smash5,       sham_turret_proj6    ] {ai_face();};
void() sham_turret_proj6     =[      $smash6,       sham_turret_proj7    ] {ai_face();};
void() sham_turret_proj7     =[      $smash7,       sham_turret_proj8    ] {ai_face();};
void() sham_turret_proj8     =[      $smash8,       sham_turret_proj9    ] {ai_face();};
void() sham_turret_proj9     =[      $smash9,       sham_turret_proj10   ] {ai_face();};
void() sham_turret_proj10    =[      $smash10,      sham_turret_proj11   ]
{
ShamRocket();
sound_attack (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM); ai_face();
};
void() sham_turret_proj11    =[      $smash11,      sham_turret_proj12   ] {ai_face();};
void() sham_turret_proj12    =[      $smash12,      sham_seek_1	   			 ] {ai_face();};

void() sham_swingr1;

void(float side) ShamClaw =
{
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;
	ai_charge(10);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

	ldmg = (random() + random() + random()) * 20;
	T_Damage (self.enemy, self, self, ldmg);
	sound_hit (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);

	if (side)
	{
		makevectors (self.angles);
		SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
	}
};

void() sham_swingl1	=[      $swingl1,      sham_swingl2   ] {
sound_misc (self, CHAN_VOICE, "shambler/melee2.wav", 1, ATTN_NORM);
ai_charge(5);};
void() sham_swingl2 =[      $swingl2,      sham_swingl3   ] {ai_charge(3);};
void() sham_swingl3 =[      $swingl3,      sham_swingl4   ] {ai_charge(7);};
void() sham_swingl4 =[      $swingl4,      sham_swingl5   ] {ai_charge(3);};
void() sham_swingl5 =[      $swingl5,      sham_swingl6   ] {ai_charge(7);};
void() sham_swingl6 =[      $swingl6,      sham_swingl7   ] {ai_charge(9);};
void() sham_swingl7 =[      $swingl7,      sham_swingl8   ] {ai_charge(5); ShamClaw(250);};
void() sham_swingl8 =[      $swingl8,      sham_swingl9   ] {ai_charge(4);};
void() sham_swingl9 =[      $swingl9,      sham_run1  ] {
ai_charge(8);
if (random()<0.5)
	self.think = sham_swingr1;
};

void() sham_swingr1	=[      $swingr1,      sham_swingr2   ] {
sound_attack (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM);
ai_charge(1);};
void() sham_swingr2	=[      $swingr2,      sham_swingr3   ] {ai_charge(8);};
void() sham_swingr3 =[      $swingr3,      sham_swingr4   ] {ai_charge(14);};
void() sham_swingr4 =[      $swingr4,      sham_swingr5   ] {ai_charge(7);};
void() sham_swingr5 =[      $swingr5,      sham_swingr6   ] {ai_charge(3);};
void() sham_swingr6 =[      $swingr6,      sham_swingr7   ] {ai_charge(6);};
void() sham_swingr7 =[      $swingr7,      sham_swingr8   ] {ai_charge(6); ShamClaw(-250);};
void() sham_swingr8 =[      $swingr8,      sham_swingr9   ] {ai_charge(3);};
void() sham_swingr9 =[      $swingr9,      sham_run1  ] {ai_charge(1);
ai_charge(10);
if (random()<0.5)
	self.think = sham_swingl1;
};

void() sham_melee2 =
{
	local float chance;

	chance = random();

	if (chance > 0.6)
		sham_swingr1 ();
	else
		sham_swingl1 ();
};

void() sham_melee =
{
	local float chance;

	chance = random();

	if (chance > 0.6 || self.health == 600) // changed to >= as you can set custom health
		sham_smash1 ();
	else if (chance > 0.3)
		sham_swingr1 ();
	else
		sham_swingl1 ();
};


//============================================================================


void() sham_arc_think =
{
	if (self.owner != world && self.owner.trigger_field == self)
		self.owner.trigger_field = world;
	remove (self);
};


void() CastLightning =
{
	local	vector	org, dir;

	self.effects = self.effects | EF_MUZZLEFLASH;

	ai_face ();

	org = self.origin + '0 0 40';

	dir = self.enemy.origin + '0 0 16' - org;
	dir = normalize (dir);

	if (self.spawnflags & I_AM_TURRET)
		{
			traceline (org, self.origin + dir*900, TRUE, self);
		}
	else
		{
			traceline (org, self.origin + dir*600, TRUE, self);
		}

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (org, trace_endpos, self, 10);
};

void() sham_magic1     =[      $magic1,       sham_magic2    ] {ai_face();
	sound_misc1 (self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM);
};
void() sham_magic2     =[      $magic2,       sham_magic3    ] {ai_face();};
void() sham_magic3     =[      $magic3,       sham_magic4    ] {ai_face();self.nextthink = time + 0.2;
local entity o;

self.effects = self.effects | EF_MUZZLEFLASH;
ai_face();
self.trigger_field = spawn();
o = self.trigger_field;
setmodel (o, "progs/s_light.mdl");
setorigin (o, self.origin);
o.owner = self;
o.angles = self.angles;
o.nextthink = time + 0.7;
o.think = sham_arc_think;
};
void() sham_magic4     =[      $magic4,       sham_magic5    ]
{
self.effects = self.effects | EF_MUZZLEFLASH;
self.trigger_field.frame = 1;
};
void() sham_magic5     =[      $magic5,       sham_magic6    ]
{
self.effects = self.effects | EF_MUZZLEFLASH;
self.trigger_field.frame = 2;
};
void() sham_magic6     =[      $magic6,       sham_magic9    ]
{
remove (self.trigger_field);
self.trigger_field = world;
CastLightning();
sound_misc2 (self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM);
};
void() sham_magic9     =[      $magic9,       sham_magic10   ]
{CastLightning();};
void() sham_magic10    =[      $magic10,      sham_magic11   ]
{CastLightning();};
void() sham_magic11    =[      $magic11,      sham_magic12   ]
{
if (skill == 3)
	CastLightning();
};
void() sham_magic12    =[      $magic12,      sham_run1	   ] {};
/////////////////////////
//// turret  start
////////////////////////
void() sham_turret_magic1     =[      $magic1,       sham_turret_magic2    ] {ai_face();
	sound_misc1 (self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM);
};
void() sham_turret_magic2     =[      $magic2,       sham_turret_magic3    ] {ai_face();};
void() sham_turret_magic3     =[      $magic3,       sham_turret_magic4    ] {ai_face();self.nextthink = time + 0.2;
local entity o;

self.effects = self.effects | EF_MUZZLEFLASH;
ai_face();
self.trigger_field = spawn();
o = self.trigger_field;
setmodel (o, "progs/s_light.mdl");
setorigin (o, self.origin);
o.owner = self;
o.angles = self.angles;
o.nextthink = time + 0.7;
o.think = sham_arc_think;
};
void() sham_turret_magic4     =[      $magic4,       sham_turret_magic5    ]
{
self.effects = self.effects | EF_MUZZLEFLASH;
self.trigger_field.frame = 1;
};
void() sham_turret_magic5     =[      $magic5,       sham_turret_magic6    ]
{
self.effects = self.effects | EF_MUZZLEFLASH;
self.trigger_field.frame = 2;
};
void() sham_turret_magic6     =[      $magic6,       sham_turret_magic9    ]
{
remove (self.trigger_field);
self.trigger_field = world;
CastLightning();
sound_misc2 (self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM);
};
void() sham_turret_magic9     =[      $magic9,       sham_turret_magic10   ]
{CastLightning();};
void() sham_turret_magic10    =[      $magic10,      sham_turret_magic11   ]
{CastLightning();};
void() sham_turret_magic11    =[      $magic11,      sham_turret_magic12   ]
{
if (skill == 3)
	CastLightning();
};
void() sham_turret_magic12  =[  $magic12, sham_turret_magic13	] {};
void() sham_turret_magic13	=[	$stand14,	sham_turret_magic14	] {ai_face();};
void() sham_turret_magic14	=[	$stand15,	sham_turret_magic15	] {ai_face();};
void() sham_turret_magic15	=[	$stand16,	sham_turret_magic16	] {ai_face();};
void() sham_turret_magic16	=[	$stand17,	sham_seek_1	] {};
void() sham_seek_1	=[	$stand1,	sham_seek_2	] {ai_run(0);};
void() sham_seek_2	=[	$stand2,	sham_seek_3	] {ai_run(0);};
void() sham_seek_3	=[	$stand3,	sham_seek_4	] {ai_run(0);};
void() sham_seek_4	=[	$stand4,	sham_seek_5	] {ai_run(0);};
void() sham_seek_5	=[	$stand5,	sham_seek_6	] {ai_run(0);};
void() sham_seek_6	=[	$stand6,	sham_seek_7	] {ai_run(0);};
void() sham_seek_7	=[	$stand7,	sham_seek_8	] {ai_run(0);};
void() sham_seek_8	=[	$stand8,	sham_seek_9	] {ai_run(0);};
void() sham_seek_9	=[	$stand9,	sham_seek_10] {ai_run(0);};
void() sham_seek_10	=[	$stand10,	sham_seek_11] {ai_run(0);};
void() sham_seek_11	=[	$stand11,	sham_seek_12] {ai_run(0);};
void() sham_seek_12	=[	$stand12,	sham_seek_13] {ai_run(0);};
void() sham_seek_13	=[	$stand13,	sham_seek_14] {ai_run(0);};
void() sham_seek_14	=[	$stand14,	sham_seek_15] {ai_run(0);};
void() sham_seek_15	=[	$stand15,	sham_seek_16] {ai_run(0);};
void() sham_seek_16	=[	$stand16,	sham_seek_17] {ai_run(0);};
void() sham_seek_17	=[	$stand17,	sham_seek_1	] {ai_run(0);};
/////////////////////////
//// turret  end
////////////////////////

void() sham_pain1       =[      $pain1, sham_pain2      ] {};
void() sham_pain2       =[      $pain2, sham_pain3      ] {};
void() sham_pain3       =[      $pain3, sham_pain4      ] {};
void() sham_pain4       =[      $pain4, sham_pain5      ] {};
void() sham_pain5       =[      $pain5, sham_pain6      ] {};
void() sham_pain6       =[      $pain6, sham_run1      ] {};

void(entity attacker, float damage)	sham_pain =
{
	sound_pain (self, CHAN_VOICE, "shambler/shurt2.wav", 1, ATTN_NORM);

	if (self.spawnflags & I_AM_TURRET)
		return;

	if (self.health <= 0)
		return;		// allready dying, don't go into pain frame

	if (random()*400 > damage)
		return;		// didn't flinch

	if (self.pain_finished > time)
		return;
	self.pain_finished = time + 2;

	if (self.trigger_field != world && self.trigger_field.owner == self)
		self.trigger_field.frame = 2;
	self.trigger_field = world;

	sham_pain1 ();
};


//============================================================================

void() sham_death1      =[      $death1,       sham_death2     ] {};
void() sham_death2      =[      $death2,       sham_death3     ] {};
void() sham_death3      =[      $death3,       sham_death4     ] {self.solid = SOLID_NOT;};
void() sham_death4      =[      $death4,       sham_death5     ] {};
void() sham_death5      =[      $death5,       sham_death6     ] {};
void() sham_death6      =[      $death6,       sham_death7     ] {};
void() sham_death7      =[      $death7,       sham_death8     ] {};
void() sham_death8      =[      $death8,       sham_death9     ] {};
void() sham_death9      =[      $death9,       sham_death10    ] {};
void() sham_death10     =[      $death10,      sham_death11    ] {};
void() sham_death11     =[      $death11,      sham_death11    ] {};

void() sham_die =
{
// check for gib
	if (self.health < -60)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		if (self.mdl_head != "") //dumptruck_ds custom_mdls
		{
			ThrowHead (self.mdl_head, self.health);
		}
		else
		{
			ThrowHead ("progs/h_shams.mdl", self.health);
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

// regular death
	sound_death (self, CHAN_VOICE, "shambler/sdeath.wav", 1, ATTN_NORM);
	DropStuff();
	sham_death1 ();
};

//============================================================================


/*QUAKED monster_shambler (1 0 0) (-32 -32 -24) (32 32 64) AMBUSH X X TRIGGER_SPAWNED X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ("progs/shambler.mdl");
}
Shambler.

Default health = 600

snd_death(string) : "Path to custom death sound"
snd_pain(string) : "Path to custom pain sound"
snd_sight(string) : "Path to custom sight sound"
snd_attack(string) : "Path to custom attack sound (GRUNT)"
snd_hit(string) : "Path to custom hit sound (FLESH TEARING)"
snd_idle(string) : "Path to custom idle sound"
snd_misc(string) : "Path to custom sound (GRUNT 2)"
snd_misc1(string) : "Path to custom sound (LIGHTNING ZAP)"
snd_misc2(string) : "Path to custom sound (LIGHTNING BOOM)"

mdl_head(string) : "Path to custom head model"
mdl_body(string) : "Path to custom body model"
skin_head(float) : "Skin index of custom head model"
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

*/
void() monster_shambler =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_body_model ("progs/shambler.mdl"); // custom_mdls dumptruck_ds
	precache_head_model ("progs/h_shams.mdl"); // custom_mdls dumptruck_ds
	// precache_model ("progs/shambler.mdl");
	precache_model ("progs/s_light.mdl");
	// precache_model ("progs/h_shams.mdl");
	precache_model ("progs/bolt.mdl");
	precache_proj_model ("progs/lavaball.mdl");

	precache_sound_misc1 ("shambler/sattck1.wav");
	precache_sound_misc2 ("shambler/sboom.wav");
	precache_sound_death ("shambler/sdeath.wav");
	precache_sound_pain ("shambler/shurt2.wav");
	precache_sound_idle ("shambler/sidle.wav");
	precache_sound_sight ("shambler/ssight.wav");
	precache_sound_attack ("shambler/melee1.wav");
	precache_sound_misc ("shambler/melee2.wav");
	precache_sound_hit ("shambler/smack.wav");
	precache_sound ("boss1/throw.wav"); // jaycie erysdren 2021-09-14

	precache_gib1 ("progs/gib1.mdl");
	precache_gib2 ("progs/gib2.mdl");
	precache_gib3 ("progs/gib3.mdl");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	body_model ("progs/shambler.mdl");
	// setmodel (self, "progs/shambler.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);

	if (!self.health) //thanks RennyC -- dumptruck_ds
	self.health = 600;
	if (self.proj_speed_mod <= 0)
	{
		self.proj_speed_mod = 1;
	}

	self.th_stand = sham_stand1;
	self.th_walk = sham_walk1;
	if (self.spawnflags & I_AM_TURRET)
	{
	  self.th_run = sham_seek_1;
	}
	else
	{
		self.th_run = sham_run1;
	}
	self.th_die = sham_die;
	if (self.style == 1)
	self.th_melee = sham_melee2;
	else
	self.th_melee = sham_melee;
	if (self.style == 1)
	self.th_missile = sham_proj1;
	else
	self.th_missile = sham_magic1;
	if (self.style == 1)
	self.th_turret = sham_turret_proj1;
	else
	self.th_turret = sham_turret_magic1;
	if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
	self.th_pain = sham_pain;
	else
	self.th_pain = SUB_NullPain;

	walkmonster_start();
};
/* Scenic Dead Monster Patch stuff here from DeadStuff mod -- dumptruck_ds */

/*QUAKED monster_dead_shambler (0 0.5 0.8) (-32 -32 -24) (32 32 64) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ({"path":"progs/shambler.mdl","frame":93});
}
*/
void() monster_dead_shambler =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/shambler.mdl");
	setmodel(self, "progs/shambler.mdl");
	self.frame = $death11;
        if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
                setsize(self,'-77.09 -72.17 -51.52','47.44 98.15 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};
