/*
====================

Fog controllers
Based on Copper's fog by Lunaran
Changed by bmFbr

====================
*/

float FOG_INTERVAL = 0.04166667; // 1/24;
/*FGD
@baseclass = Fog [
	fog_density(string) : "Fog Density"
	fog_color(string) : "Fog Color"
]
@baseclass = FogShift [
	fog_density(string) : "Start Fog Density"
	fog_color(string) : "Start Fog Color"
	fog_density2(string) : "End Fog Density"
	fog_color2(string) : "End Fog Color"
]
*/

/*
================
fog_save
================
*/
void( entity client, float density, vector color ) fog_save =
{
	if (client.classname != "player") return;

	// save whatever we set the client's fog to in case of saves/loads
	client.fog_density = density;
	client.fog_color = color;
}

void( entity client ) fog_save_to_previous =
{
	if (client.classname != "player") return;

	// copies the current fog to the secondary fields to transition from the current fog
	client.fog_density2 = client.fog_density;
	client.fog_color2 = client.fog_color;
}

void( entity client, float density) skyfog_save =
{
	if (client.classname != "player") return;

	client.skyfog_density = density;
}

void( entity client ) skyfog_save_to_previous =
{
	if (client.classname != "player") return;

	client.skyfog_density2 = client.skyfog_density;
}
/*
================
fog_setFromEnt
================
*/
void( entity client, entity fogger ) fog_setFromEnt =
{
	float density;
	//
	// Don't set the fog if the entity has no values, because it might be a custom map with
	// _fog on the worldspawn instead.
	// To actually get an entity to clear the fog, density to -1.
	// The same applies to skyfog

	//eprint(fogger);

	//dprint3("fog_density: ", ftos(fogger.fog_density*100), "\n");
	if (fogger.fog_density) {
		dprint("setting fog\n");
		density = zeroconvert(fogger.fog_density);
		fog_set(client, density, fogger.fog_color);
	}

	//dprint3("skyfog_density: ", ftos(fogger.skyfog_density*100), "\n");
	if (fogger.skyfog_density) {
		dprint("setting skyfog\n");
		density = zeroconvert(fogger.skyfog_density);
		skyfog_set(client, density);
	}
}

/*
================
fog_set
================
*/
void( entity client, float density, vector color) fog_set =
{
	if (client.classname != "player") return;

	//dprint9("Setting fog: ", ftos(density), " ", ftos(color_x), " ", ftos(color_y), " ", ftos(color_z), "\n");

	stuffcmd(client, "\nfog ");
	stuffcmd_float(client, density);
	stuffcmd(client, " ");
	stuffcmd_float(client, color_x);
	stuffcmd(client, " ");
	stuffcmd_float(client, color_y);
	stuffcmd(client, " ");
	stuffcmd_float(client, color_z);
	stuffcmd(client, "\n");

	fog_save(client, density, color);
}


void( entity client, float density) skyfog_set =
{
	if (client.classname != "player") return;

	//dprint3("Setting skyfog: ", ftos(density), "\n");

	stuffcmd(client, "\nr_skyfog ");
	stuffcmd_float(client, density);
	stuffcmd(client, "\n");

	skyfog_save(client, density);
}

