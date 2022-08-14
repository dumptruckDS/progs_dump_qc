/*
==============================================================================

			SOURCE FOR GLOBALVARS_T C STRUCTURE

==============================================================================
*/

//
// system globals
//
entity		self;
entity		other;
entity		world;
float		time;
float		frametime;

float		force_retouch;		// force all entities to touch triggers
								// next frame.  this is needed because
								// non-moving things don't normally scan
								// for triggers, and when a trigger is
								// created (like a teleport trigger), it
								// needs to catch everything.
								// decremented each frame, so set to 2
								// to guarantee everything is touched
string		mapname;

float		deathmatch;
float		coop;
float		teamplay;

float		serverflags;		// propagated from level to level, used to
								// keep track of completed episodes

float		total_secrets;
float		total_monsters;

float		found_secrets;		// number of secrets found
float		killed_monsters;	// number of monsters killed


// spawnparms are used to encode information about clients across server
// level changes
float		parm1, parm2, parm3, parm4, parm5, parm6, parm7, parm8, parm9, parm10, parm11, parm12, parm13, parm14, parm15, parm16;

//
// global variables set by built in functions
//
vector		v_forward, v_up, v_right;	// set by makevectors()

// set by traceline / tracebox
float		trace_allsolid;
float		trace_startsolid;
float		trace_fraction;
vector		trace_endpos;
vector		trace_plane_normal;
float		trace_plane_dist;
entity		trace_ent;
float		trace_inopen;
float		trace_inwater;

entity		msg_entity;				// destination of single entity writes

//
// required prog functions
//
void() 		main;						// only for testing

void()		StartFrame;

void() 		PlayerPreThink;
void() 		PlayerPostThink;

void()		ClientKill;
void()		ClientConnect;
void() 		PutClientInServer;		// call after setting the parm1... parms
void()		ClientDisconnect;

void()		SetNewParms;			// called when a client first connects to
									// a server. sets parms so they can be
									// saved off for restarts

void()		SetChangeParms;			// call to set parms for self so they can
									// be saved for a level transition


//================================================
void		end_sys_globals;		// flag for structure dumping
//================================================

/*
==============================================================================

			SOURCE FOR ENTVARS_T C STRUCTURE

==============================================================================
*/

//
// system fields (*** = do not set in prog code, maintained by C code)
//
.float		modelindex;		// *** model index in the precached list
.vector		absmin, absmax;	// *** origin + mins / maxs

.float		ltime;			// local time for entity
.float		movetype;
.float		solid;

.vector		origin;			// ***
.vector		oldorigin;		// ***
.vector		velocity;
.vector		angles;
.vector		avelocity;

.vector		punchangle;		// temp angle adjust from damage or recoil

.string		classname;		// spawn function
.string		model;
.float		frame;
.float		skin;
.float		effects;

.vector		mins, maxs;		// bounding box extents reletive to origin
.vector		size;			// maxs - mins

.void()		touch;
.void()		use;
.void()		think;
.void()		blocked;		// for doors or plats, called when can't push other

.float		nextthink;
.entity		groundentity;

// stats
.float		health;
.float		frags;
.float		weapon;			// one of the IT_SHOTGUN, etc flags
.string		weaponmodel;
.float		weaponframe;
.float		currentammo;
.float		ammo_shells, ammo_nails, ammo_rockets, ammo_cells;

.float		items;			// bit flags

.float		takedamage;
.entity		chain;
.float		deadflag;

.vector		view_ofs;			// add to origin to get eye point


.float		button0;		// fire
.float		button1;		// use
.float		button2;		// jump

.float		impulse;		// weapon changes

.float		fixangle;
.vector		v_angle;		// view / targeting angle for players
.float		idealpitch;		// calculated pitch angle for lookup up slopes


.string		netname;

.entity 	enemy;

.float		flags;

.float		colormap;
.float		team;

.float		max_health;		// players maximum health is stored here

.float		teleport_time;	// don't back up

.float		armortype;		// save this fraction of incoming damage
.float		armorvalue;

.float		waterlevel;		// 0 = not in, 1 = feet, 2 = wast, 3 = eyes
.float		watertype;		// a contents value

.float		ideal_yaw;
.float		yaw_speed;

.entity		aiment;

.entity 	goalentity;		// a movetarget or an enemy

.float		spawnflags;

.string		target;
.string		targetname;

