float MONSTER_FLAK_OGRE				= 4;
float	FL_NOSELECT			= 8192;	//ignored by entity selector
.float spikecount;	//bdw - saves up flak hits to do a single damage next frame - currently only used for flak ogre

/*
==============================================================================

OGRE

==============================================================================
*/

$cd id1/models/ogre_c
$origin 0 0 24
$base base
$skin base

$frame	stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7
$frame walk8 walk9 walk10 walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame swing1 swing2 swing3 swing4 swing5 swing6 swing7
$frame swing8 swing9 swing10 swing11 swing12 swing13 swing14

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7
$frame smash8 smash9 smash10 smash11 smash12 smash13 smash14

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6

$frame pain1 pain2 pain3 pain4 pain5

$frame painb1 painb2 painb3

$frame painc1 painc2 painc3 painc4 painc5 painc6

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13 paind14 paind15 paind16

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15

$frame death1 death2 death3 death4 death5 death6
$frame death7 death8 death9 death10 death11 death12
$frame death13 death14

$frame bdeath1 bdeath2 bdeath3 bdeath4 bdeath5 bdeath6
$frame bdeath7 bdeath8 bdeath9 bdeath10

$frame pull1 pull2 pull3 pull4 pull5 pull6 pull7 pull8 pull9 pull10 pull11

//=============================================================================


void() OgreGrenadeExplode =
{
	T_RadiusDamage (self, self.owner, 40, world);
	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() OgreGrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		OgreGrenadeExplode();
		return;
	}
	if (self.count < time) {
		sound (self, CHAN_VOICE, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	}
	self.count = time + .02;
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

//BDW 31/08/00 - evil, nasty red-hot nail cluster-bomb attack... from Marcher -- dumptruck_ds

void() FlakDoDamage =
{
	self.origin = self.oldenemy.origin + self.oldorigin;	//get correct gib direction
	T_Damage(self.oldenemy, self, self.owner, self.oldenemy.spikecount);
	self.oldenemy.spikecount = 0;
	remove(self);
};

void() FlakTouch =
{
	if (other.solid == SOLID_TRIGGER)
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood(self.dmg);

		sound(self, CHAN_VOICE, "fish/bite.wav", 1, ATTN_NORM);

		if (other.spikecount)	//not the first one
		{
			other.spikecount = other.spikecount + self.dmg;
			remove(self);
			return;
		}

		// the first one...

		other.spikecount = self.dmg;

		// stick around for a little while...
		self.velocity = '0 0 0';
		self.solid = SOLID_NOT;
		self.touch = SUB_Null;
		self.model = string_null;
		self.oldorigin = self.origin - other.origin;	//displacement from enemy origin (its gonna move next frame)
		self.oldenemy = other;
		self.think = FlakDoDamage;
		self.nextthink = time + 0.05;
		return;
	}

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	if (self.spawnflags & MONSTER_FLAK_OGRE)	//bit of a hack
	{
		remove(self);
		return;
	}

	self.dmg = self.dmg - 5;	//gets weaker with each bounce. also stops them getting stuck in world.
	if (self.dmg <= 0)
	{
		remove(self);
		return;
	}
	self.velocity = self.velocity * 0.5;	//reduce crazy ricochets
	self.movetype = MOVETYPE_BOUNCE;
};

void() BDW_OgreFireFlak =
{
	local float flakcount;
	local vector dir, ang;
	local entity flak;
	local float projspeed = 800 * self.proj_speed_mod;

	flakcount = 8;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);

// make angles out of the current displacement vector...
	ang = vectoangles(self.enemy.origin - self.origin);
// then get the required components...
	makevectors(ang);

	while (flakcount > 0)
	{
	//tighter spread...
		dir = v_forward*10 + crandom()*v_right + crandom()*v_up;
		dir = normalize(dir);
	// f*cking hack...is this a v_forward problem?
		dir_z = dir_z * -1;
		//dir = dir*1000;
		//dir = dir*800;


		flak = spawn();

		flak.owner = self;
		//flymissile is a bit too all-seeing for this gun...
		flak.movetype = MOVETYPE_FLY;
		//flak.movetype = MOVETYPE_FLYMISSILE;
		flak.solid = SOLID_BBOX;
		flak.flags = FL_NOSELECT;
		flak.touch = FlakTouch;
		flak.angles = vectoangles(dir);
		SetSpeed(flak, dir, projspeed);
		if (self.homing > 0)
		{
			SetupHoming(flak, projspeed);
		}
		else
		{
			flak.nextthink = time + 6;
			flak.think = SUB_Remove;
		}
		flak.dmg = 4;

		flak.spawnflags = MONSTER_FLAK_OGRE;	//this is a hack to tell FlakTouch that it came from an ogre
		// setmodel(flak, "progs/spike.mdl");
		flak.skin = self.skin_proj; //dumptruck_ds

		if (self.mdl_proj != "") // dumptruck_ds
		{
				setmodel (flak, self.mdl_proj);
			}
			else
			{
				setmodel (flak, "progs/spike.mdl");
		}

		if (!flak.skin_proj) // dumptruck_ds
		{
				flak.skin = self.skin_proj;
			}
			else
			{
				flak.skin = 0;
		}
	// dumptruck_ds - end

		setsize(flak, '0 0 0', '0 0 0');
		setorigin(flak, self.origin + '0 0 16');

		flakcount = flakcount - 1;
	}
};
/////////////////////////////////////////////////////////////
/* start Preach Ogre Marksman tutorial here -- dumptruck_ds*/
/////////////////////////////////////////////////////////////

//speed an ogre grenade is fired at
float OGRE_G_VEL = 600;

//fixme: get the correct gravity strength for the level
float pgrav = 800;

//a default angle to fire at if the enemy is too far away
float OGRE_DEFAULT_ELEVATION = 30;

