// these were moved for various reasons -- dumptruck_ds
// /*QUAKED info_null (0 0.5 0) (-4 -4 -4) (4 4 4)
// Used as a positional target for spotlights, etc.
// */
// /void() info_null =
// {
// 	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
// 		return;
//
// 	remove(self);
// };
//
// /*QUAKED info_notnull (0 0.5 0) (-4 -4 -4) (4 4 4)
// Used as a positional target for lightning.
// */
// void() info_notnull =
// {
// 	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
// 		return;
// };
//
// //============================================================================
//
// float START_OFF = 1;
//
// void() light_use =
// {
// 	if (self.spawnflags & START_OFF)
// 	{
// 		lightstyle(self.style, "m");
// 		self.spawnflags = self.spawnflags - START_OFF;
// 	}
// 	else
// 	{
// 		lightstyle(self.style, "a");
// 		self.spawnflags = self.spawnflags + START_OFF;
// 	}
// };
//
// /*QUAKED light (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
// Non-displayed light.
// Default light value is 300
// Default style is 0
// If targeted, it will toggle between on or off.
// */
// void() light =
// {
// 	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
// 		return;
//
// 	if (!self.targetname)
// 	{	// inert light
// 		remove(self);
// 		return;
// 	}
//
// 	if (self.style >= 32)
// 	{
// 		self.use = light_use;
// 		if (self.spawnflags & START_OFF)
// 			lightstyle(self.style, "a");
// 		else
// 			lightstyle(self.style, "m");
// 	}
// };
//
// /*QUAKED light_fluoro (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
// Non-displayed light.
// Default light value is 300
// Default style is 0
// If targeted, it will toggle between on or off.
// Makes steady fluorescent humming sound
// */
// void() light_fluoro =
// {
// 	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
// 		return;
//
// 	if (self.style >= 32)
// 	{
// 		self.use = light_use;
// 		if (self.spawnflags & START_OFF)
// 			lightstyle(self.style, "a");
// 		else
// 			lightstyle(self.style, "m");
// 	}
//
// 	precache_sound ("ambience/fl_hum1.wav");
// 	ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
// };
//
// /*QUAKED light_fluorospark (0 1 0) (-8 -8 -8) (8 8 8)
// Non-displayed light.
// Default light value is 300
// Default style is 10
// Makes sparking, broken fluorescent sound
// */
// void() light_fluorospark =
// {
// 	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
// 		return;
//
// 	if (!self.style)
// 		self.style = 10;
//
// 	precache_sound ("ambience/buzz1.wav");
// 	ambientsound (self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
// };
//
// /*QUAKED light_globe (0 1 0) (-8 -8 -8) (8 8 8)
// Sphere globe light.
// Default light value is 300
// Default style is 0
// */
// void() light_globe =
// {
// 	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
// 		return;
//
// 	precache_model ("progs/s_light.spr");
// 	setmodel (self, "progs/s_light.spr");
// 	makestatic (self);
// };
//
/*QUAKED FireAmbient (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() FireAmbient =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_sound ("ambience/fire1.wav");
// attenuate fast
	ambientsound (self.origin, "ambience/fire1.wav", 0.5, ATTN_STATIC);
};

/*QUAKED ambient_fire (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
ambinet fire sound effects added for consistency
same as FireAmbient
*/
void() ambient_fire =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

FireAmbient();
};

