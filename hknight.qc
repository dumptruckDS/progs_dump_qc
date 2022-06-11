/*
==============================================================================

KNIGHT

==============================================================================
*/

$cd id1/models/knight2
$origin 0 0 24
$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14 walk15 walk16 walk17
$frame walk18 walk19 walk20

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame char_a1 char_a2 char_a3 char_a4 char_a5 char_a6 char_a7 char_a8
$frame char_a9 char_a10 char_a11 char_a12 char_a13 char_a14 char_a15 char_a16

$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7 magica8
$frame magica9 magica10 magica11 magica12 magica13 magica14

$frame magicb1 magicb2 magicb3 magicb4 magicb5 magicb6 magicb7 magicb8
$frame magicb9 magicb10 magicb11 magicb12 magicb13

$frame char_b1 char_b2 char_b3 char_b4 char_b5 char_b6

$frame slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9 smash10
$frame smash11

$frame w_attack1 w_attack2 w_attack3 w_attack4 w_attack5 w_attack6 w_attack7
$frame w_attack8 w_attack9 w_attack10 w_attack11 w_attack12 w_attack13 w_attack14
$frame w_attack15 w_attack16 w_attack17 w_attack18 w_attack19 w_attack20
$frame w_attack21 w_attack22

$frame magicc1 magicc2 magicc3 magicc4 magicc5 magicc6 magicc7 magicc8
$frame magicc9 magicc10 magicc11


void() hknight_char_a1;
void() hknight_run1;
void() hk_idle_sound;

