/*
==============================================================================

BOSS-ONE

==============================================================================
*/
$cd id1/models/boss1
$origin 0 0 -15
$base base
$skin skin
$scale 5

$frame rise1 rise2 rise3 rise4 rise5 rise6 rise7 rise8 rise9 rise10
$frame rise11 rise12 rise13 rise14 rise15 rise16 rise17

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14 walk15
$frame walk16 walk17 walk18 walk19 walk20 walk21 walk22
$frame walk23 walk24 walk25 walk26 walk27 walk28 walk29 walk30 walk31

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15
$frame attack16 attack17 attack18 attack19 attack20 attack21 attack22
$frame attack23

$frame shocka1 shocka2 shocka3 shocka4 shocka5 shocka6 shocka7 shocka8
$frame shocka9 shocka10

$frame shockb1 shockb2 shockb3 shockb4 shockb5 shockb6

$frame shockc1 shockc2 shockc3 shockc4 shockc5 shockc6 shockc7 shockc8
$frame shockc9 shockc10

float NO_LAVASPLASH = 2; //supress lava splash effect when raising, lowering or gibbing - dumptruck_ds

void(vector p) boss2_missile;

void() boss2_face =
{
// go for another player if multi player
	if (self.enemy.health <= 0 || random() < 0.02)
	{
		self.enemy = find(self.enemy, classname, "player");
		if (!self.enemy)
			self.enemy = find(self.enemy, classname, "player");
	}
	ai_face();
};

void() boss2_rise1	=[	$rise1, boss2_rise2 ] {
	sound_move (self, CHAN_AUTO, "boss1/out1.wav", 1, ATTN_NORM);
};
void() boss2_rise2	=[	$rise2, boss2_rise3 ] {
	sound_sight (self, CHAN_AUTO, "boss1/sight1.wav", 1, ATTN_NORM);
};
void() boss2_rise3	=[	$rise3, boss2_rise4 ] {};
void() boss2_rise4	=[	$rise4, boss2_rise5 ] {};
void() boss2_rise5	=[	$rise5, boss2_rise6 ] {};
void() boss2_rise6	=[	$rise6, boss2_rise7 ] {};
void() boss2_rise7	=[	$rise7, boss2_rise8 ] {};
void() boss2_rise8	=[	$rise8, boss2_rise9 ] {};
void() boss2_rise9	=[	$rise9, boss2_rise10 ] {};
void() boss2_rise10	=[	$rise10, boss2_rise11 ] {};
void() boss2_rise11	=[	$rise11, boss2_rise12 ] {};
void() boss2_rise12	=[	$rise12, boss2_rise13 ] {};
void() boss2_rise13	=[	$rise13, boss2_rise14 ] {};
void() boss2_rise14	=[	$rise14, boss2_rise15 ] {};
void() boss2_rise15	=[	$rise15, boss2_rise16 ] {};
void() boss2_rise16	=[	$rise16, boss2_rise17 ] {};
void() boss2_rise17	=[	$rise17, boss2_missile1 ] {};

void() boss2_idle1	=[	$walk1, boss2_idle2 ]
{
// look for other players
};
void() boss2_idle2	=[	$walk2, boss2_idle3 ] {boss2_face();};
void() boss2_idle3	=[	$walk3, boss2_idle4 ] {boss2_face();};
void() boss2_idle4	=[	$walk4, boss2_idle5 ] {boss2_face();};
void() boss2_idle5	=[	$walk5, boss2_idle6 ] {boss2_face();};
void() boss2_idle6	=[	$walk6, boss2_idle7 ] {boss2_face();};
void() boss2_idle7	=[	$walk7, boss2_idle8 ] {boss2_face();};
void() boss2_idle8	=[	$walk8, boss2_idle9 ] {boss2_face();};
void() boss2_idle9	=[	$walk9, boss2_idle10 ] {boss2_face();};
void() boss2_idle10	=[	$walk10, boss2_idle11 ] {boss2_face();};
void() boss2_idle11	=[	$walk11, boss2_idle12 ] {boss2_face();};
void() boss2_idle12	=[	$walk12, boss2_idle13 ] {boss2_face();};
void() boss2_idle13	=[	$walk13, boss2_idle14 ] {boss2_face();};
void() boss2_idle14	=[	$walk14, boss2_idle15 ] {boss2_face();};
void() boss2_idle15	=[	$walk15, boss2_idle16 ] {boss2_face();};
void() boss2_idle16	=[	$walk16, boss2_idle17 ] {boss2_face();};
void() boss2_idle17	=[	$walk17, boss2_idle18 ] {boss2_face();};
void() boss2_idle18	=[	$walk18, boss2_idle19 ] {boss2_face();};
void() boss2_idle19	=[	$walk19, boss2_idle20 ] {boss2_face();};
void() boss2_idle20	=[	$walk20, boss2_idle21 ] {boss2_face();};
void() boss2_idle21	=[	$walk21, boss2_idle22 ] {boss2_face();};
void() boss2_idle22	=[	$walk22, boss2_idle23 ] {boss2_face();};
void() boss2_idle23	=[	$walk23, boss2_idle24 ] {boss2_face();};
void() boss2_idle24	=[	$walk24, boss2_idle25 ] {boss2_face();};
void() boss2_idle25	=[	$walk25, boss2_idle26 ] {boss2_face();};
void() boss2_idle26	=[	$walk26, boss2_idle27 ] {boss2_face();};
void() boss2_idle27	=[	$walk27, boss2_idle28 ] {boss2_face();};
void() boss2_idle28	=[	$walk28, boss2_idle29 ] {boss2_face();};
void() boss2_idle29	=[	$walk29, boss2_idle30 ] {boss2_face();};
void() boss2_idle30	=[	$walk30, boss2_idle31 ] {boss2_face();};
void() boss2_idle31	=[	$walk31, boss2_idle1 ] {boss2_face();};

