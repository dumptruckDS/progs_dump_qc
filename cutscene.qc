// Heavily modified for Drake.

// player_run prototype is in proto.qc.
void() DHM_CalcMoveDone;
void() move_camera;
//- - - - - - - - - - - - - - - - - - -
// This resets air capacity and drowning damage.
void(entity ent) more_air =
{
//- - - - - - - - -
    ent.air_finished = time + 12;
    ent.dmg = 2;        // initial water damage
};

// ============================================ //
// |        Movie camera trigger  - dhm       | //
// ============================================ //


// 'o' should be other, who in turn is the player who touched camera trigger.
void(entity o) spawn_dummy =
{
local   entity  s;

    s = spawn ();
//    s.origin        = o.origin;
    s.velocity      = o.velocity;
    s.angles        = o.angles;
    s.health        = o.health;
    s.weapon        = o.weapon;
    s.classname     = "dummy";
    s.movetype      = MOVETYPE_NONE;
    s.solid         = SOLID_NOT;
    setmodel (s, "progs/player.mdl"); // set temp player model in case camera can see -- dumptruck_ds
    if (s.weapon == IT_AXE)
    {
      s.frame = 0; // standing there with axe -- dumptruck_ds
    }
    else
    s.frame = 12; // standing there with gun -- dumptruck_ds
    s.weaponmodel   = o.weaponmodel;
    s.flags         = o.flags;
    s.effects       = o.effects;
    s.items         = o.items;
    s.enemy         = o.enemy;      // PM:  o.enemy changed to camera later.

// Save powerups
// Pentagram
    if (o.invincible_finished)
    {   s.invincible_finished = o.invincible_finished - time;
        if (o.invincible_time)
            s.invincible_time = o.invincible_time - time;
    }
    else
        s.invincible_finished = s.invincible_time = 0;
// Ring of Shadows
    if (o.invisible_finished)
    {   s.invisible_finished = o.invisible_finished - time;
        if (o.invisible_time)
            s.invisible_time = o.invisible_time - time;
    }
    else
        s.invisible_finished = s.invisible_time = 0;
// Quad Damage
    if (o.super_damage_finished)
    {   s.super_damage_finished = o.super_damage_finished - time;
        if (o.super_time)
            s.super_time = o.super_time - time;
    }
    else
        s.super_damage_finished = s.super_time = 0;
// Biosuit
    if (o.radsuit_finished)
    {   s.radsuit_finished = o.radsuit_finished - time;
        if (o.rad_time)
            s.rad_time = o.rad_time - time;
    }
    else
        s.radsuit_finished = s.rad_time = 0;
// // Empathy Shields
//     if (o.thorns_finished)
//     {   s.thorns_finished = o.thorns_finished - time;
//         if (o.thorns_time)
//             s.thorns_time = o.thorns_time - time;
//     }
//     else
//         s.thorns_finished = s.thorns_time = 0;
// // Cross of Deflection
//     if (o.cross_finished)
//     {   s.cross_finished = o.cross_finished - time;
//         if (o.cross_time)
//             s.cross_time = o.cross_time - time;
//     }
//     else
//         s.cross_finished = s.cross_time = 0;
// // Dark Angel Wings
//     if (o.wing_finished)
//     {   s.wing_finished = o.wing_finished - time;
//         if (o.wing_time)
//             s.wing_time = o.wing_time - time;
//     }
//     else
//         s.wing_finished = s.wing_time = 0;
// // Amulet of Reflection
//     if (o.mirror_finished)
//     {   s.mirror_finished = o.mirror_finished - time;
//         if (o.mirror_time)
//             s.mirror_time = o.mirror_time - time;
//     }
//     else
//         s.mirror_finished = s.mirror_time = 0;
// // Tome of Power
//     if (o.tome_finished)
//     {   s.tome_finished = o.tome_finished - time;
//         if (o.tome_time)
//             s.tome_time = o.tome_time - time;
//     }
//     else
//         s.tome_finished = s.tome_time = 0;

// FIXME:  Called during touch func, don't set directly?
    setorigin (s, o.origin);

// PM:  Link player to dummy, for now.
    if (o)  //.classname == "player")
        if (!o.trigger_field)
            o.trigger_field  = s;
};