// damage is accumulated through a frame. and sent as one single
// message, so the super shotgun doesn't generate huge messages
.float		dmg_take;
.float		dmg_save;
.entity		dmg_inflictor;

.entity		owner;		// who launched a missile
.vector		movedir;	// mostly for doors, but also used for waterjump

.string		message;		// trigger messages

.float		sounds;		// either a cd track number or sound number

.string		noise, noise1, noise2, noise3;	// contains names of wavs to play

//================================================
void		end_sys_fields;			// flag for structure dumping
//================================================

/*
==============================================================================

				VARS NOT REFERENCED BY C CODE

==============================================================================
*/

string version = "\nprogs_dump devkit\nversion 3.0.0"; // inspired by Copper

//
// constants
//

float	FALSE					= 0;
float 	TRUE					= 1;

// worldtype values
float	WORLDTYPE_MEDIEVAL		= 0;
float	WORLDTYPE_METAL			= 1;
float	WORLDTYPE_BASE			= 2;

// edict.flags
float	FL_FLY					= 1;
float	FL_SWIM					= 2;
float	FL_CLIENT				= 8;	// set for all client edicts
float	FL_INWATER				= 16;	// for enter / leave water splash
float	FL_MONSTER				= 32;
float	FL_GODMODE				= 64;	// player cheat
float	FL_NOTARGET				= 128;	// player cheat
float	FL_ITEM					= 256;	// extra wide size for bonus items
float	FL_ONGROUND				= 512;	// standing on something
float	FL_PARTIALGROUND		= 1024;	// not all corners are valid
float	FL_WATERJUMP			= 2048;	// player jumping out of water
float	FL_JUMPRELEASED			= 4096;	// for jump debouncing

float 	FL_NOCENTERPRINT		= 65536;// don't centerprint entity's message field when its targets are used

// edict.movetype values
float	MOVETYPE_NONE			= 0;	// never moves
//float	MOVETYPE_ANGLENOCLIP	= 1;
//float	MOVETYPE_ANGLECLIP		= 2;
float	MOVETYPE_WALK			= 3;	// players only
float	MOVETYPE_STEP			= 4;	// discrete, not real time unless fall
float	MOVETYPE_FLY			= 5;
float	MOVETYPE_TOSS			= 6;	// gravity
float	MOVETYPE_PUSH			= 7;	// no clip to world, push and crush
float	MOVETYPE_NOCLIP			= 8;
float	MOVETYPE_FLYMISSILE		= 9;	// fly with extra size against monsters
float	MOVETYPE_BOUNCE			= 10;
float	MOVETYPE_BOUNCEMISSILE	= 11;	// bounce with extra size

// edict.solid values
float	SOLID_NOT				= 0;	// no interaction with other objects
float	SOLID_TRIGGER			= 1;	// touch on edge, but not blocking
float	SOLID_BBOX				= 2;	// touch on edge, block
float	SOLID_SLIDEBOX			= 3;	// touch on edge, but not an onground
float	SOLID_BSP				= 4;	// bsp clip, touch on edge, block

// range values
float	RANGE_MELEE				= 0;
float	RANGE_NEAR				= 1;
float	RANGE_MID				= 2;
float	RANGE_FAR				= 3;

// deadflag values

float	DEAD_NO					= 0;
float	DEAD_DYING				= 1;
float	DEAD_DEAD				= 2;
float	DEAD_RESPAWNABLE		= 3;

// takedamage values

float	DAMAGE_NO				= 0;
float	DAMAGE_YES				= 1;
float	DAMAGE_AIM				= 2;

// items
float	IT_AXE					= 4096;
float	IT_SHOTGUN				= 1;
float	IT_SUPER_SHOTGUN		= 2;
float	IT_NAILGUN				= 4;
float	IT_SUPER_NAILGUN		= 8;
float	IT_GRENADE_LAUNCHER		= 16;
float	IT_ROCKET_LAUNCHER		= 32;
float	IT_LIGHTNING			= 64;
float	IT_EXTRA_WEAPON			= 128;

float	IT_SHELLS				= 256;
float	IT_NAILS				= 512;
float	IT_ROCKETS				= 1024;
float	IT_CELLS				= 2048;

float	IT_ARMOR1				= 8192;
float	IT_ARMOR2				= 16384;
float	IT_ARMOR3				= 32768;
float	IT_SUPERHEALTH			= 65536;

float	IT_KEY1					= 131072;
float	IT_KEY2					= 262144;