//
// /*QUAKED light_torch_small_walltorch (0 .5 0) (-10 -10 -20) (10 10 20)
// Short wall torch
// Default light value is 200
// Default style is 0
// */
// void() light_torch_small_walltorch =
// {
// 	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
// 		return;
//
// 	precache_model ("progs/flame.mdl");
// 	setmodel (self, "progs/flame.mdl");
// 	FireAmbient ();
// 	makestatic (self);
// };
//
// /*QUAKED light_flame_large_yellow (0 1 0) (-10 -10 -12) (12 12 18)
// Large yellow flame ball
// */
// void() light_flame_large_yellow =
// {
// 	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
// 		return;
//
// 	precache_model ("progs/flame2.mdl");
// 	setmodel (self, "progs/flame2.mdl");
// 	self.frame = 1;
// 	FireAmbient ();
// 	makestatic (self);
// };
//
// /*QUAKED light_flame_small_yellow (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
// Small yellow flame ball
// */
// void() light_flame_small_yellow =
// {
// 	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
// 		return;
//
// 	precache_model ("progs/flame2.mdl");
// 	setmodel (self, "progs/flame2.mdl");
// 	FireAmbient ();
// 	makestatic (self);
// };
//
// /*QUAKED light_flame_small_white (0 1 0) (-10 -10 -40) (10 10 40) START_OFF
// Small white flame ball
// */
// void() light_flame_small_white =
// {
// 	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
// 		return;
//
// 	precache_model ("progs/flame2.mdl");
// 	setmodel (self, "progs/flame2.mdl");
// 	FireAmbient ();
// 	makestatic (self);
// };
//
/*QUAKED light_candle (0 1 0) (-10 -10 -40) (10 10 40) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{	model("progs/candle.mdl");	}
==========
Spawnflags
==========
START_OFF - switchable lights only - light is off by default
FADE_IN_OUT - switchable lights only - light fades in and out. can't be combined with animated lights.

==========
Keys
==========
"light" "n"
Set the light intensity. Negative values are also allowed and will cause the entity to subtract light cast by other entities. Default 300.

"wait" "n"
Scale the fade distance of the light by "n". Values of n > 1 make the light fade more quickly with distance, and values < 1 make the light fade more slowly (and thus reach further). Default 1.

"delay" "n"
Select an attenuation formaula for the light:
0 => Linear attenuation (default)
1 => 1/x attenuation
2 => 1/(x^2) attenuation
3 => No attenuation (same brightness at any distance)
4 => "local minlight" - No attenuation and like minlight,
it won't raise the lighting above it's light value.
Unlike minlight, it will only affect surfaces within
line of sight of the entity.
5 => 1/(x^2) attenuation, but slightly more attenuated and
without the extra bright effect that "delay 2" has
near the source.

"_falloff" "n"
Sets the distance at which the light drops to 0, in map units.
In this mode, "wait" is ignored and "light" only controls the brightness at the center of the light, and no longer affects the falloff distance.
Only supported on linear attenuation (delay 0) lights currently.

"_color" "r g b"
Specify red(r), green(g) and blue(b) components for the colour of the light. RGB component values are between 0 and 255 (between 0 and 1 is also accepted). Default is white light ("255 255 255").

"target" "name"
Turns the light into a spotlight, with the direction of light being towards another entity with it�s "targetname" key set to "name".
"mangle" "yaw pitch roll"
Turns the light into a spotlight and specifies the direction of light using yaw, pitch and roll in degrees. Yaw specifies the angle around the Z-axis from 0 to 359 degrees and pitch specifies the angle from 90 (straight up) to -90 (straight down). Roll has no effect, so use any value (e.g. 0). Often easier than the "target" method.

"angle" "n"
Specifies the angle in degrees for a spotlight cone. Default 40.

"_softangle" "n"
Specifies the angle in degrees for an inner spotlight cone (must be less than the "angle" cone. Creates a softer transition between the full brightness of the inner cone to the edge of the outer cone. Default 0 (disabled).

"targetname" "name"
Turns the light into a switchable light, toggled by another entity targeting it�s name.

"speed" "n"
If the light is switchable and FADE_IN_OUT is set, the speed at which the light transitions. Default 0.1.

"style" "n"
Set the animated light style. Default 0.

"style2" "n"
Set the animated light style for a switchable light, because style will be overriden if a targetname is set. Default 0.

"_anglescale" "n" | "_anglesense" "n"
Sets a scaling factor for how much influence the angle of incidence of light on a surface has on the brightness of the surface. n must be between 0.0 and 1.0. Smaller values mean less attenuation, with zero meaning that angle of incidence has no effect at all on the brightness. Default 0.5.

"_dirtscale" "n" | "_dirtgain" "n"
Override the global "_dirtscale" or "_dirtgain" settings to change how this light is affected by dirtmapping (ambient occlusion). See descriptions of these keys in the worldspawn section.

"_dirt" "n"
Overrides the worldspawn setting of "_dirt" for this particular light. -1 to disable dirtmapping (ambient occlusion) for this light, making it illuminate the dirtmapping shadows. 1 to enable ambient occlusion for this light. Default is to defer to the worldspawn setting.

"_deviance" "n"
Split up the light into a sphere of randomly positioned lights within radius "n" (in world units). Useful to give shadows a wider penumbra. "_samples" specifies the number of lights in the sphere. The "light" value is automatically scaled down for most lighting formulas (except linear and non-additive minlight) to attempt to keep the brightness equal. Default is 0, do not split up lights.

"_samples" "n"
Number of lights to use for "_deviance". Default 16 (only used if "_deviance" is set).

"_surface" "texturename"
Makes surfaces with the given texture name emit light, by using this light as a template which is copied across those surfaces. Lights are spaced about 128 units (though possibly closer due to bsp splitting) apart and positioned 2 units above the surfaces.

"_surface_offset" "n"
Controls the offset lights are placed above surfaces for "_surface". Default 2.

"_surface_spotlight" "n"
For a surface light template (i.e. a light with "_surface" set), setting this to "1" makes each instance into a spotlight, with the direction of light pointing along the surface normal. In other words, it automatically sets "mangle" on each of the generated lights.

"_project_texture" "texture"
Specifies that a light should project this texture. The texture must be used in the map somewhere.

"_project_mangle" "yaw pitch roll"
Specifies the yaw/pitch/roll angles for a texture projection (overriding mangle).

"_project_fov" "n"
Specifies the fov angle for a texture projection. Default 90.

"_bouncescale" "n"
Scales the amount of light that is contributed by bounces. Default is 1.0, 0.0 disables bounce lighting for this light.

"_sun" "n"
Set to 1 to make this entity a sun, as an alternative to using the sunlight worldspawn keys. If the light targets an info_null entity, the direction towards that entity sets sun direction. The light itself is disabled, so it can be placed anywhere in the map.

The following light properties correspond to these sunlight settings:
light => _sunlight
mangle => _sunlight_mangle
deviance => _sunlight_penumbra
_color => _sunlight_color
_dirt => _sunlight_dirt
_anglescale => _anglescale

 //dumptruck_ds taken from honey (originally from Rogue)
White candle
*/
void() light_candle =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model ("progs/candle.mdl");
	setmodel (self, "progs/candle.mdl");
	makestatic (self);
};

void() model_candle_think =
{
	self.frame = self.frame + 1;
	if (self.frame > 3)
		self.frame = 0;
	self.nextthink = time + 0.1;
};

void() model_candle =
{

	precache_model ("progs/candle.mdl");

	setmodel (self, "progs/candle.mdl");

	self.think = model_candle_think;
	self.nextthink = time + 0.1;
};


//============================================================================


/*QUAKED misc_fireball (0 .5 .8) (-8 -8 -8) (8 8 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{	model ("progs/lavaball.mdl");	}
Flying lava balls
speed - set vertical speed of fireballs. default 1000.
*/

void() fire_fly;
void() fire_touch;
void() misc_fireball =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model ("progs/lavaball.mdl");
	self.classname = "fireball";
// 1998-08-14 Incorrect setting of nextthink fix by Maddes/Lord Sméagol
//	self.nextthink = time + (random() * 5);
	self.nextthink = time + 0.1 + (random() * 5);
// 1998-08-14 Incorrect setting of nextthink fix by Maddes/Lord Sméagol
	self.think = fire_fly;
	if (!self.speed)
		self.speed = 1000; // fixed typo QIP - dumptruck_ds
};

void() fire_fly =
{
local entity	fireball;

	fireball = spawn();
	fireball.solid = SOLID_TRIGGER;
	fireball.movetype = MOVETYPE_TOSS;
	fireball.velocity = '0 0 1000';
	fireball.velocity_x = (random() * 100) - 50;
	fireball.velocity_y = (random() * 100) - 50;
	fireball.velocity_z = self.speed + (random() * 200);
	fireball.classname = "fireball";
	setmodel (fireball, "progs/lavaball.mdl");
	setsize (fireball, '0 0 0', '0 0 0');
	setorigin (fireball, self.origin);
	fireball.nextthink = time + 5;
	fireball.think = SUB_Remove;
	fireball.touch = fire_touch;

	self.nextthink = time + (random() * 5) + 3;
	self.think = fire_fly;
};


