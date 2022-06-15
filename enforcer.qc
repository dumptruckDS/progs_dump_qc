/*
==============================================================================

SOLDIER / PLAYER

==============================================================================
*/

$cd id1/models/enforcer
$origin 0 -6 24
$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9 attack10

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14

$frame fdeath1 fdeath2 fdeath3 fdeath4 fdeath5 fdeath6 fdeath7 fdeath8
$frame fdeath9 fdeath10 fdeath11

$frame paina1 paina2 paina3 paina4

$frame painb1 painb2 painb3 painb4 painb5

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8
$frame paind9 paind10 paind11 paind12 paind13 paind14 paind15 paind16
$frame paind17 paind18 paind19


void() Laser_Touch =
{
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	sound_hit (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC); //dumptruck_ds
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity*0.2, 15);
		T_Damage (other, self, self.owner, 15);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}

	remove(self);
};

void(vector org, vector vec) LaunchLaser =
{

	local float projspeed = self.proj_speed_mod * 600;

	if (self.classname == "monster_enforcer" || self.classname == "monster_army")
		sound_attack (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

	vec = normalize(vec);

	newmis = spawn();
	newmis.snd_hit = self.snd_hit; // dumptruck_ds
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;
	newmis.skin = self.skin_proj; //dumptruck_ds

	if (self.mdl_proj != "") // dumptruck_ds
	{
			setmodel (newmis, self.mdl_proj);
		}
		else
		{
			setmodel (newmis, "progs/laser.mdl");
	}

	if (!newmis.skin_proj) // dumptruck_ds
	{
			newmis.skin = self.skin_proj;
		}
		else
		{
			newmis.skin = 0;
	}
	// setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, '0 0 0', '0 0 0');

	setorigin (newmis, org);

	SetSpeed(newmis, vec, projspeed);
	newmis.angles = vectoangles(newmis.velocity);
	if (self.homing > 0)
	{
		SetupHoming(newmis, projspeed);
	}
	else
	{
		newmis.nextthink = time + 5;
		newmis.think = SUB_Remove;
	}
	newmis.touch = Laser_Touch;
};

void(vector org, vector vec) EnfLaunchSpike =
{

	local float projspeed = self.proj_speed_mod * 600;

	sound_attack (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);

	vec = normalize(vec);

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	// newmis.effects = EF_DIMLIGHT;
	newmis.skin = self.skin_proj; //dumptruck_ds
	// setmodel (newmis, "progs/s_spike.mdl");

	if (self.mdl_proj != "") // dumptruck_ds
	{
			setmodel (newmis, self.mdl_proj);
		}
		else
		{
			setmodel (newmis, "progs/s_spike.mdl");
	}

	if (!newmis.skin_proj) // dumptruck_ds
	{
			newmis.skin = self.skin_proj;
		}
		else
		{
			newmis.skin = 0;
	}
// dumptruck_ds - end
	setsize (newmis, '0 0 0', '0 0 0');

	setorigin (newmis, org);

	SetSpeed(newmis, vec, projspeed);
	newmis.angles = vectoangles(newmis.velocity);

	if (self.homing > 0)
	{
		SetupHoming(newmis, projspeed);
	}
	else
	{
		newmis.nextthink = time + 5;
		newmis.think = SUB_Remove;
	}
	newmis.touch = superspike_touch;
};

//dumptruck_ds start -- from inside qc tut http://www.insideqc.com/qctut/lesson-32.shtml

void() EnfMisTouch =
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = 30 + random()*2; //dumptruck_ds

	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 40, other); //dumptruck_ds

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