float	IT_INVISIBILITY			= 524288;
float	IT_INVULNERABILITY		= 1048576;
float	IT_SUIT					= 2097152;
float	IT_QUAD					= 4194304;

// point content values

float	CONTENT_EMPTY			= -1;
float	CONTENT_SOLID			= -2;
float	CONTENT_WATER			= -3;
float	CONTENT_SLIME			= -4;
float	CONTENT_LAVA			= -5;
float	CONTENT_SKY				= -6;

float	STATE_TOP		= 0;
float	STATE_BOTTOM	= 1;
float	STATE_UP		= 2;
float	STATE_DOWN		= 3;

vector	VEC_ORIGIN = '0 0 0';
vector	VEC_HULL_MIN = '-16 -16 -24';
vector	VEC_HULL_MAX = '16 16 32';
vector	VEC_HULL_SIZE = '32 32 56';
vector	VEC_HULL2_MIN = '-32 -32 -24';
vector	VEC_HULL2_MAX = '32 32 64';
vector	VEC_HULL2_SIZE = '64 64 88';

// protocol bytes
float SVC_SETVIEWPORT     =  5;   // -> Camera <- Hipnotic Drake devkit -- dumptruck_ds
float SVC_SETVIEWANGLES   = 10;   // -> Camera <- Hipnotic Drake devkit -- dumptruck_ds
float	SVC_TEMPENTITY		= 23;
float	SVC_KILLEDMONSTER	= 27;
float	SVC_FOUNDSECRET		= 28;
float	SVC_INTERMISSION	= 30;
float	SVC_FINALE			= 31;
float	SVC_CDTRACK			= 32;
float	SVC_SELLSCREEN		= 33;
float SVC_CUTSCENE        = 34;   // Hipnotic Drake devkit -- dumptruck_ds



float	TE_SPIKE		= 0;
float	TE_SUPERSPIKE	= 1;
float	TE_GUNSHOT		= 2;
float	TE_EXPLOSION	= 3;
float TE_EXPLOSION2   = 12; // from doe -- dumptruck_ds
float	TE_TAREXPLOSION	= 4;
float	TE_LIGHTNING1	= 5;
float	TE_LIGHTNING2	= 6;
float	TE_WIZSPIKE		= 7;
float	TE_KNIGHTSPIKE	= 8;
float	TE_LIGHTNING3	= 9;
float	TE_LAVASPLASH	= 10;
float	TE_TELEPORT		= 11;

// sound channels
// channel 0 never willingly overrides
// other channels (1-7) always override a playing sound on that channel
float	CHAN_AUTO		= 0;
float	CHAN_WEAPON		= 1;
float	CHAN_VOICE		= 2;
float	CHAN_ITEM		= 3;
float	CHAN_BODY		= 4;

float	ATTN_NONE		= 0;
float	ATTN_NORM		= 1;
float	ATTN_IDLE		= 2;
float	ATTN_STATIC		= 3;

// update types

float	UPDATE_GENERAL	= 0;
float	UPDATE_STATIC	= 1;
float	UPDATE_BINARY	= 2;
float	UPDATE_TEMP		= 3;

// entity effects

float	EF_BRIGHTFIELD	= 1;
float	EF_MUZZLEFLASH 	= 2;
float	EF_BRIGHTLIGHT 	= 4;
float	EF_DIMLIGHT 	= 8;


// messages
float	MSG_BROADCAST	= 0;		// unreliable to all
float	MSG_ONE			= 1;		// reliable to one (msg_entity)
float	MSG_ALL			= 2;		// reliable to all
float	MSG_INIT		= 3;		// write to the init string

// spawnflags for func_movewall
float	MOVEWALL_VISIBLE		= 1;
float	MOVEWALL_TOUCH			= 2;
float	MOVEWALL_NONBLOCKING	= 4;

// known_release values -- iw
float	KNOWN_RELEASE_NOT			= 0;
float	KNOWN_RELEASE_ID1			= 1;
float	KNOWN_RELEASE_FUNC_MAPJAMX	= 2;

//================================================

//
// globals
//
float	movedist;
float	gameover;		// set when a rule exits

string	string_null;	// null string, nothing should be held here
//float	empty_float;

entity	newmis;			// launch_spike sets this after spawning it

entity	activator;		// the entity that activated a trigger or brush

entity	damage_attacker;	// set by T_Damage
float	framecount;

float		skill;

