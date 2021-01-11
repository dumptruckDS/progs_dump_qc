.float alpha; // translucency in supported engines
.entity char; // linker entity
float	PLAYER_TRIGGERED = 1;
float	MONSTER_TRIGGERED = 2;


void() func_fall2_think =
{
	self.waterlevel = self.watertype = 0; // turn off quake engine splash sound

	if (self.attack_finished < time)
	{
		if (self.target) // fire other targets
			SUB_UseAndForgetTargets();
			// SUB_UseTargets();

		self.solid = SOLID_NOT;
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
Falling brush by RennyC

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
	self.use = func_fall2_use;

	setmodel (self, self.model);
};

//	* You may have to modify your multi_touch(); command in triggers.qc to allow
//	* both monsters & players to activate trigger_once/multiple. I recommend allowing
//	* the mapper themselves to select how that occurs. Default behavior is player only.