void() fire_touch =
{
	T_Damage (other, self, self, 20);
	remove(self);
};

//============================================================================


void() barrel_explode =
{
	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";
	// did say self.owner
	T_RadiusDamage (self, self, 160, world);
	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
	particle (self.origin, '0 0 0', 75, 255);

	self.origin_z = self.origin_z + 32;
	BecomeExplosion ();
};



/*QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model("maps/b_explob.bsp");
}
Explosive box
*/

void() misc_explobox =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	local float	oldz;

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model ("maps/b_explob.bsp");
	setmodel (self, "maps/b_explob.bsp");
	precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;
	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};




/*QUAKED misc_explobox2 (0 .5 .8) (0 0 0) (32 32 64) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model("maps/b_exbox2.bsp");
}
Smaller explosive box
*/

void() misc_explobox2 =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	local float	oldz;

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model2 ("maps/b_exbox2.bsp");
	setmodel (self, "maps/b_exbox2.bsp");
	precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;
	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};

/*==============================================================================
trap_spikeshooter from Hipnotic -- with additions by dumptruck_ds
==============================================================================*/

//MED 11/09/96 added new spawnflags -- taken from hipdefs.qc - dumptruck_ds
float SPAWNFLAG_SUPERSPIKE	= 1;
float SPAWNFLAG_LASER = 2;
float SPAWNFLAG_LAVABALL = 4;
float SPAWNFLAG_ROCKET = 8;
float SPAWNFLAG_VOREBALL = 16;
float SPAWNFLAG_GRENADE = 32;
float SPAWNFLAG_GIBS = 64;
float SPAWNFLAG_SILENT = 128;

void() ShalMissileTouch = //moved from Shalrath to enable shooter version
{
 if (other == self.owner)
	 return;		// don't explode on owner

 if (other.classname == "monster_zombie")
	 T_Damage (other, self, self, 110);
 T_RadiusDamage (self, self.owner, 40, world);
 sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

 WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
 WriteByte (MSG_BROADCAST, TE_EXPLOSION);
 WriteCoord (MSG_BROADCAST, self.origin_x);
 WriteCoord (MSG_BROADCAST, self.origin_y);
 WriteCoord (MSG_BROADCAST, self.origin_z);

 BecomeExplosion ();


 // self.velocity = '0 0 0';
 // self.touch = SUB_Null;
 // setmodel (self, "progs/s_explod.spr");
 // self.solid = SOLID_NOT;
 // s_explode1 ();
};

void() ZombieGrenadeTouch = //moved from zombie.qc to enable shooter version
{
	if (other == self.owner)
		return;         // don't explode on owner
	if (other.takedamage)
	{
		T_Damage (other, self, self.owner, 10 );
		sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
		remove (self);
		return;
	}
	sound (self, CHAN_WEAPON, "zombie/z_miss.wav", 1, ATTN_NORM);   // bounce sound
	self.velocity = '0 0 0';
	self.avelocity = '0 0 0';
	self.touch = SUB_Remove;
};


void(vector org, vector vec) LaunchLaser;