float	known_release;	// unique id for a release; see values above -- iw

//================================================

//
// world fields (FIXME: make globals)
//
.string		wad;
.string 	map;
.float		worldtype;	// 0=medieval 1=metal 2=base
.float		skip_id1_overrides;

//================================================

.string		killtarget;

//
// quakeed fields
//
.float		light_lev;		// not used by game, but parsed by light util
.float		style;


//
// monster ai
//
.void()		th_stand;
.void()		th_walk;
.void()		th_run;
.void()		th_missile;
.void()		th_melee;
.void(entity attacker, float damage)		th_pain;
.void()		th_die;

.entity		oldenemy;		// mad at this player before taking damage

.float		speed;

.float	lefty;

.float	search_time;
.float	attack_state;

float	AS_STRAIGHT		= 1;
float	AS_SLIDING		= 2;
float	AS_MELEE		= 3;
float	AS_MISSILE		= 4;
float	AS_TURRET		= 5;

//
// player only fields
//
.float		walkframe;

.float 		attack_finished;
.float		pain_finished;

.float		invincible_finished;
.float		invisible_finished;
.float		super_damage_finished;
.float		radsuit_finished;

.float		invincible_time, invincible_sound;
.float		invisible_time, invisible_sound;
.float		super_time, super_sound;
.float		rad_time;
.float		fly_sound;

.float		axhitme;

.float		show_hostile;	// set to time+0.2 whenever a client fires a
							// weapon or takes damage.  Used to alert
							// monsters that otherwise would let the player go
.float		jump_flag;		// player jump flag
.float		swim_flag;		// player swimming sound flag
.float		air_finished;	// when time > air_finished, start drowning
.float		bubble_count;	// keeps track of the number of bubbles
.string		deathtype;		// keeps track of how the player died

//
// object stuff
//
.string		mdl;
.vector		mangle;			// angle at start

.vector		oldorigin;		// only used by secret door

.string		origmodel; // addition by bmFbr for switchable brushes

.float		t_length, t_width;


//
// doors, etc
//
.vector		/*dest,*/ dest1, dest2;
.float		wait;			// time from firing to restarting
.float		delay;			// time from activation to firing
.entity		trigger_field;	// door's trigger entity
.string		noise4;

//
// monsters
//
.float 		pausetime;
.entity 	movetarget;
.float		homing;
.float		projexpl;
.float		proj_speed_mod;
.float		proj_basespeed;
.float		infight_mode;

//
// doors
//
.float		aflag;
.float		dmg;			// damage done by door when hit

//
// misc
//
.float		cnt; 			// misc flag

//
// subs
//
.void()		think1;
.vector		finaldest, finalangle;

//
// triggers
//
.float		count;			// for counting triggers


//
// plats / doors / buttons
//
.float		lip;
.float		state;
.vector		pos1, pos2;		// top and bottom positions
.float		height;

//
// sounds
//
.float		waitmin /*, waitmax*/;
// .float		distance;
.float		volume;


//
// support for item_key_custom -- iw
//
.string keyname;
.float customkeys;


// variables for enhanced triggering from Custents - dumptruck_ds
.string target2;		// second target's name
.string target3;		// third target's name
.string target4;		// fourth target's name
.string targetname2;	// second name
.string targetname3;	// third name
.string targetname4;	// fourth name
.string killtarget2;	// second target to kill
string lastnameused;	// the targetname that was last used to trigger somthing


//
// switchable shadow
//
.float		switchshadstyle;
.float		shadowoff;
.entity shadowcontroller;
.float speed2;

//===========================================================================


//
// builtin functions
//

void(vector ang)	makevectors		= #1;		// sets v_forward, etc globals
void(entity e, vector o) setorigin	= #2;
void(entity e, string m) setmodel	= #3;		// set movetype and solid first
void(entity e, vector min, vector max) setsize = #4;
// #5 was removed
void() break						= #6;
float() random						= #7;		// returns 0 - 1
void(entity e, float chan, string samp, float vol, float atten) sound = #8;
vector(vector v) normalize			= #9;
void(string e) error				= #10;
void(string e) objerror				= #11;
float(vector v) vlen				= #12;
float(vector v) vectoyaw			= #13;
entity() spawn						= #14;
void(entity e) remove				= #15;

// sets trace_* globals
// nomonsters can be:
// An entity will also be ignored for testing if forent == test,
// forent->owner == test, or test->owner == forent
// a forent of world is ignored
void(vector v1, vector v2, float nomonsters, entity forent) traceline = #16;

