/*
+---------+
|Lightning|
+---------+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Ambient lightning for the castle map is done here                          |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

void() pd_lightning;
// void() light_reset =
// {
// 	// sending a bunch of lightstyles at once over a network is bad
// 	if (deathmatch || coop)
// 		return;
//
// 	lightstyle(0, "m");
// 	lightstyle(1, "mmnmmommommnonmmonqnmmo");
// 	lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
// 	lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
// 	lightstyle(4, "mamamamamama");
// 	lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");
// 	lightstyle(6, "nmonqnmomnmomomno");
// 	lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");
// 	lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
// 	lightstyle(9, "aaaaaaaazzzzzzzz");
// 	lightstyle(10, "mmamammmmammamamaaamammma");
// 	lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");
// 	lightstyle(63, "a");
// };

// void() full_bright =
// {
// 	// sending a bunch of lightstyles at once over a network is bad
// 	if (deathmatch || coop)
// 		return;
//
// 	lightstyle(0, "z");
// 	lightstyle(1, "z");
// 	lightstyle(2, "z");
// 	lightstyle(3, "z");
// 	lightstyle(4, "z");
// 	lightstyle(5,"z");
// 	lightstyle(6, "z");
// 	lightstyle(7, "z");
// 	lightstyle(8, "z");
// 	lightstyle(9, "z");
// 	lightstyle(10, "z");
// 	lightstyle(11, "z");
// 	lightstyle(63, "z");
// };

float (float min, float max) RandomRange =
{
	local float width;
	local float offset;
	local float result;

	width = (max - min);
	offset = (random () * width);
	result = (offset + min);
	return (result);
};

void() lightning_strike; //to fix FTEQCC error

void() zap_turnofflight =
{
	SUB_UseTargets();
	self.nextthink = time + 10 * random()*0.5;
	self.think = lightning_strike;

}

float lightning_strikes; // only allow so many lightning strikes at a given time
				         // or else we'll crash quake with too many TE_LIGHTNING calls!

void() lightning_strike =
{
	local vector targ;

	if (random() < 0.2 && lightning_strikes == 0)
	{
		lightning_strikes = lightning_strikes + 1;
		self.cnt = TRUE;

		targ = self.origin - '0 0 9999';
		targ_x = (targ_x + RandomRange (-50, 50));
		targ_y = (targ_y + RandomRange (-50, 50));

		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
		WriteEntity (MSG_BROADCAST, self);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
		WriteCoord (MSG_BROADCAST, targ_x);
		WriteCoord (MSG_BROADCAST, targ_y);
		WriteCoord (MSG_BROADCAST, targ_z);
	}

	if (self.cnt == TRUE)
	{
		lightning_strikes = lightning_strikes - 1;
		self.cnt = FALSE;
	}
	// light_reset();
	// self.think = pd_lightning;
	// SUB_UseTargets();
	self.nextthink = time + 0.1;
	self.think = zap_turnofflight;
};

/*QUAKED pd_lightning (0 1 0) (-10 -10 -10) (10 10 10)
Lightning entity, causes full bright flashes automatically
and is effective for stormy weather ambience
*/
void() pd_lightning =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;
	// if (random() < 0.02)
	// 	full_bright();
	// self.think = zap_turnofflight;
	self.nextthink = time + 10 * random()*0.5;
	self.think = lightning_strike;
};
