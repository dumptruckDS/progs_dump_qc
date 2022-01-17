

void() SUB_Null = {};

void(entity attacker, float damage) SUB_NullPain = {};

void() SUB_Remove = {remove(self);};


/*
QuakeEd only writes a single float for angles (bad idea), so up and down are
just constant angles.
*/
void() SetMovedir =
{
	if (self.angles == '0 -1 0')
		self.movedir = '0 0 1';
	else if (self.angles == '0 -2 0')
		self.movedir = '0 0 -1';
	else
	{
		makevectors (self.angles);
		self.movedir = v_forward;
	}

	self.angles = '0 0 0';
};


/*
=============
SUB_CallAsSelf

wrap the self/oself shuffle for code cleanliness elsewhere
===============
*/
void(void() fun, entity newself) SUB_CallAsSelf =
{
	local entity oself;
	
	oself = self;
	self = newself;
	fun();
	self = oself;	
}

/*
================
InitTrigger
================
*/
void() InitTrigger =
{
// trigger angles are used for one-way touches.  An angle of 0 is assumed
// to mean no restrictions, so use a yaw of 360 instead.
	if (self.angles != '0 0 0')
		SetMovedir ();
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);	// set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
};

// Drake -- dumptruck_ds
// PM:  The point trigger version of InitTrigger.
void() InitPointTrigger =
{
    local   vector  v1, v2;

    v1 = self.origin;
    v2 = v1 + self.mangle;
    self.model = "";
    setorigin (self, '0 0 0');
    InitTrigger ();     // Calls 'setmodel', so do first.
    setsize (self, v1, v2);     // Calling 'setmodel' resets entity size.
};

/*
=============
SUB_CalcMove

calculate self.velocity and self.nextthink to reach dest from
self.origin traveling at speed
===============
*/
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt =
{
	local entity	stemp;
	stemp = self;
	self = ent;

	SUB_CalcMove (tdest, tspeed, func);
	self = stemp;
};

void(vector tdest, float tspeed, void() func) SUB_CalcMove =
{
	local vector	vdestdelta;
	local float		len, traveltime, localtime;

	if (!tspeed)
		objerror("No speed is defined!");

	if (self.movetype == MOVETYPE_PUSH) localtime = self.ltime;
	else localtime = time;

	self.think1 = func;
	self.finaldest = tdest;
	self.think = SUB_CalcMoveDone;

	if (tdest == self.origin)
	{
		self.velocity = '0 0 0';
		self.nextthink = localtime + 0.1;
		return;
	}
		
// set destdelta to the vector needed to move
	vdestdelta = tdest - self.origin;
	
// calculate length of vector
	len = vlen (vdestdelta);
	
// divide by speed to get time to reach dest
	traveltime = len / tspeed;

	if (traveltime < 0.1)
	{
		self.velocity = '0 0 0';
		self.nextthink = localtime + 0.1;
		return;
	}
	
// set nextthink to trigger a think when dest is reached
	self.nextthink = localtime + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1/traveltime);	// qcc won't take vec/float	
};

/*
============
After moving, set origin to exact final destination
============
*/
void()  SUB_CalcMoveDone =
{
	setorigin(self, self.finaldest);
	self.velocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};

/*
=============
SUB_CalcAngleMove

calculate self.avelocity and self.nextthink to reach destangle from
self.angles rotating

The calling function should make sure self.think is valid
===============
*/
void(entity ent, vector destangle, float tspeed, void() func) SUB_CalcAngleMoveEnt =
{
local entity		stemp;
	stemp = self;
	self = ent;
	SUB_CalcAngleMove (destangle, tspeed, func);
	self = stemp;
};

void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove =
{
local vector	destdelta;
local float		len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");

// set destdelta to the vector needed to move
	destdelta = destangle - self.angles;

// calculate length of vector
	len = vlen (destdelta);

// divide by speed to get time to reach dest
	traveltime = len / tspeed;

// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
	self.avelocity = destdelta * (1 / traveltime);

	self.think1 = func;
	self.finalangle = destangle;
	self.think = SUB_CalcAngleMoveDone;
};

/*
============
After rotating, set angle to exact final angle
============
*/
void() SUB_CalcAngleMoveDone =
{
	self.angles = self.finalangle;
	self.avelocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};

/*
=============
SUB_CalcAngleMoveController

Same as SUB_CalcAngleMove, but using a separate controller entity
to not lose track of current think functions.

===============
*/
void() SUB_CalcAngleMoveDoneController;