void() boss2_missile1	=[	$attack1, boss2_missile2 ] {boss2_face();};
void() boss2_missile2	=[	$attack2, boss2_missile3 ] {boss2_face();};
void() boss2_missile3	=[	$attack3, boss2_missile4 ] {boss2_face();};
void() boss2_missile4	=[	$attack4, boss2_missile5 ] {boss2_face();};
void() boss2_missile5	=[	$attack5, boss2_missile6 ] {boss2_face();};
void() boss2_missile6	=[	$attack6, boss2_missile7 ] {boss2_face();};
void() boss2_missile7	=[	$attack7, boss2_missile8 ] {boss2_face();};
void() boss2_missile8	=[	$attack8, boss2_missile9 ] {boss2_face();};
void() boss2_missile9	=[	$attack9, boss2_missile10 ] {boss2_missile('100 100 200');};
void() boss2_missile10	=[	$attack10, boss2_missile11 ] {boss2_face();};
void() boss2_missile11	=[	$attack11, boss2_missile12 ] {boss2_face();};
void() boss2_missile12	=[	$attack12, boss2_missile13 ] {boss2_face();};
void() boss2_missile13	=[	$attack13, boss2_missile14 ] {boss2_face();};
void() boss2_missile14	=[	$attack14, boss2_missile15 ] {boss2_face();};
void() boss2_missile15	=[	$attack15, boss2_missile16 ] {boss2_face();};
void() boss2_missile16	=[	$attack16, boss2_missile17 ] {boss2_face();};
void() boss2_missile17	=[	$attack17, boss2_missile18 ] {boss2_face();};
void() boss2_missile18	=[	$attack18, boss2_missile19 ] {boss2_face();};
void() boss2_missile19	=[	$attack19, boss2_missile20 ] {boss2_face();};
void() boss2_missile20	=[	$attack20, boss2_missile21 ] {boss2_missile('100 -100 200');};
void() boss2_missile21	=[	$attack21, boss2_missile22 ] {boss2_face();};
void() boss2_missile22	=[	$attack22, boss2_missile23 ] {boss2_face();};
void() boss2_missile23	=[	$attack23, boss2_missile1 ] {boss2_face();};

void() boss2_shocka1 =[	$shocka1, boss2_shocka2 ] {};
void() boss2_shocka2 =[	$shocka2, boss2_shocka3 ] {};
void() boss2_shocka3 =[	$shocka3, boss2_shocka4 ] {};
void() boss2_shocka4 =[	$shocka4, boss2_shocka5 ] {};
void() boss2_shocka5 =[	$shocka5, boss2_shocka6 ] {};
void() boss2_shocka6 =[	$shocka6, boss2_shocka7 ] {};
void() boss2_shocka7 =[	$shocka7, boss2_shocka8 ] {};
void() boss2_shocka8 =[	$shocka8, boss2_shocka9 ] {};
void() boss2_shocka9 =[	$shocka9, boss2_shocka10 ] {};
void() boss2_shocka10 =[	$shocka10, boss2_missile1 ] {};

void() boss2_shockb1 =[	$shockb1, boss2_shockb2 ] {};
void() boss2_shockb2 =[	$shockb2, boss2_shockb3 ] {};
void() boss2_shockb3 =[	$shockb3, boss2_shockb4 ] {};
void() boss2_shockb4 =[	$shockb4, boss2_shockb5 ] {};
void() boss2_shockb5 =[	$shockb5, boss2_shockb6 ] {};
void() boss2_shockb6 =[	$shockb6, boss2_shockb7 ] {};
void() boss2_shockb7 =[	$shockb1, boss2_shockb8 ] {};
void() boss2_shockb8 =[	$shockb2, boss2_shockb9 ] {};
void() boss2_shockb9 =[	$shockb3, boss2_shockb10 ] {};
void() boss2_shockb10 =[	$shockb4, boss2_missile1 ] {};

