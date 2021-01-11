

void() plat_center_touch;
void() plat_outside_touch;
void() plat_trigger_use;
void() plat_go_up;
void() plat_go_down;
void() plat_crush;
float PLAT_LOW_TRIGGER = 1;

void() plat_spawn_inside_trigger =
{
	local entity	trigger;
	local vector	tmin, tmax;

//
// middle trigger
//
	trigger = spawn();
	trigger.touch = plat_center_touch;
	trigger.movetype = MOVETYPE_NONE;
	trigger.solid = SOLID_TRIGGER;
	trigger.enemy = self;

	tmin = self.mins + '25 25 0';
	tmax = self.maxs - '25 25 -8';
	tmin_z = tmax_z - (self.pos1_z - self.pos2_z + 8);
	if (self.spawnflags & PLAT_LOW_TRIGGER)
		tmax_z = tmin_z + 8;

	if (self.size_x <= 50)
	{
		tmin_x = (self.mins_x + self.maxs_x) / 2;
		tmax_x = tmin_x + 1;
	}
	if (self.size_y <= 50)
	{
		tmin_y = (self.mins_y + self.maxs_y) / 2;
		tmax_y = tmin_y + 1;
	}

	setsize (trigger, tmin, tmax);
};

void() plat_hit_top =
{
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_TOP;
	self.think = plat_go_down;
	self.nextthink = self.ltime + 3;
};

void() plat_hit_bottom =
{
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_BOTTOM;
};

void() plat_go_down =
{
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos2, self.speed, plat_hit_bottom);
};

void() plat_go_up =
{
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove (self.pos1, self.speed, plat_hit_top);
};

void() plat_center_touch =
{
	// from Copper -- dumptruck_ds
	if (!CheckValidTouch()) return;

	self = self.enemy;
	if (self.state == STATE_BOTTOM)
		plat_go_up ();
	else if (self.state == STATE_TOP)
		self.nextthink = self.ltime + 1;	// delay going down
};

void() plat_outside_touch =
{
	// from Copper -- dumptruck_ds
	if (!CheckValidTouch()) return;

//dprint ("plat_outside_touch\n");
	self = self.enemy;
	if (self.state == STATE_TOP)
		plat_go_down ();
};

void() plat_trigger_use =
{
	if (self.think)
		return;		// allready activated
	plat_go_down();
};


void() plat_crush =
{
//dprint ("plat_crush\n");

	T_Damage (other, self, self, 1);

	if (self.state == STATE_UP)
		plat_go_down ();
	else if (self.state == STATE_DOWN)
		plat_go_up ();
	else
		objerror ("plat_crush: bad self.state\n");
};

void() plat_use =
{
	self.use = SUB_Null;
	if (self.state != STATE_UP)
		objerror ("plat_use: not in up state");
	plat_go_down();
};


/*QUAKED func_plat (0 .5 .8) ? PLAT_LOW_TRIGGER X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

speed default 150

Plats are always drawn in the extended position, so they will light correctly.

If the plat is the target of another trigger or button, it will start out disabled in the extended position until it is trigger, when it will lower and become a normal plat.

If the "height" key is set, that will determine the amount the plat moves, instead of being implicitly determined by the model's height.
Set "sounds" to one of the following:
1) base fast
2) chain slow
*/


void() func_plat =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (!self.t_length)
		self.t_length = 80;
	if (!self.t_width)
		self.t_width = 10;

	if (self.sounds == 0)
		self.sounds = 2;
// FIX THIS TO LOAD A GENERIC PLAT SOUND

	if (self.sounds == 1)
	{
		precache_sound ("plats/plat1.wav");
		precache_sound ("plats/plat2.wav");
		self.noise = "plats/plat1.wav";
		self.noise1 = "plats/plat2.wav";
	}

	if (self.sounds == 2)
	{
		precache_sound ("plats/medplat1.wav");
		precache_sound ("plats/medplat2.wav");
		self.noise = "plats/medplat1.wav";
		self.noise1 = "plats/medplat2.wav";
	}


	self.mangle = self.angles;
	self.angles = '0 0 0';

	self.classname = "plat";
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);

	self.blocked = plat_crush;
	if (!self.speed)
		self.speed = 150;

// pos1 is the top position, pos2 is the bottom
	self.pos1 = self.origin;
	self.pos2 = self.origin;
	if (self.height)
		self.pos2_z = self.origin_z - self.height;
	else
		self.pos2_z = self.origin_z - self.size_z + 8;

	self.use = plat_trigger_use;

	plat_spawn_inside_trigger ();	// the "start moving" trigger

	if (self.targetname != "")
	{
		self.state = STATE_UP;
		self.use = plat_use;
	}
	else
	{
		setorigin (self, self.pos2);
		self.state = STATE_BOTTOM;
	}
};