//MED 11/09/96 added lava ball and rocket
//dumptruck_ds added voreball and grenades
void() spikeshooter_use =
{
   local entity lavaball;
   local entity voreball;
   local entity rockettrap;
   local entity gnade;
   local entity zgibs;

	if (self.spawnflags & SPAWNFLAG_LASER)
	{
      if (!(self.spawnflags & SPAWNFLAG_SILENT))
		  sound (self, CHAN_VOICE, "enforcer/enfire.wav", 1, ATTN_NORM);
			LaunchLaser (self.origin, self.movedir);
      newmis.spawnflags = self.spawnflags;
	}
   else if (self.spawnflags & SPAWNFLAG_LAVABALL)
   {
      if (!(self.spawnflags & SPAWNFLAG_SILENT))
      sound (self, CHAN_VOICE, "boss1/throw.wav", 1, ATTN_NORM); //dms
      // sound (self, CHAN_VOICE, "knight/sword2.wav", 1, ATTN_NORM); //dms
      // sound (self, CHAN_VOICE, "weapons/ax1.wav", 1, ATTN_NORM); //dms
      lavaball = spawn();
      lavaball.movetype = MOVETYPE_FLYMISSILE;
      lavaball.solid = SOLID_BBOX;
      lavaball.classname = "lavaball";
      // set lavaball speed
      lavaball.velocity = self.movedir * 600;  //was 300 dms
      lavaball.angles = vectoangles(lavaball.velocity);
      lavaball.owner = self;
      lavaball.touch = ShalMissileTouch;
      setmodel (lavaball, "progs/lavaball.mdl"); //dms
      setsize (lavaball, '0 0 0', '0 0 0');
      setorigin (lavaball, self.origin);
      lavaball.avelocity = '0 0 400';
      lavaball.nextthink = time + 5;
      lavaball.think = SUB_Remove;
   }

	 else if (self.spawnflags & SPAWNFLAG_ROCKET)
	 {
		 if (!(self.spawnflags & SPAWNFLAG_SILENT))
		 sound (self, CHAN_VOICE, "weapons/sgun1.wav", 1, ATTN_NORM);
		 rockettrap = spawn();
		 rockettrap.movetype = MOVETYPE_FLYMISSILE;
		 rockettrap.solid = SOLID_BBOX;
		 rockettrap.classname = "rockettrap";
		 // set rocket speed
		 rockettrap.velocity = self.movedir * 1000;
		 rockettrap.angles = vectoangles(rockettrap.velocity);
		 rockettrap.owner = self;
		 rockettrap.touch = T_MissileTouch;
		 setmodel (rockettrap, "progs/missile.mdl"); //dms
		 setsize (rockettrap, '0 0 0', '0 0 0');
		 setorigin (rockettrap, self.origin);
		 // rockettrap.avelocity = '0 0 400';
		 rockettrap.nextthink = time + 5;
		 rockettrap.think = SUB_Remove;
	 }
	 else if (self.spawnflags & SPAWNFLAG_VOREBALL)
	 {
		 if (!(self.spawnflags & SPAWNFLAG_SILENT))
		 sound (self, CHAN_VOICE, "shalrath/attack2.wav", 1, ATTN_NORM);
		 voreball = spawn();
		 voreball.movetype = MOVETYPE_FLYMISSILE;
		 voreball.solid = SOLID_BBOX;
		 voreball.classname = "voreball";
		 // set voreball speed
		 voreball.velocity = self.movedir * 600;  //was 300 dms
		 voreball.angles = vectoangles(voreball.velocity);
		 voreball.owner = self;
		 voreball.touch = ShalMissileTouch;
		 setmodel (voreball, "progs/v_spike.mdl"); //dms
		 setsize (voreball, '0 0 0', '0 0 0');
		 setorigin (voreball, self.origin);
		 voreball.avelocity = '0 0 400';
		 voreball.nextthink = time + 5;
		 voreball.think = SUB_Remove;
	 }

	 else if (self.spawnflags & SPAWNFLAG_GRENADE)
	 {
		 if (!(self.spawnflags & SPAWNFLAG_SILENT))
		 sound (self, CHAN_VOICE, "weapons/grenade.wav", 1, ATTN_NORM);
		 gnade = spawn();
		 gnade.movetype = MOVETYPE_BOUNCE;
		 // gnade.movetype = MOVETYPE_FLYMISSILE;
		 gnade.solid = SOLID_BBOX;
		 gnade.classname = "gnade";
		 // set grenade speed
		 // gnade.velocity = self.movedir * 600;  //was 300 dms
		 gnade.velocity = self.movedir * 600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
		 gnade.angles = vectoangles(gnade.velocity);
		 gnade.owner = self;
		 gnade.touch = GrenadeTouch;
		 setmodel (gnade, "progs/grenade.mdl"); //dms
		 setsize (gnade, '0 0 0', '0 0 0');
		 setorigin (gnade, self.origin);
		 gnade.avelocity = '300 300 300';
		 gnade.nextthink = time + 2.5;
	 	 gnade.think = GrenadeExplode;
	 }

	else if (self.spawnflags & SPAWNFLAG_GIBS)
	 {
	 	if (!(self.spawnflags & SPAWNFLAG_SILENT))
		sound (self, CHAN_VOICE, "zombie/z_shot1.wav", 1, ATTN_NORM);
	 	zgibs = spawn ();
	 	zgibs.owner = self;
	 	zgibs.movetype = MOVETYPE_BOUNCE;
	 	zgibs.solid = SOLID_BBOX;
		zgibs.classname = "zgibs";
		setmodel (zgibs, "progs/zom_gib.mdl");
		setsize (zgibs, '0 0 0', '0 0 0');
		setorigin (zgibs, self.origin);
	 	zgibs.velocity = self.movedir * 600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	 	zgibs.avelocity = '3000 1000 2000';
	 	zgibs.touch = ZombieGrenadeTouch;
	 // set missile duration
	 	zgibs.nextthink = time + 2.5;
	 	zgibs.think = SUB_Remove;
	 }

   else
	{
  if (!(self.spawnflags & SPAWNFLAG_SILENT))
    sound (self, CHAN_VOICE, "weapons/spike2.wav", 1, ATTN_NORM);
		launch_spike (self.origin, self.movedir);
		newmis.velocity = self.movedir * 500;
		if (self.spawnflags & SPAWNFLAG_SUPERSPIKE)
			newmis.touch = superspike_touch;
	}
};

//MED 11/01/96 added state capability
void() shooter_think =
{
   if (self.state)
      {
      spikeshooter_use ();
      }
	 self.nextthink = time + self.wait;
};


/*QUAKED trap_spikeshooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser lavaball rocket silent X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

When triggered, fires a spike in the direction set in QuakeEd.
Laser is only for REGISTERED.
*/

//MED 11/01/96 commented out setmovedir
void() trap_spikeshooter =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (self.proj_speed_mod <= 0)
		self.proj_speed_mod = 1;
   SetMovedir ();
	self.use = spikeshooter_use;
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		precache_model2 ("progs/laser.mdl");

		precache_sound2 ("enforcer/enfire.wav");
		precache_sound2 ("enforcer/enfstop.wav");
	}
   else if (self.spawnflags & SPAWNFLAG_LAVABALL)
   {
      precache_model ("progs/lavaball.mdl");
      // precache_sound2 ("knight/sword2.wav"); //dms
      precache_sound2 ("boss1/throw.wav"); //dms
   }
   else if (self.spawnflags & SPAWNFLAG_ROCKET)
   {
      precache_model ("progs/missile.mdl");
      precache_sound ("weapons/sgun1.wav");
   }
   else if (self.spawnflags & SPAWNFLAG_VOREBALL)
   {
		 precache_model ("progs/v_spike.mdl");
		 precache_sound ("shalrath/attack2.wav");
   }
	 else if (self.spawnflags & SPAWNFLAG_GRENADE)
	 {
		precache_model ("progs/grenade.mdl");
		precache_sound ("weapons/grenade.wav");	// grenade launcher
	 }
	 else if (self.spawnflags & SPAWNFLAG_GIBS)
	 {
		precache_model ("progs/zom_gib.mdl");
		precache_sound ("zombie/z_shot1.wav");	// Zombie gibs
		precache_sound ("zombie/z_miss.wav");
		precache_sound ("zombie/z_hit.wav");
	 }

   else
		precache_sound ("weapons/spike2.wav");
};


/*QUAKED trap_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser lavaball rocket silent X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
Continuously fires spikes.
"wait" time between spike (1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
*/
void() trap_shooter =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	trap_spikeshooter ();

	if (self.wait == 0)
		self.wait = 1;
//MED 11/01/96 added state capability
   self.state = 1;
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
};