// PM:  Removed 'name_player'; no longer needed.

void() go_back =
{
local   entity  t, c, cvars, old;
local   string  val;

    t = find (world, classname, "dummy");
    if (!t)
        objerror ("couldn't find dummy");
    t.solid = SOLID_NOT;    // So player won't bounce back.
    setmodel (t, ""); // remove temp player model upon return -- dumptruck_ds

    c = find (world, classname, "camera");
    if (!c)
        objerror ("couldn't find camera");

    c.oldorigin     = t.origin;     // So player won't bounce back to cam.

// FIXME:  Check the new vars.
    setorigin (c, t.origin);
    c.velocity      = t.velocity;
    c.view_ofs      = '0 0 22';     // PM:  Morph should take care of itself.
    c.angles_x      = t.angles_x;
    c.angles_y      = t.angles_y;
    c.angles_z      = 0;
    c.health        = t.health;
    c.weapon        = t.weapon;
    c.weaponframe   = 0;
    c.weaponmodel   = t.weaponmodel;
    c.flags         = t.flags;
    c.effects       = t.effects;
    c.items         = t.items;
    c.enemy         = t.enemy;      // PM:  Restore client's original enemy.

// Restore powerups
    if (t.invincible_finished)
    {   c.invincible_finished = time + t.invincible_finished;
        if (t.invincible_time)
            c.invincible_time = time + t.invincible_time;
    }
    if (t.invisible_finished)
    {   c.invisible_finished = time + t.invisible_finished;
        if (t.invisible_time)
            c.invisible_time = time + t.invisible_time;
    }
    if (t.super_damage_finished)
    {   c.super_damage_finished = time + t.super_damage_finished;
        if (t.super_time)
            c.super_time = time + t.super_time;
    }
    if (t.radsuit_finished)
    {   c.radsuit_finished = time + t.radsuit_finished;
        if (t.rad_time)
            c.rad_time = time + t.rad_time;
    }
    // if (t.thorns_finished)
    // {   c.thorns_finished = time + t.thorns_finished;
    //     if (t.thorns_time)
    //         c.thorns_time = time + t.thorns_time;
    // }
    // if (t.cross_finished)
    // {   c.cross_finished = time + t.cross_finished;
    //     if (t.cross_time)
    //         c.cross_time = time + t.cross_time;
    // }
    // if (t.wing_finished)
    // {   c.wing_finished = time + t.wing_finished;
    //     if (t.wing_time)
    //         c.wing_time = time + t.wing_time;
    // }
    // if (t.mirror_finished)
    // {   c.mirror_finished = time + t.mirror_finished;
    //     if (t.mirror_time)
    //         c.mirror_time = time + t.mirror_time;
    // }
    // if (t.tome_finished)
    // {   c.tome_finished = time + t.tome_finished;
    //     if (t.tome_time)
    //         c.tome_time = time + t.tome_time;
    // }

    c.fixangle      = 1;        // turn this way immediately
    c.takedamage    = DAMAGE_AIM;
    c.solid         = SOLID_SLIDEBOX;
    c.movetype      = MOVETYPE_WALK;
    c.nextthink     = time;
    c.think         = player_run;   // PM:  Reset player anim frames.
    more_air (c);   // No gasping from you!

    // c.xfl           = c.xfl | XFL_ITEMS;     // Restore pickup again. Drake -- dumptruck_ds

// Yes, you CAN change the classname here since the 'find' command already
// found the camera.  It is best to change the classname back to player now.
    c.classname     = "player";
    cutscene = 0;       // Cutscene OFF
    stuffcmd (c, "-forward\n");
    stuffcmd (c, "-strafe\n");

// Look for any CVARSET entities to restore old cvars that
// were changed for the cut-scene
    if (c.ideal_yaw == -1)
    {
        cvars = find(world, classname, "cvar_done");
        while (cvars)   // != world)
        {
            if (!cvars.message)
                cvars.message = cvars.model;
            cvar_set (cvars.netname, cvars.script);
            old = cvars;
            cvars = find (cvars, classname, "cvar_done");
            remove (old);
        }
        c.ideal_yaw = 0;
    }

    val = ftos (c.cnt);
    cvar_set ("viewsize", val);      //restore old viewsize
//    stuffcmd (c, "sizedown\nsizeup\n");   //hack-fix for GLquake

    t.nextthink = time + 0.1;
    t.think = SUB_Remove;
    remove (self);
};