void(vector destangle, float tspeed, void() func, entity controller) SUB_CalcAngleMoveController =
{
	local vector	destdelta;
	local float		len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");
		
	// set destdelta to the vector needed to move

	destdelta = normalizeAngles180(destangle - self.angles);
	/*dprint3("destangle:   ", vtos(destangle), "\n");
	dprint3("self.angles: ", vtos( self.angles), "\n");
	dprint3("destdelta:   ", vtos(destdelta), "\n");
	*/

	// calculate length of vector
	len = vlen (destdelta);
	
	// divide by speed to get time to reach dest
	traveltime = len / tspeed;

	// set nextthink to trigger a think when dest is reached
	controller.nextthink = time + traveltime;

	// scale the destdelta vector by the time spent traveling to get velocity
	self.avelocity = destdelta * (1 / traveltime);
	
	// Makes sure controller.owner points to self so it can be referenced later in the think function
	controller.owner = self;  
	controller.think1 = func;
	controller.finalangle = destangle;
	controller.think = SUB_CalcAngleMoveDoneController;
};

/*
============
After rotating, set angle to exact final angle
============
*/
void() SUB_CalcAngleMoveDoneController =
{
	self.owner.angles = self.finalangle;
	self.owner.avelocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		SUB_CallAsSelf(self.think1, self.owner);
};


//=============================================================================

void() DelayThink =
{
	activator = self.enemy;
	SUB_UseTargets ();
	remove(self);
};

/* ### (added targets, killtargets, and targetnames)
==============================
SUB_UseTargets

the global "activator" should be set to the entity that initiated the firing.

If self.delay is set, a DelayedUse entity will be created that will actually
do the SUB_UseTargets after that many seconds have passed.

Centerprints any self.message to the activator.

Removes all entities with a targetname that match self.killtarget,
or killtarget2, so some events can remove other triggers.

Search for (string)targetname, targetname2, targetname3, and targetname 4
in all entities that match (string)self.target, self.target2, self.target3,
or self.target4 and use their .use function.
==============================
*/
void(string matchstring, .string matchfield) SUB_UseSpecificTarget =
{
	local entity t, stemp, otemp, act;

	act = activator;
	t = find (world, matchfield, matchstring);
	while ( t != world )
	{
		stemp = self;
		otemp = other;
		self = t;
		other = stemp;
		if (self.use != SUB_Null)
		{
			if (self.use)
			{
				lastnameused = matchstring;
				self.use ();
			}
		}
		self = stemp;
		other = otemp;
		activator = act;
		t = find (t, matchfield, matchstring);
	}
};