/*
================
EnfRocket //dumptruck_ds start -- from inside qc tut http://www.insideqc.com/qctut/lesson-32.shtml
================
*/
void() EnfRocket =
{
	local	entity missile;
	local float projspeed = 900 * self.proj_speed_mod;
	// self.currentammo = self.ammo_rockets = self.ammo_rockets - 1; dumptruck_ds

	sound_attack (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";

// set missile speed  -- dumptruck_ds below

	SetSpeed(missile, normalize(self.enemy.origin - self.origin), projspeed);
  missile.angles = vectoangles(missile.velocity);
  missile.touch = EnfMisTouch;

	// makevectors (self.v_angle);
	// missile.velocity = aim(self, 1000);
	// missile.velocity = missile.velocity * 1000;
	// missile.angles = vectoangles(missile.velocity);

	// missile.touch = T_MissileTouch;

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
			setmodel (missile, "progs/missile.mdl");
	}

	if (!missile.skin_proj) // dumptruck_ds
	{
			missile.skin = self.skin_proj;
		}
		else
		{
			missile.skin = 0;
	}
// dumptruck_ds - end
	// setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	makevectors (self.angles); //thanks Voidforce -- dumptruck_ds
	setorigin (missile, self.origin + v_forward * 30 + v_right * 8.5 + '0 0 12'); //last number was 16 - dumptruck_ds
	// setorigin (missile, self.origin + v_forward*8 + '0 0 16');
};
//end dumptruck_ds grunt missle end
/*
================
EnfFireGrenade
================
*/
void() EnfFireGrenade =
{
	local	entity missile;

	self.effects = self.effects | EF_MUZZLEFLASH;

	sound_attack (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

// set missile speed

	makevectors (self.angles);

	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 600;
	missile.velocity_z = 200;

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = OgreGrenadeTouch;

// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = OgreGrenadeExplode;
	missile.skin = self.skin_proj; //dumptruck_ds

	if (self.mdl_proj != "") // dumptruck_ds
	{
			setmodel (missile, self.mdl_proj);
		}
		else
		{
			setmodel (missile, "progs/grenade.mdl");
	}

	if (!missile.skin_proj) // dumptruck_ds
	{
			missile.skin = self.skin_proj;
		}
		else
		{
			missile.skin = 0;
	}
// dumptruck_ds - end

	// setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16');
	// setorigin (missile, self.origin);
};

void() EnfLightning =
{
	local	vector	org, dir;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound_attack(self, CHAN_WEAPON,  "weapons/lstart.wav", 1, ATTN_NORM);
	ai_face ();
	makevectors (self.angles);
	org = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';

	dir = self.enemy.origin - self.enemy.velocity * 0.075;
	dir = normalize (dir - org + '0 0 16');

	if (self.spawnflags & I_AM_TURRET)
		{
			traceline (org, self.origin + dir*900, TRUE, self);
		}
	else
		{
			traceline (org, self.origin + dir*600, TRUE, self);
		}

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (org, trace_endpos, self, 4);
};


// style stuff -- dumptruck_ds
void() enforcer_fire =
{

if (self.style == 1)

	{
		self.effects = self.effects | EF_MUZZLEFLASH;
		ai_face();
		sound_attack (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

		EnfRocket();
		return;
	}

else if (self.style == 2)

	{
		self.effects = self.effects | EF_MUZZLEFLASH;
		ai_face();
		if (self.spawnflags & I_AM_TURRET)
			{
				PreachFireGrenade(self.attack_elevation);
			}
		else
		EnfFireGrenade();
		return;
	}

else if (self.style == 3 || self.style ==5)

	{
		local vector foo;

		self.effects = self.effects | EF_MUZZLEFLASH;
		makevectors (self.angles);

		foo = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';

		EnfLaunchSpike(foo, self.enemy.origin - self.origin);
		return;
	}

else

	local vector org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);

	org = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';

	LaunchLaser(org, self.enemy.origin - self.origin);
};

//============================================================================

void()	enf_stand1	=[	$stand1,	enf_stand2	] {ai_stand();};
void()	enf_stand2	=[	$stand2,	enf_stand3	] {ai_stand();};
void()	enf_stand3	=[	$stand3,	enf_stand4	] {ai_stand();};
void()	enf_stand4	=[	$stand4,	enf_stand5	] {ai_stand();};
void()	enf_stand5	=[	$stand5,	enf_stand6	] {ai_stand();};
void()	enf_stand6	=[	$stand6,	enf_stand7	] {ai_stand();};
void()	enf_stand7	=[	$stand7,	enf_stand1	] {ai_stand();};

void()	enf_walk1	=[	$walk1 ,	enf_walk2	] {
if (random() < 0.2)
	sound_idle (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE); //dumptruck_ds
ai_walk(2);};
void()	enf_walk2	=[	$walk2 ,	enf_walk3	] {ai_walk(4);};
void()	enf_walk3	=[	$walk3 ,	enf_walk4	] {ai_walk(4);};
void()	enf_walk4	=[	$walk4 ,	enf_walk5	] {ai_walk(3);};
void()	enf_walk5	=[	$walk5 ,	enf_walk6	] {ai_walk(1);};
void()	enf_walk6	=[	$walk6 ,	enf_walk7	] {ai_walk(2);};
void()	enf_walk7	=[	$walk7 ,	enf_walk8	] {ai_walk(2);};
void()	enf_walk8	=[	$walk8 ,	enf_walk9	] {ai_walk(1);};
void()	enf_walk9	=[	$walk9 ,	enf_walk10	] {ai_walk(2);};
void()	enf_walk10	=[	$walk10,	enf_walk11	] {ai_walk(4);};
void()	enf_walk11	=[	$walk11,	enf_walk12	] {ai_walk(4);};
void()	enf_walk12	=[	$walk12,	enf_walk13	] {ai_walk(1);};
void()	enf_walk13	=[	$walk13,	enf_walk14	] {ai_walk(2);};
void()	enf_walk14	=[	$walk14,	enf_walk15	] {ai_walk(3);};
void()	enf_walk15	=[	$walk15,	enf_walk16	] {ai_walk(4);};
void()	enf_walk16	=[	$walk16,	enf_walk1	] {ai_walk(2);};

void()	enf_run1	=[	$run1  ,	enf_run2	] {
if (random() < 0.2)
	sound_idle (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE); //dumptruck_ds
ai_run(18);};
void()	enf_run2	=[	$run2  ,	enf_run3	] {ai_run(14);};
void()	enf_run3	=[	$run3  ,	enf_run4	] {ai_run(7);};
void()	enf_run4	=[	$run4  ,	enf_run5	] {ai_run(12);};
void()	enf_run5	=[	$run5  ,	enf_run6	] {ai_run(14);};
void()	enf_run6	=[	$run6  ,	enf_run7	] {ai_run(14);};
void()	enf_run7	=[	$run7  ,	enf_run8	] {ai_run(7);};
void()	enf_run8	=[	$run8  ,	enf_run1	] {ai_run(11);};

void()	enf_atk1	=[	$attack1,	enf_atk2	] {ai_face();};
void()	enf_atk2	=[	$attack2,	enf_atk3	] {ai_face();};
void()	enf_atk3	=[	$attack3,	enf_atk4	] {ai_face();};
void()	enf_atk4	=[	$attack4,	enf_atk5	] {ai_face();};
void()	enf_atk5	=[	$attack5,	enf_atk6	] {ai_face();};
void()	enf_atk6	=[	$attack6,	enf_atk7	] {enforcer_fire();};
void()	enf_atk7	=[	$attack7,	enf_atk8	] {ai_face();};
void()	enf_atk8	=[	$attack8,	enf_atk9	] {ai_face();};
void()	enf_atk9	=[	$attack5,	enf_atk10	] {ai_face();};
void()	enf_atk10	=[	$attack6,	enf_atk11	] {enforcer_fire();};
void()	enf_atk11	=[	$attack7,	enf_atk12	] {ai_face();};
void()	enf_atk12	=[	$attack8,	enf_atk13	] {ai_face();};
void()	enf_atk13	=[	$attack9,	enf_atk14	] {ai_face();};
void()	enf_atk14	=[	$attack10,	enf_run1	] {ai_face();SUB_CheckRefire (enf_atk1);
};
/* modified animation frames for style Enforcers */ // dumptruck_ds
void() enf_2atk7;
void()	enf_2atk1	=[	$attack1,	enf_2atk2	] {ai_face();self.count = 0;self.t_length= 8 + floor(random()*6);};
void()	enf_2atk2	=[	$attack2,	enf_2atk3	] {ai_face();};
void()	enf_2atk3	=[	$attack3,	enf_2atk4	] {ai_face();};
void()	enf_2atk4	=[	$attack4,	enf_2atk5	] {ai_face();};
void()	enf_2atk5	=[	$attack5,	enf_2atk6	] {ai_face();};

void()	enf_2atk6	={
self.frame = $attack6;
self.nextthink = time + .1;
if (self.style == 5 && self.count < self.t_length)
{
  self.count +=1;
}
else
{
  self.think = enf_2atk7;
}
ai_face();
enforcer_fire();};
void()	enf_2atk7	=[	$attack7,	enf_2atk8	] {ai_face();};
void()	enf_2atk8	=[	$attack8,	enf_2atk9	] {ai_face();};
void()	enf_2atk9	=[	$attack9,	enf_2atk10	] {ai_face();};
void()	enf_2atk10	=[	$attack10,	enf_run1	] {ai_face();SUB_CheckRefire (enf_2atk1);
};

void()	enf_4atk1	=[	$attack1,	enf_4atk2	] {ai_face();};
void()	enf_4atk2	=[	$attack2,	enf_4atk3	] {ai_face();};
void()	enf_4atk3	=[	$attack3,	enf_4atk4	] {ai_face();};
void()	enf_4atk4	=[	$attack4,	enf_4atk5	] {ai_face();};
void()	enf_4atk5	=[	$attack5,	enf_4atk6	] {ai_face();};
void()	enf_4atk6	=[	$attack6,	enf_4atk7	] {EnfLightning();};
void()	enf_4atk7	=[	$attack6,	enf_4atk8	] {EnfLightning();};
void()	enf_4atk8	=[	$attack6,	enf_4atk9	] {EnfLightning();};
void()	enf_4atk9	=[	$attack7,	enf_4atk10	] {ai_face();};
void()	enf_4atk10	=[	$attack8,	enf_4atk11	] {ai_face();};
void()	enf_4atk11	=[	$attack9,	enf_4atk12	] {ai_face();};
void()	enf_4atk12	=[	$attack10,	enf_run1	] {ai_face();SUB_CheckRefire (enf_2atk1);
};
////////////////////////////
// new frames for turret mode START
////////////////////////////

void()	enf_turret_atk1	=[	$attack1,	enf_turret_atk2	] {ai_face();};
void()	enf_turret_atk2	=[	$attack2,	enf_turret_atk3	] {ai_face();};
void()	enf_turret_atk3	=[	$attack3,	enf_turret_atk4	] {ai_face();self.attack_elevation = IterateElevation(OGRE_DEFAULT_ELEVATION, self.enemy.origin);};
void()	enf_turret_atk4	=[	$attack4,	enf_turret_atk5	] {ai_face();self.attack_elevation = IterateElevation(self.attack_elevation, self.enemy.origin);};
void()	enf_turret_atk5	=[	$attack5,	enf_turret_atk6	] {ai_face();self.attack_elevation = IterateElevation(self.attack_elevation, self.enemy.origin);};
void()	enf_turret_atk6	=[	$attack6,	enf_turret_atk7	] {enforcer_fire();};
void()	enf_turret_atk7	=[	$attack7,	enf_turret_atk8	] {ai_face();self.attack_elevation = IterateElevation(OGRE_DEFAULT_ELEVATION, self.enemy.origin);};
void()	enf_turret_atk8	=[	$attack8,	enf_turret_atk9	] {ai_face();self.attack_elevation = IterateElevation(self.attack_elevation, self.enemy.origin);};
void()	enf_turret_atk9	=[	$attack5,	enf_turret_atk10	] {ai_face();self.attack_elevation = IterateElevation(self.attack_elevation, self.enemy.origin);};
void()	enf_turret_atk10	=[	$attack6,	enf_turret_atk11	] {enforcer_fire();};
void()	enf_turret_atk11	=[	$attack7,	enf_turret_atk12	] {ai_face();};
void()	enf_turret_atk12	=[	$attack8,	enf_turret_atk13	] {ai_face();};
void()	enf_turret_atk13	=[	$attack9,	enf_turret_atk14	] {ai_face();};
void()	enf_turret_atk14	=[	$attack10,	enf_seek_stand1	] {ai_face();SUB_CheckRefire (enf_turret_atk1);
};
void()	enf_seek_stand1	=[	$stand1,	enf_seek_stand2	] {ai_run(0);};
void()	enf_seek_stand2	=[	$stand2,	enf_seek_stand3	] {ai_run(0);};
void()	enf_seek_stand3	=[	$stand3,	enf_seek_stand4	] {ai_run(0);};
void()	enf_seek_stand4	=[	$stand4,	enf_seek_stand5	] {ai_run(0);};
void()	enf_seek_stand5	=[	$stand5,	enf_seek_stand6	] {ai_run(0);};
void()	enf_seek_stand6	=[	$stand6,	enf_seek_stand7	] {ai_run(0);};
void()	enf_seek_stand7	=[	$stand7,	enf_seek_stand1	] {ai_run(0);};

void() enf_2turret_atk7;
void()	enf_2turret_atk1	=[	$attack1,	enf_2turret_atk2	] {ai_face();self.count = 0;self.t_length= 4 + floor(random()*4);};
void()	enf_2turret_atk2	=[	$attack2,	enf_2turret_atk3	] {ai_face();};
void()	enf_2turret_atk3	=[	$attack3,	enf_2turret_atk4	] {ai_face();};
void()	enf_2turret_atk4	=[	$attack4,	enf_2turret_atk5	] {ai_face();};
void()	enf_2turret_atk5	=[	$attack5,	enf_2turret_atk6	] {ai_face();};

void()	enf_2turret_atk6	={
self.frame = $attack6;
self.nextthink = time + .1;
if (self.style == 5 && self.count < self.t_length)
{
  self.count +=1;
}
else
{
  self.think = enf_2turret_atk7;
}
ai_face();
enforcer_fire();};
void()	enf_2turret_atk7	=[	$attack7,	enf_2turret_atk8	] {ai_face();};
void()	enf_2turret_atk8	=[	$attack8,	enf_2turret_atk9	] {ai_face();};
void()	enf_2turret_atk9	=[	$attack9,	enf_2turret_atk10	] {ai_face();};
void()	enf_2turret_atk10	=[	$attack10,	enf_2stand1	] {ai_face();SUB_CheckRefire (enf_2turret_atk1);
};
void()	enf_4turret_atk1	=[	$attack1,	enf_4turret_atk2	] {ai_face();};
void()	enf_4turret_atk2	=[	$attack2,	enf_4turret_atk3	] {ai_face();};
void()	enf_4turret_atk3	=[	$attack3,	enf_4turret_atk4	] {ai_face();};
void()	enf_4turret_atk4	=[	$attack4,	enf_4turret_atk5	] {ai_face();};
void()	enf_4turret_atk5	=[	$attack5,	enf_4turret_atk6	] {ai_face();};
void()	enf_4turret_atk6	=[	$attack6,	enf_4turret_atk7	] {EnfLightning();};
void()	enf_4turret_atk7	=[	$attack6,	enf_4turret_atk8	] {EnfLightning();};
void()	enf_4turret_atk8	=[	$attack6,	enf_4turret_atk9	] {EnfLightning();};
void()	enf_4turret_atk9	=[	$attack7,	enf_4turret_atk10	] {ai_face();};
void()	enf_4turret_atk10	=[	$attack8,	enf_4turret_atk11	] {ai_face();};
void()	enf_4turret_atk11	=[	$attack9,	enf_4turret_atk12	] {ai_face();};
void()	enf_4turret_atk12	=[	$attack10,	enf_2stand1	] {ai_face();SUB_CheckRefire (enf_2turret_atk1);
};
void()	enf_2stand1	=[	$stand1,	enf_2stand2	] {ai_run(0);};
void()	enf_2stand2	=[	$stand2,	enf_2stand3	] {ai_run(0);};
void()	enf_2stand3	=[	$stand3,	enf_2stand4	] {ai_run(0);};
void()	enf_2stand4	=[	$stand4,	enf_2stand5	] {ai_run(0);};
void()	enf_2stand5	=[	$stand5,	enf_2stand6	] {ai_run(0);};
void()	enf_2stand6	=[	$stand6,	enf_2stand7	] {ai_run(0);};
void()	enf_2stand7	=[	$stand7,	enf_2stand1	] {ai_run(0);};
////////////////////////////
// new frames for turret mode END
////////////////////////////
void()	enf_paina1	=[	$paina1,	enf_paina2	] {};
void()	enf_paina2	=[	$paina2,	enf_paina3	] {};
void()	enf_paina3	=[	$paina3,	enf_paina4	] {};
void()	enf_paina4	=[	$paina4,	enf_run1	] {};

void()	enf_painb1	=[	$painb1,	enf_painb2	] {};
void()	enf_painb2	=[	$painb2,	enf_painb3	] {};
void()	enf_painb3	=[	$painb3,	enf_painb4	] {};
void()	enf_painb4	=[	$painb4,	enf_painb5	] {};
void()	enf_painb5	=[	$painb5,	enf_run1	] {};

void()	enf_painc1	=[	$painc1,	enf_painc2	] {};
void()	enf_painc2	=[	$painc2,	enf_painc3	] {};
void()	enf_painc3	=[	$painc3,	enf_painc4	] {};
void()	enf_painc4	=[	$painc4,	enf_painc5	] {};
void()	enf_painc5	=[	$painc5,	enf_painc6	] {};
void()	enf_painc6	=[	$painc6,	enf_painc7	] {};
void()	enf_painc7	=[	$painc7,	enf_painc8	] {};
void()	enf_painc8	=[	$painc8,	enf_run1	] {};

void()	enf_paind1	=[	$paind1,	enf_paind2	] {};
void()	enf_paind2	=[	$paind2,	enf_paind3	] {};
void()	enf_paind3	=[	$paind3,	enf_paind4	] {};
void()	enf_paind4	=[	$paind4,	enf_paind5	] {ai_painforward(2);};
void()	enf_paind5	=[	$paind5,	enf_paind6	] {ai_painforward(1);};
void()	enf_paind6	=[	$paind6,	enf_paind7	] {};
void()	enf_paind7	=[	$paind7,	enf_paind8	] {};
void()	enf_paind8	=[	$paind8,	enf_paind9	] {};
void()	enf_paind9	=[	$paind9,	enf_paind10	] {};
void()	enf_paind10	=[	$paind10,	enf_paind11	] {};
void()	enf_paind11	=[	$paind11,	enf_paind12	] {ai_painforward(1);};
void()	enf_paind12	=[	$paind12,	enf_paind13	] {ai_painforward(1);};
void()	enf_paind13	=[	$paind13,	enf_paind14	] {ai_painforward(1);};
void()	enf_paind14	=[	$paind14,	enf_paind15	] {};
void()	enf_paind15	=[	$paind15,	enf_paind16	] {};
void()	enf_paind16	=[	$paind16,	enf_paind17	] {ai_pain(1);};
void()	enf_paind17	=[	$paind17,	enf_paind18	] {ai_pain(1);};
void()	enf_paind18	=[	$paind18,	enf_paind19	] {};
void()	enf_paind19	=[	$paind19,	enf_run1	] {};

void(entity attacker, float damage)	enf_pain =
{
	local float r;

	r = random ();

	if (self.pain_finished > time)
		return;

	if (r < 0.5)
		sound_pain (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM); //dumptruck_ds
	else
		sound_misc3 (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM); // dumptruck_ds

	if (r < 0.2)
	{
		self.pain_finished = time + 1;
		// moved these here to avoid spamming pain sounds - dumptruck_ds
		if (self.spawnflags & I_AM_TURRET)
		return;
		else
		enf_paina1 ();
	}
	else if (r < 0.4)
	{
		self.pain_finished = time + 1;
		if (self.spawnflags & I_AM_TURRET)
		return;
		else
		enf_painb1 ();
	}
	else if (r < 0.7)
	{
		self.pain_finished = time + 1;
		if (self.spawnflags & I_AM_TURRET)
		return;
		else
		enf_painc1 ();
	}
	else
	{
		self.pain_finished = time + 2;
		if (self.spawnflags & I_AM_TURRET)
		return;
		else
		enf_paind1 ();
	}
};

//============================================================================




void()	enf_die1	=[	$death1,	enf_die2	] {};
void()	enf_die2	=[	$death2,	enf_die3	] {};
void()	enf_die3	=[	$death3,	enf_die4	]
{
	self.solid = SOLID_NOT;

	if (self.style == 1) // style ammotype check -- dumptruck_ds
		{
			self.ammo_rockets = 2;
		}
	if (self.style == 2) // style ammotype check -- dumptruck_ds
		{
			self.ammo_rockets = 2;
		}
	if (self.style == 3 || self.style == 5) // style ammotype check -- dumptruck_ds
		{
			self.ammo_nails = 5;
		}
	if (self.style == 0 || self.style == 4) // style ammotype check -- dumptruck_ds
		{
			self.ammo_cells = 5;
		}
	if(!self.keep_ammo)DropBackpack();
};
void()	enf_die4	=[	$death4,	enf_die5	] {ai_forward(14);};
void()	enf_die5	=[	$death5,	enf_die6	] {ai_forward(2);};
void()	enf_die6	=[	$death6,	enf_die7	] {};
void()	enf_die7	=[	$death7,	enf_die8	] {};
void()	enf_die8	=[	$death8,	enf_die9	] {};
void()	enf_die9	=[	$death9,	enf_die10	] {ai_forward(3);};
void()	enf_die10	=[	$death10,	enf_die11	] {ai_forward(5);};
void()	enf_die11	=[	$death11,	enf_die12	] {ai_forward(5);};
void()	enf_die12	=[	$death12,	enf_die13	] {ai_forward(5);};
void()	enf_die13	=[	$death13,	enf_die14	] {};
void()	enf_die14	=[	$death14,	enf_die14	] {};

void()	enf_fdie1	=[	$fdeath1,	enf_fdie2	] {

};
void()	enf_fdie2	=[	$fdeath2,	enf_fdie3	] {};
void()	enf_fdie3	=[	$fdeath3,	enf_fdie4	]
{
	self.solid = SOLID_NOT;

 	if (self.style == 1) // style ammotype check -- dumptruck_ds
		{
			self.ammo_rockets = 2;
		}
	if (self.style == 2) // style ammotype check -- dumptruck_ds
		{
			self.ammo_rockets = 2;
		}
	if (self.style == 3 || self.style == 5) // style ammotype check -- dumptruck_ds
		{
			self.ammo_nails = 5;
		}
	if (self.style == 0 || self.style == 4) // style ammotype check -- dumptruck_ds
		{
			self.ammo_cells = 5;
		}
	if(!self.keep_ammo)DropBackpack();
};
void()	enf_fdie4	=[	$fdeath4,	enf_fdie5	] {};
void()	enf_fdie5	=[	$fdeath5,	enf_fdie6	] {};
void()	enf_fdie6	=[	$fdeath6,	enf_fdie7	] {};
void()	enf_fdie7	=[	$fdeath7,	enf_fdie8	] {};
void()	enf_fdie8	=[	$fdeath8,	enf_fdie9	] {};
void()	enf_fdie9	=[	$fdeath9,	enf_fdie10	] {};
void()	enf_fdie10	=[	$fdeath10,	enf_fdie11	] {};
void()	enf_fdie11	=[	$fdeath11,	enf_fdie11	] {};


void() enf_die =
{
// check for gib
	if (self.health < -35)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
			if (self.mdl_head != "") //dumptruck_ds custom_mdls
			{
				ThrowHead (self.mdl_head, self.health);
			}
			else
			{
				ThrowHead ("progs/h_mega.mdl", self.health);
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
	sound_death (self, CHAN_VOICE, "enforcer/death1.wav", 1, ATTN_NORM); //dumptruck_ds
	DropStuff();
	if (random() > 0.5)
		enf_die1 ();
	else
		enf_fdie1 ();
};


/*QUAKED monster_enforcer (1 0 0) (-16 -16 -24) (16 16 40) AMBUSH X X TRIGGER_SPAWNED X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ("progs/enforcer.mdl");
}
Enforcer.

Default health = 80

keep_ammo(integer) : "1 = Don't drop backpack upon death"

style(Choices) : "Attack type"
0 : "Default (lasers)"
1	: "rockets"
2 : "grenades"
3 : "nails"

snd_death(string) : Path to custom death sound"
snd_pain(string) : "Path to 1st custom pain sound"
snd_sight(string) : "Path to custom sight sound for STOP!"
snd_attack(string) : Path to custom attack sound e.g laser firing"
snd_hit(string) : "Path to custom hit sound e.g. laser hits wall"
snd_idle(string) : "Path to custom idle sound"
snd_misc(string) : "Path to custom sight sound for FREEZE!"
snd_misc1(string) : "Path to custom sight sound for YOU THERE!"
snd_misc2(string) : "Path to custom sight sound for HALT!"
snd_misc3(string) : "Path to 2nd custom pain sound"

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
obit_method(string) : "When used with obit_name, will set part of the text for a custom obituary. e.g. eviscerated - If empty, defaults to killed."
obit_name(string) : "When used with obit_method, this will set part of the text for a custom obituary. e.g. a Super Soldier! Using the examples here, the obituary would read: Player was eviscerated by a Super Solider!"
damage_mod(float) : "USE WITH CAUTION! Multiply all damage from this monster by this number (e.g. 4 = Quad damage)"

*/
void() monster_enforcer =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (deathmatch)
	{
		remove(self);
		return;
	}
	if (self.style >= 6)
		objerror("style key set too high\n");

	precache_body_model2 ("progs/enforcer.mdl");  // custom_mdls function -- dumptruck_ds
	precache_head_model2 ("progs/h_mega.mdl");
	precache_proj_model2 ("progs/laser.mdl");
	precache_proj_model2 ("progs/s_spike.mdl");
	precache_proj_model2 ("progs/missile.mdl");
 //dumptruck_ds
	precache_sound2_death ("enforcer/death1.wav");
	precache_sound2_attack ("enforcer/enfire.wav");
	precache_sound2_hit ("enforcer/enfstop.wav");
	precache_sound2_idle ("enforcer/idle1.wav");
	precache_sound2_pain ("enforcer/pain1.wav");
	precache_sound2_misc3 ("enforcer/pain2.wav");
	precache_sound2_sight ("enforcer/sight1.wav");
	precache_sound2_misc ("enforcer/sight2.wav"); // these will be replaced with custom noise fields eventually - dumptruck_ds
	precache_sound2_misc1 ("enforcer/sight3.wav");
	precache_sound2_misc2 ("enforcer/sight4.wav");

	precache_gib1 ("progs/gib1.mdl");
	precache_gib2 ("progs/gib2.mdl");
	precache_gib3 ("progs/gib3.mdl");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	body_model ("progs/enforcer.mdl"); // SPIKE to the RESCUE!!!! - got this fixed. -- dumptruck_ds
	// // setmodel (self, "progs/enforcer.mdl"); //orginal dumptruck_ds

	setsize (self, '-16 -16 -24', '16 16 40');

	if (!self.proj_speed_mod)
	{
		self.proj_speed_mod = 1;
	}

	if (!self.health) //thanks RennyC -- dumptruck_ds
	self.health = 80;

	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	if (self.spawnflags & I_AM_TURRET)
	{
		self.th_run = enf_2stand1;
	}
	else
	{
		self.th_run = enf_run1;
	}
	if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
		self.th_pain = enf_pain;
	else
		self.th_pain = SUB_NullPain;
	self.th_die = enf_die;
	if (self.style == 1 || self.style == 2 || self.style == 5) // new animation frame check -- dumptruck_ds
		{
			if (self.spawnflags & I_AM_TURRET)
				{
					self.th_turret = enf_2turret_atk1;
				}
			self.th_missile = enf_2atk1;
		}
	else if (self.style == 0 || self.style == 3 ) // new animation frame check -- dumptruck_ds
		{
			if (self.spawnflags & I_AM_TURRET)
			{
				self.th_turret = enf_turret_atk1;
			}
			self.th_missile = enf_atk1;
		}
	else if (self.style == 4) // new animation frame check -- dumptruck_ds
		{
			if (self.spawnflags & I_AM_TURRET)
			{
				self.th_turret = enf_4turret_atk1;
			}
			self.th_missile = enf_4atk1;
		}
	walkmonster_start();
};

/* Scenic Dead Monster Patch stuff here from DeadStuff mod -- dumptruck_ds */

/*QUAKED monster_dead_enforcer (0 0.5 0.8) (-16 -16 -24) (16 16 32) SOLID FACE_UP X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ({"path":"progs/enforcer.mdl","frame":54});
}
*/
void() monster_dead_enforcer =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/enforcer.mdl");
	setmodel(self, "progs/enforcer.mdl");
	if (self.spawnflags & 2)
	{
		self.frame = $fdeath11;

		if (self.spawnflags & 1)
		{
			self.solid = SOLID_BBOX;
                	setsize(self,'-41.16 -45.65 -51.95','21.45 25.49 30');
		}
		else
		{
			self.solid = SOLID_NOT;
		}
	}
	else
	{
		self.frame = $death14;
		if (self.spawnflags & 1)
		{
			self.solid = SOLID_BBOX;
                	setsize(self,'-39.85 -29.35 -49.07','20.52 33.17 30');
		}
		else
		{
			self.solid = SOLID_NOT;
		}
	}
};