//============================================================================
//re-triggered trains from Rubicon 2 - dumptruck_ds
//============================================================================

void() train_next;
void() func_train_find;

float TRAIN_RETRIGGER = 1; //johnfitz -- retriggerable trains

void() train_blocked =
{
	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 0.5;
	T_Damage (other, self, self, self.dmg);
};
void() train_use =
{
	//johnfitz -- retriggerable trains
	if (self.spawnflags & TRAIN_RETRIGGER) {
		train_next();
		return;
	}
	//johnfitz

	if (self.think != func_train_find)
		return;		// already activated
	train_next();
};

//johnfitz
void() train_moving_use =
{
	//still moving, so save it for later
	self.cnt = self.cnt + 1;
}
//johnfitz

void() train_wait =
{
	//johnfitz -- retriggerable trains
	if (self.spawnflags & TRAIN_RETRIGGER) {
		if (self.cnt > 0) { //triggered early, so continue now
			self.cnt = self.cnt - 1;
			self.nextthink = self.ltime + 0.1;
			self.think = train_next;
			return;
		}
		self.use = train_use; //ready to be re-triggered
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM); //play stopping sound
		return;
	}
	//johnfitz

	if (self.wait)
	{
		self.nextthink = self.ltime + self.wait;
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	}
	else
		self.nextthink = self.ltime + 0.1;

	self.think = train_next;
};

void() train_next =
{
	local entity	targ;

	//johnfitz -- retriggerable trains
	if (self.spawnflags & TRAIN_RETRIGGER) {
		self.use = train_moving_use; //store up any premature triggerings until current movement is finished
	}
	//johnfitz

	targ = find (world, targetname, self.target);
	self.target = targ.target;
	if (!self.target)
		objerror ("train_next: no next target");
	if (targ.wait)
		self.wait = targ.wait;
	else
		self.wait = 0;
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	SUB_CalcMove (targ.origin - self.mins, self.speed, train_wait);
};

void() func_train_find =

{
	local entity	targ;

	targ = find (world, targetname, self.target);
	self.target = targ.target;
	setorigin (self, targ.origin - self.mins);
	if (!self.targetname)
	{	// not triggered, so start immediately
		self.nextthink = self.ltime + 0.1;
		self.think = train_next;
	}
};

/*QUAKED func_train (0 .5 .8) ? RETRIGGER X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Trains are moving platforms that players can ride.
The targets origin specifies the min point of the train at each corner.
The train spawns at the first target it is pointing at.
If the train is the target of a button or trigger, it will not begin moving until activated.

RETRIGGER: stop at each path_corner and don't resume until triggered again (ignores wait time)

speed default 100
dmg default 2
noise path to custom sound
sounds
1) ratchet metal
2) base
3) custom

*/
void() func_train =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

// Some of the stock id1 maps (at least e2m7, e3m3, and e3m6) contain
// one or more func_train entities which have spawnflag 1 erroneously
// set.  In the id1 progs.dat, spawnflag 1 didn't do anything, but in
// progs_dump it does: it's the "RETRIGGER" spawnflag.  So, if one of
// the id1 maps is being played, we clear this spawnflag to maintain the
// original behavior.  -- iw
//
	if (known_release == KNOWN_RELEASE_ID1 &&
			(self.spawnflags & TRAIN_RETRIGGER))
	{
		dprint ("WARNING: progs.dat sanitized 'RETRIGGER' spawnflag of func_train\n");
		self.spawnflags = self.spawnflags -
				(self.spawnflags & TRAIN_RETRIGGER);
	}

	if (!self.speed)
		self.speed = 100;
	if (!self.target)
		objerror ("func_train without a target");
	if (!self.dmg)
		self.dmg = 2;

	if (self.sounds == 0)
	{
		self.noise = ("misc/null.wav");
		precache_sound ("misc/null.wav");
		self.noise1 = ("misc/null.wav");
		precache_sound ("misc/null.wav");
	}

	if (self.sounds == 1)
	{
		self.noise = ("plats/train2.wav");
		precache_sound ("plats/train2.wav");
		self.noise1 = ("plats/train1.wav");
		precache_sound ("plats/train1.wav");
	}

	//johnfitz -- more sounds
	if (self.sounds == 2)
	{
		self.noise = "doors/hydro2.wav";
		precache_sound ("doors/hydro2.wav");
		self.noise1 = "doors/hydro1.wav";
		precache_sound ("doors/hydro1.wav");
	}

	if (self.sounds == 3) //custom sounds -- dumptruck_ds
	{
		self.noise = self.noise3;  //stop sound
		precache_sound (self.noise3);
		self.noise1 = self.noise4; //sound in motion
		precache_sound (self.noise4);
	}

	//johnfitz

	self.cnt = 0; //johnfitz -- used to store premature trigger events when TRAIN_RETRIGGER is set

	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.classname = "train";

	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);