/*
================
fog_blendTouch
================
*/
void() fog_blendTouch =
{
	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;

	if (self.estate != STATE_ACTIVE)
		return;

	// fix for only first client getting a fog change when multiple coop clients are touching this at once
	if (time != self.rad_time)	// because fog is rad
		if (time < self.attack_finished)
			return;

	float f, lerp_density, leaving;
	float lerp_sdensity;
	float ent_density, ent_density2, ent_sdensity, ent_sdensity2;
	vector dorg, mid, ovel;
	vector lerp_color;

	ent_density = zeroconvert(self.fog_density);
	ent_density2 = zeroconvert(self.fog_density2);

	ent_sdensity = zeroconvert(self.skyfog_density);
	ent_sdensity2 = zeroconvert(self.skyfog_density2);

	// if you run/fall through a fogblend fast enough you can come out the other side
	// partially blended, so check if player will exit the trigger bounds before the
	// next touch (same class of bug as leaping through lasers in Q2)
	ovel = other.velocity * FOG_INTERVAL;
	leaving = ( (other.absmax_x + ovel_x < self.absmin_x) ||
				(other.absmax_y + ovel_y < self.absmin_y) ||
				(other.absmax_z + ovel_z < self.absmin_z) ||
				(other.absmin_x + ovel_x > self.absmax_x) ||
				(other.absmin_y + ovel_y > self.absmax_y) ||
				(other.absmin_z + ovel_z > self.absmax_z) );

	if (leaving)
	{
		// last chance to set fog correctly, so snap it to the final values
		leaving = other.velocity * self.movedir;
		if (leaving > 0)
		{
			lerp_density = ent_density2;
			lerp_color = self.fog_color2;
			lerp_sdensity = ent_sdensity2;
		}
		else
		{
			lerp_density = ent_density;
			lerp_color = self.fog_color;
			lerp_sdensity = ent_sdensity;
		}
	}
	else
	{
		// in transition, blend proportionally between the two fogs
		mid = (self.mins + self.maxs) * 0.5;
		dorg = other.origin + other.view_ofs - mid;

		f = dorg * self.movedir;
		f = (f / self.distance) + 0.5;

		lerp_density = lerp(ent_density, ent_density2, f);
		lerp_color = lerpVector(self.fog_color, self.fog_color2, f);
		lerp_sdensity = lerp(ent_sdensity, ent_sdensity2, f);
	}

	if (self.fog_density || self.fog_density2) fog_set(other, lerp_density, lerp_color);
	if (self.skyfog_density || self.skyfog_density2) skyfog_set(other, lerp_sdensity);

	self.rad_time = time;
	self.attack_finished = time + FOG_INTERVAL;

	// reset client's fogblend_entity in case it's currently being transitioned by another entity
	other.fogblend_entity = world;
}


/*QUAKED trigger_fogblend (.5 .5 .2) ?
Acts as a smoothly blending portal between two zones of different fog. Sets the fog for any client passing through it, blending their global fog settings between "fog_color"/"fog_density" and "fog_color2"/"fog_density2" proportional to their position within the trigger.
The axis of motion on which the blend happens is defined by "angle", pointing to whatever zone has color2 and density2.  Trigger therefore has two 'sides' - the side that "angle" points to, and the opposite side.

"distance" - override the length of the blend period in world units - defaults to bounds size
	on 'angle' otherwise. this is only useful for diagonal triggers.

CAVEATS:
- will 'stuffcmd' 2 dozen times per frame so try not to make these huge
- a bug in most quake engine ports will reset the eye position smoothing that happens when climbing stairs or riding a plat on every frame that a 'stuffcmd' is sent, so fog transitions during upwards motion will cause noticeable stuttering.
*/
/*FGD
@SolidClass base(Appearflags, Targetname, Target, FogShift) = trigger_fogblend :
"Trigger: Fog Blend
Acts as a smoothly blending portal between two zones of different fog. Sets the fog for any client passing through it, blending their global fog settings between start and end values proportional to their position within the trigger.

- will 'stuffcmd' 2 dozen times per frame so try not to make these huge
- a bug in most quake engine ports will reset the eye position smoothing that happens when climbing stairs or riding a plat on every frame that a 'stuffcmd' is sent, so fog transitions during upwards motion will cause noticeable stuttering."
[
	distance(integer) : "Length of blend distance (defaults to size of trigger)"
	angle(integer) : "Axis of motion of blend (points toward end values)"
]
*/
void() trigger_fogblend =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (self.angles == '0 0 0')		// InitTrigger assumes angle 0 means no angle
		self.angles = '0 360 0';

	InitTrigger ();
	self.touch = fog_blendTouch;
	self.distance = zeroconvertdefault(self.distance, BoundsAngleSize(self.movedir, self.size));

	SUB_CheckWaiting();
}


/*
================
fog_blendTimeThink
used by both trigger_fog and target_fogblend
================
*/

float FOGBLEND_ONEWAY = 1;
float FOGBLEND_REVERSE = 2;
float FOGBLEND_ALLCLIENTS = 4;
float FOGBLEND_BLENDTO = 8;