//MED 11/01/96 added new use function
void() trap_shooter_use =
   {
   self.state = 1 - self.state;
   };
//MED 11/01/96 added new function
/*QUAKED trap_switched_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser lavaball rocket silent X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
Continuously fires spikes.
"wait" time between spike (1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
"state" 0 initially off, 1 initially on. (0 default)
*/
void() trap_switched_shooter =
 {
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

   trap_spikeshooter ();

	if (self.wait == 0)
		self.wait = 1;
//MED 11/01/96 added state capability
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
   self.use = trap_shooter_use;
 };

/*
===============================================================================


===============================================================================
*/


void() make_bubbles;
void() bubble_remove;
void() bubble_bob;

/*QUAKED air_bubbles (0 .5 .8) (-8 -8 -8) (8 8 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

air bubbles entity

*/

void() air_bubbles =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (deathmatch)
	{
		remove (self);
		return;
	}
	precache_model ("progs/s_bubble.spr");
	self.nextthink = time + 1;
	self.think = make_bubbles;
};

void() make_bubbles =
{
local entity	bubble;

	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + random() + 0.5;
	self.think = make_bubbles;
};

void() bubble_split =
{
local entity	bubble;
	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = self.velocity;
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 1;
	bubble.cnt = 10;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.frame = 1;
	self.cnt = 10;
	if (self.waterlevel != 3)
		remove (self);
};

void() bubble_remove =
{
	if (other.classname == self.classname)
	{
//		dprint ("bump");
		return;
	}
	remove(self);
};

void() bubble_bob =
{
local float		rnd1, rnd2, rnd3;


	self.cnt = self.cnt + 1;
	if (self.cnt == 4)
		bubble_split();
	if (self.cnt == 20)
		remove(self);

	rnd1 = self.velocity_x + (-10 + (random() * 20));
	rnd2 = self.velocity_y + (-10 + (random() * 20));
	rnd3 = self.velocity_z + 10 + random() * 10;

	if (rnd1 > 10)
		rnd1 = 5;
	if (rnd1 < -10)
		rnd1 = -5;

	if (rnd2 > 10)
		rnd2 = 5;
	if (rnd2 < -10)
		rnd2 = -5;

	if (rnd3 < 10)
		rnd3 = 15;
	if (rnd3 > 30)
		rnd3 = 25;

	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.velocity_z = rnd3;

	self.nextthink = time + 0.5;
	self.think = bubble_bob;
};

/*~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~*/

/*QUAKED viewthing (0 .5 .8) (-8 -8 -8) (8 8 8)

Just for the debugging level.  Don't use
*/

void() viewthing =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	precache_model ("progs/player.mdl");
	setmodel (self, "progs/player.mdl");
};


/*
==============================================================================

SIMPLE BMODELS

==============================================================================
*/

void() func_wall_use =
{	// change to alternate textures
	self.frame = 1 - self.frame;
};

/*QUAKED func_wall (0 .5 .8) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
This is just a solid wall if not inhibitted
*/
void() func_wall =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};


/*QUAKED func_illusionary (0 .5 .8) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
A simple entity that looks solid but lets you walk through it.
*/
void() func_illusionary =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel (self, self.model);
	makestatic (self);
};


float GATE_REVERSE = 16; // For func_episodegate and func_bossgate appear when player has all runes

/*QUAKED func_episodegate (0 .5 .8) ? E1 E2 E3 E4 REVERSE_FUNCTIONALITY
This bmodel will appear if the episode has allready been completed, so players can't reenter it.
*/
void() func_episodegate =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (self.spawnflags & GATE_REVERSE)
	{
		self.spawnflags = self.spawnflags - GATE_REVERSE; // this is to avoid a possible issue with sigil_touch2
		if (serverflags & self.spawnflags)
			return;			// Haven't gotten rune yet
	}
	else
	{
		if (!(serverflags & self.spawnflags))
			return;			// can still enter episode
	}
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};

/*QUAKED func_bossgate (0 .5 .8) ? X X X X REVERSE_FUNCTIONALITY
This bmodel appears unless players have all of the episode sigils.
*/
void() func_bossgate =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (self.spawnflags & GATE_REVERSE)
	{
		if (!((serverflags & 15) == 15))
		{
			return;  // not all complete
		}
	}
	else
	{
		if ( (serverflags & 15) == 15 )
			return;		// all episodes completed
	}
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};

/*****************
func_togglevisiblewall

A bmodel which you can toggle its visibility. Behaves much like a traditional func_wall in any other way,
but you can target it to toggle visible/invisible.
If the entity has a switchable shadow it also toggles.

spawnflag 1: starts invisible
spawnflag 2: set brush as non-solid

******************/

float TOGGLEVISWALL_STARTOFF = 1;
float TOGGLEVISWALL_NOTSOLID = 2;

void() func_togglevisiblewall_use =
{
	if(!self.state) {
		if(!(self.spawnflags & TOGGLEVISWALL_NOTSOLID)) {
			self.solid = SOLID_BSP;
			self.movetype = MOVETYPE_PUSH;
		}
		setmodel (self, self.origmodel);
		if(self.switchshadstyle) lightstyle(self.switchshadstyle, "a");
		self.state = 1;
	} else {

		self.solid = SOLID_NOT;
		self.movetype = MOVETYPE_NONE;
		setmodel (self, "");
		if(self.switchshadstyle) lightstyle(self.switchshadstyle, "m");
		self.state = 0;
	}

};

void() func_togglevisiblewall =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.angles = '0 0 0';
	self.use = func_togglevisiblewall_use;

	self.origmodel = self.model;

	if(self.spawnflags & TOGGLEVISWALL_STARTOFF) self.state = 1;
	else self.state = 0;

	if(self.spawnflags & TOGGLEVISWALL_NOTSOLID) {
		self.solid = SOLID_NOT;
		self.movetype = MOVETYPE_NONE;
	}

	func_togglevisiblewall_use();

};


/*****************
func_shadow

An invisible bmodel that can be used to only cast shadows.

******************/

void() func_shadow = {
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;

	self.modelindex = 0;
	self.model = "";

}