//uses QuakeC builtins to calculate tan of angle
//WARNING: uses makevectors! This overwrites the v_forward... globals
float(float theta) tan =
{
  local vector ang; //temporary used to calculate trig values
  ang = '0 0 0';
  ang_y = theta; //assign theta to the yaw to simplify reasoning
  makevectors(ang);
  return v_forward_y / v_forward_x;
}

//inverse tan function
//takes two parameters, numerator and denominator
//this copes better with denominator 0 and gets quadrant correct
float(float y, float x) atan2 =
{
  local vector ang; //temporary used to calculate trig values
  ang = '0 0 0';
  ang_x = x;
  ang_y = y;
  return vectoyaw(ang);
}

float(float theta, vector dest) IterateElevation =
{
  local float a, b, c; //constants in the equation to be solved
  local vector ofs; //displacement we wish the projectile to travel
  local float y, z; //horizontal and vertical components of ofs
  local float tan_theta; //trig values of the angle theta

  //calculate how far we are firing
  ofs = dest - self.origin;
  z = ofs_z;
  ofs_z = 0;
  y = vlen(ofs);

  //find the coefficients of the quadratic in tan(theta)
  a = 0.5 * pgrav * y * y / (OGRE_G_VEL * OGRE_G_VEL);
  b = -y;
  c = a + z;

  //check if the destination is too far to reach
  if(b*b < 4*a*c)
    return OGRE_DEFAULT_ELEVATION;

  //calculate the tan value of the given theta
  tan_theta = tan(theta);

  //reuse ang to create the improved firing direction
  theta = atan2(a*tan_theta*tan_theta - c,
                      2*a*tan_theta + b);

  //constrain the values to stop anything too mad happening
  while(theta > 90)
    theta = theta - 180;
  return theta;
}
/*
================
PreachFireGrenade
================
*/
void(float elevation) PreachFireGrenade =
{
	local	entity missile;
	local vector ang;

	self.effects = self.effects | EF_MUZZLEFLASH;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

// set missile speed
	ang = self.angles;
  ang_x = -elevation;
  makevectors (ang);

  missile.velocity = v_forward * OGRE_G_VEL;

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = OgreGrenadeTouch;

// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = OgreGrenadeExplode;
	// setmodel (missile, "progs/grenade.mdl");
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

	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin);
};

// end Preach tutorial

