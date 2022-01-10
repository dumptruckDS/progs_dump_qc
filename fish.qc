$cd id1/models/fish
$origin 0 0 24
$base base
$skin skin

$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9 attack10 attack11 attack12 attack13
$frame attack14 attack15 attack16 attack17 attack18

$frame death1 death2 death3 death4 death5 death6 death7
$frame death8 death9 death10 death11 death12 death13 death14 death15
$frame death16 death17 death18 death19 death20 death21

$frame swim1 swim2 swim3 swim4 swim5 swim6 swim7 swim8
$frame swim9 swim10 swim11 swim12 swim13 swim14 swim15 swim16 swim17
$frame swim18

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8
$frame pain9

void() swimmonster_start;

void() f_stand1  =[      $swim1, f_stand2 ] {ai_stand();};
void() f_stand2  =[      $swim2, f_stand3 ] {ai_stand();};
void() f_stand3  =[      $swim3, f_stand4 ] {ai_stand();};
void() f_stand4  =[      $swim4, f_stand5 ] {ai_stand();};
void() f_stand5  =[      $swim5, f_stand6 ] {ai_stand();};
void() f_stand6  =[      $swim6, f_stand7 ] {ai_stand();};
void() f_stand7  =[      $swim7, f_stand8 ] {ai_stand();};
void() f_stand8  =[      $swim8, f_stand9 ] {ai_stand();};
void() f_stand9  =[      $swim9, f_stand10  ] {ai_stand();};
void() f_stand10 =[      $swim10, f_stand11 ] {ai_stand();};
void() f_stand11 =[      $swim11, f_stand12 ] {ai_stand();};
void() f_stand12 =[      $swim12, f_stand13 ] {ai_stand();};
void() f_stand13 =[      $swim13, f_stand14 ] {ai_stand();};
void() f_stand14 =[      $swim14, f_stand15 ] {ai_stand();};
void() f_stand15 =[      $swim15, f_stand16 ] {ai_stand();};
void() f_stand16 =[      $swim16, f_stand17 ] {ai_stand();};
void() f_stand17 =[      $swim17, f_stand18 ] {ai_stand();};
void() f_stand18 =[      $swim18, f_stand1 ] {ai_stand();};

void() f_walk1  =[      $swim1, f_walk2 ] {ai_walk(8);};
void() f_walk2  =[      $swim2, f_walk3 ] {ai_walk(8);};
void() f_walk3  =[      $swim3, f_walk4 ] {ai_walk(8);};
void() f_walk4  =[      $swim4, f_walk5 ] {ai_walk(8);};
void() f_walk5  =[      $swim5, f_walk6 ] {ai_walk(8);};
void() f_walk6  =[      $swim6, f_walk7 ] {ai_walk(8);};
void() f_walk7  =[      $swim7, f_walk8 ] {ai_walk(8);};
void() f_walk8  =[      $swim8, f_walk9 ] {ai_walk(8);};
void() f_walk9  =[      $swim9, f_walk10  ] {ai_walk(8);};
void() f_walk10 =[      $swim10, f_walk11 ] {ai_walk(8);};
void() f_walk11 =[      $swim11, f_walk12 ] {ai_walk(8);};
void() f_walk12 =[      $swim12, f_walk13 ] {ai_walk(8);};
void() f_walk13 =[      $swim13, f_walk14 ] {ai_walk(8);};
void() f_walk14 =[      $swim14, f_walk15 ] {ai_walk(8);};
void() f_walk15 =[      $swim15, f_walk16 ] {ai_walk(8);};
void() f_walk16 =[      $swim16, f_walk17 ] {ai_walk(8);};
void() f_walk17 =[      $swim17, f_walk18 ] {ai_walk(8);};
void() f_walk18 =[      $swim18, f_walk1 ] {ai_walk(8);};

void() f_run1  =[      $swim1, f_run2 ] {ai_run(12);
	if (random() < 0.5)
		sound_idle (self, CHAN_VOICE, "fish/idle.wav", 1, ATTN_NORM);
};
void() f_run2  =[      $swim3, f_run3 ] {ai_run(12);};
void() f_run3  =[      $swim5, f_run4 ] {ai_run(12);};
void() f_run4  =[      $swim7, f_run5 ] {ai_run(12);};
void() f_run5  =[      $swim9, f_run6 ] {ai_run(12);};
void() f_run6  =[      $swim11, f_run7 ] {ai_run(12);};
void() f_run7  =[      $swim13, f_run8 ] {ai_run(12);};
void() f_run8  =[      $swim15, f_run9 ] {ai_run(12);};
void() f_run9  =[      $swim17, f_run1 ] {ai_run(12);};

void() fish_melee =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;

	sound_attack (self, CHAN_VOICE, "fish/bite.wav", 1, ATTN_NORM);
	ldmg = (random() + random()) * 3;
	T_Damage (self.enemy, self, self, ldmg);
};

