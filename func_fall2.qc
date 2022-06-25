.float alpha; // translucency in supported engines
.entity char; // linker entity
float	PLAYER_TRIGGERED = 1;
float	MONSTER_TRIGGERED = 2;
float	FALL_BREAKABLE = 8;		//VR
// float	FALL_SOLID = 16;		//VR

void() fall_break_fields;

void() func_fall2_think =
{
	self.waterlevel = self.watertype = 0; // turn off quake engine splash sound

	if (self.attack_finished < time)
	{
		if (self.target) // fire other targets
			SUB_UseAndForgetTargets();
			// SUB_UseTargets();

			self.solid = SOLID_NOT; // removed FALL_SOLID behavior -- dumptruck_ds
			if (self.pos1 != '0 0 0')
			self.avelocity = self.pos1; // apply stored avelocity vector values

		if (self.pos2 && !self.velocity) // Add velocity movement
			self.velocity = self.pos2;

		if (self.cnt > 0) // cnt over 0
		{
			if (self.cnt >= 2)
			{
				self.movetype = MOVETYPE_BOUNCE;
				if (self.velocity_z < self.lip)
					self.velocity_z = self.lip;
			}
			else // cnt is 1
			{
				self.movetype = MOVETYPE_NOCLIP;
				if (self.velocity_z > self.lip)
					self.velocity_z = self.velocity_z - self.speed * (frametime * 100);
				else
					self.velocity_z = self.lip;
			}
		}
		else // default behavior (cnt is 0)
		{
			self.movetype = MOVETYPE_TOSS;
			if (self.velocity_z < self.lip)
				self.velocity_z = self.lip;
		}

		if (self.pain_finished != -1)
		{
			if (self.alpha > 0.1)
				self.alpha = self.alpha - self.pain_finished;
			else
			{
				if (self.noise2)
					sound (self, CHAN_AUTO, self.noise2, 1, ATTN_NORM);
				remove(self);
				return;
			}
		}

		if (self.flags&FL_ONGROUND && self.spawnflags&FALL_BREAKABLE) {	//VR
			self.spawnflags(-)1;			//aka BREAKABLE_NO_MONSTERS
			self.spawnflags(-)2;			//aka BREAK_EXPLODE
			self.mins = self.absmin;		//because of how debris origin is calculated
			self.maxs = self.absmax;
			self.health = self.lip*0.1;		//debris gets velocity from health
			self.cnt = self.count;			//func_breakable uses cnt for quantity of debris to spawn
			func_breakable_die();			//removes self
			return;
		}
	}

	self.nextthink = self.ltime + 0.1;
};

void() fall2_touch =
{
	if (!other.takedamage)
		return;
	if (other.classname != "player") // player activated only
		return;
	if (self.spawnflags & MONSTER_TRIGGERED) // disable on monster only, also fixes weird issue
		return;

	self.think = func_fall2_think;
	self.nextthink = self.ltime + 0.1;

	self.attack_finished = time + self.wait;

	// if (self.spawnflags&FALL_SOLID) {	//VR
	// 	setsize(self, self.mins, self.maxs);
	// 	self.solid = SOLID_BBOX;
	// }
	// else
	// 	self.solid = SOLID_NOT;

	if (self.noise)
		sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);

	self.touch = SUB_Null; // disable touch, only do this once!

	if (self.char)
		remove(self.char);
};

void() func_fall2_use =
{
	self.think = func_fall2_think;
	self.nextthink = self.ltime + 0.1;
	self.touch = SUB_Null; // disable touch when used

	// if (self.spawnflags&FALL_SOLID) {	//VR
	// 	setsize(self, self.mins, self.maxs);
	// 	self.solid = SOLID_BBOX;
	// }
	// else
	// 	self.solid = SOLID_NOT;

	self.attack_finished = time + self.wait;
	if (self.noise)
		sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
};

void() func_fall2_field_touch =
{
	if (other.flags & FL_FLY) // flying monsters shouldn't trigger falling platforms
		return;

	if (other.flags & FL_MONSTER)
	{
		local entity oself;

		oself = self;

		self = self.owner;
		self.think = func_fall2_use;
		self.nextthink = self.owner.ltime + 0.1;

		self = oself;

		remove(self);
	}
};

