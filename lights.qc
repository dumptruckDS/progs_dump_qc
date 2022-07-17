/*========================================
lights.qc taken from c0burn's Slipgate mod -- dumptruck_ds
========================================*/

float START_OFF		= 1;
float FADE_IN_OUT	= 2;
float SILENT_TORCH = 4; // for silent torch -- dumptruck_ds

/*QUAKED info_null (0 0.5 0) (-4 -4 -4) (4 4 4) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Used as a positional target for spotlights, etc.
*/
void() info_null =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	remove(self);
};

/*QUAKED info_notnull (0 0.5 0) (-4 -4 -4) (4 4 4) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Never used in the or
*/
void() info_notnull =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;
};

/*==========
lightstyle_lookup
==========*/
string(float num) lightstyle_lookup =
{
	switch (num)
	{
		// 0 normal
		case 0:
			return "m";
			break;
		// 1 FLICKER (first variety)
		case 1:
			return "mmnmmommommnonmmonqnmmo";
			break;
		// 2 SLOW STRONG PULSE
		case 2:
			return "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba";
			break;
		// 3 CANDLE (first variety)
		case 3:
			return "mmmmmaaaaammmmmaaaaaabcdefgabcdefg";
			break;
		// 4 FAST STROBE
		case 4:
			return "mamamamamama";
			break;
		// 5 GENTLE PULSE 1
		case 5:
			return "jklmnopqrstuvwxyzyxwvutsrqponmlkj";
			break;
		// 6 FLICKER (second variety)
		case 6:
			return "nmonqnmomnmomomno";
			break;
		// 7 CANDLE (second variety)
		case 7:
			return "mmmaaaabcdefgmmmmaaaammmaamm";
			break;
		// 8 CANDLE (third variety)
		case 8:
			return "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa";
			break;
		// 9 SLOW STROBE (fourth variety)
		case 9:
			return "aaaaaaaazzzzzzzz";
			break;
		// 10 FLUORESCENT FLICKER
		case 10:
			return "mmamammmmammamamaaamammma";
			break;
		// 11 SLOW PULSE NOT FADE TO BLACK
		case 11:
			return "abcdefghijklmnopqrrqponmlkjihgfedcba";
			break;
		// 12 BLINK OFF / ON (can be synced with animated textures, e.g. +0light and +1light)
		case 12:
			return "aamm";	// textures animate at 5fps but lights are 10fps...
			break;
		// DEFAULT
		default:
			return "a";
			break;
	}
};

/*==========
setup_lightstyles

Setup light animation tables. 'a' is total darkness, 'z' is maxbright.
Styles 32+ are assigned by the light program for switchable lights.
==========*/
void() setup_lightstyles =
{
	for (float i = 0; i <= 12; i++)
	{
		lightstyle(i, lightstyle_lookup(i));
	}
};

/*==========
lightstyle_fade_lookup
==========*/
string(float num) lightstyle_fade_lookup =
{
	switch (num)
	{
		case 0:
			return "a";
			break;
		case 1:
			return "b";
			break;
		case 2:
			return "c";
			break;
		case 3:
			return "d";
			break;
		case 4:
			return "e";
			break;
		case 5:
			return "f";
			break;
		case 6:
			return "g";
			break;
		case 7:
			return "h";
			break;
		case 8:
			return "i";
			break;
		case 9:
			return "j";
			break;
		case 10:
			return "k";
			break;
		case 11:
			return "l";
			break;
		case 12:
			return "m";
			break;
		default:
			error("count out of range\n");
			break;
	}
};

/*==========
light_fade_in
==========*/
void() light_fade_in =
{
	if (self.count < 0)
		self.count = 0;
	if (self.count > 12)
		self.count = 12;

	lightstyle(self.style, lightstyle_fade_lookup(self.count));
	self.count = self.count + 1;
	if (self.count > 12)
		return;

	self.think = light_fade_in;
	self.nextthink = time + self.speed;
};

/*==========
light_fade_out
==========*/
void() light_fade_out =
{
	if (self.count < 0)
		self.count = 0;
	if (self.count > 12)
		self.count = 12;

	lightstyle(self.style, lightstyle_fade_lookup(self.count));
	self.count = self.count - 1;
	if (self.count < 0)
		return;

	self.think = light_fade_out;
	self.nextthink = time + self.speed;
};

