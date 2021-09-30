// button and multiple button

void() button_wait;
void() button_return;

void() button_wait =
{
	self.state = STATE_TOP;
	self.nextthink = self.ltime + self.wait;
	self.think = button_return;
	activator = self.enemy;
	self.frame = 1;			// use alternate textures

	if (self.estate != STATE_ACTIVE)
		return;
	
	SUB_UseTargets();
	
};

void() button_done =
{
	self.state = STATE_BOTTOM;
};

void() button_return =
{
	if (self.estate != STATE_ACTIVE) return;

	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos1, self.speed, button_done);
	self.frame = 0;			// use normal textures
	if (self.health)
		self.takedamage = DAMAGE_YES;	// can be shot again
};


void() button_blocked =
{	// do nothing, just don't ome all the way back out
};


void() button_fire =
{
	if (self.estate != STATE_ACTIVE) return;

	if (self.state == STATE_UP || self.state == STATE_TOP)
		return;

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	self.state = STATE_UP;
	SUB_CalcMove (self.pos2, self.speed, button_wait);
};


void() button_use =
{
	self.enemy = activator;
	button_fire ();
};

void() button_touch =
{
	if (other.classname != "player")
		return;
	self.enemy = other;
	button_fire ();
};

void() button_killed =
{
	if (self.estate != STATE_ACTIVE) return;

	self.enemy = damage_attacker;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;	// wil be reset upon return
	button_fire ();
};



// adapted from Copper, thanks Lunaran
void(entity b) button_lock =
{
	entity oself;

	if (b.estate == STATE_INACTIVE)
		return;

	oself = self;
	self = b;

	if (self.state == STATE_UP || self.state == STATE_TOP)
		self.prevstate = STATE_TOP;
	else 
		self.prevstate = STATE_BOTTOM;

	if (self.max_health)
		self.takedamage = DAMAGE_NO;
	self.state = STATE_UP;
	SUB_CalcMove (self.pos2, self.speed, button_wait);
	self.estate = STATE_INACTIVE;

	self = oself;
}

void(entity b, float dontresetstate) button_unlock =
{
	entity oself;

	if (b.estate == STATE_ACTIVE)
		return;

	oself = self;
	self = b;

	if (!dontresetstate || self.wait != -1 || self.prevstate == STATE_BOTTOM) {
		if (self.max_health)
		{
			self.takedamage = DAMAGE_YES;
			self.health = self.max_health;
		}
		self.frame = 0;			// use normal textures
		self.state = STATE_DOWN;
		SUB_CalcMove (self.pos1, self.speed, button_done);
	}

	self.estate = STATE_ACTIVE;

	self = oself;
}


/*QUAKED func_button (0 .5 .8) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
When a button is touched, it moves some distance in the direction of it's angle, triggers all of it's targets, waits some time, then returns to it's original position where it can be triggered again.

"angle"	determines the opening direction
"target"	all entities with a matching targetname will be used
"speed"	override the default 40 speed
"wait"	override the default 1 second wait (-1 = never return)
"lip"	override the default 4 pixel lip remaining at end of move
"health"	if set, the button must be killed instead of touched
"sounds"
0) steam metal
1) wooden clunk
2) metallic click
3) in-out
*/
void() func_button =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (self.sounds == 0)
	{
		precache_sound ("buttons/airbut1.wav");
		self.noise = "buttons/airbut1.wav";
	}
	if (self.sounds == 1)
	{
		precache_sound ("buttons/switch21.wav");
		self.noise = "buttons/switch21.wav";
	}
	if (self.sounds == 2)
	{
		precache_sound ("buttons/switch02.wav");
		self.noise = "buttons/switch02.wav";
	}
	if (self.sounds == 3)
	{
		precache_sound ("buttons/switch04.wav");
		self.noise = "buttons/switch04.wav";
	}

	SetMovedir ();

	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel (self, self.model);

	self.blocked = button_blocked;
	self.use = button_use;

	if (self.health)
	{
		self.max_health = self.health;
		self.th_die = button_killed;
		self.takedamage = DAMAGE_YES;
	}
	else
		self.touch = button_touch;

	if (!self.speed)
		self.speed = 40;
	if (!self.wait)
		self.wait = 1;
	if (!self.lip)
		self.lip = 4;

	self.state = STATE_BOTTOM;

	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);
};