//===============
// This routine short-circuits player turning and movement while in camera
// mode.  self.oldorigin is used as self.angles, and self.mangle is used as
// self.velocity.  This allows me to compute these figures in code, and
// overwrite what the game thinks they should be.  Called from 'client.qc'.
//===============
void() look_ahead =
{
// PM:  Vision style cam sets angles to mangle and velocity to zeroes.
// The camera in vision mode cutscenes cannot move.
//    if (vision)
//    {
//        self.angles = self.enemy.mangle;
//        self.fixangle = 1;
//        // self.nextthink removed since it's done in PlayerPreThink.
//        return;
//    }

// PM:  Using Zerstorer style cutscene code...
    self.angles = self.oldorigin;
    self.velocity = self.mangle;
    self.fixangle = 1;
    cvar_set ("viewsize", "120");        //keep screen maximized

    if (self.delay == 0)
    {
        local   vector  looky;

        looky_x = self.movedir_x - self.origin_x;
        looky_y = self.movedir_y - self.origin_y;
        looky_z = self.origin_z - self.movedir_z;
        self.oldorigin = vectoangles (looky);
    }
};

// This is a modified SUB_CalcMove routine.
void(vector tdest, float tspeed, entity cam) DHM_CalcMove =
{
local   vector  vdestdelta;
local   float   len, traveltime;

    self.finaldest = tdest;
    self.think = DHM_CalcMoveDone;

    if (tdest == cam.origin)
    {
        cam.velocity = cam.mangle = '0 0 0';
        self.nextthink = time + 0.01;
        return;
    }

// set destdelta to the vector needed to move
    vdestdelta = tdest - cam.origin;

// calculate length of vector
    len = vlen (vdestdelta);

// divide by speed to get time to reach dest
    traveltime = len / tspeed;

    if (traveltime < 0.1)
    {
        cam.velocity = cam.mangle = '0 0 0';
        self.nextthink = time + 0.01;
        return;
    }

// set nextthink to trigger a think when dest is reached
    self.nextthink = time + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
    cam.velocity = cam.mangle = vdestdelta * (1/traveltime);
};

//- - - - - - - - -
// Zerstorer-only cutscene code.
void() wait_camera =
{
    if (!self.wait)
        {move_camera (); return;}

    self.nextthink = time + self.wait;
    self.think = move_camera;
};

//============
// After moving, set origin to exact final destination
//============
void() DHM_CalcMoveDone =
{
    if (!cutscene)      // Old check:  if (self.enemy.classname != "camera")
        {remove (self); return;}

    setorigin(self.enemy, self.finaldest);
    self.enemy.velocity = self.enemy.mangle = '0 0 0';

    if (self.cnt == -1)
        {remove (self); return;}

    self.nextthink = time + 0.01;
    self.think = wait_camera;
};

void() move_camera =
{
local   entity  cpt, fpt;
local   vector  looky;

    if (!cutscene)      // Old check:  if (self.enemy.classname != "camera")
        {remove (self); return;}

    cpt = find (world, targetname, self.target);
    if (!cpt.target)     //if this is the end of the line, stop camera
    {
        self.think = SUB_Null;
        self.enemy.velocity = '0 0 0';
        self.enemy.mangle = '0 0 0';     //mangle == velocity in cut-scene
        DHM_CalcMoveDone();
        self.cnt = -1;    // remove control entity in DHM_CalcMoveDone
        //return;
    }
    if (cpt.focal_point)    //is there a new focal point?
    {
        fpt = find (world, targetname, cpt.focal_point);
        if (!fpt)
            objerror("Couldn't find new focal point!");

        self.enemy.movedir = fpt.origin;
        looky_x = self.enemy.movedir_x - self.enemy.origin_x;
        looky_y = self.enemy.movedir_y - self.enemy.origin_y;
        looky_z = self.enemy.origin_z - self.enemy.movedir_z;
        self.enemy.oldorigin = vectoangles (looky);
        self.enemy.angles = self.enemy.oldorigin;    //oldorigin == angles in CS
    }
// Check for auto-focus or still camera angle
    if (cpt.delay)
        self.enemy.delay = cpt.delay;
    else
        self.enemy.delay = 0;

    self.target = cpt.target;
    self.wait = cpt.wait;
    if(cpt.speed)
        self.speed = cpt.speed;
    DHM_CalcMove (cpt.origin, self.speed, self.enemy);
};
//- - - - - - - - -

