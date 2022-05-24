/*
==============================================================================

OLD ONE 2 - killable variant -- dumptruck_ds

==============================================================================
*/
$cd id1/models/old2_one
$origin 0 0 24
$base base
$skin skin
$scale 1

$frame old1 old2 old3 old4 old5 old6 old7 old8 old9
$frame old10 old11 old12 old13 old14 old15 old16 old17 old18 old19
$frame old20 old21 old22 old23 old24 old25 old26 old27 old28 old29
$frame old30 old31 old32 old33 old34 old35 old36 old37 old38 old39
$frame old40 old41 old42 old43 old44 old45 old46

$frame shake1 shake2 shake3 shake4 shake5 shake6 shake7 shake8
$frame shake9 shake10 shake11 shake12 shake13 shake14
$frame shake15 shake16 shake17 shake18 shake19 shake20

void() shub_face =
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


void() old2_stand =
{
	FindTarget ();
};

void() old2_idle1        =[      $old1,  old2_idle2       ] {old2_stand();};
void() old2_idle2        =[      $old2,  old2_idle3       ] {old2_stand();};
void() old2_idle3        =[      $old3,  old2_idle4       ] {old2_stand();};
void() old2_idle4        =[      $old4,  old2_idle5       ] {old2_stand();};
void() old2_idle5        =[      $old5,  old2_idle6       ] {old2_stand();};
void() old2_idle6        =[      $old6,  old2_idle7       ] {old2_stand();};
void() old2_idle7        =[      $old7,  old2_idle8       ] {old2_stand();};
void() old2_idle8        =[      $old8,  old2_idle9       ] {old2_stand();};
void() old2_idle9        =[      $old9,  old2_idle10      ] {old2_stand();};
void() old2_idle10       =[      $old10, old2_idle11      ] {old2_stand();};
void() old2_idle11       =[      $old11, old2_idle12      ] {old2_stand();};
void() old2_idle12       =[      $old12, old2_idle13      ] {old2_stand();};
void() old2_idle13       =[      $old13, old2_idle14      ] {old2_stand();};
void() old2_idle14       =[      $old14, old2_idle15      ] {old2_stand();};
void() old2_idle15       =[      $old15, old2_idle16      ] {old2_stand();};
void() old2_idle16       =[      $old16, old2_idle17      ] {old2_stand();};
void() old2_idle17       =[      $old17, old2_idle18      ] {old2_stand();};
void() old2_idle18       =[      $old18, old2_idle19      ] {old2_stand();};
void() old2_idle19       =[      $old19, old2_idle20      ] {old2_stand();};
void() old2_idle20       =[      $old20, old2_idle21      ] {old2_stand();};
void() old2_idle21       =[      $old21, old2_idle22      ] {old2_stand();};
void() old2_idle22       =[      $old22, old2_idle23      ] {old2_stand();};
void() old2_idle23       =[      $old23, old2_idle24      ] {old2_stand();};
void() old2_idle24       =[      $old24, old2_idle25      ] {old2_stand();};
void() old2_idle25       =[      $old25, old2_idle26      ] {old2_stand();};
void() old2_idle26       =[      $old26, old2_idle27      ] {old2_stand();};
void() old2_idle27       =[      $old27, old2_idle28      ] {old2_stand();};
void() old2_idle28       =[      $old28, old2_idle29      ] {old2_stand();};
void() old2_idle29       =[      $old29, old2_idle30      ] {old2_stand();};
void() old2_idle30       =[      $old30, old2_idle31      ] {old2_stand();};
void() old2_idle31       =[      $old31, old2_idle32      ] {old2_stand();};
void() old2_idle32       =[      $old32, old2_idle33      ] {old2_stand();};
void() old2_idle33       =[      $old33, old2_idle34      ] {old2_stand();};
void() old2_idle34       =[      $old34, old2_idle35      ] {old2_stand();};
void() old2_idle35       =[      $old35, old2_idle36      ] {old2_stand();};
void() old2_idle36       =[      $old36, old2_idle37      ] {old2_stand();};
void() old2_idle37       =[      $old37, old2_idle38      ] {old2_stand();};
void() old2_idle38       =[      $old38, old2_idle39      ] {old2_stand();};
void() old2_idle39       =[      $old39, old2_idle40      ] {old2_stand();};
void() old2_idle40       =[      $old40, old2_idle41      ] {old2_stand();};
void() old2_idle41       =[      $old41, old2_idle42      ] {old2_stand();};
void() old2_idle42       =[      $old42, old2_idle43      ] {old2_stand();};
void() old2_idle43       =[      $old43, old2_idle44      ] {old2_stand();};
void() old2_idle44       =[      $old44, old2_idle45      ] {old2_stand();};
void() old2_idle45       =[      $old45, old2_idle46      ] {old2_stand();};
void() old2_idle46       =[      $old46, old2_idle1       ] {old2_stand();};