void() boss2_shockc1 =[	$shockc1, boss2_shockc2 ] {};
void() boss2_shockc2 =[	$shockc2, boss2_shockc3 ] {};
void() boss2_shockc3 =[	$shockc3, boss2_shockc4 ] {};
void() boss2_shockc4 =[	$shockc4, boss2_shockc5 ] {};
void() boss2_shockc5 =[	$shockc5, boss2_shockc6 ] {};
void() boss2_shockc6 =[	$shockc6, boss2_shockc7 ] {};
void() boss2_shockc7 =[	$shockc7, boss2_shockc8 ] {};
void() boss2_shockc8 =[	$shockc8, boss2_shockc9 ] {};
void() boss2_shockc9 =[	$shockc9, boss2_shockc10 ] {};
void() boss2_shockc10 =[	$shockc10, boss2_death1 ] {};

void() boss2_pain1 =[ $shocka1, boss2_pain2 ] {};
void() boss2_pain2 =[ $shocka2, boss2_pain3 ] {};
void() boss2_pain3 =[ $shocka3, boss2_pain4 ] {};
void() boss2_pain4 =[ $shocka4, boss2_pain5 ] {
	sound_pain (self, CHAN_VOICE, "boss1/pain.wav", 1, ATTN_NORM); // pain noise
};
void() boss2_pain5 =[ $shocka5, boss2_pain6 ] {};
void() boss2_pain6 =[ $shocka6, bos2s_pain7 ] {};
void() bos2s_pain7 =[ $shocka7, boss2_pain8 ] {};
void() boss2_pain8 =[ $shocka8, boss2_pain9 ] {};
void() boss2_pain9 =[ $shocka9, boss2_missile1 ] {}; // auto shoot a lavaball