void(entity cl, float sTo, float f) skyfog_blendSetFraction = {
	float s;

	s = lerpHermite(cl.skyfog_density2, sTo, f);

	//eprint(cl);
	//dprint3("Fraction skyfog density: ", ftos(s), "\n");

	skyfog_set(cl, s);
};

void(entity cl, vector cTo, float dTo, float f) fog_blendSetFraction = {
	float d;
	vector c;

	d = lerpHermite(cl.fog_density2, dTo, f);
	c = lerpVectorHermite(cl.fog_color2, cTo, f);

	/*
	eprint(cl);
	dprint3("fog density: ", ftos(d), "\n");
	dprint3("color: ", vtos(c), "\n");
	dprint3("fraction: ", ftos(f), "\n");
	*/

	fog_set(cl, d, c);
};

void() fog_blendTimeThink = {
	float f;
	float dTo, sTo;
	vector cTo;

	if (time >= self.pain_finished)	{
		f = 1;
	}
	else {
		self.nextthink = time + FOG_INTERVAL;
		if (self.state && self.speed)
			f = 1 - (self.pain_finished - time) / self.speed;
		else if (self.speed2)
			f = 1 - (self.pain_finished - time) / self.speed2;
		else
			f = 1;
	}

	if (self.state) {
		dTo = self.fog_density2;
		cTo = self.fog_color2;
		sTo = self.skyfog_density2;
	}
	else {
		dTo = self.fog_density;
		cTo = self.fog_color;
		sTo = self.skyfog_density;
	}

	if (self.spawnflags & FOGBLEND_ALLCLIENTS) {
		entity pl;
		pl = nextent(world);
		while (pl.flags & FL_CLIENT) {
			if (pl.fogblend_entity == self) {
				if (dTo && !(pl.fog_density2 == dTo && pl.fog_color2 == cTo))
					fog_blendSetFraction(pl, cTo, zeroconvert(dTo), f);

				if (sTo)
					skyfog_blendSetFraction(pl, zeroconvert(sTo), f);

				if (time >= self.pain_finished)
					pl.fogblend_entity = world;
			}

			pl = nextent(pl);
		}
	}
	else {
		if (self.enemy.fogblend_entity == self) {
			if (dTo && !(self.enemy.fog_density2 == dTo && self.enemy.fog_color2 == cTo))
				fog_blendSetFraction(self.enemy, cTo, zeroconvert(dTo), f);

			if (sTo)
				skyfog_blendSetFraction(self.enemy, zeroconvert(sTo), f);

			if (time >= self.pain_finished) {
				self.enemy.fogblend_entity = world;

			}
		}
	}

	if (self.classname == "fog_controller"){
		if (self.enemy.fogblend_entity != self || time >= self.pain_finished) {
			remove(self);
			return;
		}
	}
};



/**************************************

target_fogblend

**************************************/

void() target_fogblend_use = {

	self.enemy = activator;
	if (self.enemy.classname != "player") return;


	if (!(self.spawnflags & FOGBLEND_ONEWAY))
		self.state = 1 - self.state;

	if (self.state)
		self.pain_finished = time + self.delay + self.speed;
	else
		self.pain_finished = time + self.delay + self.speed2;


	if (self.spawnflags & FOGBLEND_ALLCLIENTS) {
		entity pl;
		pl = nextent(world);
		while (pl.flags & FL_CLIENT) {
			if (self.fog_density) fog_save_to_previous(pl);
			if (self.skyfog_density) skyfog_save_to_previous(pl);

			pl.fogblend_entity = self;

			pl = nextent(pl);
		}
	}
	else {
		if (self.fog_density) fog_save_to_previous(self.enemy);
		if (self.skyfog_density) skyfog_save_to_previous(self.enemy);

		self.enemy.fogblend_entity = self;
	}

	self.nextthink = time + self.delay;
};