void(vector p) shub_missile =
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

	local entity puff; // added this to motivate fireballs dumptruck_ds

	puff = spawn ();

	setmodel (puff, "progs/s_explod.spr");
	puff.origin = (org);
	puff.think = s_explode1;
	puff.nextthink = time;

	launch_spike2 (org, vec, 300); // lavaball in your face!
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

	// setmodel (newmis, "progs/lavaball.mdl");
	newmis.avelocity = '200 100 300';
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.touch = T_MissileTouch; // rocket explosion
	sound_attack (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);

// check for dead enemy
	if (self.enemy.health <= 0)
		old2_idle1 ();
};

void() old2_attk1        =[      $old1,  old2_attk2       ] {shub_face();};
void() old2_attk2        =[      $old2,  old2_attk3       ] {shub_face();};
void() old2_attk3        =[      $old3,  old2_attk4       ] {shub_face();};
void() old2_attk4        =[      $old4,  old2_attk5       ] {shub_face();};
void() old2_attk5        =[      $old5,  old2_attk6       ] {shub_face();};
void() old2_attk6        =[      $old6,  old2_attk7       ] {shub_face();};
void() old2_attk7        =[      $old7,  old2_attk8       ] {shub_face();};
void() old2_attk8        =[      $old8,  old2_attk9       ] {shub_face();};
void() old2_attk9        =[      $old9,  old2_attk10      ] {shub_missile('0 -16 416');};
void() old2_attk10       =[      $old10, old2_attk11      ] {shub_face();};
void() old2_attk11       =[      $old11, old2_attk12      ] {shub_face();};
void() old2_attk12       =[      $old12, old2_attk13      ] {shub_face();};
void() old2_attk13       =[      $old13, old2_attk14      ] {shub_face();};
void() old2_attk14       =[      $old14, old2_attk15      ] {shub_face();};
void() old2_attk15       =[      $old15, old2_attk16      ] {shub_face();};
void() old2_attk16       =[      $old16, old2_attk17      ] {shub_face();};
void() old2_attk17       =[      $old17, old2_attk18      ] {shub_face();};
void() old2_attk18       =[      $old18, old2_attk19      ] {shub_missile('0 -16 416');};
void() old2_attk19       =[      $old19, old2_attk20      ] {shub_face();};
void() old2_attk20       =[      $old20, old2_attk21      ] {shub_face();};
void() old2_attk21       =[      $old21, old2_attk22      ] {shub_face();};
void() old2_attk22       =[      $old22, old2_attk23      ] {shub_face();};
void() old2_attk23       =[      $old23, old2_attk24      ] {shub_face();};
void() old2_attk24       =[      $old24, old2_attk25      ] {shub_face();};
void() old2_attk25       =[      $old25, old2_attk26      ] {shub_face();};
void() old2_attk26       =[      $old26, old2_attk27      ] {shub_face();};
void() old2_attk27       =[      $old27, old2_attk28      ] {shub_missile('0 -16 416');};
void() old2_attk28       =[      $old28, old2_attk29      ] {shub_face();};
void() old2_attk29       =[      $old29, old2_attk30      ] {shub_face();};
void() old2_attk30       =[      $old30, old2_attk31      ] {shub_face();};
void() old2_attk31       =[      $old31, old2_attk32      ] {shub_face();};
void() old2_attk32       =[      $old32, old2_attk33      ] {shub_face();};
void() old2_attk33       =[      $old33, old2_attk34      ] {shub_face();};
void() old2_attk34       =[      $old34, old2_attk35      ] {shub_face();};
void() old2_attk35       =[      $old35, old2_attk36      ] {shub_face();};
void() old2_attk36       =[      $old36, old2_attk37      ] {shub_missile('0 -16 416');};
void() old2_attk37       =[      $old37, old2_attk38      ] {shub_face();};
void() old2_attk38       =[      $old38, old2_attk39      ] {shub_face();};
void() old2_attk39       =[      $old39, old2_attk40      ] {shub_face();};
void() old2_attk40       =[      $old40, old2_attk41      ] {shub_face();};
void() old2_attk41       =[      $old41, old2_attk42      ] {shub_face();};
void() old2_attk42       =[      $old42, old2_attk43      ] {shub_face();};
void() old2_attk43       =[      $old43, old2_attk44      ] {shub_face();};
void() old2_attk44       =[      $old44, old2_attk45      ] {shub_face();};
void() old2_attk45       =[      $old45, old2_attk46      ] {shub_missile('0 -16 416');};
void() old2_attk46       =[      $old46, old2_attk1       ] {shub_face();};
//death twitch --dumptruck_ds
void() old2_twitch1        =[      $shake1,  old2_twitch2       ] {sound_misc (self, CHAN_VOICE, "boss2/pop2.wav", 1, ATTN_NONE);};
void() old2_twitch2        =[      $shake2,  old2_twitch3       ] {};
void() old2_twitch3        =[      $shake3,  old2_twitch4       ] {};
void() old2_twitch4        =[      $shake4,  old2_twitch5       ] {};
void() old2_twitch5        =[      $shake5,  old2_twitch6       ] {};
void() old2_twitch6        =[      $shake6,  old2_twitch7       ] {};
void() old2_twitch7        =[      $shake7,  old2_twitch8       ] {};
void() old2_twitch8        =[      $shake8,  old2_twitch9       ] {};
void() old2_twitch9        =[      $shake9,  old2_twitch10      ] {};
void() old2_twitch10       =[      $shake10, old2_twitch11      ] {};
void() old2_twitch11       =[      $shake11, old2_twitch12      ] {};
void() old2_twitch12       =[      $shake12, old2_twitch13      ] {};
void() old2_twitch13       =[      $shake13, old2_twitch14      ] {};
void() old2_twitch14       =[      $shake14, old2_twitch15      ] {};
void() old2_twitch15       =[      $shake15, old2_twitch16      ] {};
void() old2_twitch16       =[      $shake16, old2_twitch17      ] {};
void() old2_twitch17       =[      $shake17, old2_twitch18      ] {};
void() old2_twitch18       =[      $shake18, old2_twitch19      ] {};
void() old2_twitch19       =[      $shake19, old2_twitch20      ] {};
void() old2_twitch20       =[      $shake20, old2_twitch21      ] {};
void() old2_twitch21       =[      $shake17, old2_twitch22      ] {};
void() old2_twitch22       =[      $shake18, old2_twitch23      ] {};
void() old2_twitch23       =[      $shake19, old2_twitch24      ] {};
void() old2_twitch24       =[      $shake20, old2_twitch25      ] {};
void() old2_twitch25       =[      $shake17, old2_twitch26      ] {};
void() old2_twitch26       =[      $shake18, old2_twitch27      ] {};
void() old2_twitch27       =[      $shake19, old2_twitch28      ] {};
void() old2_twitch28       =[      $shake20, oldone2_die        ] {};