void() GibBoss2 =
{
	sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	// throw tons of meat chunks

	local vector boss;
	local float x, y, z;
	local float r;
	// local entity n;

	boss = self.origin;
	z = 16;
	while (z <= 144)
	{
		x = -64;
		while (x <= 64)
		{
			y = -64;
			while (y <= 64)
			{
				self.origin_x = boss_x + x;
				self.origin_y = boss_y + y;
				self.origin_z = boss_z + z;

				r = random();
				if (r < 0.3)
					// ThrowGib ("progs/gib1.mdl", -120);
					if (self.mdl_gib1 != "") // custom models -- dumptruck_ds
					{
						ThrowGib (self.mdl_gib1, -120);
					}
					else
					{
						ThrowGib ("progs/gib1.mdl", -120);
					}
				else if (r < 0.5)
					// ThrowGib ("progs/gib2.mdl", -120);
					if (self.mdl_gib2 != "") // custom models -- dumptruck_ds
					{
						ThrowGib (self.mdl_gib2, -120);
					}
					else
					{
						ThrowGib ("progs/gib2.mdl", -120);
					}
				else if (r < 0.7)
					ThrowGib ("progs/lavaball.mdl", -120);
				else
					// ThrowGib ("progs/gib3.mdl", -120);
					if (self.mdl_gib3 != "") // custom models -- dumptruck_ds
					{
						ThrowGib (self.mdl_gib3, -120);
					}
					else
					{
						ThrowGib ("progs/gib3.mdl", -120);
					}
				y = y + 32;
			}
			x = x + 32;
		}
		z = z + 96;
	}

	local entity head;

	head = spawn();
	head.origin = self.origin + '0 0 128';
	head.velocity_z = 600; + (random() * 200);
	head.velocity_x = -300 + (random() * 600);
	head.velocity_y = -200 + (random() * 600);
	head.avelocity_x = random()*120;
	head.avelocity_y = random()*120;
	head.avelocity_z = random()*120;
	head.flags = self.flags - (self.flags & FL_ONGROUND);
	head.solid = SOLID_NOT;
	head.movetype = MOVETYPE_BOUNCE;
	head.takedamage = DAMAGE_NO;
	if (self.mdl_head != "") // dumptruck_ds custom_mdls
	{
			setmodel (head, self.mdl_head);
		}
		else
		{
			setmodel (head, "progs/h_boss.mdl");
	}

	if (!self.skin_head) // dumptruck_ds
	{
			head.skin = self.skin_proj;
		}
		else
		{
			head.skin = 0;
	}
	setsize (head, '-67 -60 -6', '62 52 88');
	// setsize (head, '-16 -16 0', '16 16 56');
	head.touch = SUB_Null;
	head.think = SUB_Remove;
	head.nextthink = time + 120;
	if !(self.spawnflags & NO_LAVASPLASH)
	{
		// killed_monsters = killed_monsters + 1; //already done in combat.qc since this is now FL_MONSTER
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
		// WriteByte (MSG_ALL, SVC_KILLEDMONSTER); //already done in combat.qc since this is now FL_MONSTER -- dumptruck_ds
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
	remove (self);
};

void() boss2_die =
{
	if (self.health < -50) // if health under -15
	{
		GibBoss2 ();
		return;
	}
	else // otherwise
	{
		boss2_death1 (); // normal death
		return;
	}
};

void() boss2_death1 = [$death1, boss2_death2] {
	sound_death (self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM);
};
void() boss2_death2 = [$death2, boss2_death3] {};
void() boss2_death3 = [$death3, boss2_death4] {};
void() boss2_death4 = [$death4, boss2_death5] {};
void() boss2_death5 = [$death5, boss2_death6] {};
void() boss2_death6 = [$death6, boss2_death7] {};
void() boss2_death7 = [$death7, boss2_death8] {};
void() boss2_death8 = [$death8, boss2_death9] {};
void() boss2_death9 = [$death9, boss2_death10]
{
	sound_move (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
	if !(self.spawnflags & NO_LAVASPLASH)
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
};

void(entity attacker, float damage) boss2_pain_go =
{
	if (self.pain_finished > time)
		return;

	boss2_pain1();
	self.pain_finished = time + 4;
};

void() boss2_death10 = [$death9, boss2_death10]
{
// unlike the code for the original monster_boss, this function doesn't
// need to increment killed_monsters or call SUB_UseTargets(); this
// entity gets killed by regular damage and has FL_MONSTER, so the
// Killed() function (in combat.qc) will already have taken care of
// those things -- iw

	remove (self);
};

void(vector p) boss2_missile =
{
	local	vector	offang;
	local	vector	org, vec, d;
	local	float	t;

	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);

	org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';

// lead the player on hard mode
	if (skill > 1)
	{
		t = vlen(self.enemy.origin - org) / 300;
		vec = self.enemy.velocity;
		vec_z = 0;
		d = self.enemy.origin + t * vec;
	}
	else
	{
		d = self.enemy.origin;
	}

	vec = normalize (d - org);

	launch_spike2 (org, vec, 300);
	// setmodel (newmis, "progs/lavaball.mdl");
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

	newmis.avelocity = '200 100 300';
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.touch = T_MissileTouch; // rocket explosion
	sound_attack (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);

// check for dead enemy
	if (self.enemy.health <= 0)
		boss2_idle1 ();
};


void() boss2_awake =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.takedamage = DAMAGE_AIM;

	body_model ("progs/boss.mdl");
	// setmodel (self, "progs/boss.mdl");
	setsize (self, '-128 -128 -24', '128 128 256');

	if (!self.health)
	{
		if (skill == 0)
			self.health = 1000;
		else
			self.health = 3000;
	}

// note that self.th_run has to be set in order to avoid a "NULL
// function" Host_Error in the case where T_Damage() calls
// FoundTarget(), which calls HuntTarget(), which uses self.th_run as
// the next self.think -- iw
	self.th_run = boss2_missile1;

	self.th_pain = boss2_pain_go;
	self.th_die = boss2_die;

// give the boss a couple of seconds to finish rising before allowing it
// to go into its pain animation -- iw
	self.pain_finished = time + 2;

	self.enemy = activator;

	if !(self.spawnflags & NO_LAVASPLASH)
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	self.yaw_speed = 20;
	boss2_rise1 ();
};


/*QUAKED monster_boss2 (1 0 0) (-128 -128 -24) (128 128 256)
*/
void() monster_boss2 =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (self.spawnflags & I_AM_TURRET)
		objerror("Incompatible spawnflag: TURRET_MODE\n");

	if (deathmatch)
	{
		remove(self);
		return;
	} //custom sounds and models -- dumptruck_ds
	precache_body_model ("progs/boss.mdl");
	precache_head_model ("progs/h_boss.mdl");
	precache_model ("progs/lavaball.mdl");
	// precache_model ("progs/boss.mdl");
	precache_model ("progs/h_boss.mdl");

	precache_sound ("weapons/rocket1i.wav");
	precache_sound_move ("boss1/out1.wav");
	precache_sound_sight ("boss1/sight1.wav");
	precache_sound ("misc/power.wav");
	precache_sound_attack ("boss1/throw.wav");
	precache_sound_pain ("boss1/pain.wav");
	precache_sound_death ("boss1/death.wav");

	precache_gib1 ("progs/gib1.mdl");
	precache_gib2 ("progs/gib2.mdl");
	precache_gib3 ("progs/gib3.mdl");

	total_monsters = total_monsters + 1;
	self.flags = FL_MONSTER;
	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten
	self.use = boss2_awake;
};