/*
================
PreachFireZombie
for Z-Aware Zombies in Turret Mode only
================
*/
void(float elevation) PreachFireZombie =
{
	local	entity missile;
	local vector ang;

	// self.effects = self.effects | EF_MUZZLEFLASH;

	sound_attack (self, CHAN_WEAPON, "zombie/z_shot1.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

// set missile speed
	ang = self.angles;
  ang_x = -elevation;
  makevectors (ang);

  missile.velocity = v_forward * OGRE_G_VEL;

	missile.avelocity = '3000 1000 2000';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = ZombieGrenadeTouch;

// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = SUB_Remove;
	// setmodel (missile, "progs/grenade.mdl");
	if (self.mdl_proj != "") // dumptruck_ds
	{
			setmodel (missile, self.mdl_proj);
		}
		else
		{
			setmodel (missile, "progs/zom_gib.mdl");
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
	setorigin (missile, self.origin);
};

// end Preach tutorial

/*
================
OgreFireGrenade
================
*/
void() MultiGrenadeTouch;
void() MultiGrenadeExplode;

void() OgreFireGrenade =
{
	local	entity missile;

	self.effects = self.effects | EF_MUZZLEFLASH;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
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
// set missile speed

	makevectors (self.angles);
	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 600;
	missile.velocity_z = 200;
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);

	// set missile duration
		if(self.style == 3)
		{
			missile.touch = MultiGrenadeTouch;
			missile.nextthink = time + 2.5;
			missile.think = MultiGrenadeExplode;
			setmodel (missile, "progs/mervup.mdl");
			setsize (missile, '0 0 0', '0 0 0');
			setorigin (missile, self.origin);
			missile.classname = "MultiGrenade";
		}
		else
		{
			missile.touch = OgreGrenadeTouch;
			missile.nextthink = time + 2.5;
			missile.think = OgreGrenadeExplode;
			// setmodel (missile, "progs/grenade.mdl");
			setsize (missile, '0 0 0', '0 0 0');
			setorigin (missile, self.origin);
		}
	};

	// missile.touch = OgreGrenadeTouch;

// // set missile duration
// 	missile.nextthink = time + 2.5;
// 	missile.think = OgreGrenadeExplode;
//
// 	setmodel (missile, "progs/grenade.mdl");
// 	setsize (missile, '0 0 0', '0 0 0');
// 	setorigin (missile, self.origin);
// };

/*
================
OgreFireSpike from insideqc tutorial here: http://www.insideqc.com/qctut/lesson-33.shtml
================
*/
void() OgreFireSpike =
{
    local vector dir;
    // local entity old;


    sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
    self.attack_finished = time + .7;
    // self.attack_finished = time + 0.2;
		self.effects = self.effects | EF_MUZZLEFLASH; // -- dumptruck_ds

    dir = normalize (self.enemy.origin - self.origin);

    launch_spike (self.origin + v_right * 4 + '0 0 16', dir);

    newmis.touch = superduperspike_touch; //dumptruck_ds found in client.qc
    // setmodel (newmis, "progs/lspike.mdl");
		newmis.skin = self.skin_proj; //dumptruck_ds

		if (self.mdl_proj != "") // dumptruck_ds
		{
				setmodel (newmis, self.mdl_proj);
			}
			else
			{
				setmodel (newmis, "progs/lspike.mdl");
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

    setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
};
//=============================================================================
// Multi Grenade Code from doe progs MULT_WPN.QC -- dumptruck_ds
//=============================================================================
void() MultiGrenadeTouch;

//================================
//================================
void() MiniGrenadeExplode =
{
	if ( self.owner.classname == "player")
		T_RadiusDamage (self, self.owner, 90, world);
	else
		T_RadiusDamage (self, self.owner, 60, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
    WriteByte (MSG_BROADCAST, 230);
    WriteByte (MSG_BROADCAST, 5);

	BecomeExplosion ();
};

//================================
//================================
void(float offsetAngle) MiniGrenadeLaunch =
{
	local	entity missile/*, mpuff*/;
	local	float	tempRand;

	missile = spawn ();
	missile.owner = self.owner;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "MiniGrenade";

// set missile speed
	missile.v_angle = self.v_angle;
	missile.v_angle_y = missile.v_angle_y + offsetAngle;
	makevectors (missile.v_angle);

		missile.velocity = v_forward*100 + v_up*400;
		tempRand = (crandom()*60) - 30;
		missile.velocity = missile.velocity + tempRand * v_forward;
		tempRand = (crandom()*40) - 20;
		missile.velocity = missile.velocity + tempRand * v_right;
		tempRand = (crandom()*60) - 30;
		missile.velocity = missile.velocity + tempRand * v_up;

	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = MultiGrenadeTouch;

	setmodel (missile, "progs/mervup.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin);

// set missile duration
	missile.nextthink = time + 1 + (crandom() * 0.5);
	missile.think = MiniGrenadeExplode;
};

//================================
//================================
void() MultiGrenadeExplode =
{
	MiniGrenadeLaunch(0);
	MiniGrenadeLaunch(72);
	MiniGrenadeLaunch(144);
	MiniGrenadeLaunch(216);
	MiniGrenadeLaunch(288);

	remove (self);
};

//================================
//================================
void() MultiGrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		if (self.classname == "MiniGrenade")
			MiniGrenadeExplode();
		else
		{
			if (self.owner.classname == "player")
				GrenadeExplode();
			else
				MiniGrenadeExplode();
		}
		return;
	}
	// bounce sound
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

//================================
//================================
void() W_FireMultiGrenade =
{
	local	entity missile/*, mpuff*/;

	// self.currentammo = self.ammo_multi_rockets = self.ammo_multi_rockets - 1;
	// UpdateAmmoCounts (self);

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	// self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "MultiGrenade";

	makevectors (self.angles);
	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 600;
	missile.velocity_z = 200;
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);


// set missile speed
	// makevectors (self.v_angle);
	// if (self.v_angle_x)
	// 	missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	// else
	// {
	// 	missile.velocity = aim(self, 10000);
	// 	missile.velocity = missile.velocity * 600;
	// 	missile.velocity_z = 200;
	// }
	//
	// missile.avelocity = '300 300 300';
	// missile.angles = vectoangles(missile.velocity);
	missile.touch = MultiGrenadeTouch;

// set missile duration
	missile.nextthink = time + 1;
	missile.think = MultiGrenadeExplode;
	setmodel (missile, "progs/mervup.mdl");
	missile.skin = self.skin_proj; //dumptruck_ds

	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin + '0 0 16');
};

//=============================================================================
//end doe qc -- dumptruck_ds
//=============================================================================
/*
================
OgreFireLavaBall by jaycie erysdren 2021-09-14
================
*/

void() OgreFireLavaBall =
{
	local	vector	offang;
	local	vector	org, vec, d;
	// local	float	t;

	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);

	org = self.origin; // + p_x*v_forward + p_y*v_right + p_z*'0 0 1';

// lead the player on hard mode
	// if (skill > 1)
	// {
	// 	t = vlen(self.enemy.origin - org) / 300;
	// 	vec = self.enemy.velocity;
	// 	vec_z = 0;
	// 	d = self.enemy.origin + t * vec;
	// }
	// else
	// {
		d = self.enemy.origin;
	// }

	vec = normalize (d - org);

	// launch_spike (org, vec);
	launch_spike2 (self.origin + v_right * 4 + '0 0 16', vec, 600);
	self.effects = self.effects | EF_MUZZLEFLASH;
	if (self.mdl_proj != "") // dumptruck_ds custom_mdls
	{
			setmodel (newmis, self.mdl_proj);
		}
		else
		{
			setmodel (newmis, "progs/lavaball.mdl");
	}

	if (!newmis.skin_proj) // dumptruck_ds
	{
			newmis.skin = self.skin_proj;
		}
		else
		{
			newmis.skin = 0;
	}
	newmis.avelocity = self.cust_avelocity;
	if !(newmis.avelocity)
	newmis.avelocity = '200 100 300';
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	// newmis.touch = T_MissileTouch; // rocket explosion
	newmis.touch = OgreGrenadeExplode;
	sound_attack (self, CHAN_AUTO, "boss1/throw.wav", 1, ATTN_NORM);

};

/*
================
chainsaw

FIXME
================
*/
void(float side) chainsaw =
{
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;
	if (!CanDamage (self.enemy, self))
		return;

	ai_charge(10);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

	ldmg = (random() + random() + random()) * 4;
	T_Damage (self.enemy, self, self, ldmg);

	if (side)
	{
		makevectors (self.angles);
		if (side == 1)
			SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
		else
			SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
	}
};

void() ogre_stand1	=[	$stand1,	ogre_stand2	] {ai_stand();};
void() ogre_stand2	=[	$stand2,	ogre_stand3	] {ai_stand();};
void() ogre_stand3	=[	$stand3,	ogre_stand4	] {ai_stand();};
void() ogre_stand4	=[	$stand4,	ogre_stand5	] {ai_stand();};
void() ogre_stand5	=[	$stand5,	ogre_stand6	] {
if (random() < 0.2)
	sound_idle (self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE);
ai_stand();
};
void() ogre_stand6	=[	$stand6,	ogre_stand7	] {ai_stand();};
void() ogre_stand7	=[	$stand7,	ogre_stand8	] {ai_stand();};
void() ogre_stand8	=[	$stand8,	ogre_stand9	] {ai_stand();};
void() ogre_stand9	=[	$stand9,	ogre_stand1	] {ai_stand();};

