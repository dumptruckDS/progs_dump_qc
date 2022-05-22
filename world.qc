
void() InitBodyQue;


void() main =
{
	dprint ("main function\n");

// these are just commands the the prog compiler to copy these files

	precache_file ("progs.dat");
	precache_file ("gfx.wad");
	precache_file ("quake.rc");
	precache_file ("default.cfg");

	precache_file ("end1.bin");
	precache_file2 ("end2.bin");

	precache_file ("demo1.dem");
	precache_file ("demo2.dem");
	precache_file ("demo3.dem");

//
// these are all of the lumps from the cached.ls files
//
	precache_file ("gfx/palette.lmp");
	precache_file ("gfx/colormap.lmp");

	precache_file2 ("gfx/pop.lmp");

	precache_file ("gfx/complete.lmp");
	precache_file ("gfx/inter.lmp");

	precache_file ("gfx/ranking.lmp");
	precache_file ("gfx/vidmodes.lmp");
	precache_file ("gfx/finale.lmp");
	precache_file ("gfx/conback.lmp");
	precache_file ("gfx/qplaque.lmp");

	precache_file ("gfx/menudot1.lmp");
	precache_file ("gfx/menudot2.lmp");
	precache_file ("gfx/menudot3.lmp");
	precache_file ("gfx/menudot4.lmp");
	precache_file ("gfx/menudot5.lmp");
	precache_file ("gfx/menudot6.lmp");

	precache_file ("gfx/menuplyr.lmp");
	precache_file ("gfx/bigbox.lmp");
	precache_file ("gfx/dim_modm.lmp");
	precache_file ("gfx/dim_drct.lmp");
	precache_file ("gfx/dim_ipx.lmp");
	precache_file ("gfx/dim_tcp.lmp");
	precache_file ("gfx/dim_mult.lmp");
	precache_file ("gfx/mainmenu.lmp");

	precache_file ("gfx/box_tl.lmp");
	precache_file ("gfx/box_tm.lmp");
	precache_file ("gfx/box_tr.lmp");

	precache_file ("gfx/box_ml.lmp");
	precache_file ("gfx/box_mm.lmp");
	precache_file ("gfx/box_mm2.lmp");
	precache_file ("gfx/box_mr.lmp");

	precache_file ("gfx/box_bl.lmp");
	precache_file ("gfx/box_bm.lmp");
	precache_file ("gfx/box_br.lmp");

	precache_file ("gfx/sp_menu.lmp");
	precache_file ("gfx/ttl_sgl.lmp");
	precache_file ("gfx/ttl_main.lmp");
	precache_file ("gfx/ttl_cstm.lmp");

	precache_file ("gfx/mp_menu.lmp");

	precache_file ("gfx/netmen1.lmp");
	precache_file ("gfx/netmen2.lmp");
	precache_file ("gfx/netmen3.lmp");
	precache_file ("gfx/netmen4.lmp");
	precache_file ("gfx/netmen5.lmp");

	precache_file ("gfx/sell.lmp");

	precache_file ("gfx/help0.lmp");
	precache_file ("gfx/help1.lmp");
	precache_file ("gfx/help2.lmp");
	precache_file ("gfx/help3.lmp");
	precache_file ("gfx/help4.lmp");
	precache_file ("gfx/help5.lmp");

	precache_file ("gfx/pause.lmp");
	precache_file ("gfx/loading.lmp");

	precache_file ("gfx/p_option.lmp");
	precache_file ("gfx/p_load.lmp");
	precache_file ("gfx/p_save.lmp");
	precache_file ("gfx/p_multi.lmp");

// sounds loaded by C code
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");
	precache_sound ("misc/menu3.wav");

	precache_sound ("ambience/water1.wav");
	precache_sound ("ambience/wind2.wav");

// shareware
	precache_file ("maps/start.bsp");

	precache_file ("maps/e1m1.bsp");
	precache_file ("maps/e1m2.bsp");
	precache_file ("maps/e1m3.bsp");
	precache_file ("maps/e1m4.bsp");
	precache_file ("maps/e1m5.bsp");
	precache_file ("maps/e1m6.bsp");
	precache_file ("maps/e1m7.bsp");
	precache_file ("maps/e1m8.bsp");

// registered
	precache_file2 ("gfx/pop.lmp");

	precache_file2 ("maps/e2m1.bsp");
	precache_file2 ("maps/e2m2.bsp");
	precache_file2 ("maps/e2m3.bsp");
	precache_file2 ("maps/e2m4.bsp");
	precache_file2 ("maps/e2m5.bsp");
	precache_file2 ("maps/e2m6.bsp");
	precache_file2 ("maps/e2m7.bsp");

	precache_file2 ("maps/e3m1.bsp");
	precache_file2 ("maps/e3m2.bsp");
	precache_file2 ("maps/e3m3.bsp");
	precache_file2 ("maps/e3m4.bsp");
	precache_file2 ("maps/e3m5.bsp");
	precache_file2 ("maps/e3m6.bsp");
	precache_file2 ("maps/e3m7.bsp");

	precache_file2 ("maps/e4m1.bsp");
	precache_file2 ("maps/e4m2.bsp");
	precache_file2 ("maps/e4m3.bsp");
	precache_file2 ("maps/e4m4.bsp");
	precache_file2 ("maps/e4m5.bsp");
	precache_file2 ("maps/e4m6.bsp");
	precache_file2 ("maps/e4m7.bsp");
	precache_file2 ("maps/e4m8.bsp");

	precache_file2 ("maps/end.bsp");

	precache_file2 ("maps/dm1.bsp");
	precache_file2 ("maps/dm2.bsp");
	precache_file2 ("maps/dm3.bsp");
	precache_file2 ("maps/dm4.bsp");
	precache_file2 ("maps/dm5.bsp");
	precache_file2 ("maps/dm6.bsp");
};