void(float offset) hknight_shot =
{
	local	vector	offang;
	local	vector	org, vec;
	local float exploding = self.projexpl == 1 || (self.projexpl == 2 && offset % 2 == 0) || (self.projexpl == 3 && random()*2 < 1);
	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + offset * 6;

	makevectors (offang);

	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;

// set missile speed
	vec = normalize (v_forward);
	vec_z = 0 - vec_z + (random() - 0.5)*0.1;

	launch_spike2 (org, vec, 300);
	newmis.classname = "knightspike";
	// setmodel (newmis, "progs/k_spike.mdl");
	if (exploding)
	{
		newmis.touch = T_HellKnightMisTouch;
		if (self.mdl_exproj != "") // dumptruck_ds custom_mdls
		{
			setmodel (newmis, self.mdl_exproj);
		}
		else
		{
			setmodel (newmis, "progs/k_spike2.mdl");
		}

		if (self.skin_exproj) // dumptruck_ds
		{
			newmis.skin = self.skin_exproj;
		}
		else
		{
			newmis.skin = 0;
		}
	}
	else
	{
		if (self.mdl_proj != "") // dumptruck_ds custom_mdls
		{
			setmodel (newmis, self.mdl_proj);
		}
		else
		{
			setmodel (newmis, "progs/k_spike.mdl");
		}

		if (self.skin_proj) // dumptruck_ds
		{
			newmis.skin = self.skin_proj;
		}
		else
		{
			newmis.skin = 0;
		}
	}
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	sound_attack (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
};

void() CheckForCharge =
{
// check for mad charge
if (!enemy_vis)
	return;
if (time < self.attack_finished)
	return;
if ( fabs(self.origin_z - self.enemy.origin_z) > 20)
	return;		// too much height change
if ( vlen (self.origin - self.enemy.origin) < 80)
	return;		// use regular attack

// charge
	SUB_AttackFinished (2);
	hknight_char_a1 ();

};

void() CheckContinueCharge =
{
	if (time > self.attack_finished)
	{
		SUB_AttackFinished (3);
		hknight_run1 ();
		return;		// done charging
	}
	if (random() > 0.5)
		sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
};

//===========================================================================

void()	hknight_stand1	=[	$stand1,	hknight_stand2	] {ai_stand();};
void()	hknight_stand2	=[	$stand2,	hknight_stand3	] {ai_stand();};
void()	hknight_stand3	=[	$stand3,	hknight_stand4	] {ai_stand();};
void()	hknight_stand4	=[	$stand4,	hknight_stand5	] {ai_stand();};
void()	hknight_stand5	=[	$stand5,	hknight_stand6	] {ai_stand();};
void()	hknight_stand6	=[	$stand6,	hknight_stand7	] {ai_stand();};
void()	hknight_stand7	=[	$stand7,	hknight_stand8	] {ai_stand();};
void()	hknight_stand8	=[	$stand8,	hknight_stand9	] {ai_stand();};
void()	hknight_stand9	=[	$stand9,	hknight_stand1	] {ai_stand();};

//===========================================================================

void()	hknight_walk1	=[	$walk1,		hknight_walk2	] {
hk_idle_sound();
ai_walk(2);};
void()	hknight_walk2	=[	$walk2,		hknight_walk3	] {ai_walk(5);};
void()	hknight_walk3	=[	$walk3,		hknight_walk4	] {ai_walk(5);};
void()	hknight_walk4	=[	$walk4,		hknight_walk5	] {ai_walk(4);};
void()	hknight_walk5	=[	$walk5,		hknight_walk6	] {ai_walk(4);};
void()	hknight_walk6	=[	$walk6,		hknight_walk7	] {ai_walk(2);};
void()	hknight_walk7	=[	$walk7,		hknight_walk8	] {ai_walk(2);};
void()	hknight_walk8	=[	$walk8,		hknight_walk9	] {ai_walk(3);};
void()	hknight_walk9	=[	$walk9,		hknight_walk10	] {ai_walk(3);};
void()	hknight_walk10	=[	$walk10,	hknight_walk11	] {ai_walk(4);};
void()	hknight_walk11	=[	$walk11,	hknight_walk12	] {ai_walk(3);};
void()	hknight_walk12	=[	$walk12,	hknight_walk13	] {ai_walk(4);};
void()	hknight_walk13	=[	$walk13,	hknight_walk14	] {ai_walk(6);};
void()	hknight_walk14	=[	$walk14,	hknight_walk15	] {ai_walk(2);};
void()	hknight_walk15	=[	$walk15,	hknight_walk16	] {ai_walk(2);};
void()	hknight_walk16	=[	$walk16,	hknight_walk17	] {ai_walk(4);};
void()	hknight_walk17	=[	$walk17,	hknight_walk18	] {ai_walk(3);};
void()	hknight_walk18	=[	$walk18,	hknight_walk19	] {ai_walk(3);};
void()	hknight_walk19	=[	$walk19,	hknight_walk20	] {ai_walk(3);};
void()	hknight_walk20	=[	$walk20,	hknight_walk1	] {ai_walk(2);};

//===========================================================================

void()	hknight_run1	=[	$run1,		hknight_run2	] {
hk_idle_sound();
ai_run (20); CheckForCharge (); };
void()	hknight_run2	=[	$run2,		hknight_run3	] {ai_run(25);};
void()	hknight_run3	=[	$run3,		hknight_run4	] {ai_run(18);};
void()	hknight_run4	=[	$run4,		hknight_run5	] {ai_run(16);};
void()	hknight_run5	=[	$run5,		hknight_run6	] {ai_run(14);};
void()	hknight_run6	=[	$run6,		hknight_run7	] {ai_run(25);};
void()	hknight_run7	=[	$run7,		hknight_run8	] {ai_run(21);};
void()	hknight_run8	=[	$run8,		hknight_run1	] {ai_run(13);};

//============================================================================

void()	hknight_pain1	=[	$pain1,		hknight_pain2	] {sound_pain (self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);};
void()	hknight_pain2	=[	$pain2,		hknight_pain3	] {};
void()	hknight_pain3	=[	$pain3,		hknight_pain4	] {};
void()	hknight_pain4	=[	$pain4,		hknight_pain5	] {};
void()	hknight_pain5	=[	$pain5,		hknight_run1	] {};

//============================================================================

void()	hknight_die1	=[	$death1,	hknight_die2	] {ai_forward(10);};
void()	hknight_die2	=[	$death2,	hknight_die3	] {ai_forward(8);};
void()	hknight_die3	=[	$death3,	hknight_die4	]{self.solid = SOLID_NOT;ai_forward(7);};
void()	hknight_die4	=[	$death4,	hknight_die5	] {};
void()	hknight_die5	=[	$death5,	hknight_die6	] {};
void()	hknight_die6	=[	$death6,	hknight_die7	] {};
void()	hknight_die7	=[	$death7,	hknight_die8	] {};
void()	hknight_die8	=[	$death8,	hknight_die9	] {ai_forward(10);};
void()	hknight_die9	=[	$death9,	hknight_die10	] {ai_forward(11);};
void()	hknight_die10	=[	$death10,	hknight_die11	] {};
void()	hknight_die11	=[	$death11,	hknight_die12	] {};
void()	hknight_die12	=[	$death12,	hknight_die12	] {};

void()	hknight_dieb1	=[	$deathb1,	hknight_dieb2	] {};
void()	hknight_dieb2	=[	$deathb2,	hknight_dieb3	] {};
void()	hknight_dieb3	=[	$deathb3,	hknight_dieb4	] {self.solid = SOLID_NOT;};
void()	hknight_dieb4	=[	$deathb4,	hknight_dieb5	] {};
void()	hknight_dieb5	=[	$deathb5,	hknight_dieb6	] {};
void()	hknight_dieb6	=[	$deathb6,	hknight_dieb7	] {};
void()	hknight_dieb7	=[	$deathb7,	hknight_dieb8	] {};
void()	hknight_dieb8	=[	$deathb8,	hknight_dieb9	] {};
void()	hknight_dieb9	=[	$deathb9,	hknight_dieb9	] {};

void() hknight_die =
{
// check for gib
	if (self.health < -40)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		if (self.mdl_head != "") //dumptruck_ds custom_mdls
		{
			ThrowHead (self.mdl_head, self.health);
		}
		else
		{
			ThrowHead ("progs/h_hellkn.mdl", self.health);
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
	sound_death (self, CHAN_VOICE, "hknight/death1.wav", 1, ATTN_NORM);
	DropStuff();
	if (random() > 0.5)
		hknight_die1 ();
	else
		hknight_dieb1 ();
};


//============================================================================

void()	hknight_magica1 =[	$magica1,	hknight_magica2	] {ai_face();};
void()	hknight_magica2 =[	$magica2,	hknight_magica3	] {ai_face();};
void()	hknight_magica3 =[	$magica3,	hknight_magica4	] {ai_face();};
void()	hknight_magica4 =[	$magica4,	hknight_magica5	] {ai_face();};
void()	hknight_magica5 =[	$magica5,	hknight_magica6	] {ai_face();};
void()	hknight_magica6 =[	$magica6,	hknight_magica7	] {ai_face();};
void()	hknight_magica7 =[	$magica7,	hknight_magica8	] {hknight_shot(-2);};
void()	hknight_magica8 =[	$magica8,	hknight_magica9	] {hknight_shot(-1);};
void()	hknight_magica9 =[	$magica9,	hknight_magica10] {hknight_shot(0);};
void()	hknight_magica10 =[	$magica10,	hknight_magica11] {hknight_shot(1);};
void()	hknight_magica11 =[	$magica11,	hknight_magica12] {hknight_shot(2);};
void()	hknight_magica12 =[	$magica12,	hknight_magica13] {hknight_shot(3);};
void()	hknight_magica13 =[	$magica13,	hknight_magica14] {ai_face();};
void()	hknight_magica14 =[	$magica14,	hknight_run1	] {ai_face();};

//============================================================================

void() HellKnightLightning =
{
	local	vector	org, dir;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound_attack(self, CHAN_WEAPON,  "weapons/lstart.wav", 1, ATTN_NORM);
	ai_face ();
	makevectors (self.angles);
	org = self.origin + v_forward * 50 + '0 0 20';

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
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (org, trace_endpos, self, 20);
};
void()	hknight_magicb1 =[	$magicb1,	hknight_magicb2	] {ai_face();};
void()	hknight_magicb2 =[	$magicb2,	hknight_magicb3	] {ai_face();};
void()	hknight_magicb3 =[	$magicb3,	hknight_magicb4	] {ai_face();};
void()	hknight_magicb4 =[	$magicb4,	hknight_magicb5	] {ai_face();};
void()	hknight_magicb5 =[	$magicb5,	hknight_magicb6	] {ai_face();};
void()	hknight_magicb6 =[	$magicb6,	hknight_magicb7	] {ai_face();};
void()	hknight_magicb7 =[	$magicb7,	hknight_magicb8	] {ai_face();};
void()	hknight_magicb8 =[	$magicb8,	hknight_magicb9	] {ai_face();};
void()	hknight_magicb9 =[	$magicb9,	hknight_magicb10] {ai_face();};
void()	hknight_magicb10 =[	$magicb10,	hknight_magicb11] {ai_face();sound_misc2 (self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM);HellKnightLightning();};
void()	hknight_magicb11 =[	$magicb11,	hknight_magicb12] {ai_face();};
void()	hknight_magicb12 =[	$magicb12,	hknight_magicb13] {ai_face();};
void()	hknight_magicb13 =[	$magicb13,	hknight_run1] {ai_face();};

//============================================================================

void()	hknight_magicc1 =[	$magicc1,	hknight_magicc2	] {ai_face();};
void()	hknight_magicc2 =[	$magicc2,	hknight_magicc3	] {ai_face();};
void()	hknight_magicc3 =[	$magicc3,	hknight_magicc4	] {ai_face();};
void()	hknight_magicc4 =[	$magicc4,	hknight_magicc5	] {ai_face();};
void()	hknight_magicc5 =[	$magicc5,	hknight_magicc6	] {ai_face();};
void()	hknight_magicc6 =[	$magicc6,	hknight_magicc7	] {hknight_shot(-2);};
void()	hknight_magicc7 =[	$magicc7,	hknight_magicc8	] {hknight_shot(-1);};
void()	hknight_magicc8 =[	$magicc8,	hknight_magicc9	] {hknight_shot(0);};
void()	hknight_magicc9 =[	$magicc9,	hknight_magicc10] {hknight_shot(1);};
void()	hknight_magicc10 =[	$magicc10,	hknight_magicc11] {hknight_shot(2);};
void()	hknight_magicc11 =[	$magicc11,	hknight_run1] {hknight_shot(3);};

//============================================================================
///////////////////////////////////////
////// turret frames START - revisions
//////////////////////////////////////
void()	hknight_turret_magicc1 =[	$magicc1,	hknight_turret_magicc2	] {ai_face();};
void()	hknight_turret_magicc2 =[	$magicc2,	hknight_turret_magicc3	] {ai_face();};
void()	hknight_turret_magicc3 =[	$magicc3,	hknight_turret_magicc4	] {ai_face();};
void()	hknight_turret_magicc4 =[	$magicc4,	hknight_turret_magicc5	] {ai_face();};
void()	hknight_turret_magicc5 =[	$magicc5,	hknight_turret_magicc6	] {ai_face();};
void()	hknight_turret_magicc6 =[	$magicc6,	hknight_turret_magicc7	] {hknight_shot(-2);};
void()	hknight_turret_magicc7 =[	$magicc7,	hknight_turret_magicc8	] {hknight_shot(-1);};
void()	hknight_turret_magicc8 =[	$magicc8,	hknight_turret_magicc9	] {hknight_shot(0);};
void()	hknight_turret_magicc9 =[	$magicc9,	hknight_turret_magicc10] {hknight_shot(1);};
void()	hknight_turret_magicc10 =[ $magicc10,	hknight_turret_magicc11] {hknight_shot(2);};
void()	hknight_turret_magicc11 =[ $magicc11,	hknight_turret_magicc12] {ai_face();};
void()	hknight_turret_magicc12	=[	$stand1,	hknight_turret_magicc13	] {ai_face();};
void()	hknight_turret_magicc13	=[	$stand2,	hknight_turret_magicc14	] {ai_face();};
void()	hknight_turret_magicc14	=[	$stand3,	hknight_turret_magicc15	] {ai_face();};
void()	hknight_turret_magicc15	=[	$stand4,	hknight_seek_stand1	] {ai_run(0);};
void()	hknight_seek_stand1	=[	$stand1,	hknight_seek_stand2	] {ai_run(0);};
void()	hknight_seek_stand2	=[	$stand2,	hknight_seek_stand3	] {ai_run(0);};
void()	hknight_seek_stand3	=[	$stand3,	hknight_seek_stand4	] {ai_run(0);};
void()	hknight_seek_stand4	=[	$stand4,	hknight_seek_stand5	] {ai_run(0);};
void()	hknight_seek_stand5	=[	$stand5,	hknight_seek_stand6	] {ai_run(0);};
void()	hknight_seek_stand6	=[	$stand6,	hknight_seek_stand7	] {ai_run(0);};
void()	hknight_seek_stand7	=[	$stand7,	hknight_seek_stand8	] {ai_run(0);};
void()	hknight_seek_stand8	=[	$stand8,	hknight_seek_stand9	] {ai_run(0);};
void()	hknight_seek_stand9	=[	$stand9,	hknight_seek_stand1	] {ai_run(0);};

void()	hknight_turret_magicb1 =[	$magicb1,	hknight_turret_magicb2	] {ai_face();};
void()	hknight_turret_magicb2 =[	$magicb2,	hknight_turret_magicb3	] {ai_face();};
void()	hknight_turret_magicb3 =[	$magicb3,	hknight_turret_magicb4	] {ai_face();};
void()	hknight_turret_magicb4 =[	$magicb4,	hknight_turret_magicb5	] {ai_face();};
void()	hknight_turret_magicb5 =[	$magicb5,	hknight_turret_magicb6	] {ai_face();};
void()	hknight_turret_magicb6 =[	$magicb6,	hknight_turret_magicb7	] {ai_face();};
void()	hknight_turret_magicb7 =[	$magicb7,	hknight_turret_magicb8	] {ai_face();};
void()	hknight_turret_magicb8 =[	$magicb8,	hknight_turret_magicb9	] {ai_face();};
void()	hknight_turret_magicb9 =[	$magicb9,	hknight_turret_magicb10] {ai_face();};
void()	hknight_turret_magicb10 =[	$magicb10,	hknight_turret_magicb11] {ai_face();sound_misc2 (self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM);HellKnightLightning();};
void()	hknight_turret_magicb11 =[	$magicb11,	hknight_turret_magicb12] {ai_face();};
void()	hknight_turret_magicb12 =[	$magicb12,	hknight_turret_magicb13] {ai_face();};
void()	hknight_turret_magicb13 =[	$magicb13,	hknight_seek_stand1] {ai_face();};
/////////////////////////
////// turret frames END
/////////////////////////

//===========================================================================

void()	hknight_char_a1	=[	$char_a1,	hknight_char_a2	] {ai_charge(20);};
void()	hknight_char_a2	=[	$char_a2,	hknight_char_a3	] {ai_charge(25);};
void()	hknight_char_a3	=[	$char_a3,	hknight_char_a4	] {ai_charge(18);};
void()	hknight_char_a4	=[	$char_a4,	hknight_char_a5	] {ai_charge(16);};
void()	hknight_char_a5	=[	$char_a5,	hknight_char_a6	] {ai_charge(14);};
void()	hknight_char_a6	=[	$char_a6,	hknight_char_a7	] {ai_charge(20); ai_melee();};
void()	hknight_char_a7	=[	$char_a7,	hknight_char_a8	] {ai_charge(21); ai_melee();};
void()	hknight_char_a8	=[	$char_a8,	hknight_char_a9	] {ai_charge(13); ai_melee();};
void()	hknight_char_a9	=[	$char_a9,	hknight_char_a10	] {ai_charge(20); ai_melee();};
void()	hknight_char_a10=[	$char_a10,	hknight_char_a11	] {ai_charge(20); ai_melee();};
void()	hknight_char_a11=[	$char_a11,	hknight_char_a12	] {ai_charge(18); ai_melee();};
void()	hknight_char_a12=[	$char_a12,	hknight_char_a13	] {ai_charge(16);};
void()	hknight_char_a13=[	$char_a13,	hknight_char_a14	] {ai_charge(14);};
void()	hknight_char_a14=[	$char_a14,	hknight_char_a15	] {ai_charge(25);};
void()	hknight_char_a15=[	$char_a15,	hknight_char_a16	] {ai_charge(21);};
void()	hknight_char_a16=[	$char_a16,	hknight_run1	] {ai_charge(13);};

//===========================================================================

void()	hknight_char_b1	=[	$char_b1,	hknight_char_b2	]
{CheckContinueCharge (); ai_charge(23); ai_melee();};
void()	hknight_char_b2	=[	$char_b2,	hknight_char_b3	] {ai_charge(17); ai_melee();};
void()	hknight_char_b3	=[	$char_b3,	hknight_char_b4	] {ai_charge(12); ai_melee();};
void()	hknight_char_b4	=[	$char_b4,	hknight_char_b5	] {ai_charge(22); ai_melee();};
void()	hknight_char_b5	=[	$char_b5,	hknight_char_b6	] {ai_charge(18); ai_melee();};
void()	hknight_char_b6	=[	$char_b6,	hknight_char_b1	] {ai_charge(8); ai_melee();};

//===========================================================================

void()	hknight_slice1	=[	$slice1,	hknight_slice2	] {ai_charge(9);};
void()	hknight_slice2	=[	$slice2,	hknight_slice3	] {ai_charge(6);};
void()	hknight_slice3	=[	$slice3,	hknight_slice4	] {ai_charge(13);};
void()	hknight_slice4	=[	$slice4,	hknight_slice5	] {ai_charge(4);};
void()	hknight_slice5	=[	$slice5,	hknight_slice6	] {ai_charge(7); ai_melee();};
void()	hknight_slice6	=[	$slice6,	hknight_slice7	] {ai_charge(15); ai_melee();};
void()	hknight_slice7	=[	$slice7,	hknight_slice8	] {ai_charge(8); ai_melee();};
void()	hknight_slice8	=[	$slice8,	hknight_slice9	] {ai_charge(2); ai_melee();};
void()	hknight_slice9	=[	$slice9,	hknight_slice10	] {ai_melee();};
void()	hknight_slice10	=[	$slice10,	hknight_run1	] {ai_charge(3);};

//===========================================================================

void()	hknight_smash1	=[	$smash1,	hknight_smash2	] {ai_charge(1);};
void()	hknight_smash2	=[	$smash2,	hknight_smash3	] {ai_charge(13);};
void()	hknight_smash3	=[	$smash3,	hknight_smash4	] {ai_charge(9);};
void()	hknight_smash4	=[	$smash4,	hknight_smash5	] {ai_charge(11);};
void()	hknight_smash5	=[	$smash5,	hknight_smash6	] {ai_charge(10); ai_melee();};
void()	hknight_smash6	=[	$smash6,	hknight_smash7	] {ai_charge(7); ai_melee();};
void()	hknight_smash7	=[	$smash7,	hknight_smash8	] {ai_charge(12); ai_melee();};
void()	hknight_smash8	=[	$smash8,	hknight_smash9	] {ai_charge(2); ai_melee();};
void()	hknight_smash9	=[	$smash9,	hknight_smash10	] {ai_charge(3); ai_melee();};
void()	hknight_smash10	=[	$smash10,	hknight_smash11	] {ai_charge(0);};
void()	hknight_smash11	=[	$smash11,	hknight_run1	] {ai_charge(0);};

//============================================================================

void()	hknight_watk1	=[	$w_attack1,	hknight_watk2	] {ai_charge(2);};
void()	hknight_watk2	=[	$w_attack2,	hknight_watk3	] {ai_charge(0);};
void()	hknight_watk3	=[	$w_attack3,	hknight_watk4	] {ai_charge(0);};
void()	hknight_watk4	=[	$w_attack4,	hknight_watk5	] {ai_melee();};
void()	hknight_watk5	=[	$w_attack5,	hknight_watk6	] {ai_melee();};
void()	hknight_watk6	=[	$w_attack6,	hknight_watk7	] {ai_melee();};
void()	hknight_watk7	=[	$w_attack7,	hknight_watk8	] {ai_charge(1);};
void()	hknight_watk8	=[	$w_attack8,	hknight_watk9	] {ai_charge(4);};
void()	hknight_watk9	=[	$w_attack9,	hknight_watk10	] {ai_charge(5);};
void()	hknight_watk10	=[	$w_attack10,	hknight_watk11	] {ai_charge(3); ai_melee();};
void()	hknight_watk11	=[	$w_attack11,	hknight_watk12	] {ai_charge(2); ai_melee();};
void()	hknight_watk12	=[	$w_attack12,	hknight_watk13	] {ai_charge(2); ai_melee();};
void()	hknight_watk13	=[	$w_attack13,	hknight_watk14	] {ai_charge(0);};
void()	hknight_watk14	=[	$w_attack14,	hknight_watk15	] {ai_charge(0);};
void()	hknight_watk15	=[	$w_attack15,	hknight_watk16	] {ai_charge(0);};
void()	hknight_watk16	=[	$w_attack16,	hknight_watk17	] {ai_charge(1);};
void()	hknight_watk17	=[	$w_attack17,	hknight_watk18	] {ai_charge(1); ai_melee();};
void()	hknight_watk18	=[	$w_attack18,	hknight_watk19	] {ai_charge(3); ai_melee();};
void()	hknight_watk19	=[	$w_attack19,	hknight_watk20	] {ai_charge(4); ai_melee();};
void()	hknight_watk20	=[	$w_attack20,	hknight_watk21	] {ai_charge(6);};
void()	hknight_watk21	=[	$w_attack21,	hknight_watk22	] {ai_charge(7);};
void()	hknight_watk22	=[	$w_attack22,	hknight_run1	] {ai_charge(3);};

//============================================================================

void() hk_idle_sound =
{
	if (random() < 0.2)
		sound_idle (self, CHAN_VOICE, "hknight/idle.wav", 1, ATTN_NORM);
};

void(entity attacker, float damage)	hknight_pain =
{
	local float r;

	r = random();

	if (self.pain_finished > time)
		return;

	if (self.spawnflags & I_AM_TURRET)
	{
		if (r < 0.5)
		{
			self.pain_finished = time + 1.5;
			sound_pain (self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);
		}
		return;
	}

	sound_pain (self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);

	if (time - self.pain_finished > 5)
	{	// always go into pain frame if it has been a while
		hknight_pain1 ();
		self.pain_finished = time + 1;
		return;
	}

	if ((random()*30 > damage) )
		return;		// didn't flinch

	self.pain_finished = time + 1;
	hknight_pain1 ();
};

float	hknight_type;

void() hknight_melee =
{
	hknight_type = hknight_type + 1;

	sound_misc (self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);
	if (hknight_type == 1)
		hknight_slice1 ();
	else if (hknight_type == 2)
		hknight_smash1 ();
	else if (hknight_type == 3)
	{
		hknight_watk1 ();
		hknight_type = 0;
	}
};

/*QUAKED monster_hell_knight (1 0 0) (-16 -16 -24) (16 16 40) AMBUSH X X TRIGGER_SPAWNED X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ("progs/hknight.mdl");
}
Hellknight.

Default health = 250"

snd_death(string) : "Path to custom death sound"
snd_pain(string) : "Path to custom pain sound"
snd_sight(string) : "Path to custom sight sound"
snd_attack(string) : "Path to custom attack sound (MAGIC BOING)"
snd_idle(string) : Path to custom idle sound"
snd_misc(string) : Path to custom SWORD SLASH sound"

mdl_head(string) : "Path to custom head model"
mdl_body(string) : "Path to custom body model"
mdl_proj(string) : "Path to custom projectile model"
mdl_exproj(string) : "Path to custom projectile model for exploding projectiles"
skin_head(float) : "Skin index of custom head model"
skin_proj(float) : "Skin index of custom projectile model"
skin_exproj(float) : "Skin index of custom projectile model for exploding projectiles"
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

projexpl(choices) : "Exploding projectiles"
0 : "No explosions"
1 : "All projectiles explode"
2 : "Every other projectile explodes"
3 : "Random per projectile"

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
void() monster_hell_knight =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model2 ("progs/hknight.mdl");
	precache_model2 ("progs/k_spike.mdl");
	precache_model2 ("progs/k_spike2.mdl");
	precache_model2 ("progs/h_hellkn.mdl");
	//dumptruck_ds custom_mdls
	precache_body_model2 ("progs/hknight.mdl");
	precache_head_model2 ("progs/h_hellkn.mdl");
	precache_proj_model2 ("progs/k_spike.mdl");
	precache_exproj_model2 ("progs/k_spike2.mdl"); // this needed a unique name defiined in custom_mdls.qc -- dumptruck_ds
// dumptruck_ds

	precache_sound2_attack ("hknight/attack1.wav");
	precache_sound2_death ("hknight/death1.wav");
	precache_sound2_pain ("hknight/pain1.wav");
	precache_sound2_sight ("hknight/sight1.wav");
	precache_sound ("hknight/hit.wav");		// used by C code, so don't sound2
	precache_sound2_misc ("hknight/slash1.wav");
	precache_sound2_idle ("hknight/idle.wav");
	precache_sound2 ("hknight/grunt.wav"); // what??? never knew about this! -- dumptruck_ds

	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");

	precache_gib1 ("progs/gib1.mdl");
	precache_gib2 ("progs/gib2.mdl");
	precache_gib3 ("progs/gib3.mdl");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	body_model ("progs/hknight.mdl"); // custom_mdls dumptruck_ds
	// setmodel (self, "progs/hknight.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');

	if (!self.health) //thanks RennyC -- dumptruck_ds
	self.health = 250;

	if (!self.proj_speed_mod)
	{
		self.proj_speed_mod = 1;
	}

	self.th_stand = hknight_stand1;
	self.th_walk = hknight_walk1;
	if (self.spawnflags & I_AM_TURRET)
	{
	  self.th_run = hknight_seek_stand1;
	}
	else
	{
		self.th_run = hknight_run1;
	}
	self.th_melee = hknight_melee;
	if (self.style == 1)
	{
		self.th_missile = hknight_magicb1;
		self.th_turret = hknight_turret_magicb1;
	}
	else
	{
		self.th_missile = hknight_magicc1;
		self.th_turret = hknight_turret_magicc1;
	}
	if !(self.berserk) //Berserk test from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
	self.th_pain = hknight_pain;
	else
	self.th_pain = SUB_NullPain;
	self.th_die = hknight_die;

	walkmonster_start ();
};

/* Scenic Dead Monster Patch stuff here from DeadStuff mod -- dumptruck_ds */

/*QUAKED monster_dead_hell_knight (0 0.5 0.8) (-16 -16 -24) (16 16 32) SOLID X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ({"path":"progs/hknight.mdl","frame":62});
}
*/
void() monster_dead_hell_knight =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/hknight.mdl");
	setmodel(self, "progs/hknight.mdl");
	if (self.spawnflags & 2)
	{
		self.frame = $deathb9;

		if (self.spawnflags & 1)
		{
			self.solid = SOLID_BBOX;
                	setsize(self,'-68.96 -20.43 -53.98','34.8 21.15 30');
		}
		else
		{
			self.solid = SOLID_NOT;
		}
	}
	else
	{
		self.frame = $death12;
		if (self.spawnflags & 1)
		{
			self.solid = SOLID_BBOX;
                	setsize(self,'-42.05 -31.07 -51.56','46.34 25.02 30');
		}
		else
		{
			self.solid = SOLID_NOT;
		}
	}
};