void(entity attacker, float damage) oldone2_pain =
{
	if (self.pain_finished > time)
		return;

	sound_pain (self, CHAN_AUTO, "oldone2/pd_pop2.wav", 1, ATTN_NORM); //new pain sound
	old2_attk1();
	self.pain_finished = time + 4;
};

void() oldone2_die =
{
// 1998-07-30 Shub kill count fix by Maddes  start
	//killed_monsters = killed_monsters + 1;
	//WriteByte (MSG_ALL, SVC_KILLEDMONSTER);	// Already done by FL_MONSTER
// 1998-07-30 Shub kill count fix by Maddes  end
	// throw tons of meat chunks
	local	vector	oldo;
	local	float	x, y, z;
	local	float	r;

	oldo = self.origin + '0 0 112';

	z = 16;
	while (z <= 144)
	{
		x = -64;
		while (x <= 64)
		{
			y = -64;
			while (y <= 64)
			{
				self.origin_x = oldo_x + x;
				self.origin_y = oldo_y + y;
				self.origin_z = oldo_z + z;

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
				else if (r < 0.6)
					// ThrowGib ("progs/gib2.mdl", -120);
					if (self.mdl_gib2 != "") // custom models -- dumptruck_ds
					{
						ThrowGib (self.mdl_gib2, -120);
					}
					else
					{
						ThrowGib ("progs/gib2.mdl", -120);
					}
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
	particle (oldo, '0 0 0', 0, 255);
	particle (oldo, '128 128 128', 0, 255);
	sound_death (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);

	remove (self);
}

/*QUAKED monster_oldone2 (1 0 0) (-160 -128 -24) (160 128 256)
*/
void() monster_oldone2 =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (self.spawnflags & I_AM_TURRET)
		objerror("Incompatible spawnflag: TURRET_MODE\n");

	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_body_model2 ("progs/oldone.mdl");
	// precache_model2 ("progs/oldone.mdl");

	precache_sound2_death ("boss2/death.wav");
	// precache_sound2_idle ("boss2/idle.wav");
	precache_sound2_sight ("boss2/sight.wav");
	precache_sound2_misc ("boss2/pop2.wav");
	precache_sound2_pain ("oldone2/pd_pop2.wav");

	precache_model ("progs/lavaball.mdl");
	precache_sound ("boss1/throw.wav");

	precache_gib1 ("progs/gib1.mdl");
	precache_gib2 ("progs/gib2.mdl");
	precache_gib3 ("progs/gib3.mdl");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	body_model ("progs/oldone.mdl"); //custom_mdls dumptruck_ds
	// setmodel (self, "progs/oldone.mdl");
	setsize (self, '-160 -128 -24', '160 128 256');

	if (!self.health)
	{
		if (skill == 0)
			self.health = 1000;
		else
			self.health = 3000;
	}

	self.flags = FL_MONSTER;
	self.think = old2_idle1;
	self.nextthink = time + 0.1;
	self.takedamage = DAMAGE_AIM;
	self.th_run = old2_attk1;
	self.th_pain = oldone2_pain;
	self.th_die = old2_twitch1;
	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten

	total_monsters = total_monsters + 1;
};