void() go_camera =
{
local   vector  looky;

    cutscene = 1;   // Cutscene ON.

// Don't let player-turned-camera pick up items.
    // self.xfl        = self.xfl - (self.xfl & XFL_ITEMS);

// Change the player into a camera
// PM:  Ok, you win!  Too much stuff checks for 'player', so use 'camera'
// to be safe.  Just make sure alignment stuff doesn't break, namely
// friendly monsters getting mad at a player when they shouldn't.
    self.classname  = "camera";
    self.velocity   = '0 0 0';
    self.view_ofs   = '0 0 0';
    // PM:  Change the modelindex to a non-zero number that points to an
    //  invisible model so that the camera entity is invisible if seen
    //  because of reflective textures or builtin chasecam (chase_active 1).
    //  Requires my custom invisible model (which is a sprite).
    self.modelindex  = mindex_inviso;
    // Turn off glowing effects.
    self.effects     = 0;
    self.items       = 0;
    self.weaponmodel = "";      // Remove weapon from the screen.
//- - - - - - - - - - - - - - - - - - -
//    if (vision)
//    {
//        self.angles     = self.enemy.mangle;
//        self.fixangle   = 1;
//        self.movetype   = MOVETYPE_NONE;
//        self.takedamage = DAMAGE_NO;
//        self.solid      = SOLID_NOT;
//        self.weaponmodel= "";

        // Removed thinking since it's done by PlayerPreThink->Cutscene_Think.
//    }
//- - - - - - - - - - - - - - - - - - -
//    else    // Default to Zerstorer style cutscene.
    {
        looky_x = self.movedir_x - self.enemy.origin_x;
        looky_y = self.movedir_y - self.enemy.origin_y;
        looky_z = self.enemy.origin_z - self.movedir_z;
        self.oldorigin = vectoangles (looky);
        self.angles = self.oldorigin;        //oldorigin == angles in CS

    // Check if camera is auto-focus or not
        if (self.enemy.delay)
            self.delay = self.enemy.delay;
        else
            self.delay = 0;

        self.velocity = self.mangle = '0 0 0';

        self.dmg         = 0;   // PM:  Do we need this?
        self.fixangle    = 1;        // turn this way immediately
        self.movetype    = MOVETYPE_NOCLIP;
        self.takedamage  = DAMAGE_NO;
        // PM:  Solid cannot be 0 or else camera can't trigger stuff by touch.

    // Spawn a control function to handle moving the camera
        if (self.enemy.target)
        {
            local   entity  control;

            control = spawn();
            control.classname   = "camcontrol";
            control.enemy       = self;
            control.target      = self.enemy.target;
            control.speed       = self.enemy.speed;
            control.nextthink   = time + self.enemy.wait + 0.05;
            control.think       = move_camera;
        }
    }

// Setting script_count to 0 is what triggers the script to play,
// It will then play the script number.
    if (!self.script)
        dprint ("trigger_camera needs a script number!");
    self.script_count = 0;

    self.cnt = cvar("viewsize");
    cvar_set ("viewsize", "120");     //Full screen
    // PM:  Vision sets 'v_idlescale' for swaying screen.  Not in Drake!
    stuffcmd (self, "sizedown\nsizeup\n");   //hack-fix for GLquake
    stuffcmd (self, "+strafe\n");

    setorigin (self, self.enemy.origin);

//- - - - - - - - -
// PM:  Space invasion prevention.
// Make the dummy solid to prevent monsters or other junk from occupying
// the space where the player stood before the cutscene started.
// After all, the player will be placed back when the cutscene ends,
// and we don't want him stuck inside a monster or something.
//
// We need to wait until after the player becomes the camera, before we can
// make the dummy solid.  If we make the dummy solid as it spawned, the
// player could get stuck inside the dummy (instead of moving) between
// trigger activation and transformation to camera.
//
// In Vision code, player becomes camera a frame or so after trigger
// activation.  In Zer code, player becomes camera at the same time
// the trigger activates.
//
// Note:  If you still have trouble getting a Vision cutscene to work in a
// certain level, move the following code to the top of 'look_ahead'.
// Doing so would be less than ideal since the check would get called every
// frame during the cutscene, instead of just once here.
// The only level that still has problems with dummy made solid now
// is 'vision.bsp', which has its own pak.  Tronyn's maps, the levels
// that really matter, have no problems.
//- - - - - - - - -
// 'self' is the player-turned-camera entity.
    // '!self.trigger_field' is the world, and its classname is worldspawn.
    if (self.trigger_field.classname == "dummy")
    {
        self.trigger_field.solid = SOLID_BBOX;
        setsize (self.trigger_field, self.mins, self.maxs);

        self.trigger_field = world;     // Unlink now that it's done.
    }
//- - - - - - - - -
};