/********************
misc_shadowcontroller

Controls switchable shadows on any bmodel entity (except doors).
Target entity must have set _switchableshadow set to 1.

speed: Controls the time in seconds it takes to fade the shadow in. Default is 0.5, and setting it to -1 disables fading.
speed2: Same as 'speed' but for the fade out animation. If unset it's the same value as 'speed'.
spawnflag 1: target shadow starts as disabled

*********************/

float SHADOWCONTROLLER_STARTOFF = 1;

void() shadow_fade_out =
{
	if (self.count < 0)
		self.count = 0;
	if (self.count > 12)
		self.count = 12;

	dprint(ftos(self.count));dprint("\n");

	lightstyle(self.switchshadstyle, lightstyle_fade_lookup(self.count));
	self.count = self.count + self.dmg;
	if (self.count > 12)
		return;

	self.think = shadow_fade_out;
	self.nextthink = time + self.delay;
};

void() shadow_fade_in =
{
	if (self.count < 0)
		self.count = 0;
	if (self.count > 12)
		self.count = 12;

	dprint(ftos(self.count));dprint("\n");

	lightstyle(self.switchshadstyle, lightstyle_fade_lookup(self.count));
	self.count = self.count - self.dmg;
	if (self.count < 0)
		return;

	self.think = shadow_fade_in;
	self.nextthink = time + self.delay;

};

void(float speed) misc_shadowcontroller_setsteps = {
	// self.delay -> time between steps
	// self.dmg -> step size
	if(speed >= 0.24) {
		self.delay = (speed/12);
		self.dmg = 1;
	}
	else if(speed >= 0.12) {
		self.delay = (speed/6);
		self.dmg = 2;
	}
	else if(speed >= 0.06) {
		self.delay = (speed/3);
		self.dmg = 4;
	}
	else if(speed >= 0.04) {
		self.delay = (speed/2);
		self.dmg = 6;
	}
	else {
		self.delay = 0;
		self.dmg = 12;
	}

}

void() misc_shadowcontroller_use = {

	if(self.shadowoff) {
		dprint("Fade in:\n");

		misc_shadowcontroller_setsteps(self.speed);

		shadow_fade_in();

		self.shadowoff = 0;
	} else {
		dprint("Fade out:\n");

		misc_shadowcontroller_setsteps(self.speed2);

		shadow_fade_out();

		self.shadowoff = 1;
	}
}

void() misc_shadowcontroller = {
	entity t1;

	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;


	// doesn't search for a target if switchshadstyle is already set
	// used for built-in shadow controllers
	if(!self.switchshadstyle) {

		// we need to find only the first target entity with switchable shadows set, since shadow lightstyles are bound by targetname


		t1 = find(world, targetname2, self.target);

		while(t1 != world && !t1.switchshadstyle) {
			t1 = find(t1, targetname2, self.target);
		}

		if(t1 == world) {
			t1 = find(world, targetname, self.target);

			while(t1 != world && !t1.switchshadstyle) {
				t1 = find(t1, targetname, self.target);
			}
		}


		if(t1 == world) {
			dprint("\b[misc_shadowcontroller]\b _switchableshadow not set in target ");dprint(self.target);dprint("\n");
			return;
		}

		self.switchshadstyle = t1.switchshadstyle;
	}

	if(!self.speed) self.speed = 0.5;
	if(!self.speed2) self.speed2 = self.speed;

	if(self.spawnflags & SHADOWCONTROLLER_STARTOFF) {
		lightstyle(self.switchshadstyle, "m");

		self.shadowoff = 1;
		self.count = 12;

		misc_shadowcontroller_setsteps(self.speed2);
	}
	else {
		lightstyle(self.switchshadstyle, "a");
		self.shadowoff = 0;
		self.count = 0;
		misc_shadowcontroller_setsteps(self.speed);
	}

	self.use = misc_shadowcontroller_use;
}


/*
misc_infight

target = monster that gets mad
target2 = who target1 will be angry at

spawnflag 1 = mutual hate, both targets get angry at each other instantly
spawnflag 2 = maintain activator, makes it so the player that triggers the infighting sees centerprints triggered by it
*/

float INFIGHT_MUTUAL = 1;
float INFIGHT_PLAYER_ACTIVATION = 2;

void(entity t1, entity t2) make_angry_at =
{
	if (t2.health > 0 && t1.health > 0) { // checks if targets are alive
		if (t1.enemy.classname == "player")
			t1.oldenemy = t1.enemy;
		t1.enemy = t2;

		entity oself = self;
		self = t1; // FoundTarget() only acts on self
		FoundTarget();
		self = oself;
	}
};

void() misc_infight_use =
{
	local entity	t1, t2;

	for (t1 = world; (t1 = find(t1, targetname, self.target)); )
    {
      for (t2 = world; (t2 = find(t2, targetname, self.target2)); )
      {
  //  t1 = find(world, targetname, self.target);
  //  t2 = find(world, targetname, self.target2);

    	if (!t1)
    	{
          dprint("[trigger_infight] Cannot find target, checking targetname2\n");
          t1 = find(world, targetname2, self.target);
    	}
        if (!t1)
    	{
   		  dprint("[trigger_infight] Cannot find target, checking targetname3\n");
   		  t1 = find(world, targetname3, self.target);
   		}
    	if (!t1)
    	{
          dprint("[trigger_infight] Cannot find target, checking targetname4\n");
          t1 = find(world, targetname4, self.target);
        }
    	if (!t1)
    	{
          dprint("[trigger_infight] Cannot find target, exhausted all targetnames\n");
          return;
    	}
    	if (!t2)
    	{
          dprint("[trigger_infight] Cannot find target2 checking targetname2\n");
          t2 = find(world, targetname2, self.target2);
    	}
    	if (!t2)
    	{
          dprint("[trigger_infight] Cannot find target2 checking targetname3\n");
          t2 = find(world, targetname3, self.target2);
    	}
    	if (!t2)
    	{
          dprint("[trigger_infight] Cannot find target2 checking targetname4\n");
          t2 = find(world, targetname4, self.target2);
    	}
    	if (!t2)
    	{
          dprint("[trigger_infight] Cannot find target2, exhausted all targetnames\n");
          return;
    	}

		make_angry_at(t1, t2);

		if (self.spawnflags & INFIGHT_PLAYER_ACTIVATION)
      	{
          t1.infight_activator = activator;
          t2.infight_activator = activator;
      	}

		if (self.spawnflags & INFIGHT_MUTUAL)
		  make_angry_at(t2, t1);
	  }
	}
};