/*
================
DetectKnownRelease

This detects whether the current map is from a known release for which
a backwards-compatibility hack should be applied, and sets the
known_release global accordingly.  -- iw
================
*/
void() DetectKnownRelease =
{
	local string release_name;

	known_release = KNOWN_RELEASE_NOT;
	release_name = "";

	if (mapname == "dm1" ||
		mapname == "dm2" ||
		mapname == "dm3" ||
		mapname == "dm4" ||
		mapname == "dm5" ||
		mapname == "dm6" ||
		mapname == "e1m1" ||
		mapname == "e1m2" ||
		mapname == "e1m3" ||
		mapname == "e1m4" ||
		mapname == "e1m5" ||
		mapname == "e1m6" ||
		mapname == "e1m7" ||
		mapname == "e1m8" ||
		mapname == "e2m1" ||
		mapname == "e2m2" ||
		mapname == "e2m3" ||
		mapname == "e2m4" ||
		mapname == "e2m5" ||
		mapname == "e2m6" ||
		mapname == "e2m7" ||
		mapname == "e3m1" ||
		mapname == "e3m2" ||
		mapname == "e3m3" ||
		mapname == "e3m4" ||
		mapname == "e3m5" ||
		mapname == "e3m6" ||
		mapname == "e3m7" ||
		mapname == "e4m1" ||
		mapname == "e4m2" ||
		mapname == "e4m3" ||
		mapname == "e4m4" ||
		mapname == "e4m5" ||
		mapname == "e4m6" ||
		mapname == "e4m7" ||
		mapname == "e4m8" ||
		mapname == "end" ||
		(mapname == "start" && world.message == "Introduction"))
	{
		known_release = KNOWN_RELEASE_ID1;
		release_name = "id1";
	}

	if (mapname == "jamx_artistical" ||
		mapname == "jamx_bloodshot" ||
		mapname == "jamx_fw" ||
		mapname == "jamx_hcm" ||
		mapname == "jamx_ionous" ||
		mapname == "jamx_jcr" ||
		mapname == "jamx_kalebclark" ||
		mapname == "jamx_mafon" ||
		//mapname == "jamx_mugwump" ||   // dummy map
		mapname == "jamx_naitelveni" ||
		mapname == "jamx_newhouse" ||
		mapname == "jamx_pinchy" ||
		mapname == "jamx_strwrk" ||
		mapname == "jamx_ukko" ||
		mapname == "jamx_yoder" ||
		(mapname == "start" && world.message == "An Unending Dusk"))
	{
		known_release = KNOWN_RELEASE_FUNC_MAPJAMX;
		release_name = "func_mapjamx";
	}

	if (release_name != "")
	{
		dprint ("WARNING: progs.dat detected a map from ");
		dprint (release_name);
		dprint (", attempting to behave compatibly\n");
	}
};