// PM:  Called from either touch or use.
void(entity who) camera_activate =
{
// only activate for player, 1st time touched
    if (who.health <= 0)
        return;
    if (who.deadflag)       // In case of Alien Quake facehugger kill.
        return;
    if (who.classname != "player")
        return;

// You can't touch/use this again.
    self.touch  = self.use  = SUB_Null;

// If player is on ground, take him off ground so no one gets confused
    who.flags = who.flags - (who.flags & FL_ONGROUND);

// put a dummy where the player was
    spawn_dummy (who);

// find camera
    local   entity  t;

    t = find (world, targetname, self.target);
//    if (vision)
//    {
//        if (!t)
//            objerror ("couldn't find target");
//    }
//    else
    {
        local   entity  fpt;

        while ((t != world) && (t.classname != "info_movie_camera"))
            t = find (t, targetname, self.target);
        if (!t)
            objerror ("couldn't find target");

    // find focal point
        fpt = find (world, targetname, self.focal_point);
        if (!fpt)
            objerror ("You must have a focal point!\n");
        else
            who.movedir = fpt.origin;    //movedir used to calc focal dir
    }

// Go to the camera - not in this function, because touch functions are
// called while looping through c code, and you don't want to move the
// player, or something like that?
    who.enemy = t;        //save camera position, etc.
    who.script = self.script;    //save script number
    who.script_delay = self.script_delay;  //save delay for page 1

//    if (vision)
//    {   // PM:  Don't try instant start because that breaks soeexit.bsp.
//        who.nextthink = time + 0.05;
//        who.think = go_camera;
//    }
//    else
        SUB_Think (who, go_camera);

    activator = self;
    SUB_UseTargets ();

//Remove the trigger_camera from level
    self.nextthink = time + 0.1;
    self.think = SUB_Remove;
};

void() camera_touch =
{
    if (self.targetname)
        if (self.nextthink < time)
            return;
    if (self.cnt == -1)
        return;
    camera_activate (other);
};
void() camera_point_touch = {camera_activate (other);};

//============
// --> QUAKED info_movie_camera (.5 .5 .5) (-8 -8 -8) (8 8 32) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

// This is the destination marker for a camera.  It should have a "targetname"
// field with the same value as a camera-trigger's "target" field.
//============
void() imc_touch =
{
local   string  temps;

    if (other.classname != "camera")
        return;
    temps = self.target;
    self.target = self.message;
    SUB_UseTargets();
    self.target = temps;
    if (self.cnt)
        return;

    self.think = SUB_Remove;
    self.nextthink = time + 10;
    self.solid = SOLID_NOT;
};

void() info_movie_camera =
{
// this does nothing, just serves as a target spot
//    if (vision)
//        return;

// ...more than a spot in Zer mode.
    //self.use = SUB_Null;
    self.solid = SOLID_TRIGGER;
    setorigin(self, self.origin);
    setsize(self, '-8 -8 -8', '8 8 8');
    self.touch = imc_touch;
};