void() f_attack1        =[      $attack1,       f_attack2 ] {ai_charge(10);};
void() f_attack2        =[      $attack2,       f_attack3 ] {ai_charge(10);};
void() f_attack3        =[      $attack3,       f_attack4 ] {fish_melee();};
void() f_attack4        =[      $attack4,       f_attack5 ] {ai_charge(10);};
void() f_attack5        =[      $attack5,       f_attack6 ] {ai_charge(10);};
void() f_attack6        =[      $attack6,       f_attack7 ] {ai_charge(10);};
void() f_attack7        =[      $attack7,       f_attack8 ] {ai_charge(10);};
void() f_attack8        =[      $attack8,       f_attack9 ] {ai_charge(10);};
void() f_attack9        =[      $attack9,       f_attack10] {fish_melee();};
void() f_attack10       =[      $attack10,      f_attack11] {ai_charge(10);};
void() f_attack11       =[      $attack11,      f_attack12] {ai_charge(10);};
void() f_attack12       =[      $attack12,      f_attack13] {ai_charge(10);};
void() f_attack13       =[      $attack13,      f_attack14] {ai_charge(10);};
void() f_attack14       =[      $attack14,      f_attack15] {ai_charge(10);};
void() f_attack15       =[      $attack15,      f_attack16] {fish_melee();};
void() f_attack16       =[      $attack16,      f_attack17] {ai_charge(10);};
void() f_attack17       =[      $attack17,      f_attack18] {ai_charge(10);};
void() f_attack18       =[      $attack18,      f_run1    ] {ai_charge(10);};

void() f_death1 =[      $death1,        f_death2        ]
	{
		self.solid = SOLID_NOT;
		sound_death (self, CHAN_VOICE, "fish/death.wav", 1, ATTN_NORM);
	};
void() f_death2 =[      $death2,        f_death3        ] {};
void() f_death3 =[      $death3,        f_death4        ] {};
void() f_death4 =[      $death4,        f_death5        ] {};
void() f_death5 =[      $death5,        f_death6        ] {};
void() f_death6 =[      $death6,        f_death7        ] {};
void() f_death7 =[      $death7,        f_death8        ] {};
void() f_death8 =[      $death8,        f_death9        ] {};
void() f_death9 =[      $death9,        f_death10       ] {};
void() f_death10 =[      $death10,       f_death11       ] {};
void() f_death11 =[      $death11,       f_death12       ] {};
void() f_death12 =[      $death12,       f_death13       ] {};
void() f_death13 =[      $death13,       f_death14       ] {};
void() f_death14 =[      $death14,       f_death15       ] {};
void() f_death15 =[      $death15,       f_death16       ] {};
void() f_death16 =[      $death16,       f_death17       ] {};
void() f_death17 =[      $death17,       f_death18       ] {};
void() f_death18 =[      $death18,       f_death19       ] {};
void() f_death19 =[      $death19,       f_death20       ] {};
void() f_death20 =[      $death20,       f_death21       ] {};
void() f_death21 =[      $death21,       f_death21       ] {};

void() fish_die =
{
	if (self.health < -35) //fish gibs -- dumptruck_ds
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		// ThrowGib ("progs/gib3.mdl", self.health);
		// ThrowGib ("progs/gib1.mdl", self.health);
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
		if (self.mdl_head != "")
		{
			ThrowHead (self.mdl_head, self.health);
		}
		else
		{
			ThrowHead ("progs/h_dog.mdl", self.health);
		}
		DropStuff();
		SUB_Remove();
	}
	// regular death
	else
	  {
			DropStuff();
			f_death1();
		}
};

void() f_pain1  =[      $pain1, f_pain2 ] {};
void() f_pain2  =[      $pain2, f_pain3 ] {ai_pain(6);};
void() f_pain3  =[      $pain3, f_pain4 ] {ai_pain(6);};
void() f_pain4  =[      $pain4, f_pain5 ] {ai_pain(6);};
void() f_pain5  =[      $pain5, f_pain6 ] {ai_pain(6);};
void() f_pain6  =[      $pain6, f_pain7 ] {ai_pain(6);};
void() f_pain7  =[      $pain7, f_pain8 ] {ai_pain(6);};
void() f_pain8  =[      $pain8, f_pain9 ] {ai_pain(6);};
void() f_pain9  =[      $pain9, f_run1 ] {ai_pain(6);};

void(entity attacker, float damage)	fish_pain =
{
// fish always do pain frames
	f_pain1 ();
};



/*QUAKED monster_fish (1 0 0) (-16 -16 -24) (16 16 24) AMBUSH X X TRIGGER_SPAWNED X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ("progs/fish.mdl");
}
Rotfish.

Default health = 25"

snd_death(string) : "Path to custom death sound (BUBBLES)"
snd_attack(string) : "Path to custom attack sound (CRUNCHY BITE)"
snd_idle(string) : "Path to custom idle sound"

mdl_body(string) : "Path to custom body model"
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
void() monster_fish =
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
	precache_body_model2 ("progs/fish.mdl");
	// precache_model2 ("progs/fish.mdl");

	precache_sound2_death ("fish/death.wav");
	precache_sound2_attack ("fish/bite.wav");
	precache_sound2_idle ("fish/idle.wav");

	precache_gib1 ("progs/gib1.mdl");
	precache_gib2 ("progs/gib2.mdl");
	precache_gib3 ("progs/gib3.mdl");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	body_model ("progs/fish.mdl");
	// setmodel (self, "progs/fish.mdl");

	setsize (self, '-16 -16 -24', '16 16 24');

	if (!self.health) //thanks RennyC -- dumptruck_ds
	self.health = 25;

	self.th_stand = f_stand1;
	self.th_walk = f_walk1;
	self.th_run = f_run1;
	// self.th_die = f_death1;
	self.th_die = fish_die;
	if !(self.berserk) //Berserk from http://celephais.net/board/view_thread.php?id=4&start=3465 -- dumptruck_ds
	self.th_pain = fish_pain;
	else
	self.th_pain = SUB_NullPain;
	self.th_melee = f_attack1;

	swimmonster_start ();
};
