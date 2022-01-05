//this is on hold and not in progs.src
// crashes in QS at the moment Jaycie is looking into it
.float solidstate;
.float visiblestate;

float START_INVISIBLE = 1;
float START_NONSOLID = 2;
float START_ALTFRAMES = 4;
float TOGGLE_VISIBILITY = 8;
float TOGGLE_SOLIDITY = 16;
float TOGGLE_FRAMES = 32;

void() func_brush_use =
{
	if (self.spawnflags & TOGGLE_VISIBILITY)
	{
		if (self.visiblestate == 1)
		{
			self.model = "";
			self.visiblestate = 0;
		}
		else
		{
			self.model = self.mdl;
			self.visiblestate = 1;
		}
	}
	if (self.spawnflags & TOGGLE_SOLIDITY)
	{
		if (self.solidstate == 1)
		{
			self.solid = SOLID_NOT;
			self.solidstate = 0;
		}
		else
		{
			self.solid = SOLID_BSP;
			setorigin(self, self.origin);
			self.solidstate = 1;
		}
	}
	if (self.spawnflags & TOGGLE_FRAMES)
		self.frame = 1 - self.frame;
};

void() func_brush =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.use = func_brush_use;
	setmodel(self, self.model);
	self.mdl = self.model;
	setorigin(self, self.origin);

	if (self.spawnflags & START_INVISIBLE)
	{
		self.visiblestate = 0;
		self.model = "";
	}
	else
	{
		self.visiblestate = 1;
	}

	if (self.spawnflags & START_NONSOLID)
	{
		self.solidstate = 0;
		self.solid = SOLID_NOT;
	}
	else
	{
		self.solidstate = 1;
		self.solid = SOLID_BSP;
	}

	if (self.spawnflags & START_ALTFRAMES)
		self.frame = 1;
	else
		self.frame = 0;
};