void() ogre_walk1	=[	$walk1,		ogre_walk2	] {ai_walk(3);};
void() ogre_walk2	=[	$walk2,		ogre_walk3	] {ai_walk(2);};
void() ogre_walk3	=[	$walk3,		ogre_walk4	] {
ai_walk(2);
if (random() < 0.2)
	sound_idle (self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE);
};
void() ogre_walk4	=[	$walk4,		ogre_walk5	] {ai_walk(2);};
void() ogre_walk5	=[	$walk5,		ogre_walk6	] {ai_walk(2);};
void() ogre_walk6	=[	$walk6,		ogre_walk7	] {
ai_walk(5);
if (random() < 0.1)
	sound_misc (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);
};
void() ogre_walk7	=[	$walk7,		ogre_walk8	] {ai_walk(3);};
void() ogre_walk8	=[	$walk8,		ogre_walk9	] {ai_walk(2);};
void() ogre_walk9	=[	$walk9,		ogre_walk10	] {ai_walk(3);};
void() ogre_walk10	=[	$walk10,	ogre_walk11	] {ai_walk(1);};
void() ogre_walk11	=[	$walk11,	ogre_walk12	] {ai_walk(2);};
void() ogre_walk12	=[	$walk12,	ogre_walk13	] {ai_walk(3);};
void() ogre_walk13	=[	$walk13,	ogre_walk14	] {ai_walk(3);};
void() ogre_walk14	=[	$walk14,	ogre_walk15	] {ai_walk(3);};
void() ogre_walk15	=[	$walk15,	ogre_walk16	] {ai_walk(3);};
void() ogre_walk16	=[	$walk16,	ogre_walk1	] {ai_walk(4);};

void() ogre_run1	=[	$run1,		ogre_run2	] {ai_run(9);
if (random() < 0.2)
	sound_misc1 (self, CHAN_VOICE, "ogre/ogidle2.wav", 1, ATTN_IDLE);
};
void() ogre_run2	=[	$run2,		ogre_run3	] {ai_run(12);};
void() ogre_run3	=[	$run3,		ogre_run4	] {ai_run(8);};
void() ogre_run4	=[	$run4,		ogre_run5	] {ai_run(22);};
void() ogre_run5	=[	$run5,		ogre_run6	] {ai_run(16);};
void() ogre_run6	=[	$run6,		ogre_run7	] {ai_run(4);};
void() ogre_run7	=[	$run7,		ogre_run8	] {ai_run(13);};
void() ogre_run8	=[	$run8,		ogre_run1	] {ai_run(24);};