// start trains on the second frame, to make sure their targets have had
// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};

//Code for the fixed teleporttrain written by c0burn and modified by ZungryWare
void() teleporttrain_calcmove;
void() teleporttrain_next =
{
	local vector dir;
	setorigin(self, self.enemy.origin + '16 16 16');

	if (!self.target)
	{
		self.enemy = world;
		return;
	}
	self.enemy = find(world, targetname, self.target);
	if (self.enemy.classname == "path_corner")
	{
		dir = normalize((self.enemy.origin + '16 16 16') - self.origin);
		self.velocity = dir * self.speed;
		self.target = self.enemy.target;
	}
	else
	{
		objerror("unable to find target\n");
		remove(self);
	}
	teleporttrain_calcmove();
};
void() teleporttrain_wait =
{
	local float wait_time;
	if (self.enemy.wait > 0)
		wait_time = self.enemy.wait;
	else
		wait_time = .1;
	self.velocity = '0 0 0';
	self.nextthink = time + wait_time;
	self.think = teleporttrain_next;

}
void() teleporttrain_calcmove =
{
	local float len;
	local vector delta;
	local float spd;

	delta = (self.enemy.origin + '16 16 16') - self.origin;
	len = vlen(delta);
	spd = vlen(self.velocity);
	self.nextthink = time + (len / spd);
	self.think = teleporttrain_wait;
};
void() teleporttrain_use =
{
	if (self.velocity == '0 0 0')
	{
		teleporttrain_next();
	}
};
void() teleporttrain_find =
{
	// always start positioned on the first path_corner
	self.enemy = find(world, targetname, self.target);
	if (self.enemy.classname == "path_corner")
	{
		setorigin (self, self.enemy.origin + '16 16 16');
		self.target = self.enemy.target;
		}
	else
	{
		objerror("unable to find target\n");
		remove(self);
		return;
	}

	if (self.spawnflags & 4) // start immediately even with a targetname
	{
		teleporttrain_next();
	}
	// not triggered, so start immediately
	else if (!self.targetname)
	{
		teleporttrain_next();
	}
	else
	{
		self.use = teleporttrain_use;
	}
};
/*QUAKED misc_teleporttrain (.5 .5 .5) (-16 -16 -16) (16 16 16) X DONT_ROTATE START_ON_WITH_TARGETNAME INVISIBLE X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{	model("progs/teleport.mdl");	}
This was used for the final boss level in the original game. In progs_dump you can use this as a moving decoration or even target it as a spawn point for a func_monster_spawner. Make sure and select the Don't Rotate spawnflag though or you'll experience a pretty hilarious effect!

You set this up like a func_train using path_corners. By default, it will move automatically between path corners upon map load. However, you can have it wait to move by giving it a targetname. If you need to target it as a spawner and want it to move on map load, use the Start On spawnflag.

You can add effects, use a custom model using the mdl_body keyvalue and even make it invisible with spawnflag 8.

Effects
0: "None (Default)"
1 : "Brightfield (yellow particles)"
4 : "Bright light"
8 : "Dim light"


Teleporter target for final boss level. Must target a series of 'path_corner' entities.
It will position itself on its first target at map load.
If a targetname is set, it must be triggered to start moving, otherwise it will start automatically.
*/
void() misc_teleporttrain =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (!self.target)
	{
		objerror ("misc_teleporttrain has no target");
		remove(self);
		return;
	}
	if (self.speed <= 0)
	{
		self.speed = 100;
	}

	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_FLY;
	precache_body_model ("progs/teleport.mdl");  // custom custom_mdls -- dumptruck_ds
	precache_model ("progs/s_null.spr");  // invisble -- dumptruck_ds
	if (self.spawnflags & 8)
	// setmodel (self, "progs/s_null.spr");
	body_model ("progs/s_null.spr");
	else
	body_model ("progs/teleport.mdl");
	// precache_model ("progs/teleport.mdl");
	setsize (self, '-16 -16 -16', '16 16 16');

	//Causes the ball to spin around like it was originally intended to.
	if (!(self.spawnflags & 2)) 			//don't spin - helpful for invisible spawner -- dumptruck_ds
	self.avelocity = '40 80 120';
	// self.avelocity = '100 200 300';

	self.think = teleporttrain_find;
	self.nextthink = time + 0.1;
};