void() misc_infight =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	self.use = misc_infight_use;
};





//============================================================================
/*QUAKED ambient_suck_wind (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
*/
void() ambient_suck_wind =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_sound ("ambience/suck1.wav");
	ambientsound (self.origin, "ambience/suck1.wav", 1, ATTN_STATIC);
};

/*QUAKED ambient_drone (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
*/
void() ambient_drone =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_sound ("ambience/drone6.wav");
	ambientsound (self.origin, "ambience/drone6.wav", 0.5, ATTN_STATIC);
};

/*QUAKED ambient_flouro_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
*/
void() ambient_flouro_buzz =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 1, ATTN_STATIC);
};
/*QUAKED ambient_drip (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
*/
void() ambient_drip =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_sound ("ambience/drip1.wav");
	ambientsound (self.origin, "ambience/drip1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_comp_hum (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

*/
void() ambient_comp_hum =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_sound ("ambience/comp1.wav");
	ambientsound (self.origin, "ambience/comp1.wav", 1, ATTN_STATIC);
};
/*QUAKED ambient_light_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
*/
void() ambient_light_buzz =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_sound ("ambience/fl_hum1.wav");
	ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_swamp1 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
*/
void() ambient_swamp1 =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_sound ("ambience/swamp1.wav");
	ambientsound (self.origin, "ambience/swamp1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_swamp2 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
*/
void() ambient_swamp2 =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_sound ("ambience/swamp2.wav");
	ambientsound (self.origin, "ambience/swamp2.wav", 0.5, ATTN_STATIC);
};
/////////////////////////////////////////////////////////////
////////// dumptruck_ds ////////////////////////////////////
///////////////////////////////////////////////////////////

/* Additions to Ambient Sound effects. These are hard coded into the engine and
   usually play back automatically when the sky or water textures are used. If
   you'd prefer to use these in custom setups, you can use the command line
   switch -nomabient in when you VIS your map to disable the hard coded sounds. */

/*QUAKED ambient_water1 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
*/
void() ambient_water1 =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_sound ("ambience/water1.wav");
	ambientsound (self.origin, "ambience/water1.wav", 1, ATTN_STATIC);
};
/*QUAKED ambient_wind2 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
*/
void() ambient_wind2 =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_sound ("ambience/wind2.wav");
	ambientsound (self.origin, "ambience/wind2.wav", 1, ATTN_STATIC);
};
/////////////////////////////////////////////////////////////
////////// dumptruck_ds ////////////////////////////////////
///////////////////////////////////////////////////////////

/* The original ambient_thunder was included in Quake but the code was missing.
   This version is borrowed from the Zerstörer mod but modified to only play the
   original thumder1.wav included in the game. This is also different than the
   other  ambient sounds as it plays back randomly as opposed to looping. You
   only need one  of these in your level. It will play everywhere. */

void() thunder_go_boom =
{
	if (random() < 0.5)
		sound (self, CHAN_AUTO, "ambience/thunder1.wav", 0.7, ATTN_NONE);
	else
		sound (self, CHAN_AUTO, "ambience/thunder1.wav", 1, ATTN_NONE);

	self.think = thunder_go_boom;
	self.nextthink = time + 40*random();
};

/*QUAKED ambient_thunder (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
The original ambient_thunder was included in Quake but the code was missing.
This version is borrowed from the Zerstörer mod but modified to only play the
original thumder1.wav included in the game. This is also different than the
other  ambient sounds as it plays back randomly as opposed to looping. You
only need one  of these in your level. It will play everywhere.
*/
void() ambient_thunder =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	//  changed from ambient to delayed sound (sounds better)
	precache_sound ("ambience/thunder1.wav");
	// precache_sound ("ambience/thunder2.wav"); this file in not included in the game
	self.think = thunder_go_boom;
	self.nextthink = time + random();
};



//============================================================================

void() noise_think =
{
	self.nextthink = time + 0.5;
	sound (self, 1, "enforcer/enfire.wav", 1, ATTN_NORM);
	sound (self, 2, "enforcer/enfstop.wav", 1, ATTN_NORM);
	sound (self, 3, "enforcer/sight1.wav", 1, ATTN_NORM);
	sound (self, 4, "enforcer/sight2.wav", 1, ATTN_NORM);
	sound (self, 5, "enforcer/sight3.wav", 1, ATTN_NORM);
	sound (self, 6, "enforcer/sight4.wav", 1, ATTN_NORM);
	sound (self, 7, "enforcer/pain1.wav", 1, ATTN_NORM);
};

/*QUAKED misc_noisemaker (1 0.5 0) (-10 -10 -10) (10 10 10) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

For optimzation testing, starts a lot of sounds.
*/

void() misc_noisemaker =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/idle1.wav");

	self.nextthink = time + 0.1 + random();
	self.think = noise_think;
};


/***********************************************

target_autosave
from Copper

***********************************************/

void() target_autosave_use =
{
	if (self.enemy)
	{
		activator = self.enemy;
		self.enemy = world;
	}
	if (activator.classname != "player") return;
	if (time < 2)	// make sure an autosave fired from a player start doesn't happen too early
	{
		//if (serverflags & SVFL_RESPAWNING)
		//{
		//	dprint("RESPAWNING flag set, skipping autosave\n");
		//	return;
		//}
		self.enemy = activator;
		self.think = target_autosave_use;
		self.nextthink = 2;
		return;
	}
	// sound(activator, CHAN_VOICE, "misc/sav.wav", 0.3, ATTN_NORM);
	autosave(activator, self.message);
}