void() camera_use =
{
    local   entity  pl;

    pl = find(world, classname, "player");    // Only one in single-player.
    camera_activate (pl);

// Old code.
//    self.nextthink = time + 100000;
//    force_retouch = 2;        // make sure even still objects get hit
//    self.think = SUB_Null;
};

//- - - - - - - - -
// Zerstorer-only cutscene code.
void() gocam_use =
{
local   entity  control, temp;

    control = find(world, classname, "camcontrol");
    if (control == world)
        dprint ("Can't find camcontrol!\n");

    temp = self;
    self = control;
    DHM_CalcMoveDone ();
    self = temp;
    self.nextthink = time + 0.1;
    self.think = SUB_Remove;
};

void() trigger_gocamera = {self.use = gocam_use;};

/*QUAKED info_focal_point (.5 .5 .5) (-8 -8 -8) (8 8 32) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
This is the point that the camera will face.  It should have a "targetname"
field with the same value as a camera-trigger's "focal_point" field.
*/
// PM:  This entity is kept only for map compatibility reasons.
// Otherwise, this entity is redundant.  Use 'info_notnull' instead.
void() info_focal_point = {};   // just holds a spot for the focal point.

void(float pt) trigger_camera_spawn =
{
// Update:  Don't let dmsp muck up cutscenes and vice versa.
    if (deathmatch || coop)
        {remove (self);  return;}   // PM:  Fix -- abort if removed.

    if (pt)
    {   // The new way, this is for you Tronyn.
        InitPointTrigger ();
        if (!self.targetname)
            self.touch = camera_point_touch;
    }
    else
    {   // The old way...
        InitTrigger ();
        // PM:  Must always allow touch because some old maps need it.
        self.touch = camera_touch;
    }
    // find the destination
    if (!self.target)
        objerror ("Camera trigger with no target");
    self.use = camera_use;
};

/*QUAKED trigger_camera (.5 .5 .5) ? X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
A player touching this will be transported to the corresponding
info_movie_camera entity.  You must set the "target" field, and put a
info_movie_camera with a "targetname" field that matches.  The "script"
key gives a starting script number, and the "script_delay" key is the
amount of time(seconds) to stay on the first script page.

If the trigger_camera has a targetname, it will only enter camera mode
after it has been fired.
*/
void() trigger_camera = {trigger_camera_spawn (FALSE);};

/*QUAKED trigger_camera_point (.5 .5 .5) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
When this is triggered the player will be transported to the corresponding
info_movie_camera entity.  You must set the "target" field, and put a
info_movie_camera with a "targetname" field that matches.  The "script"
key gives a starting script number, and the "script_delay" key is the
amount of time(seconds) to stay on the first script page.
*/
void() trigger_camera_point = {trigger_camera_spawn (TRUE);};

//----------------------------------
//       Scripting function - dhm
//----------------------------------
// The original timing idea for scripts was inspired by Zoid.  Study the
// code for Zoid's CTF, it is an excellent example of good Quake-C coding.
// Also look at all of Quake Command's stuff.  Wedge rules.
//----------------------------------
// Script_play is called from PlayerPreThink()
// 'self' is the player (camera)
//----------------------------------
void() Script_play =
{
local   entity  scrpt;

    scrpt = find (world, script_num, self.script);
    if (!scrpt)
       dprint ("Error: script not found!");

    // If script has a target, trigger it once.
//    if (!vision)
        if (scrpt.target)
        {
            local   entity  temp;

            temp = self;
            self = scrpt;
            SUB_UseTargets ();
            self.target = world.null_string;
            self = temp;
        }

    self.script_delay = scrpt.script_delay;
    self.script_time = time + 1;
    self.script_count = self.script_count + 1;
    centerprint (self, scrpt.message);

    if (self.script_count == self.script_delay)
    {
        self.script = scrpt.next_script;
        if (self.script != "0")
            self.script_count = 0;
        else
        {
            scrpt.nextthink = time + 3;
            scrpt.classname = "going_back";
            scrpt.think = go_back;
        }
    }
};