/*QUAKED func_fall2 (0 .5 .8) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
Falling brush by RennyC with additions from whirledtsar

wait - how long until the brush begins falling
noise - the sound to make when touched / activated
noise2 - the sound to make before it's removed, pain_finished of -1 disables noise2 as the object stays forever
cnt - 0 is default behavior (MOVETYPE_TOSS), 1 means collisions are disabled while falling (MOVETYPE_NOCLIP), 2 turns the brush into a bouncing entity (MOVETYPE_BOUNCE)
pain_finished - default of 0.01, higher value has the object/brush fade out faster thus in turn affecting how long it stays. -1 stays forever
speed - speed as to how fast something falls per game frame, default is 10, higher values mean faster falling. Only for cnt of 1 (MOVETYPE_NOCLIP).
Recommended to use lip for max fall speed on MOVETYPE_TOSS/BOUNCE entities (cnt 0 and 2) as they follow Quake's default gravity
lip - maximum fall speed that can be achieved, caps 'speed' variable. Default is -800
avelocity - have it spin when activated using X, Y, Z vector coordinates. MOVETYPE_BOUNCE ignores avelocity !Use an origin brush for proper spin!

spawnflags:
Default behavior allows anyone to activate func_fall2 on touch ONLY
1 - Player activated only
2 - Monster activated only
8 - break on impact (use style key for textures, see manual for more)
16 - fall solid; remains solid on ground

Able to .target other entities, including other func_fall2s
*/

void() func_fall2 =
{
	//
	// This is a hack to have monsters be able to trigger it by fake touch - Thanks to Nahuel
	//

	// Don't spawn on player only or if I'm a targetable
	if (!(self.spawnflags & PLAYER_TRIGGERED) && !(self.targetname))
	{
		local entity func_fall2_field;

		func_fall2_field = spawn();
		func_fall2_field.owner = self;
		self.char = func_fall2_field; // Link 'em
		func_fall2_field.solid = SOLID_TRIGGER;
		setsize (func_fall2_field, self.absmin, self.absmax + '0 0 8');
		setorigin (func_fall2_field, self.origin);
		setmodel (func_fall2_field, self.model);
		func_fall2_field.touch = func_fall2_field_touch;
	}

	if (self.noise)
		precache_sound(self.noise);
	if (self.noise2)
		precache_sound(self.noise2);

	self.alpha = 1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;

	if (!self.pain_finished)
		self.pain_finished = 0.01;
	if (!self.targetname)
		self.touch = fall2_touch; // .touch in this instance is for players only
	if (!self.speed)
		self.speed = 10;
	if (!self.lip)
		self.lip = -800;
	if (self.avelocity != '0 0 0')
	{
		self.pos1 = self.avelocity; // store it
		self.avelocity = '0 0 0';
	}
	if (self.spawnflags&FALL_BREAKABLE) {	//VR
		self.pain_finished = -1;	//dont fade if set to break
		fall_break_fields();
	}
	self.use = func_fall2_use;

	setmodel (self, self.model);
};

//	* You may have to modify your multi_touch(); command in triggers.qc to allow
//	* both monsters & players to activate trigger_once/multiple. I recommend allowing
//	* the mapper themselves to select how that occurs. Default behavior is player only.

void fall_break_fields ()
{
	break_template_setup();

	self.mdl_debris = "progs/debris.mdl";
	precache_model (self.mdl_debris);

	if (self.noise1 != "") precache_sound(self.noise1);
// adding new default sounds for "simple" breakables in 1.2.0 -- dumptruck_ds
// here's genreic metal breaking
	if (self.style == 0 || self.style == 11 || self.style == 12 || self.style == 17 || self.style == 18 || self.style == 19
		|| self.style == 24 || self.style == 31)
		if !(self.noise1)
	{
		precache_sound("break/metal2.wav");
		self.noise1 = "break/metal2.wav";
	}
	if (self.style == 3 || self.style == 4 || self.style == 5)
		if !(self.noise1)
	{
		precache_sound("break/wood1.wav");
		precache_sound("break/wood2.wav");
		if (random() > 0.6) // wood only randomized
		self.noise1 = "break/wood1.wav";
		else
		self.noise1 = "break/wood2.wav";
	}
	// glass sounds -- this is more of a shattering sound anyway
	if (self.style == 6 || self.style == 7 || self.style == 8 || self.style == 9 || self.style == 10)
		if !(self.noise1)
	{
		precache_sound("break/metal1.wav");
		self.noise1 = "break/metal1.wav";
	}
	if (self.style == 1 || self.style == 2 || self.style == 13 || self.style == 14
		|| self.style == 15 || self.style == 16 || self.style == 20 || self.style == 21
		|| self.style == 22 || self.style == 23)
		if !(self.noise1)
	{
		precache_sound("break/bricks1.wav");
		self.noise1 = "break/bricks1.wav";
	}
	if (self.style == 25 || self.style == 26 || self.style == 27 || self.style == 28 || self.style == 29 || self.style == 30)
		if !(self.noise1)
	{
		precache_sound("break/stones1.wav");
		self.noise1 = "break/stones1.wav";
	}

	if (!self.health)
		self.health = 20;
	if (!self.count)
		self.count = 5; // was 6 dumptruck_ds
}