void() toggle_autosave =
{
	entity e = world;
	float printed = FALSE;
	do {
		e = find(e, classname, "target_autosave");
		if (!e) break;

		if (e.use == target_autosave_use)
		{
			e.use = SUB_Null;
			if (!printed)
			{
				bprint("Autosaves disabled\n");
				printed = TRUE;
			}
		} else {
			e.use = target_autosave_use;
			if (!printed)
			{
				bprint("Autosaves reenabled\n");
				printed = TRUE;
			}
		}

	} while (e != world);
}

/*QUAKED target_autosave (1 .0 .5) (-8 -8 -8) (8 8 8)
Saves the game when triggered by a player. Never appears in multiplayer. the bprint tends to stomp any other prints on screen in most quake clients, so use a delayed trigger_relay if you fire this from an important pickup/trigger_counter/something else that puts text on screen more important than the autosave blurb.

Keys:
"message" change save file name, defaults to 'auto'
*/
/*FGD
@Pointclass base(Target, Targetname, Appearflags) color(255 0 128) size(32 32 32) = target_autosave :
"Saves the game when triggered by a player. Never appears in multiplayer.
the bprint tends to stomp any other prints on screen in most quake clients, so use a delayed trigger_relay if you fire this from an important pickup/trigger_counter/something else that puts text on screen more important than the autosave blurb."
[
	message(string) : "Change save filename" : "auto"
]
*/
void() target_autosave =
{
	if (deathmatch || coop)
	{
		remove(self);
		return;
	}


	if (self.message == string_null)
		self.message = "auto";
	// precache_sound2("misc/sav.wav");
	self.use = target_autosave_use;
}


/*
=============================================================

trigger_textstory

=============================================================
*/

float TEXTSTORY_SILENT = 1;
float TEXTSTORY_NOFADE = 2;

void(entity controller) textstory_hide = {
	if (!self.enemy || !(self.enemy.flags & FL_CLIENT)) return;

	self.enemy.suppressCenterPrint = FALSE;
	centerprint(self.enemy, "");

	if (controller.noise2)
		sound(self.enemy, CHAN_BODY, controller.noise2, 1, ATTN_NORM);

	if (!(controller.spawnflags & TEXTSTORY_NOFADE))
		csf_fade(self.enemy, 0, '0 0 0', 0.5);

};

void(entity controller) textstory_show = {
	if (!self.enemy || !(self.enemy.flags & FL_CLIENT)) return;

	self.enemy.suppressCenterPrint = TRUE;

	centerprint_builtin(self.enemy, controller.message);

	if (!self.state) {
		if (controller.noise1)
			sound(self.enemy, CHAN_BODY, controller.noise1, 1, ATTN_NORM);

		if (!(controller.spawnflags & TEXTSTORY_NOFADE))
			if (!self.fade_amt) //custom fade amount --dumptruck_ds
			{
				csf_fade(self.enemy, 160, '0 0 0', 1);
			}
			else
				csf_fade(self.enemy, self.fade_amt, '0 0 0', 1); 
	}


	self.state = 1;
};

//----------------------------------------

void() trigger_textstory_hide = {
	textstory_hide(self);

	self.enemy = world;
	self.state = 0;
};

void() trigger_textstory_show = {
	textstory_show(self);

	self.think = trigger_textstory_hide;
	self.nextthink = time + 0.2;

};

void() trigger_textstory_touch = {

	if (!(other.flags & FL_CLIENT)) return;
	if (self.estate != STATE_ACTIVE) return;

	// don't show message if another player is already triggering it
	if (other != self.enemy && self.state == 1) return;

	if (self.mangle && !isInAngle(other.v_angle, self.mangle, self.view_ofs))
		return;

	if (self.attack_finished < time) {

		self.attack_finished = time + 0.1;
		self.enemy = other;

		trigger_textstory_show();
	}
};

void() trigger_textstory = {
	InitTrigger();
	self.touch = trigger_textstory_touch;

	if (self.view_ofs == '0 0 0')
		self.view_ofs = '90 90 0';

	if (self.mangle) self.mangle = normalizeAngles180(self.mangle);

	if (self.noise1 == "")
		self.noise1 = "misc/talk.wav";

	if (self.noise2 == "")
		self.noise2 = "misc/null.wav";

	if (self.spawnflags & TEXTSTORY_SILENT) {
		self.noise1 = "";
		self.noise2 = "";
	}


	if (self.noise1 != "")
		precache_sound (self.noise1);
	if (self.noise2 != "")
		precache_sound (self.noise2);

	SUB_CheckWaiting();
};


//-----------------------------


void() target_textstory_helper_hide = {

	textstory_hide(self.owner);
	remove(self);
};

void() target_textstory_helper_show = {
	if (!self.enemy || !(self.enemy.flags & FL_CLIENT)) {
		remove(self);
		return;
	}

	textstory_show(self.owner);

	if (self.attack_finished < time) self.think = target_textstory_helper_hide;

	self.nextthink = time + 0.1;
};

void(entity tgt) target_textstory_spawn_helper = {
	entity e;

	e = spawn();
	e.classname = "target_textstory_helper";
	e.owner = self;
	e.think = target_textstory_helper_show;
	e.nextthink = time + 0.1;
	e.attack_finished = time + self.wait;
	e.enemy = tgt;
};

void() target_textstory_use = {

	if (!(activator.flags & FL_CLIENT)) return;
	if (self.estate != STATE_ACTIVE) return;

	entity t;

	if (self.spawnflags & TRIGGER_CENTERPRINTALL) {
		t = find(world, classname, "player");
		while (t) {
			target_textstory_spawn_helper(t);
			t = find(t, classname, "player");
		}
	}
	else
		target_textstory_spawn_helper(activator);
};

void() target_textstory = {
	if (self.noise1 == "")
		self.noise1 = "misc/talk.wav";

	if (self.noise2 == "")
		self.noise2 = "misc/null.wav";

	if (self.spawnflags & TEXTSTORY_SILENT) {
		self.noise1 = "";
		self.noise2 = "";
	}

	if (self.noise1 != "")
		precache_sound (self.noise1);
	if (self.noise2 != "")
		precache_sound (self.noise2);

	if (!self.wait)
		self.wait = 5;

	self.use = target_textstory_use;
};