entity() checkclient				= #17;	// returns a client to look for
entity(entity start, .string fld, string match) find = #18;
string(string s) precache_sound		= #19;
string(string s) precache_model		= #20;
void(entity client, string s)stuffcmd = #21;
entity(vector org, float rad) findradius = #22;
void(string s) bprint				= #23;
void(entity client, string s) sprint = #24;
void(string s) dprint				= #25;
string(float f) ftos				= #26;
string(vector v) vtos				= #27;
void() coredump						= #28;		// prints all edicts
void() traceon						= #29;		// turns statment trace on
void() traceoff						= #30;
void(entity e) eprint				= #31;		// prints an entire edict
float(float yaw, float dist) walkmove	= #32;	// returns TRUE or FALSE
// #33 was removed
float() droptofloor= #34;	// TRUE if landed on floor
void(float style, string value) lightstyle = #35;
float(float v) rint					= #36;		// round to nearest int
float(float v) floor				= #37;		// largest integer <= v
float(float v) ceil					= #38;		// smallest integer >= v
// #39 was removed
float(entity e) checkbottom			= #40;		// true if self is on ground
float(vector v) pointcontents		= #41;		// returns a CONTENT_*
// #42 was removed
float(float f) fabs = #43;
vector(entity e, float speed) aim = #44;		// returns the shooting vector
float(string s) cvar = #45;						// return cvar.value
void(string s) localcmd = #46;					// put string into local que
entity(entity e) nextent = #47;					// for looping through all ents
void(vector o, vector d, float color, float count) particle = #48;// start a particle effect
void() ChangeYaw = #49;						// turn towards self.ideal_yaw
											// at self.yaw_speed
// #50 was removed
vector(vector v) vectoangles			= #51;

//
// direct client message generation
//
void(float to, float f) WriteByte		= #52;
void(float to, float f) WriteChar		= #53;
void(float to, float f) WriteShort		= #54;
void(float to, float f) WriteLong		= #55;
void(float to, float f) WriteCoord		= #56;
void(float to, float f) WriteAngle		= #57;
void(float to, string s) WriteString	= #58;
void(float to, entity s) WriteEntity	= #59;

//
// broadcast client message generation
//

// void(float f) bWriteByte		= #59;
// void(float f) bWriteChar		= #60;
// void(float f) bWriteShort		= #61;
// void(float f) bWriteLong		= #62;
// void(float f) bWriteCoord		= #63;
// void(float f) bWriteAngle		= #64;
// void(string s) bWriteString	= #65;
// void(entity e) bWriteEntity = #66;

void(float step) movetogoal				= #67;

string(string s) precache_file		= #68;	// no effect except for -copy
void(entity e) makestatic		= #69;
void(string s) changelevel = #70;

//#71 was removed

void(string var, string val) cvar_set = #72;	// sets cvar.value

// The following function definitions allow the engine's builtin
// centerprint function (builtin #73) to be called with different
// numbers of string arguments.  The string that will be printed is the
// concatenation of the string arguments.
//
// These definitions work because builtin #73 is implemented in such
// a way that it can accept multiple string arguments in this manner,
// even though the original QuakeC code didn't take advantage of this
// fact.  A maximum of seven string arguments can be passed because
// a function is limited to a total of eight arguments (and the first
// argument is the client).  Note that in the original engine, all of
// the strings for a centerprint message are concatenated into a single
// 256-char buffer, therefore excessively long messages should be
// avoided.  -- iw
//

.float suppressCenterPrint;

void(entity client, string s1) centerprint_builtin = #73;
void(entity client, string s1, string s2) centerprint_builtin2 = #73;
void(entity client, string s1, string s2, string s3) centerprint_builtin3 = #73;
void(entity client, string s1, string s2, string s3, string s4) centerprint_builtin4 = #73;
void(entity client, string s1, string s2, string s3, string s4, string s5) centerprint_builtin5 = #73;
void(entity client, string s1, string s2, string s3, string s4, string s5, string s6) centerprint_builtin6 = #73;
void(entity client, string s1, string s2, string s3, string s4, string s5, string s6, string s7) centerprint_builtin7 = #73;

void(entity client, string s1) centerprint = {
	// Is the centerprint message being used by something else?
	if (!client.suppressCenterPrint)
		centerprint_builtin(client, s1);
	else {
		// Send message to client console instead
		sprint(client, "(centerprint) ");
		sprint(client, s1);
		sprint(client, "\n");
	}
}

