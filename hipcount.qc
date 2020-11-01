/* Counter QuickC program
   By Jim Dose'  9/13/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/

float COUNTER_TOGGLE = 1;
float COUNTER_LOOP = 2;
float COUNTER_STEP = 4;
float COUNTER_RESET = 8;
float COUNTER_RANDOM = 16;
float COUNTER_FINISHCOUNT = 32;
float COUNTER_START_ON = 64;

void() counter_on_use;
void() counter_off_use;

void() counter_think =
	{
	self.cnt = self.cnt + 1;
	if ( self.spawnflags & COUNTER_RANDOM )
		{
		self.state = random() * self.count;
		self.state = floor( self.state ) + 1;
		}
	else
		{
		self.state = self.cnt;
		}

	// fix func_counter and func_oncount handling of activator -- iw
	//activator = other;
	activator = self.enemy;
	SUB_UseTargets();
	self.nextthink = time + self.wait;

	if ( self.spawnflags & COUNTER_STEP )
		{
		counter_on_use();
		}

	if ( self.cnt >= self.count )
		{
		self.cnt = 0;
		if ( ( self.aflag ) || !( self.spawnflags & COUNTER_LOOP ) )
			{
			if (self.spawnflags & COUNTER_TOGGLE)
				{
				counter_on_use();
				}
			else
				{
				remove (self);
				}
			}
		}
	};

// fix func_counter and func_oncount handling of activator -- iw
void() counter_start_on_think =
	{
	activator = world;  // to ensure it's not a random entity -- iw
	counter_off_use();
	};

void() counter_on_use =
	{
	if ( ( self.cnt != 0 ) && ( self.spawnflags & COUNTER_FINISHCOUNT ) )
		{
		self.aflag = TRUE;
		return;
		}

	self.use = counter_off_use;
	self.think = SUB_Null;
	self.aflag = FALSE;
	};

void() counter_off_use =
	{
	self.aflag = FALSE;
	if (self.spawnflags & COUNTER_TOGGLE)
		{
		self.use = counter_on_use;
		}
	else
		{
		self.use = SUB_Null;
		}

	if ( self.spawnflags & COUNTER_RESET )
		{
		self.cnt = 0;
		self.state = 0;
		}
	// fix func_counter and func_oncount handling of activator -- iw
	self.enemy = activator;
	self.think = counter_think;
	// fix "delay" making func_counter not work -- iw
	//if (self.delay)
	if (self.pausetime)
		{
		// fix "delay" making func_counter not work -- iw
		//self.nextthink = time + self.delay;
		self.nextthink = time + self.pausetime;
		}
	else
		{
		counter_think();
		}
	};

float( entity counter ) counter_GetCount =
	{
	if ( counter.classname == "counter" )
		{
		return counter.state;
		}
	return 0;
	};

/*QUAKED func_counter (0 0 0.5) (0 0 0) (32 32 32) TOGGLE LOOP STEP RESET RANDOM FINISHCOUNT START_ON X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
TOGGLE causes the counter to switch between an on and off state
each time the counter is triggered.

LOOP causes the counter to repeat infinitly.  The count resets to zero
after reaching the value in "count".

STEP causes the counter to only increment when triggered.  Effectively,
this turns the counter into a relay with counting abilities.

RESET causes the counter to reset to 0 when restarted.

RANDOM causes the counter to generate random values in the range 1 to "count"
at the specified interval.

FINISHCOUNT causes the counter to continue counting until it reaches "count"
before shutting down even after being set to an off state.

START_ON causes the counter to be on when the level starts.

"count" specifies how many times to repeat the event.  If LOOP is set,
it specifies how high to count before reseting to zero.  Default is 10.

"wait"  the length of time between each trigger event. Default is 1 second.

"delay" how much time to wait before firing after being switched on.
*/

void() func_counter =
	{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if ( !self.wait )
	   {
	   self.wait = 1;
	   }

	self.count = floor( self.count );
	if ( self.count <= 0 )
	   {
	   self.count = 10;
	   }

	// fix "delay" making func_counter not work -- iw
	self.pausetime = self.delay;
	self.delay = 0;

	self.cnt = 0;
	self.state = 0;

	self.classname = "counter";
	self.use = counter_off_use;
	self.think = SUB_Null;
   if ( self.spawnflags & COUNTER_START_ON )
      {
      // fix func_counter and func_oncount handling of activator -- iw
      //self.think = counter_off_use;
      self.think = counter_start_on_think;
      self.nextthink = time + 0.1;
      }
	};

void() oncount_use =
	{
	if ( counter_GetCount( other ) == self.count )
		{
		// fix func_counter and func_oncount handling of activator -- iw
		//activator = other;
		SUB_UseTargets();
		}
	};

/*QUAKED func_oncount (0 0 0.5) (0 0 0) (16 16 16)
Must be used as the target for func_counter.  When the counter
reaches the value set by count, func_oncount triggers its targets.

"count" specifies the value to trigger on.  Default is 1.

"delay" how much time to wait before firing after being triggered.
*/

void() func_oncount =
	{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.count = floor( self.count );
	if ( self.count <= 0 )
	   {
	   self.count = 1;
	   }

	self.classname = "oncount";
	self.use = oncount_use;
	self.think = SUB_Null;
	};