//- - - - - - - - -
// PM:  Player thinking during a cutscene.  Called by 'PlayerPreThink'.
void() Cutscene_Think =
{
  /* --------------------------------------------
    If we are in camera mode, play the script.
     -------------------------------------------- */
        // PM:  Allow player to stop cutscene on any map.
        if (self.impulse)
            if (self.script_count != 1000000)
            {
                local   entity  goback;     // PM:  dhm's cutscene code.

                self.script_count = 1000000;
                // if (world.model == "maps/soeexit.bsp")
                // {   // Hack:  Jump directly to intermission/credits.
                //     NextLevel ();
                //     return;
                // }
                // If cut-scene has ended, and user tries to exit, don't
                // spawn a second go_back control entity.
                goback = find(world, classname, "going_back");
                if (!goback)
                {
                   sprint(self, "...\n");
                   goback = spawn();
                   goback.nextthink = time + 1.5;
                   goback.think = go_back;
                   self.impulse = 0;    // PM:  New -- just kill cutscene.
                }
            }

        if (cutscene)       // PM:  Vision didn't look_ahead here, but do it
            look_ahead ();  //  anyway instead of thinking about it.
        if (self.script_count < self.script_delay)
            if (self.script_time < time)
                Script_play ();
};

void() script_sound_play =
{
  if (self.noise != "")
  	sound (other, CHAN_AUTO, self.noise, 1, ATTN_NONE);
  	else
  	sound (other, CHAN_AUTO, self.noise1, 1, ATTN_NONE);
};
//- - - - - - - - -
//============
// --> QUAKED info_script_sound (.5 .5 .5) (-8 -8 -8) (8 8 32) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

// This is the noise player for a script.

void() info_script_sound =
{
  if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
  return;
  //play all the sounds available for a normal trigger
  if (self.sounds == 0)
  {
      precache_sound ("misc/null.wav");
      self.noise = "misc/null.wav";
  }
  else if (self.sounds == 1)
  {
      precache_sound ("misc/secret.wav");
      self.noise = "misc/secret.wav";
  }
  else if (self.sounds == 2)
  {
      precache_sound ("misc/talk.wav");
      self.noise = "misc/talk.wav";
  }
  else if (self.sounds == 3)
  {
      precache_sound ("misc/trigger1.wav");
      self.noise = "misc/trigger1.wav";
  }
  else if (self.sounds == 4)
  {
    if (!self.noise1) //dumptruck_ds
    {
      objerror ("no soundfile set in noise1!\n");
      remove(self);
      return;
    }
    else
      precache_sound (self.noise1);
      self.noise = self.noise1;
  }
    self.use = script_sound_play;
};

//============
// --> QUAKED info_script (.5 .5 .5) (-8 -8 -8) (8 8 32)
// This is the destination marker for a script.
// It should have a "script_num" field that signifies the script number, and
// a "next_script" to signal the next script ("0" if this is the last page of
// the script), a "script_delay" to signify how many seconds to display this
// page, and of course a "message" field with the text to display.
//
// PM:  Use 'info_notnull' instead.
//============
void() info_script =
{
    if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
        return;
};


// ------------------------------ //
// |       trigger_cvarset      | //
// ------------------------------ //
//============
// --> QUAKED trigger_cvarset (.5 .5 .5) (-8 -8 -8) (8 8 32)
// You can set any CVAR on the server with this trigger.  Put the CVAR name
// in "netname" and put the value in "message".  Useful CVAR's are
// sv_gravity, sv_friction, fov, and v_idlescale.
//============
void() change_cvar =
{
local   entity  check;

    cvar_set (self.netname, self.message);
    bprint("\n\n\n\n");

    self.classname = "cvar_done";
    check = find(world, classname, "player");
    if (!check)
        check = find(world, classname, "camera");

    check.ideal_yaw = -1;

    self.nextthink = time + 0.02;
    self.think = SUB_UseTargets;
};

void() cvarset_touch =
{
    if (self.cnt > time || other.health <= 0 || other.classname != "player")
        return;

    change_cvar ();
};

void() trigger_cvarset =
{
    if (deathmatch || coop)
        remove (self);

    InitTrigger ();
    self.use = change_cvar;
};


// PM:  Removed gravity and earthquake entities.

//===========================/  END OF FILE  /===========================//
