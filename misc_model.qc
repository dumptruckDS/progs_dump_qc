/*
 * misc_model.qc requires math.qc
 *
 * Author: Joshua Skelton joshua.skelton@gmail.com
 * Edited by: Inky 20201219 Minor changes for a better integration with my own code
 * Edited by: bmFbr for solid and gravity spawnflags and custom bbox sizes
 * Edited by: dumptruck_ds to add start and stop animations
 */

// The starting frame of the animation
.float first_frame;

// The ending frame of the animation
.float last_frame;

// Forward declarations
void() misc_model_think;

/*QUAKED misc_model (0 0.5 0.8) (-8 -8 -8) (8 8 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ({"path" : mdl, "skin" : skin, "frame": frame});
}
An entity for displaying models. A frame range can be given to animate the
model.

mdl: The model to display. Can be of type mdl, bsp, or spr.

frame: The frame to display. Can be used to offset the animation.

first_frame: The starting frame of the animation.

last_frame: The last frame of the animation.
*/

float MISC_MODEL_GRAVITY = 1;
float MISC_MODEL_SOLID = 2;
float MISC_MODEL_BACK_AND_FORTH = 4;
float MISC_MODEL_ONLY_ONCE = 8;
float MISC_MODEL_PLAY_COUNT = 16;
float MISC_MODEL_STARTOFF = 32;


void() misc_model_use = {
	if (self.state == STATE_ACTIVE) {
		if (self.spawnflags & MISC_MODEL_SOLID) self.solid = SOLID_NOT;
		self.model = "";

		self.state = STATE_INVISIBLE;
		setorigin(self, self.origin);
	}
	else {
		if (self.spawnflags & MISC_MODEL_SOLID) self.solid = SOLID_BBOX;
		self.model = self.mdl;

		self.state = STATE_ACTIVE;
		setorigin(self, self.origin);
	}
};

void() misc_model = {
    if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
        return;

    if (!self.mdl || self.mdl == "")
        objerror("Model not defined");

	if(!self.centeroffset) self.centeroffset = '0 0 0';
	if(!self.mdlsz) self.mdlsz = '32 32 32';

	vector vmin, vmax;

	vmin_x = self.centeroffset_x - (self.mdlsz_x / 2);
	vmin_y = self.centeroffset_y - (self.mdlsz_y / 2);
	vmin_z = self.centeroffset_z - (self.mdlsz_z / 2);

	vmax_x = self.centeroffset_x + (self.mdlsz_x / 2);
	vmax_y = self.centeroffset_y + (self.mdlsz_y / 2);
	vmax_z = self.centeroffset_z + (self.mdlsz_z / 2);

    precache_model(self.mdl);
    setmodel(self, self.mdl);
    
	setsize(self, vmin, vmax);
	
	if(self.spawnflags & MISC_MODEL_SOLID) self.solid = SOLID_BBOX;
	else self.solid = SOLID_NOT;

	if(self.spawnflags & MISC_MODEL_GRAVITY) self.movetype = MOVETYPE_TOSS;
	else self.movetype = MOVETYPE_NONE;

    self.use = misc_model_use;

    if (!self.frame) {
        self.frame = self.first_frame;
    }

    // Make static (not animate) if not given a frame range, and not affected by gravity
    // also remains active if it has a targetname (so it can be killtargeted/toggled)
    if (!self.last_frame
    	&& !(self.spawnflags & MISC_MODEL_GRAVITY)
    	&& !(self.spawnflags & MISC_MODEL_SOLID)
    	&& !self.targetname
    	&& !self.targetname2
    	// && !(self.spawnflags & MISC_MODEL_DONTMAKESTATIC)
    ) makestatic(self);
    // Make static (not animate) if not given a frame range, and not affected by gravity
	//changed by bmFbr
    // if (!self.last_frame && !(self.spawnflags & MISC_MODEL_GRAVITY)) {
    //     makestatic(self);
    //     return;
    // }

    if (self.last_frame) { // if it as a custom animation range
    	// Default animation speed to 10 fps
	    if (!self.speed) {
	        self.speed = 0.1;
	    }
        self.nextthink = time + self.speed;
        self.think = misc_model_think;
    }
    
	if (self.spawnflags & MISC_MODEL_STARTOFF)    
		self.state = STATE_ACTIVE;
	else    
		self.state = STATE_INVISIBLE;

	misc_model_use();    
        
};

/*
 * misc_model_think
 *
 * Handles animation for misc_model entity.
 */
void() misc_model_think = {
    self.nextthink = time + fabs(self.speed);
    if (self.estate != STATE_ACTIVE) return;
    
    self.frame = self.frame + sign(self.speed);

    if (self.spawnflags & MISC_MODEL_BACK_AND_FORTH && self.frame < self.first_frame)
  	{
  		self.speed = -1 * self.speed;
  		self.frame+=2;
  	}
  	else if (self.spawnflags & MISC_MODEL_BACK_AND_FORTH && self.frame > self.last_frame)
  	{
  		self.speed = -1 * self.speed;
  		self.frame-=2;
  	}
  	else
  		self.frame = wrap(self.frame, self.first_frame, self.last_frame);

  	if(self.spawnflags & MISC_MODEL_ONLY_ONCE && self.frame==self.last_frame && self.last_frame!=self.first_frame)
      self.nextthink = -1;

    if(self.spawnflags & MISC_MODEL_PLAY_COUNT && self.frame==self.last_frame && self.last_frame!=self.first_frame)
    {
      if !(self.count)
         objerror ("Error: set count to the number of animation cycles!");
      self.cnt = self.cnt +1;
      dprint (ftos(self.cnt));
      dprint ("\n");
      if (self.cnt != self.count)
        return FALSE;
      else
    		self.nextthink = -1;
    }
};