entity	lastspawn;

//=======================
/*QUAKED worldspawn (0 0 0) ?
Only used for the world entity.

Optionally set reset_items to one of the following values:
0: don't reset the player's inventory
1: reset to shotgun, axe, and 25 shells
2: reset to axe only

message(string) : "Level name"

worldtype(choices) : "Ambience" : 0 =
0 : "Medieval"
1 : "Runic (metal)"
2 : "Present (base)"

sounds(integer) : "CD track to play" : 0

light(integer) : "Ambient light" : 0 : "Set a global minimum light level of 'n' across the whole map. This is an easy way to eliminate completely dark areas of the level, however you may lose some contrast as a result, so use with care. Default 0"

reset_items(choices) : "Reset the player's inventory on spawn" : 0 =
0 "Don't reset the player's inventory"
1 "Reset to shotgun, axe, and 25 shells"
2 "Reset to axe only"

_sunlight(integer) : "Sunlight" : 0 : "Set the brightness of the sunlight coming from an unseen sun in the sky. Sky brushes (or more accurately bsp leafs with sky contents) will emit sunlight at an angle specified by the _sun_mangle key. Default 0"

_sun_mangle(string) : "Sun mangle (Yaw pitch roll)" : "0 -90 0" : "Specifies the direction of sunlight using yaw(x), pitch(y) and roll(z) in degrees. Yaw specifies the angle around the Z-axis from 0 to 359 degrees and pitch specifies the angle from 90 (straight up) to -90 (straight down). Roll has no effect, so use any value (e.g. 0). Default is straight down (0 -90 0)"

_sunlight_penumbra(integer) : "Sunlight penumbra in degrees" : 0 : "Specifies the penumbra width, in degrees, of sunlight. Useful values are 3-4 for a gentle soft edge, or 10-20+ for more diffuse sunlight. Default is 0"

_sunlight_color(color255) : "Sunlight color R G B" : "255 255 255" : "Specify red(r), green(g) and blue(b) components for the colour of the sunlight. RGB component values are between 0 and 255 (between 0 and 1 is also accepted). Default is white light (255 255 255)"

_sunlight2(integer) : "Sunlight 2 brightness" : 0 : "Set the brightness of a large dome of lights positioned around the map (16K unit radius). Useful for simulating higly diffused light (e.g. cloudy skies) in outdoor areas. Default 0"

_sunlight2_color(color255) : "Sunlight 2 color R G B" : "255 255 255" : "Specifies the colour of _sunlight2, same format as _sunlight_color. Default is white light (255 255 255)"

_sunlight3(integer) : "Sunlight 3 brightness" : 0 : "Same as _sunlight2 but creates lights on the bottom hemisphere. Default 0"

_sunlight3_color(color255) : "Sunlight 3 color R G B" : "255 255 255" : "Specifies the colour of _sunlight3, same format as _sunlight_color. Default is white light (255 255 255)"

_dist(integer) : "Global light scale" : 1 : "Scales the fade distance of all lights by a factor of n. If n is more than 1 lights fade more quickly with distance and if n is less than 1, lights fade more slowly with distance and light reaches further"

_range(float) : "Global light range" : "0.5" : "Scales the brightness range of all lights without affecting their fade discance. Values of n more than 0.5 makes lights brighter and n less than 0.5 makes lights less bright. The same effect can be achieved on individual lights by adjusting both the 'light' and 'wait' attributes"

_anglescale(float) : "Light angle scale" : "0.5" : "Sets a scaling factor for how much influence the angle of incidence of sunlight on a surface has on the brightness of the surface. n must be between 0.0 and 1.0. Smaller values mean less attenuation, with zero meaning that angle of incidence has no effect at all on the brightness. Default 0.5"

_dirt(integer) : "Dirt mapping (AO)" : -1 : "1 enables dirtmapping (ambient occlusion) on all lights, borrowed from q3map2. This adds shadows to corners and crevices. You can override the global setting for specific lights with the _dirt light entity key or _sunlight_dirt, _sunlight2_dirt, and _minlight_dirt worldspawn keys. Default is no dirtmapping (-1)"

_sunlight_dirt(integer) : "Sunlight dirt" : -1 : "1 enables dirtmapping (ambient occlusion) on sunlight, -1 to disable (making it illuminate the dirtmapping shadows). Default is to use the value of '_dirt'"

_sunlight2_dirt(integer) : "Sublight 2 dirt" : -1 : "1 enables dirtmapping (ambient occlusion) on sunlight2, -1 to disable. Default is to use the value of '_dirt'"

_minlight_dirt(integer) : "Minlight dirt" : -1 : "1 enables dirtmapping (ambient occlusion) on minlight, -1 to disable. Default is to use the value of '_dirt'"

_dirtmode(integer) : "Dirt mode" : 0 : "Choose between ordered (0, default) and randomized (1) dirtmapping."

_dirtdepth(integer) : "Dirt depth" : 128 : "Maximum depth of occlusion checking for dirtmapping, default 128."

_dirtscale(integer) : "Dirt scale" : 1 : "Scale factor used in dirt calculations, default 1. Lower values (e.g. 0.5) make the dirt fainter, 2.0 would create much darker shadows"

_dirtgain(integer) : "Dirt gain" : 1 : "Exponent used in dirt calculation, default 1. Lower values (e.g. 0.5) make the shadows darker and stretch further away from corners"

_gamma(integer) : "Lightmap gamma" : 1 : "Adjust brightness of final lightmap. Default 1, >1 is brighter, <1 is darker"

fog(string) : "Fog Command" :  : "ENGINE only 'console command' for setting fog parameters, Density/R/G/B example = (0.05 0.3 0.3 0.3)."

fog_density(string) : "Fog Density example = (0.05)"

fog_color(string) : "Fog Color R/G/B example = (0.3 0.3 0.3)"

sky(string) : "Sky Texture" :  : "Must have compatible skybox textures in gfx/env folder."
*/
//=======================
void() worldspawn =
{
	DetectKnownRelease ();

	InitNewSpawnflags ();  // new spawnflags for all entities -- iw

	lastspawn = world;
	InitBodyQue ();

// custom map attributes
	if (self.model == "maps/e1m8.bsp" && self.skip_id1_overrides == 0)
		cvar_set ("sv_gravity", "100");
	else
		cvar_set ("sv_gravity", "800");

	cutscene = 0;   // No cutscene is active during worldspawn. Drake -- dumptruck_ds

	world_sounds = &world.sounds;  //Spike via dumptruck_ds || not read-only yet...

// the area based ambient sounds MUST be the first precache_sounds

// player precaches
	W_Precache ();			// get weapon precaches

// sounds used from C physics code
	precache_sound_land ("demon/dland2.wav");		// landing thud
	precache_sound ("misc/h2ohit1.wav");		// landing splash

// setup precaches always needed
	precache_sound ("items/itembk2.wav");		// item respawn sound
	precache_sound ("player/plyrjmp8.wav");		// player jump
	precache_sound ("player/land.wav");			// player landing
	precache_sound ("player/land2.wav");		// player hurt landing
	precache_sound ("player/drown1.wav");		// drowning pain
	precache_sound ("player/drown2.wav");		// drowning pain
	precache_sound ("player/gasp1.wav");		// gasping for air
	precache_sound ("player/gasp2.wav");		// taking breath
	precache_sound ("player/h2odeath.wav");		// drowning death

	precache_sound ("misc/talk.wav");			// talk
	precache_sound ("player/teledth1.wav");		// telefrag
	precache_sound ("misc/r_tele1.wav");		// teleport sounds
	precache_sound ("misc/r_tele2.wav");
	precache_sound ("misc/r_tele3.wav");
	precache_sound ("misc/r_tele4.wav");
	precache_sound ("misc/r_tele5.wav");
	precache_sound ("weapons/lock4.wav");		// ammo pick up
	precache_sound ("weapons/pkup.wav");		// weapon up
	precache_sound ("items/armor1.wav");		// armor up
	precache_sound ("weapons/lhit.wav");		//lightning
	precache_sound ("weapons/lstart.wav");		//lightning start

	// iw -- fix powerup cheat sounds // noticed this in Copper so why not? --ds
	// sounds used by cheats
		precache_sound ("items/suit2.wav");			// suit (finish)
		precache_sound ("items/protect2.wav");		// pent (finish)
		precache_sound ("items/protect3.wav");		// pent (protect)
		precache_sound ("items/inv2.wav");			// ring (finish)
		precache_sound ("items/inv3.wav");			// ring (idle)
		precache_sound ("items/damage2.wav");		// quad (finish)
		precache_sound ("items/damage3.wav");		// quad (attack)
	// iw -- END

	precache_sound ("misc/power.wav");			//lightning for boss

// player gib sounds
	precache_sound ("player/gib.wav");			// player gib sound
	precache_sound ("player/udeath.wav");		// player gib sound
	precache_sound ("player/tornoff2.wav");		// gib sound

// player pain sounds

	precache_sound ("player/pain1.wav");
	precache_sound ("player/pain2.wav");
	precache_sound ("player/pain3.wav");
	precache_sound ("player/pain4.wav");
	precache_sound ("player/pain5.wav");
	precache_sound ("player/pain6.wav");

// player death sounds
	precache_sound ("player/death1.wav");
	precache_sound ("player/death2.wav");
	precache_sound ("player/death3.wav");
	precache_sound ("player/death4.wav");
	precache_sound ("player/death5.wav");

// ax sounds
	precache_sound ("weapons/ax1.wav");			// ax swoosh
	precache_sound ("player/axhit1.wav");		// ax hit meat
	precache_sound ("player/axhit2.wav");		// ax hit world

	precache_sound ("player/h2ojump.wav");		// player jumping into water
	precache_sound ("player/slimbrn2.wav");		// player enter slime
	precache_sound ("player/inh2o.wav");		// player enter water
	precache_sound ("player/inlava.wav");		// player enter lava
	precache_sound ("misc/outwater.wav");		// leaving water sound

	precache_sound ("player/lburn1.wav");		// lava burn
	precache_sound ("player/lburn2.wav");		// lava burn

	precache_sound ("misc/water1.wav");			// swimming
	precache_sound ("misc/water2.wav");			// swimming

	precache_model ("progs/player.mdl");
	precache_model ("progs/s_null.spr");  // Invisible -- Drake -- dumptruck_ds
	// precache_model ("progs/null_256.spr");  // Invisible -- Drake -- dumptruck_ds
	precache_model ("progs/eyes.mdl");
	precache_model ("progs/h_player.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_model ("progs/s_bubble.spr");	// drowning bubbles
	precache_model ("progs/s_explod.spr");	// sprite explosion

	precache_model ("progs/v_axe.mdl");
	precache_model ("progs/v_shot.mdl");
	precache_model ("progs/v_nail.mdl");
	precache_model ("progs/v_rock.mdl");
	precache_model ("progs/v_shot2.mdl");
	precache_model ("progs/v_nail2.mdl");
	precache_model ("progs/v_rock2.mdl");

	precache_model ("progs/bolt.mdl");		// for lightning gun
	precache_model ("progs/bolt2.mdl");		// for lightning gun
	precache_model ("progs/bolt3.mdl");		// for boss shock
	precache_model ("progs/lavaball.mdl");	// for testing

	precache_model ("progs/missile.mdl");
	precache_model ("progs/grenade.mdl");
	precache_model ("progs/spike.mdl");
	// dumptruck_ds added w_spike due to errors
	// with custom_mdls in precache_proj_model in wizard.qc
	// precache_model ("progs/w_spike.mdl");
	// this is on hold for now head and body are working
	precache_model ("progs/s_spike.mdl");

	precache_model ("progs/backpack.mdl");

	precache_model ("progs/zom_gib.mdl");

	precache_model ("progs/v_light.mdl");

	precache_model ("progs/w_s_key.mdl"); // dumptruck_ds needed for DropStuff
	precache_model ("progs/w_g_key.mdl"); //
	precache_sound ("misc/medkey.wav");
	precache_sound ("misc/runekey.wav");
	precache_model ("progs/m_s_key.mdl");
	precache_model ("progs/m_g_key.mdl");
	precache_sound2 ("misc/basekey.wav");
	precache_model2 ("progs/b_s_key.mdl");
	precache_model2 ("progs/b_g_key.mdl");
	precache_model ("progs/h_mdls/pd_vial.mdl"); // DropVial -- dumptruck_ds
	precache_sound ("items/r_item1.wav");
	precache_sound ("dump/armsh1.wav"); // DropShard -- dumptruck_ds
	precache_model ("progs/armshr.mdl");

//
// Setup light animation tables. 'a' is total darkness, 'z' is maxbright.
//

	// 0 normal
	lightstyle(0, "m");

	// 1 FLICKER (first variety)
	lightstyle(1, "mmnmmommommnonmmonqnmmo");

	// 2 SLOW STRONG PULSE
	lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");

	// 3 CANDLE (first variety)
	lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");

	// 4 FAST STROBE
	lightstyle(4, "mamamamamama");

	// 5 GENTLE PULSE 1
	lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");

	// 6 FLICKER (second variety)
	lightstyle(6, "nmonqnmomnmomomno");

	// 7 CANDLE (second variety)
	lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");

	// 8 CANDLE (third variety)
	lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");

	// 9 SLOW STROBE (fourth variety)
	lightstyle(9, "aaaaaaaazzzzzzzz");

	// 10 FLUORESCENT FLICKER
	lightstyle(10, "mmamammmmammamamaaamammma");

	// 11 SLOW PULSE NOT FADE TO BLACK
	lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");

	// styles 32-62 are assigned by the light program for switchable lights

	// 63 testing
	lightstyle(63, "a");
};

void() RestartLoopSounds_think = {
	sound(self, self.impulse, self.noise, self.volume, self.speed);
};

void() RestartLoopSounds = {
	entity e;
	e = find(world, classname, "play_sound_triggered");
	while (e) {

		if (e.spawnflags & 3 == 3) { // both "toggle" and "looped" need to be set
			if (e.state == 1) {
				e.nextthink = time + 0.1;
				e.think = RestartLoopSounds_think;
			}
		}

		e = find(e, classname, "play_sound_triggered");
	}
};


void() StartFrame =
{
	if (!done_inhibition_summary)  // new spawnflags for all entities -- iw
		PrintInhibitionSummary ();

	teamplay = cvar("teamplay");
	skill = cvar("skill");
	framecount = framecount + 1;

	if (cleanUpClientStuff) {
		cleanUpClientStuff -= 1;

		RestartLoopSounds();
	}
	else if (!gamestarted && framecount > 2)
	{
		if (framecount != 3)
			cleanUpClientStuff += 2;

		gamestarted = TRUE;
	}
};

/*
==============================================================================

BODY QUE

==============================================================================
*/

entity	bodyque_head;

void() bodyque =
{	// just here so spawn functions don't complain after the world
	// creates bodyques
};

void() InitBodyQue =
{
	bodyque_head = spawn();
	bodyque_head.classname = "bodyque";
	bodyque_head.owner = spawn();
	bodyque_head.owner.classname = "bodyque";
	bodyque_head.owner.owner = spawn();
	bodyque_head.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner = spawn();
	bodyque_head.owner.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner.owner = bodyque_head;
};


// make a body que entry for the given ent so the ent can be
// respawned elsewhere
void(entity ent) CopyToBodyQue =
{
	bodyque_head.angles = ent.angles;
	bodyque_head.model = ent.model;
	bodyque_head.modelindex = ent.modelindex;
	bodyque_head.frame = ent.frame;
	bodyque_head.colormap = ent.colormap;
	bodyque_head.movetype = ent.movetype;
	bodyque_head.velocity = ent.velocity;
	bodyque_head.flags = 0;
	setorigin (bodyque_head, ent.origin);
	setsize (bodyque_head, ent.mins, ent.maxs);
	bodyque_head = bodyque_head.owner;
};