void(entity client, string s1, string s2) centerprint2 = {
	// Is the centerprint message being used by something else?
	if (!client.suppressCenterPrint)
		centerprint_builtin2(client, s1, s2);
	else {
		// Send message to client console instead
		sprint(client, "(centerprint) ");
		sprint(client, s1);
		sprint(client, s2);
		sprint(client, "\n");
	}
}

void(vector pos, string samp, float vol, float atten) ambientsound = #74;

string(string s) precache_model2	= #75;		// registered version only
string(string s) precache_sound2	= #76;		// registered version only
string(string s) precache_file2		= #77;		// registered version only

void(entity e) setspawnparms		= #78;		// set parm1... to the
												// values at level start
												// for coop respawn

//============================================================================

//
// subs.qc
//
void(vector tdest, float tspeed, void() func) SUB_CalcMove;
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt;
void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove;
void()  SUB_CalcMoveDone;
void() SUB_CalcAngleMoveDone;
void() SUB_Null;
void() SUB_UseTargets;
void() SUB_Remove;

//
//	combat.qc
//
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage;


float (entity e, float healamount, float ignore) T_Heal; // health function

float(entity targ, entity inflictor) CanDamage;

void() DummyFunction = //gets rid of the last compiler warnings ; - )
{
local string w;
local float l;
w = self.wad;
l = self.light_lev;
}
.float is_waiting;	// Supa, triggers, wait until activated before we can trigger?
.float	gravity; //from custdefs.qc by way of Hipnotic
// These are required by the Hipnotic code
//added update stat message
float SVC_UPDATESTAT = 3;
//added total monster message
float STAT_TOTALMONSTERS = 12;

//dumptruck_ds from Rogue eod defs

//
// elevator fields
//

.float 		elevatorLastUse;
.float		elevatorOnFloor;
.float		elevatorToFloor;
.vector		elevatorDestination;

//
// plat2 fields
//
.float		plat2Called;
.float		plat2LastMove;
.float		plat2GoTime;
.float		plat2GoTo;
//
// misc pd_additions
//
.float		reset_items; //dumptruck_ds
.float		spawn_angry; //dumptruck_ds
.string		mdl_debris; //dumptruck_ds
.float		keep_ammo; //dumptruck_ds
.string 	obit_name; //dumptruck_ds
.string 	obit_method; //dumptruck_ds
.float 		damage_mod; //dumptruck_ds

/*============================================================================
johnfitz new defs from Rubicon2
============================================================================*/
float BREAKABLE_NO_MONSTERS = 1;

.float 		wantedgravity; // thanks Spike!
.float		onladder;
//.float		ladder_step_finished; //footsteps on ladder no uses -- dumptruck_ds

//dumptruck_ds defs for breakables in rubcon2.qc -- thanks to Qmaster and the Arcane Dimensions team
/*
.string break_template1_e;
.string break_template2_e;
.string break_template3_e;
.string break_template4_e;
.string break_template5_e;
.string find_brk_template_model;
*/
//from remakequake -- dumptruck_ds

.vector		dest, dest1, dest2;

void(string type, string text) print_self =
{
	dprint (type);
	dprint (" '");
	dprint (self.classname);
	dprint ("' ");
	dprint (text);
	dprint (" at ");
	dprint (vtos(self.origin));
	dprint ("\n");
};

void() monster_pain_use; //dumptruck_ds
void() SUB_UsePain; //dumptruck_ds
.float 		pain_threshold; //dumptruck_ds
.string 	pain_target; //dumptruck_ds
.float color; //Hipnotic
.float megahealth_rottime; // dumptruck_ds
.float alpha; // from RennyC func_fall in dtmisc.qc
.float ltrailLastUsed;  //from DOE lighnin
.float style2; //c0burn's switchable lights
.float sight_trigger; //dumptruck_ds
.float keep_ammo; //dumptruck_ds
.float berserk; //dumptruck_ds
nosave float *world_sounds;  //via Spike fun times! nosave=noclobber
void() trigger_changemusic; // dumptruck_ds
void() onlookat_touch; // dumptruck_ds

string(float num) lightstyle_fade_lookup; //addition by bmFbr for switchable shadows
void() misc_shadowcontroller;
void() misc_shadowcontroller_use;
void() shadow_fade_in;
void() shadow_fade_out;