/*==========
light_use

using a light will turn it on and off
==========*/
void() light_use =
{
	if (self.spawnflags & START_OFF)
	{
		self.spawnflags = self.spawnflags - START_OFF;
		if (self.spawnflags & FADE_IN_OUT && !self.style2)
			light_fade_in();
		else
			lightstyle(self.style, lightstyle_lookup(self.style2));
	}
	else
	{
		self.spawnflags = self.spawnflags + START_OFF;
		if (self.spawnflags & FADE_IN_OUT && !self.style2)
			light_fade_out();
		else
			lightstyle(self.style, "a");
	}
};

/*QUAKED light (0 1 0) (-8 -8 -8) (8 8 8) START_OFF FADE_IN_OUT X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Light

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
*/
void() light =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	// default speed for fading in/out
	if (self.speed <= 0)
		self.speed = 0.1;

	// non-switchable light
	if (!self.targetname)
	{
		remove(self);
		return;
	}

	// switchable light
	if (self.style >= 32)
	{
		self.use = light_use;
		if (self.spawnflags & START_OFF)
		{
			self.count = 0;
			lightstyle(self.style, "a");
		}
		else
		{
			self.count = 12;
			lightstyle(self.style, lightstyle_lookup(self.style2));
		}
	}
};

/*QUAKED light_fluoro (0 1 0) (-8 -8 -8) (8 8 8) START_OFF FADE_IN_OUT X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Non-displayed light.
Makes steady fluorescent humming sound.
See the "light" entity for a full description.
*/
void() light_fluoro =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	ambient_light_buzz();
	light();
};

/*QUAKED light_fluorospark (0 1 0) (-8 -8 -8) (8 8 8) START_OFF FADE_IN_OUT X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Non-displayed light.
Makes sparking, broken fluorescent sound.
Can't be toggled.
Default style is 10.
See the "light" entity for a full description.
*/
void() light_fluorospark =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (!self.style)
		self.style = 10;
	ambient_flouro_buzz();
	remove(self);
};

/*QUAKED light_globe (0 1 0) (-8 -8 -8) (8 8 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
Sphere globe light.
Can't be toggled.
See the "light" entity for a full description.
*/
void() light_globe =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/s_light.spr");
	setmodel(self, "progs/s_light.spr");
	makestatic(self);
};

/*QUAKED light_torch_small_walltorch (0 .5 0) (-10 -10 -20) (10 10 20) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{	model ("progs/flame.mdl");	}
Short wall torch
See the "light" entity for a full description.
*/
void() light_torch_small_walltorch =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	// precache_model("progs/flame.mdl");
	precache_body_model("progs/flame.mdl");
	// setmodel(self, "progs/flame.mdl");
	body_model("progs/flame.mdl");
	if !(self.spawnflags && SILENT_TORCH) // for silent torch -- dumptruck_ds
	FireAmbient ();
	makestatic(self);
};

/*QUAKED light_flame_large_yellow (0 1 0) (-10 -10 -12) (12 12 18) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{	model ( { "path" : "progs/flame2.mdl", "frame" : 1 } );	}
Large yellow flame
See the "light" entity for a full description.
*/
void() light_flame_large_yellow =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	self.frame = 1;
	FireAmbient ();
	makestatic(self);
};

/*QUAKED light_flame_small_yellow (0 1 0) (-8 -8 -8) (8 8 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{	model ("progs/flame2.mdl");	}
Small yellow flame
See the "light" entity for a full description.
*/
void() light_flame_small_yellow =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	precache_model("progs/flame2.mdl");
	setmodel(self, "progs/flame2.mdl");
	FireAmbient ();
	makestatic(self);
};

/*QUAKED light_flame_small_white (0 1 0) (-8 -8 -8) (8 8 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{	model ("progs/flame2.mdl");	}
Left for compatability
Identical to "light_flame_small_yellow"
*/
void() light_flame_small_white =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	light_flame_small_yellow();
};

/*QUAKED light_sprite_flame (0 1 0) (-8 -8 -8) (8 8 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{	model ("progs/s_flame.spr");	}
Large flame spite*/
void() light_sprite_flame =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

		precache_model("progs/s_flame.spr");
		setmodel(self, "progs/s_flame.spr");
		FireAmbient ();

		self.frame = rint(random() * 13);
		self.first_frame = 0;
		self.last_frame = 13;
		self.speed = 0.05;
		self.think = misc_model_think;
		self.nextthink = time + 0.1;

};