void() ogre_swing1	=[	$swing1,		ogre_swing2	] {ai_charge(11);
sound_attack (self, CHAN_WEAPON, "ogre/ogsawatk.wav", 1, ATTN_NORM);
};
void() ogre_swing2	=[	$swing2,		ogre_swing3	] {ai_charge(1);};
void() ogre_swing3	=[	$swing3,		ogre_swing4	] {ai_charge(4);};
void() ogre_swing4	=[	$swing4,		ogre_swing5	] {ai_charge(13);};
void() ogre_swing5	=[	$swing5,		ogre_swing6	] {ai_charge(9); chainsaw(0);self.angles_y = self.angles_y + random()*25;};
void() ogre_swing6	=[	$swing6,		ogre_swing7	] {chainsaw(200);self.angles_y = self.angles_y + random()* 25;};
void() ogre_swing7	=[	$swing7,		ogre_swing8	] {chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() ogre_swing8	=[	$swing8,		ogre_swing9	] {chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() ogre_swing9	=[	$swing9,		ogre_swing10 ] {chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() ogre_swing10	=[	$swing10,		ogre_swing11 ] {chainsaw(-200);self.angles_y = self.angles_y + random()* 25;};
void() ogre_swing11	=[	$swing11,		ogre_swing12 ] {chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() ogre_swing12	=[	$swing12,		ogre_swing13 ] {ai_charge(3);};
void() ogre_swing13	=[	$swing13,		ogre_swing14 ] {ai_charge(8);};
void() ogre_swing14	=[	$swing14,		ogre_run1	] {ai_charge(9);};

void() ogre_smash1	=[	$smash1,		ogre_smash2	] {ai_charge(6);
sound_attack (self, CHAN_WEAPON, "ogre/ogsawatk.wav", 1, ATTN_NORM);
};
void() ogre_smash2	=[	$smash2,		ogre_smash3	] {ai_charge(0);};
void() ogre_smash3	=[	$smash3,		ogre_smash4	] {ai_charge(0);};
void() ogre_smash4	=[	$smash4,		ogre_smash5	] {ai_charge(1);};
void() ogre_smash5	=[	$smash5,		ogre_smash6	] {ai_charge(4);};
void() ogre_smash6	=[	$smash6,		ogre_smash7	] {ai_charge(4); chainsaw(0);};
void() ogre_smash7	=[	$smash7,		ogre_smash8	] {ai_charge(4); chainsaw(0);};
void() ogre_smash8	=[	$smash8,		ogre_smash9	] {ai_charge(10); chainsaw(0);};
void() ogre_smash9	=[	$smash9,		ogre_smash10 ] {ai_charge(13); chainsaw(0);};
void() ogre_smash10	=[	$smash10,		ogre_smash11 ] {chainsaw(1);};
void() ogre_smash11	=[	$smash11,		ogre_smash12 ] {ai_charge(2); chainsaw(0);
// self.nextthink = self.nextthink + random()*0.2;};	// slight variation
self.nextthink = time + 0.1 + random()*0.2;};	// 1998-08-14 Incorrect setting of nextthink fix by Maddes/Lord Sméagol
void() ogre_smash12	=[	$smash12,		ogre_smash13 ] {ai_charge(0);};
void() ogre_smash13	=[	$smash13,		ogre_smash14 ] {ai_charge(4);};
void() ogre_smash14	=[	$smash14,		ogre_run1	] {ai_charge(12);};

// Preach tutorial alternate animation frames for monster_ogre_marksman -- dumptruck_ds
.float attack_elevation;
void() ogre2_nail1   =[  $shoot1,        ogre2_nail2  ] {ai_face();
self.attack_elevation = IterateElevation(OGRE_DEFAULT_ELEVATION, self.enemy.origin);};
void() ogre2_nail2   =[  $shoot2,        ogre2_nail3  ] {ai_face();
self.attack_elevation = IterateElevation(self.attack_elevation, self.enemy.origin);};
void() ogre2_nail3   =[  $shoot2,        ogre2_nail4  ] {ai_face();
self.attack_elevation = IterateElevation(self.attack_elevation, self.enemy.origin);};
void() ogre2_nail4   =[  $shoot3,        ogre_nail5  ] {ai_face();
	PreachFireGrenade(self.attack_elevation);
};
// Preach tutorial alternate animation frames for monster_ogre_marksman -- dumptruck_ds
// these are for the turret version of monster_ogre_marksman
.float attack_elevation;
void() ogre2_turret_attack1 =[  $shoot1,        ogre2_turret_attack2  ] {ai_face();
self.attack_elevation = IterateElevation(OGRE_DEFAULT_ELEVATION, self.enemy.origin);};
void() ogre2_turret_attack2   =[  $shoot2,        ogre2_turret_attack3  ] {ai_face();
self.attack_elevation = IterateElevation(self.attack_elevation, self.enemy.origin);};
void() ogre2_turret_attack3   =[  $shoot2,        ogre2_turret_attack4  ] {ai_face();
self.attack_elevation = IterateElevation(self.attack_elevation, self.enemy.origin);};
void() ogre2_turret_attack4   =[  $shoot3,        ogre2_turret_attack5  ] {ai_face();
	PreachFireGrenade(self.attack_elevation);};
void() ogre2_turret_attack5   =[  $shoot4,        ogre2_turret_attack6  ] {ai_face();};
void() ogre2_turret_attack6   =[  $shoot5,        ogre2_turret_attack7  ] {ai_face();};
void() ogre2_turret_attack7   =[  $shoot5,        ogre2_turret_attack8  ] {ai_face();};
void() ogre2_turret_attack8   =[  $shoot6,        ogre2_turret_attack9  ] {ai_face();};
void() ogre2_turret_attack9   =[  $shoot6,        ogre2_turret_seek1  ] {ai_face();};
void() ogre2_turret_seek1	=[	$stand1,	ogre2_turret_seek2	] {ai_run(0);};
void() ogre2_turret_seek2	=[	$stand2,	ogre2_turret_seek3	] {ai_run(0);};
void() ogre2_turret_seek3	=[	$stand3,	ogre2_turret_seek4	] {ai_run(0);};
void() ogre2_turret_seek4	=[	$stand4,	ogre2_turret_seek5	] {ai_run(0);};
void() ogre2_turret_seek5	=[	$stand5,	ogre2_turret_seek6	] {
if (random() < 0.2)
	sound_idle (self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE);
	ai_run(0);
};
void() ogre2_turret_seek6	=[	$stand6,	ogre2_turret_seek7	] {ai_run(0);};
void() ogre2_turret_seek7	=[	$stand7,	ogre2_turret_seek8	] {ai_run(0);};
void() ogre2_turret_seek8	=[	$stand8,	ogre2_turret_seek9	] {ai_run(0);};
void() ogre2_turret_seek9	=[	$stand9,	ogre2_turret_seek1	] {ai_run(0);};

//end Preach -- dumptruck_ds
void() ogre_nail1	=[	$shoot1,		ogre_nail2	] {ai_face();};
void() ogre_nail2	=[	$shoot2,		ogre_nail3	] {ai_face();};
void() ogre_nail3	=[	$shoot2,		ogre_nail4	] {ai_face();};
void() ogre_nail4	=[	$shoot3,		ogre_nail5	] {ai_face();
	if (self.style == 0)
		{
			OgreFireGrenade();
		}
	if (self.style == 1)
		{
			BDW_OgreFireFlak();
			// OgreFireSpike();
		}
	else if (self.style == 2)
		{
			OgreFireSpike();
		}
		if (self.style == 3)
		{
			W_FireMultiGrenade();
		}
		if (self.style == 4) // jaycie erysdren 2021-09-14
		{
			OgreFireLavaBall();
			sound_misc2 (self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM); // used for initial attack sound dumptruck_ds
		}
};
void() ogre_nail5	=[	$shoot4,		ogre_nail6	] {ai_face();};
void() ogre_nail6	=[	$shoot5,		ogre_nail7	] {ai_face();};
void() ogre_nail7	=[	$shoot6,		ogre_run1	] {ai_face();};
//
////////////////////////
// turret frames START
////////////////////////
//
void() ogre_turret_attack1	=[	$shoot1,		ogre_turret_attack2	] {ai_face();};
void() ogre_turret_attack2	=[	$shoot2,		ogre_turret_attack3	] {ai_face();};
void() ogre_turret_attack3	=[	$shoot2,		ogre_turret_attack4	] {ai_face();};
void() ogre_turret_attack4	=[	$shoot3,		ogre_turret_attack5	] {ai_face();
	if (self.style == 0)
		{
			OgreFireGrenade();
		}
	if (self.style == 1)
		{
			BDW_OgreFireFlak();
			// OgreFireSpike();
		}
	else if (self.style == 2)
		{
			OgreFireSpike();
		}
		if (self.style == 3)
		{
			W_FireMultiGrenade();
		}
		if (self.style == 4) // jaycie erysdren 2021-09-14
		{
			OgreFireLavaBall();
			sound_misc2 (self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM); // used for initial attack sound dumptruck_ds
		}
};
void() ogre_turret_attack5	=[	$shoot4,		ogre_turret_attack6	] {ai_face();};

void() ogre_turret_attack6=[	$shoot5,	ogre_turret_attack7	] {ai_face();};
void() ogre_turret_attack7=[  $shoot5,  ogre_turret_attack8 ] {ai_face();};
void() ogre_turret_attack8=[  $shoot6,  ogre_turret_attack9 ] {ai_face();};
void() ogre_turret_attack9=[  $shoot6,  ogre_turret_seek1 ] {ai_face();};
void() ogre_turret_seek1	=[	$stand1,	ogre_turret_seek2	] {ai_run(0);};
void() ogre_turret_seek2	=[	$stand2,	ogre_turret_seek3	] {ai_run(0);};
void() ogre_turret_seek3	=[	$stand3,	ogre_turret_seek4	] {ai_run(0);};
void() ogre_turret_seek4	=[	$stand4,	ogre_turret_seek5	] {ai_run(0);};
void() ogre_turret_seek5	=[	$stand5,	ogre_turret_seek6	] {
if (random() < 0.2)
	sound_idle (self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE);
	ai_run(0);
};
void() ogre_turret_seek6	=[	$stand6,	ogre_turret_seek7	] {ai_run(0);};
void() ogre_turret_seek7	=[	$stand7,	ogre_turret_seek8	] {ai_run(0);};
void() ogre_turret_seek8	=[	$stand8,	ogre_turret_seek9	] {ai_run(0);};
void() ogre_turret_seek9	=[	$stand9,	ogre_turret_seek1	] {ai_run(0);};
////////////////////////
//turret frames END
///////////////////////
void()	ogre_pain1	=[	$pain1,		ogre_pain2	] {};
void()	ogre_pain2	=[	$pain2,		ogre_pain3	] {};
void()	ogre_pain3	=[	$pain3,		ogre_pain4	] {};
void()	ogre_pain4	=[	$pain4,		ogre_pain5	] {};
void()	ogre_pain5	=[	$pain5,		ogre_run1	] {};


void()	ogre_painb1	=[	$painb1,	ogre_painb2	] {};
void()	ogre_painb2	=[	$painb2,	ogre_painb3	] {};
void()	ogre_painb3	=[	$painb3,	ogre_run1	] {};


void()	ogre_painc1	=[	$painc1,	ogre_painc2	] {};
void()	ogre_painc2	=[	$painc2,	ogre_painc3	] {};
void()	ogre_painc3	=[	$painc3,	ogre_painc4	] {};
void()	ogre_painc4	=[	$painc4,	ogre_painc5	] {};
void()	ogre_painc5	=[	$painc5,	ogre_painc6	] {};
void()	ogre_painc6	=[	$painc6,	ogre_run1	] {};


void()	ogre_paind1	=[	$paind1,	ogre_paind2	] {};
void()	ogre_paind2	=[	$paind2,	ogre_paind3	] {ai_pain(10);};
void()	ogre_paind3	=[	$paind3,	ogre_paind4	] {ai_pain(9);};
void()	ogre_paind4	=[	$paind4,	ogre_paind5	] {ai_pain(4);};
void()	ogre_paind5	=[	$paind5,	ogre_paind6	] {};
void()	ogre_paind6	=[	$paind6,	ogre_paind7	] {};
void()	ogre_paind7	=[	$paind7,	ogre_paind8	] {};
void()	ogre_paind8	=[	$paind8,	ogre_paind9	] {};
void()	ogre_paind9	=[	$paind9,	ogre_paind10	] {};
void()	ogre_paind10=[	$paind10,	ogre_paind11	] {};
void()	ogre_paind11=[	$paind11,	ogre_paind12	] {};
void()	ogre_paind12=[	$paind12,	ogre_paind13	] {};
void()	ogre_paind13=[	$paind13,	ogre_paind14	] {};
void()	ogre_paind14=[	$paind14,	ogre_paind15	] {};
void()	ogre_paind15=[	$paind15,	ogre_paind16	] {};
void()	ogre_paind16=[	$paind16,	ogre_run1	] {};

void()	ogre_paine1	=[	$paine1,	ogre_paine2	] {};
void()	ogre_paine2	=[	$paine2,	ogre_paine3	] {ai_pain(10);};
void()	ogre_paine3	=[	$paine3,	ogre_paine4	] {ai_pain(9);};
void()	ogre_paine4	=[	$paine4,	ogre_paine5	] {ai_pain(4);};
void()	ogre_paine5	=[	$paine5,	ogre_paine6	] {};
void()	ogre_paine6	=[	$paine6,	ogre_paine7	] {};
void()	ogre_paine7	=[	$paine7,	ogre_paine8	] {};
void()	ogre_paine8	=[	$paine8,	ogre_paine9	] {};
void()	ogre_paine9	=[	$paine9,	ogre_paine10	] {};
void()	ogre_paine10=[	$paine10,	ogre_paine11	] {};
void()	ogre_paine11=[	$paine11,	ogre_paine12	] {};
void()	ogre_paine12=[	$paine12,	ogre_paine13	] {};
void()	ogre_paine13=[	$paine13,	ogre_paine14	] {};
void()	ogre_paine14=[	$paine14,	ogre_paine15	] {};
void()	ogre_paine15=[	$paine15,	ogre_run1	] {};


void(entity attacker, float damage)	ogre_pain =
{
	local float	r;

// don't make multiple pain sounds right after each other
	if (self.pain_finished > time)
		return;

	if (self.spawnflags & I_AM_TURRET)
		return;

	sound_pain (self, CHAN_VOICE, "ogre/ogpain1.wav", 1, ATTN_NORM);

	r = random();

	if (r < 0.25)
	{
		ogre_pain1 ();
		self.pain_finished = time + 1;
	}
	else if (r < 0.5)
	{
		ogre_painb1 ();
		self.pain_finished = time + 1;
	}
	else if (r < 0.75)
	{
		ogre_painc1 ();
		self.pain_finished = time + 1;
	}
	else if (r < 0.88)
	{
		ogre_paind1 ();
		self.pain_finished = time + 2;
	}
	else
	{
		ogre_paine1 ();
		self.pain_finished = time + 2;
	}
};

void()	ogre_die1	=[	$death1,	ogre_die2	] {};
void()	ogre_die2	=[	$death2,	ogre_die3	] {};
void()	ogre_die3	=[	$death3,	ogre_die4	]
{self.solid = SOLID_NOT;
	// style ammotype check -- dumptruck_ds
		if (self.style == 1) // flak style
		{
			self.ammo_nails = 5;
		}
		if (self.style == 2) // super nail style
		{
			self.ammo_nails = 5;
		}
		if (self.style == 3) //DOE multi-grenade
		{
			self.ammo_rockets = 2;
		}
		else if (self.style == 0) //default Ogre
		{
			self.ammo_rockets = 2;
		}
if(!self.keep_ammo)DropBackpack();};
void()	ogre_die4	=[	$death4,	ogre_die5	] {};
void()	ogre_die5	=[	$death5,	ogre_die6	] {};
void()	ogre_die6	=[	$death6,	ogre_die7	] {};
void()	ogre_die7	=[	$death7,	ogre_die8	] {};
void()	ogre_die8	=[	$death8,	ogre_die9	] {};
void()	ogre_die9	=[	$death9,	ogre_die10	] {};
void()	ogre_die10	=[	$death10,	ogre_die11	] {};
void()	ogre_die11	=[	$death11,	ogre_die12	] {};
void()	ogre_die12	=[	$death12,	ogre_die13	] {};
void()	ogre_die13	=[	$death13,	ogre_die14	] {};
void()	ogre_die14	=[	$death14,	ogre_die14	] {};

void()	ogre_bdie1	=[	$bdeath1,	ogre_bdie2	] {};
void()	ogre_bdie2	=[	$bdeath2,	ogre_bdie3	] {ai_forward(5);};
void()	ogre_bdie3	=[	$bdeath3,	ogre_bdie4	]
{self.solid = SOLID_NOT;
	// style ammotype check -- dumptruck_ds
		if (self.style == 1)
		{
			self.ammo_nails = 5;
		}
		if (self.style == 2)
		{
			self.ammo_nails = 5;
		}
		if (self.style == 3) //DOE multi-grenade
		{
			self.ammo_rockets = 2;
		}
		if (self.style == 4) // lavaball ogre jaycie erysdren 2021-09-14
		{
			self.ammo_rockets = 2;
		}
		else if (self.style == 0)
		{
			self.ammo_rockets = 2;
		}
if(!self.keep_ammo)DropBackpack();};
void()	ogre_bdie4	=[	$bdeath4,	ogre_bdie5	] {ai_forward(1);};
void()	ogre_bdie5	=[	$bdeath5,	ogre_bdie6	] {ai_forward(3);};
void()	ogre_bdie6	=[	$bdeath6,	ogre_bdie7	] {ai_forward(7);};
void()	ogre_bdie7	=[	$bdeath7,	ogre_bdie8	] {ai_forward(25);};
void()	ogre_bdie8	=[	$bdeath8,	ogre_bdie9	] {};
void()	ogre_bdie9	=[	$bdeath9,	ogre_bdie10	] {};
void()	ogre_bdie10	=[	$bdeath10,	ogre_bdie10	] {};

void() ogre_die =
{
// check for gib
	if (self.health < -80)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		if (self.mdl_head != "") //dumptruck_ds custom_mdls
		{
			ThrowHead (self.mdl_head, self.health);
		}
		else
		{
			ThrowHead ("progs/h_ogre.mdl", self.health);
		}
		// ThrowGib ("progs/gib3.mdl", self.health);
		// ThrowGib ("progs/gib3.mdl", self.health);
		// ThrowGib ("progs/gib3.mdl", self.health);
		if (self.mdl_gib1 != "") // custom models -- dumptruck_ds
		{
			ThrowGib (self.mdl_gib1, self.health);
		}
		else
		{
			ThrowGib ("progs/gib3.mdl", self.health);
		}
		if (self.mdl_gib2 != "")
		{
			ThrowGib (self.mdl_gib2, self.health);
		}
		else
		{
			ThrowGib ("progs/gib3.mdl", self.health);
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

	sound_death (self, CHAN_VOICE, "ogre/ogdth.wav", 1, ATTN_NORM);

	DropStuff();
	if (random() < 0.5)
		ogre_die1 ();
	else
		ogre_bdie1 ();
};

void() ogre_melee =
{
	if (random() > 0.5)
		ogre_smash1 ();
	else
		ogre_swing1 ();
};


/*QUAKED monster_ogre (1 0 0) (-32 -32 -24) (32 32 64) AMBUSH X X TRIGGER_SPAWNED X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ("progs/ogre.mdl");
}
Ogre.

Default health = 200"

style(Choices) : "Attack type" =
0 : "Default (grenade)"
1 : "Flak Ogre (Marcher, Quoth)"
2 : "sniper (shoots single, deadly lava round)"
3 : "multi-grenade (Mission Pack 2)"

keep_ammo(integer) : "1 = Don't drop backpack upon death"
snd_death(string) : "Path to custom death sound"
snd_pain(string) : "Path to custom pain sound"
snd_sight(string) : "Path to custom sight sound"
snd_attack(string) : "Path to custom attack sound (CHAINSAW)"
snd_idle(string) : "Path to custom idle sound (IDLE)"
snd_misc(string) : "Path to custom sound (IDLE CHAINSAW DRAG)"
snd_misc1(string) : "Path to custom sound (ATTACK GRUNT)"

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

*/
void() monster_ogre =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (deathmatch)
	{
		remove(self);
		return;
	}
	// custom_mdls dumptruck_ds
	precache_body_model ("progs/ogre.mdl");
	precache_head_model ("progs/h_ogre.mdl");
	precache_proj_model ("progs/grenade.mdl");

	// custom_mdls dumptruck_ds
	precache_model ("progs/mervup.mdl"); //for style 3 Orge dumptruck_ds
	precache_model ("progs/lspike.mdl"); //for style 2 Ogre dumptruck_ds
	precache_sound_misc ("ogre/ogdrag.wav");
	precache_sound_death ("ogre/ogdth.wav");
	precache_sound_idle ("ogre/ogidle.wav");
	precache_sound_misc1 ("ogre/ogidle2.wav");
	precache_sound_pain ("ogre/ogpain1.wav");
	precache_sound_attack ("ogre/ogsawatk.wav");
	precache_sound_sight ("ogre/ogwake.wav");
	precache_sound_misc2 ("shalrath/attack2.wav");
	precache_sound ("fish/bite.wav");
	precache_sound ("boss1/throw.wav"); // jaycie erysdren 2021-09-14

	precache_gib1 ("progs/gib1.mdl");
	precache_gib2 ("progs/gib2.mdl");
	precache_gib3 ("progs/gib3.mdl");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	// custom_mdls dumptruck_ds
	body_model ("progs/ogre.mdl");
	// setmodel (self, "progs/ogre.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (!self.proj_speed_mod)
	{
		self.proj_speed_mod = 1;
	}
	if (!self.health) //thanks RennyC -- dumptruck_ds
	self.health = 200;

	self.th_stand = ogre_stand1;
	self.th_walk = ogre_walk1;
	if (self.spawnflags & I_AM_TURRET)
	{
	  self.th_run = ogre_turret_seek1;
	}
	else
	{
		self.th_run = ogre_run1;
	}
	self.th_die = ogre_die;
	self.th_melee = ogre_melee;
	self.th_missile = ogre_nail1;
	self.th_turret = ogre_turret_attack1; //dumptruck_ds
	if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
	self.th_pain = ogre_pain;
	else
	self.th_pain = SUB_NullPain;

	walkmonster_start();
};

/*QUAKED monster_ogre_marksman (1 0 0) (-32 -32 -24) (32 32 64) AMBUSH X X TRIGGER_SPAWNED X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
model ({ "path" : "progs/ogre.mdl",	"frame": 63 });
}
Ogre Marksman.
Unlike vanilla Quake, this is a slightly more accurate Orge.

keep_ammo(integer) : "1 = Don't drop backpack upon death"
snd_death(string) : "Path to custom death sound"
snd_pain(string) : "Path to custom pain sound"
snd_sight(string) : "Path to custom sight sound"
snd_attack(string) : "Path to custom attack sound (CHAINSAW)"
snd_idle(string) : "Path to custom idle sound (IDLE)"
snd_misc(string) : "Path to custom sound (IDLE CHAINSAW DRAG)"
snd_misc1(string) : "Path to custom sound (ATTACK GRUNT)"

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

*/
void() monster_ogre_marksman =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (deathmatch)
	{
		remove(self);
		return;
	}
	// custom_mdls dumptruck_ds
	precache_body_model ("progs/ogre.mdl");
	precache_head_model ("progs/h_ogre.mdl");
	precache_proj_model ("progs/grenade.mdl");

	precache_sound_misc ("ogre/ogdrag.wav");
	precache_sound_death ("ogre/ogdth.wav");
	precache_sound_idle ("ogre/ogidle.wav");
	precache_sound_misc1 ("ogre/ogidle2.wav");
	precache_sound_pain ("ogre/ogpain1.wav");
	precache_sound_attack ("ogre/ogsawatk.wav");
	precache_sound_sight ("ogre/ogwake.wav");

	precache_gib1 ("progs/gib1.mdl");
	precache_gib2 ("progs/gib2.mdl");
	precache_gib3 ("progs/gib3.mdl");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	// custom_mdls dumptruck_ds
	body_model ("progs/ogre.mdl");
	// setmodel (self, "progs/ogre.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (!self.proj_speed_mod)
	{
		self.proj_speed_mod = 1;
	}
	if (!self.health) //thanks RennyC -- dumptruck_ds
	self.health = 200;

	self.th_stand = ogre_stand1;
	self.th_walk = ogre_walk1;
	if (self.spawnflags & I_AM_TURRET)
	{
	  self.th_run = ogre2_turret_seek1;
	}
	else
	{
		self.th_run = ogre_run1;
	}
	self.th_die = ogre_die;
	self.th_melee = ogre_melee;
	self.th_missile = ogre2_nail1;
	self.th_turret = ogre2_turret_attack1; //dumptruck_ds
	if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
	self.th_pain = ogre_pain;
	else
	self.th_pain = SUB_NullPain;

	walkmonster_start();
};

// {
// 	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
// 		return;
//
// 	monster_ogre ();
// };

/* Scenic Dead Monster Patch stuff here from DeadStuff mod -- dumptruck_ds */

/*QUAKED monster_dead_ogre (0 0.5 0.8) (-32 -32 -24) (32 32 64) SOLID ON_SIDE X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ({"path":"progs/ogre.mdl","frame":135});
}
*/
void() monster_dead_ogre =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/ogre.mdl");
	setmodel(self, "progs/ogre.mdl");
	if (self.spawnflags & 2)
	{
		self.frame = $death14;

		if (self.spawnflags & 1)
		{
			self.solid = SOLID_BBOX;
                	setsize(self,'-40.64 -54.06 -54.1','29.42 54.63 30');
		}
		else
		{
			self.solid = SOLID_NOT;
		}
	}
	else
	{
		self.frame = $bdeath10;
		if (self.spawnflags & 1)
		{
			self.solid = SOLID_BBOX;
                	setsize(self,'-45.64 -29.46 -54.52','33.87 39.18 30');
		}
		else
		{
			self.solid = SOLID_NOT;
		}
	}
};
