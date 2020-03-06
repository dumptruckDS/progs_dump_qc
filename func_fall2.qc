void() func_fall2_think =
{
	if (self.attack_finished < time)
	{
		if (self.target) // fire other targets
			SUB_UseTargets();

		self.solid = SOLID_NOT;
		if (self.pos1 != '0 0 0')
			self.avelocity = self.pos1; // apply stored avelocity vector values

		if (self.style > 0) // style over 0
		{
			if (self.style >= 2)
			{
				self.movetype = MOVETYPE_BOUNCE;
				if (self.velocity_z < self.lip)
					self.velocity_z = self.lip;
			}
			else // style is 1
			{
				self.movetype = MOVETYPE_NOCLIP;
				if (self.velocity_z > self.lip)
					self.velocity_z = self.velocity_z - self.speed * (frametime * 100);
				else
					self.velocity_z = self.lip;
			}
		}
		else // default behavior (style is 0)
		{
			self.movetype = MOVETYPE_TOSS;
			if (self.velocity_z < self.lip)
				self.velocity_z = self.lip;
		}

		if (self.style2 != -1)
		{
			if (self.alpha > 0.1)
				self.alpha = self.alpha - self.style2;
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
	// if (!other.takedamage || self.style == TRUE)
		return;
	if (self.spawnflags & 1 && other.classname != "player") // Player activated only
		return;
	if ((self.spawnflags & 2) && !(other.flags & FL_MONSTER)) // Monster activated only
		return;

	self.think = func_fall2_think;
	self.nextthink = self.ltime + 0.1;

	self.attack_finished = time + self.wait;
	if (self.noise)
		sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	self.touch = SUB_Null; // disable touch, only do this once
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

/*QUAKED func_fall2 (0 .5 .8) ?
Falling brush by RennyC

wait - how long until the brush begins falling
noise - the sound to make when touched / activated
noise2 - the sound to make before it's removed, style2 of -1 disables noise2 as the object stays forever
style - 0 is default behavior (MOVETYPE_TOSS), 1 means collisions are disabled while falling (MOVETYPE_NOCLIP), 2 turns the brush into a
	   bouncing entity (MOVETYPE_BOUNCE)
style2 - controls fade time - default of 0.01, higher value has the object/brush fade out faster thus in turn affecting how long it stays. -1 stays forever
It's best to NOT use style 1 and style2 -1 togther; as the brush will continue to loop through the map verically.
speed - speed as to how fast something falls per game frame, default is 10, higher values mean faster falling. Only for style of 1 (MOVETYPE_NOCLIP).
		Recommended to use lip for max fall speed on MOVETYPE_TOSS/BOUNCE entities (style 0 and 2) as they follow Quake's default gravity
lip - maximum fall speed that can be achieved, caps 'speed' variable. Default is -800
avelocity - have it spin when activated using X, Y, Z vector coordinates. MOVETYPE_BOUNCE ignores avelocity !Use an origin brush for proper spin!

spawnflags:
	Default behavior allows anyone to activate func_fall2 on touch
	1 - Player activated only
	2 - Monster activated only

Able to .target other entities, including other func_fall2s

*REMINDER* func_fall2s tied to a origin brush are NON-SOLID!
*/

void() func_fall2 =
{
	if (self.noise)
		precache_sound(self.noise);
	if (self.noise2)
		precache_sound(self.noise2);

	self.alpha = 1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;

	if (!self.style2)
		self.style2 = 0.01;
	if (!self.targetname)
		self.touch = fall2_touch;
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
