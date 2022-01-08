void() train_next_nk;
void() func_puppet_find;

float SYNCH = 1; //Spawnflag for path_corner

void() train_use_nk =
{
	if(self.wait==-1)
		self.use=SUB_Null;

	if (self.decap != 1)
	{ //Moving?
		self.decap = 1;
		if (self.think != train_next_nk)
		{
			self.think = func_puppet_find;
			train_next_nk();
		}
	}
	else
	{
		self.decap = 2;
	}
};

void() func_puppet_animate = {
    self.nextthink = time + fabs(self.frags);
	float nextframe = self.enemy.frame + sign(self.frags);
	nextframe = wrap(nextframe, self.button1, self.button2);
    self.enemy.frame = nextframe;
	if (self.spawnflags & /*Anim back & forth*/1)
	{
		if (self.enemy.frame < self.button1)
			self.enemy.frame = self.button2;
		else if (self.enemy.frame > self.button2)
			self.enemy.frame = self.button1;
	}
};

//Inky 20201105 Animates the puppet according to its destination path_corner's settings if any (animates only if targ.modelindex or targ.button2 are set)
void(entity puppet, entity targ) func_puppet_setup_animation = {
	// float weapmod;

	if (targ.button2)
	{
		entity animator = self.enemy;

		//Get animation boundaries from target setup
		animator.button1 = targ.button1;
		animator.button2 = targ.button2;

		//Set the initial animation frame
		if (targ.button0)
			self.frame = targ.button0;
		else
			self.frame = targ.button1;

		//Set the animation speed
		if (targ.frags)
			animator.frags = targ.frags;
		else
			animator.frags = 0.05; // Default animation speed

		//Initiate the animation
		animator.nextthink = time + animator.frags;
		animator.think = func_puppet_animate;
	}
};

void() puppet_move =
{
local vector	vdestdelta,adestdelta;
local float		len, traveltime;

	self.think = puppet_move;

	// set destdelta to the vector needed to move
	vdestdelta = self.finaldest - self.origin;

	// calculate length of vector
	len = vlen (vdestdelta);

	// divide by speed to get time to reach dest
	traveltime = len / self.speed;

	if (self.finaldest == self.origin || len < 1)
	{
		self.velocity = '0 0 0';
		if(self.wait==-2)
		{
			remove(self);
			return;
		}
		else if(self.wait==-1)
			self.nextthink=-1;
		else if (self.wait>0)
			self.nextthink = time + self.wait;
		else
			self.nextthink = self.ltime + 0.1;
		self.think = train_next_nk;
		return;
	}

	//Angle calculation
	adestdelta = self.finalangle - self.angles;	// set adestdelta to the vector needed to move
	float alen = vlen(adestdelta);					// calculate length of vector
	if(self.angles==self.finalangle || alen < 1 || self.angletime < 0.1)
	{
		self.angles = self.finalangle;
		self.avelocity = '0 0 0';
		self.angletime = 0;
	}
	else
	{
		if(self.spawnflags&/*SYNCH_ANGLES*/1)
			self.anglespeed=self.speed/len*alen;				//
		self.angletime = alen / self.anglespeed;				// divide by speed to get time to reach dest
		// scale the adestdelta vector by the time spent traveling to get velocity
		self.avelocity	= adestdelta * (1 / self.angletime);
	}

	// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

	// scale the destdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1/traveltime);	// qcc won't take vec/float
};


void() train_next_nk =
{
	entity targ = find (world, targetname, self.target);
	self.target = targ.target;

	if (!self.target) objerror ("train_next: no next target");

	if (targ.wait) self.wait = targ.wait;

	if(targ.speed>0) self.speed=targ.speed;

	//Inky 20201105 Animates the puppet according to the destination path_corner's settings (if any: animates only if given a frame range thanks to self.button2)
	func_puppet_setup_animation(self,targ);

	self.finaldest = targ.origin;
	self.wait = targ.wait;

	self.finalangle = self.angles + targ.angles;

	self.nextthink = self.ltime + 0.1;
	self.think = puppet_move;
};

void() func_puppet_find =
{
	entity targ = find (world, targetname, self.target);
	setorigin (self, targ.origin);

	//Inky 20201105 Animates the train model according to the destination path_corner's settings (if any: animates only if given a frame range thanks to self.button2)
	func_puppet_setup_animation(self,targ);
};

/*QUAKED func_puppet
The puppet spawns at the first target it is pointing at, just like a train.
The puppet must be the target of a button or trigger. It will not begin moving until activated.

"speed" - how fast it moves between spots (default=100)
"anglespeed" - how fast it rotates to a new angle (default = 100)

"model" - A model file to use (use "directory/model.mdl" format)

The train will modify it's angles by whatever angles it's next path point has, so if it heads towards a path corner with an angle of '0 90 0', the train will rotate '0 90 0' on it's way to the pathpoint.
If you make the anglespeed the same as the angle, the turn should finish right as the train gets to the new spot.
NOTE: A path_corner using spawnflag "SYNCH" will make the train automatically calculate a new anglespeed based on the distance it's going and will finish the turn at the same time the move is done.

Animation
---------
Puppets must have a model + the following special settings at each path_corner meant to be reached with an animation:
"button0" - starting frame # within the range, if different from the first animation frame (optional)
"button1" - first animation frame (mandatory)
"button2" - last animation frame (mandatory)
"frags" - frame duration, if different from the default 0.05 (optional)
"wait" - -1 will make it stop forever, -3 will make the train stop and wait for the next trigger event
*/
void() func_puppet =
{
	self.decap = 0;

	precache_model2(self.model);
	setmodel (self, self.model);
	setorigin(self,self.origin);
	self.movetype = MOVETYPE_FLY;
	self.solid = SOLID_SLIDEBOX;
	self.flags = FL_FLY;

	//Animator
	entity animator = spawn();
	animator.enemy = self;
	self.enemy = animator;

	if (!self.speed)
		self.speed = 100;

	if (!self.anglespeed)
		self.anglespeed = 100;

	if (!self.target)     objerror ("func_puppet without a target");
	if (!self.targetname) objerror ("func_puppet without a targetname");

	self.use = train_use_nk;

	// start puppet on the second frame, to make sure its targets have had a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_puppet_find;
};