/*QUAKED target_fogblend (.5 .5 .2) (-8 -8 -8) (8 8 8) ONE_WAY REVERSE GLOBAL BLENDTO
Blends the fog for a client.  activator's fog will be blended from "fog_color" and "fog_density"
to "fog_color2" and "fog_density2".  Triggering again will blend it back, unless ONE_WAY is set.
Set REVERSE if you're tired of swapping the values by hand.
Set GLOBAL to affect all clients in multiplayer, not just the activator.

"delay" - pause before beginning to blend
"speed" - time to spend blending, -1 for an instant change to fog2.
"speed2" - time to spend blending back, if different than "speed". -1 for instant.

CAVEATS:
- will 'stuffcmd' 2 dozen times per frame so try not to make this take too long
- a bug in most quake engine ports will reset the eye position smoothing that happens when climbing stairs or riding a plat on every frame that a 'stuffcmd' is sent, so fog transitions during upwards motion will cause noticeable stuttering.
*/
/*FGD
@PointClass base(Appearflags, Targetname, Target, FogShift) color(128 128 50) = target_fogblend :
"Target: Fog Blend
Activator's fog will be blended over time from start to end values.

- will 'stuffcmd' 2 dozen times per frame so try not to make this take too long
- a bug in most quake engine ports will reset the eye position smoothing that happens when climbing stairs or riding a plat on every frame that a 'stuffcmd' is sent, so fog transitions during upwards motion will cause noticeable stuttering."
[
	spawnflags(flags) = [
		1 : "One-Way Only" : 0
		2 : "Reverse Start/End" : 0
		4 : "All clients" : 0
	]
	delay(string) : "Pause before starting blend"
	speed(string) : "Time to blend (-1 for instant)"
	speed2(string) : "Time to blend back, if different (-1 for instant)"
]
*/
void() target_fogblend =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (!self.fog_density && !self.skyfog_density) {
		objerror("Neither fog density nor skyfog density set");
		return;
	}

	self.use = target_fogblend_use;
	self.think = fog_blendTimeThink;

	if (self.spawnflags & FOGBLEND_REVERSE)
		self.state = 1;
	else
		self.state = 0;

	if (self.spawnflags & FOGBLEND_ONEWAY)
		self.state = 1 - self.state;

	if (!self.speed) self.speed = 1;
	if (!self.speed2) self.speed2 = self.speed;

	if (self.speed == -1) self.speed = 0;
	if (self.speed2 == -1) self.speed2 = 0;
}



/**************************************

trigger_fog

**************************************/

void() trigger_fog_touch = {
	if (self.estate != STATE_ACTIVE)
		return;

	if (!(other.flags & FL_CLIENT))
		return;

	// fog already set to this value
	if (other.fog_color == self.fog_color && other.fog_density == self.fog_density)
		return;

	// transition already occurring from this trigger
	if (other.fogblend_entity.owner == self)
		return;

	if (self.fog_density) fog_save_to_previous(other);
	if (self.skyfog_density) skyfog_save_to_previous(other);

	// spawn a temp entity to control the transition for this client
	entity controller;

	controller = spawn();
	controller.classname = "fog_controller";
	controller.owner = self;
	controller.enemy = other;
	controller.speed2 = self.speed; // speed2 is used when state is 0
	controller.fog_color = self.fog_color;
	controller.fog_density = self.fog_density;
	controller.skyfog_density = self.skyfog_density;

	controller.pain_finished = time + self.delay + self.speed;

	controller.think = fog_blendTimeThink;
	controller.nextthink = time + controller.delay;

	other.fogblend_entity = controller;
};

/*QUAKED trigger_fog (.5 .5 .2) ?
Smoothly blends touching client's currently applied fog to "fog_color" and "fog_density" over time.

"delay" - pause before beginning to blend.
"speed" - time to spend blending, -1 for an instant change.

CAVEATS:
- will 'stuffcmd' 2 dozen times per second so try not to make these huge
- a bug in most quake engine ports will reset the eye position smoothing that happens when climbing stairs or riding a plat on every frame that a 'stuffcmd' is sent, so fog transitions during upwards motion will cause noticeable stuttering.
*/

void() trigger_fog = {

	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (!self.fog_density && !self.skyfog_density) {
		objerror("Neither fog density nor skyfog density set");
		return;
	}
	InitTrigger ();
	self.touch = trigger_fog_touch;
	if (!self.speed) self.speed = 1;

	SUB_CheckWaiting();
};