// Drake Cutscenes -- Borrowed from Zerstorer.
.string     script;         //dhm - denotes which script to read.
.string     next_script;    //dhm - denotes the current script.
.string     script_num;     //dhm - number for info_scripts.
//.string     camera_point;   //dhm - target for camera to move to.
.string     focal_point;    //dhm - focus point for camera.
.float      script_delay;   //dhm - time until next script.
.float      script_time;    //dhm - used for script timing.
.float      script_count;   //dhm - ditto.
// cutscene.qc - - -
void() Cutscene_Think;
float  cutscene;       // Set to TRUE during a cutscene.
float  mindex_inviso;  // Invisible (null sprite)
.string     null_string;    // Replace 'string_null' with 'world.null_string'.
                            //  null string, nothing should be held here.
// Drake Cutscenes end

// from Custents
// variable for healing trigger
.float	heal_timer;
.float	heal_amount;
.float	health_max;
// Constants for the healing trigger
float HEAL_START_ON	= 1;
float HEAL_PLAYER_ONLY	= 2;
float HEAL_MONSTER_ONLY	= 4;

// Custom Monster Sounds START -- dumptruck_ds

.string snd_death;
.string snd_pain;
.string snd_sight;
.string snd_attack;
.string snd_hit;
.string snd_idle;
.string snd_land;
.string snd_move;
.string snd_misc;
.string snd_misc1;
.string snd_misc2;
.string snd_misc3;

// Custom Monster Sounds END -- dumptruck_ds

// Custom Model Start -- dumptruck_ds

.string mdl_head;
.string mdl_body;
.string mdl_proj;
.string mdl_exproj;
.float skin_head;
.float skin_proj;
.float skin_exproj;
.string mdl_gib1;
.string mdl_gib2;
.string mdl_gib3;

.vector mdlsz, centeroffset; // addition by bmFbr for custom model bounding box definition

// Custom Model End -- dumptruck_ds

.float shardvalue; // ammo shard value

.float drop_item; // key DropStuff


float SPAWN_SILENTLY = 2097152;
float TRIGGER_CENTERPRINTALL = 1048576;

// entity state
.float estate;
.void() dormant_use;
float STATE_ACTIVE      = 0;
float STATE_INACTIVE    = 1;
float STATE_INVISIBLE = 8;

.float prevstate;

//
// fog
//
.vector		fog_color, fog_color2;
.float		fog_density, fog_density2;
.float 		skyfog_density, skyfog_density2;
.entity 	fogblend_entity;
.float 		distance;

void( entity client, float density, vector color ) fog_save;
void( entity client, float density) skyfog_save;
void( entity client, entity fogger ) fog_setFromEnt;
void( entity client, float density, vector color ) fog_set;
void( entity client, float density) skyfog_set;

nosave float cleanUpClientStuff;
nosave float gamestarted;


.string	include;
.string type;

.float last_setstate_frame = light_lev;
.entity last_setstate = aiment;
// 1998-07-03 hurt_touch fix by Robert Field  start
//
// triggers.qc
//
.float hurt_together_time;
.float hurt_nextthink;
// 1998-07-03 hurt_touch fix by Robert Field  end
float I_AM_TURRET = 262144; //dumptruck_ds
.void() th_turret;


.entity animcontroller;
.entity rotatecontroller;
.float multiplier;

.float 		first_frame, last_frame;
.float 		first_frame2, last_frame2;
.float 		frtime, frtime2;
.float 		animtype, animtype2;
.vector		cmins, cmaxs;
.vector 	cust_avelocity;
.float touch_time;

// cshift controller

.entity csfcontroller;

.vector csf_color;
.float csf_density;

void(entity client) csf_apply;
void(entity client, float density, vector color, float spd) csf_fade;
void(entity client, float density, vector color) csf_set;

.float fade_amt;

// worldspawn default mdls
.string h_vial_mdl;
.string h_25_mdl;
.string h_15_mdl;
.string h_mega_mdl;

.string s_sm_mdl;
.string s_lg_mdl;

.string n_sm_mdl;
.string n_lg_mdl;

.string r_sm_mdl;
.string r_lg_mdl;

.string c_sm_mdl;
.string c_lg_mdl;

.string a_shr_mdl;
.string a_grn_mdl;
.string a_ylw_mdl;
.string a_red_mdl;

.entity infight_activator;