void() SUB_UseTargets =
{
//	local entity t, stemp, otemp, act;
	local entity t;

	if (self.estate != STATE_ACTIVE) return;
//
// check for a delay
//
	if (self.delay)
	{
	// create a temp object to fire at a later time
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.killtarget2 = self.killtarget2;
		t.target = self.target;
		t.target2 = self.target2;
		t.target3 = self.target3;
		t.target4 = self.target4;
		return;
	}


//
// print the message
//
	if (self.message != "" && !(self.flags & FL_NOCENTERPRINT)) {
		if (self.spawnflags & TRIGGER_CENTERPRINTALL) {
			t = find(world, classname, "player");
			while (t) {
				centerprint (t, self.message);
				if (!self.noise)
					sound (t, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
				t = find(t, classname, "player");
			}
		}
		
		else if (activator.classname == "player") {
			centerprint (activator, self.message);
			if (!self.noise)
				sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
		}	
	}

//
// kill the killtarget entities
//
	if (self.killtarget != "")
	{
		t = find(world, targetname, self.killtarget);
		while(t != world)
		{
			if(t.switchshadstyle) lightstyle(t.switchshadstyle, "m");
			remove(t);
			t = find(t, targetname, self.killtarget);
		}
		t = find(world, targetname2, self.killtarget);
		while(t != world)
		{
			if(t.switchshadstyle) lightstyle(t.switchshadstyle, "m");
			remove(t);
			t = find(t, targetname2, self.killtarget);
		}
		t = find(world, targetname3, self.killtarget);
		while(t != world)
		{
			if(t.switchshadstyle) lightstyle(t.switchshadstyle, "m");
			remove(t);
			t = find(t, targetname3, self.killtarget);
		}
		t = find(world, targetname4, self.killtarget);
		while(t != world)
		{
			if(t.switchshadstyle) lightstyle(t.switchshadstyle, "m");
			remove(t);
			t = find(t, targetname4, self.killtarget);
		}
	}

//
// kill the killtaget2 entities
//
	if (self.killtarget2 != "")
	{
		t = find(world, targetname, self.killtarget2);
		while(t != world)
		{
			if(t.switchshadstyle) lightstyle(t.switchshadstyle, "m");
			remove(t);
			t = find(t, targetname, self.killtarget2);
		}
		t = find(world, targetname2, self.killtarget2);
		while(t != world)
		{
			if(t.switchshadstyle) lightstyle(t.switchshadstyle, "m");
			remove(t);
			t = find(t, targetname2, self.killtarget2);
		}
		t = find(world, targetname3, self.killtarget2);
		while(t != world)
		{
			if(t.switchshadstyle) lightstyle(t.switchshadstyle, "m");
			remove(t);
			t = find(t, targetname3, self.killtarget2);
		}
		t = find(world, targetname4, self.killtarget2);
		while(t != world)
		{
			if(t.switchshadstyle) lightstyle(t.switchshadstyle, "m");
			remove(t);
			t = find(t, targetname4, self.killtarget2);
		}
	}

//
// fire targets
//

// target 1
	if (self.target != "")
	{
		SUB_UseSpecificTarget(self.target, targetname);
		SUB_UseSpecificTarget(self.target, targetname2);
		SUB_UseSpecificTarget(self.target, targetname3);
		SUB_UseSpecificTarget(self.target, targetname4);
	}

// target 2
	if (self.target2 != "")
	{
		SUB_UseSpecificTarget(self.target2, targetname);
		SUB_UseSpecificTarget(self.target2, targetname2);
		SUB_UseSpecificTarget(self.target2, targetname3);
		SUB_UseSpecificTarget(self.target2, targetname4);
	}

// target 3
	if (self.target3 != "")
	{
		SUB_UseSpecificTarget(self.target3, targetname);
		SUB_UseSpecificTarget(self.target3, targetname2);
		SUB_UseSpecificTarget(self.target3, targetname3);
		SUB_UseSpecificTarget(self.target3, targetname4);
	}

// target 4
	if (self.target4 != "")
	{
		SUB_UseSpecificTarget(self.target4, targetname);
		SUB_UseSpecificTarget(self.target4, targetname2);
		SUB_UseSpecificTarget(self.target4, targetname3);
		SUB_UseSpecificTarget(self.target4, targetname4);
	}
};

void(string matchstring) SUB_UseName =
{
	SUB_UseSpecificTarget(matchstring, targetname);
	SUB_UseSpecificTarget(matchstring, targetname2);
	SUB_UseSpecificTarget(matchstring, targetname3);
	SUB_UseSpecificTarget(matchstring, targetname4);
};
// ### end of Custents triggering code

/*
=============
SUB_UseEntTargets
===============
*/
void(entity t) SUB_UseEntTargets =
{
	if (t == world) return;
	activator = self;
	entity oself = self;
	self = t;
	SUB_UseTargets();
	self = oself;
}

/*
================
SUB_UseAndForgetTargets

This calls SUB_UseTargets, then clears all of self's fields that cause
SUB_UseTargets to do things.  The intention is that if SUB_UseTargets
gets called again in the future, it won't do anything.  Call this
function if you want an entity to fire its targets just this once, and
never again.

Note that this function relies on the fact that SUB_UseTargets has
already been modified to work around the engine bug involving tests of
the form 'if (string)', i.e. that the tests in SUB_UseTargets are now of
the form 'if (string != "")'.  -- iw
================
*/
void() SUB_UseAndForgetTargets =
{
	SUB_UseTargets ();

	self.delay = 0;
	self.killtarget = "";
	self.killtarget2 = "";
	self.message = "";
	self.target = "";
	self.target2 = "";
	self.target3 = "";
	self.target4 = "";
};

/*
================
SUB_FieldIsTargeted

Return TRUE if the "fld" field of this entity is non-empty and matches
the target (or target2/3/4 or pain_target) field of any other entity,
otherwise return FALSE.  -- iw
================
*/
float(.string fld) SUB_FieldIsTargeted =
{
	if (self.fld == "")
		return FALSE;

	// the following function calls are staggered to avoid the silly
	// "return value conflict" problem with traditional compilers -- iw

	if (find (world, target, self.fld) != world)
		return TRUE;

	if (find (world, target2, self.fld) != world)
		return TRUE;

	if (find (world, target3, self.fld) != world)
		return TRUE;

	if (find (world, target4, self.fld) != world)
		return TRUE;

	if (find (world, pain_target, self.fld) != world)
		return TRUE;

	return FALSE;
};

/*
================
SUB_IsTargeted

Return TRUE if the targetname (or targetname2/3/4) field of this entity
is non-empty and matches the target (or target2/3/4 or pain_target)
field of any other entity, otherwise return FALSE.  -- iw
================
*/
float() SUB_IsTargeted =
{
	// the following function calls are staggered to avoid the silly
	// "return value conflict" problem with traditional compilers -- iw

	if (SUB_FieldIsTargeted (targetname))
		return TRUE;

	if (SUB_FieldIsTargeted (targetname2))
		return TRUE;

	if (SUB_FieldIsTargeted (targetname3))
		return TRUE;

	if (SUB_FieldIsTargeted (targetname4))
		return TRUE;

	return FALSE;
};

//
// pain_target //dumptruck_ds
//
void() SUB_UsePain =
{
	if (self.pain_target != "")
	{
		SUB_UseSpecificTarget (self.pain_target, targetname);
		SUB_UseSpecificTarget (self.pain_target, targetname2);
		SUB_UseSpecificTarget (self.pain_target, targetname3);
		SUB_UseSpecificTarget (self.pain_target, targetname4);
	}
	self.pain_target = "";  //dumptruck_ds via Discord - thanks Spike, Snaut and QueenJazz
};

/*

in nightmare mode, all attack_finished times become 0
some monsters refire twice automatically

*/

void(float normal) SUB_AttackFinished =
{
	self.cnt = 0;		// refire count for nightmare
	if (skill != 3)
		self.attack_finished = time + normal;
};

float (entity targ) visible;

void (void() thinkst) SUB_CheckRefire =
{
	if (skill != 3)
		return;
	if (self.cnt == 1)
		return;
	if (!visible (self.enemy))
		return;
	self.cnt = 1;
	self.think = thinkst;
};

/*
================
SUB_DislodgeRestingEntities

This clears the FL_ONGROUND flag from any entities that are on top of
self.

The engine does not update the FL_ONGROUND flag automatically in some
cases, with the result that certain types of entities can be left
floating in mid-air if the entity they are resting on is removed from
under them.  This function is intended to be called in the case where
self is going to be removed, to ensure that other entities are not left
floating.  -- iw
================
*/
void() SUB_DislodgeRestingEntities =
{
	local entity e;

	e = nextent (world);
	while (e != world)
	{
		if ((e.flags & FL_ONGROUND) && e.groundentity == self)
			e.flags = e.flags - (e.flags & FL_ONGROUND);
		e = nextent (e);
	}
};
//------------------------------------------------------------------------//
//  Drake -- This makes an entity do a think function right now.
//------------------------------------------------------------------------//
void(entity ent, void() thinkst) SUB_Think =
{
    local   entity  swap;

    swap = self;
    self = ent;
    thinkst ();
    self = swap;
};

/// from Copper -- dumptruck_ds (orginally found in triggers.qc)
/*
================================
CheckValidTouch
health and playerhood checks were duplicated everywhere
added noclip check because Quake's default still-touch-everything noclip is awful
================================
*/
float() CheckValidTouch =
{
	if (other.classname != "player")
		return FALSE;
	if (other.health <= 0)
		return FALSE;
	if (other.movetype == MOVETYPE_NOCLIP)
		return FALSE;
	if (self.estate != STATE_ACTIVE)
		return FALSE;
	return TRUE;
}
float(float a, float b) not = { return a - (a & b); } // fix not issue in client.qc - Copper -- dumptruck_ds

void() SUB_EndWaiting = {
	self.is_waiting = 0;
	self.estate = STATE_ACTIVE;
	if (self.use == SUB_EndWaiting) self.use = self.dormant_use;

	// special case for teleports, makes it ignore the fact that it has a targetname when touched
	if (self.classname == "trigger_teleport") {
		self.is_waiting = -1;
	}
};

void() SUB_CheckWaiting = {
	if (self.is_waiting > 0) {
		self.dormant_use = self.use;
		self.use = SUB_EndWaiting;
		self.estate = STATE_INACTIVE;

		dprint("Spawned a waiting ");
		dprint(self.classname);
		dprint(" with targetname ");
		dprint(self.targetname);
		dprint(" and target ");
		dprint(self.target);
		dprint("\n");
	}
};