.float attack_timer;
.float bsporigin;			// All bmodel origins are 0,0,0 check this first
.float distance;
.float waitmin2;

float BOB_COLLISION = 2;		// Collision for misc_bob
float BOB_NONSOLID = 4;			// Non solid for func_bob

/*QUAKED func_bob (0 .5 .8) ?
A SOLID bmodel that gently moves back and forth
-------- KEYS --------
targetname : trigger entity (works with entity state system)
angle    : direction movement, use "360" for angle 0
height   : direction intensity (def=8)
count    : direction cycle timer (def=2s, minimum=1s)
waitmin  : Speed up scale (def=1) 1+=non linear
waitmin2 : Slow down scale (def=0.75)
delay    : Starting time delay (def=0, -1=random)
style 	 : If set to 1, starts off and waits for trigger
_dirt       : -1 = will be excluded from dirtmapping
_minlight   : Minimum light level for any surface of the brush model
_mincolor   : Minimum light color for any surface (def='1 1 1' RGB)
_shadow     : Will cast shadows on other models and itself
_shadowself : Will cast shadows on itself
-------- SPAWNFLAGS --------
STARTOFF : Starts off and waits for trigger - DISABLED, Ripped out ESTATE System (RennyC)
-------- NOTES --------
A SOLID bmodel that gently moves back and forth
*/

//----------------------------------------------------------------------
void() func_bob_timer =
{
	// Keep ticking in background, use local timer (faster)
	self.think = func_bob_timer;

	if (self.bsporigin)
		self.nextthink = self.ltime + 0.1;
	else
		self.nextthink = time + 0.1;

	// Has the cycle completed?
	if (self.attack_timer < time)
	{
		// Setup bob cycle and half way point for slowdown
		self.attack_timer = time + self.count;
		self.distance = time + (self.count * 0.5);
		// Flip direction of bmodel bob
		self.lefty = 1 - self.lefty;
		if (self.lefty < 1)
			self.t_length = self.height;
		else
			self.t_length = -self.height;

		// Always reset velocity and flags
		self.velocity = '0 0 0';
		self.flags = 0;
	}

	// Is the direction set?
	// This is a block condition to prevent the bmodel moving
	if (self.lefty != -1)
	{
		// Slow down velocity (gradually)
		if (self.distance < time)
			self.velocity = self.velocity * self.waitmin2;
		else
		{
			// Speed up velocity (linear/exponentially)
			self.t_length = self.t_length * self.waitmin;
			self.velocity = self.velocity + (self.movedir * self.t_length);
		}
	}
};

//----------------------------------------------------------------------
void() func_bob_on =
{
	if (self.bsporigin)
	{
		// Check for solid spawnflag
		if (self.spawnflags & BOB_NONSOLID)
		{
			self.movetype = MOVETYPE_PUSH;
			self.solid = SOLID_NOT;
		}
		else
		{
			self.movetype = MOVETYPE_PUSH;
			self.solid = SOLID_BSP;
		}
	}
	else
	{
		self.movetype = MOVETYPE_FLY;
		if (self.spawnflags & BOB_COLLISION)
			self.solid = SOLID_BBOX;
		else
			self.solid = SOLID_NOT;
		self.flags = 0;	// Reset any onground flags
	}
	setmodel (self, self.mdl);
	setsize (self, self.mins , self.maxs);
};

//----------------------------------------------------------------------
void() func_bob_off =
{
	self.movetype = MOVETYPE_NONE;
	if (self.spawnflags & BOB_COLLISION)
		self.solid = SOLID_BBOX;
	else
		self.solid = SOLID_NOT;
	setmodel (self, self.mdl);
	setsize (self, self.mins , self.maxs);
	self.velocity = '0 0 0';

	if (self.style & 1)
		self.use = func_bob_on;
};

//----------------------------------------------------------------------
void() func_bob =
{
	if (!self.spawnflags)
		self.spawnflags = BOB_COLLISION;
	// Using a custom model?
	if (self.mdl == "")
	{
		self.bsporigin = TRUE;
		self.mdl = self.model;
	}
	else
	{
		self.bsporigin = FALSE;
		self.modelindex = 0;
		self.model = "";
	}

	SetMovedir ();
	self.movedir = normalize(self.movedir);

	if (self.height <= 0)
		self.height = 8;			// Direction intensity
	if (self.count < 1)
		self.count = 2;				// Direction switch timer
	if (self.waitmin <= 0)
		self.waitmin = 1;			// Speed up
	if (self.waitmin2 <= 0)
		self.waitmin2 = 0.75;		// Slow down
	if (self.delay < 0)
		self.delay = random() + random() + random();

	// Setup Entity State functionality - Nope! (RennyC)
	// if (self.targetname != "")
	// 	self.use = func_bob_on;

	if (!self.style)  //added style key 1 for start off -- dumptruck_ds
		func_bob_on();
	else
		func_bob_off();

	self.think = func_bob_timer;
	self.nextthink = time + 0.1 + self.delay;
};

//----------------------------------------------------------------------

/*QUAKED misc_bob (0 0.5 0.8) (-8 -8 -8) (8 8 8)
*/
void() misc_bob =
{
	if (self.mdl == "")
		self.mdl = string_null;
	precache_model(self.mdl);

	func_bob();
};
