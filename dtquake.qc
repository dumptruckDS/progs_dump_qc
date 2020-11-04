// /*this is a point entity from Rubicon Rumble Pack Devkit; REQUIRES A TARGETNAME*/
//
// // ===== TRIGGER_SHAKE =======================================================
//
float VIEWONLY = 1;

void() shake_think =
{
	if (self.attack_finished < time)	// Done
	{
		self.nextthink = -1;

		if (self.noise1 != "")
			sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);

		return;
	}

	local	entity plyr;

	// Shake all players in the effect radius...

	plyr = findradius(self.origin, self.count);

	while(plyr)
	{
		if (plyr.flags & FL_CLIENT)
		{
			local float	d;

			// Scale effect by distance
			d = vlen(self.origin - plyr.origin);
			d = (self.count - d)/self.count;

			if (d > 0)
			{
				// shake up the view
				plyr.punchangle_x = -1 * (random() + (0.025*self.dmg*d));

				// push the player around
				if (plyr.flags & FL_ONGROUND && !(self.spawnflags & VIEWONLY))
				{
					d = self.dmg*d;
					plyr.velocity_x = plyr.velocity_x + (random()*d*2 - d);
					plyr.velocity_y = plyr.velocity_y + (random()*d*2 - d);
					plyr.velocity_z = plyr.velocity_z + (random()*d);// always push up
				}
			}
		}

		plyr = plyr.chain;
	}

	// keep going
	self.nextthink = time + 0.1;
};

void() shake_use =
{
	if (self.attack_finished > time) return;// already active

	// Start...

	if (self.noise != "")
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	self.attack_finished = time + self.wait;
	self.nextthink = time + 0.1;
};

/*QUAKED trigger_shake (.5 0 .5) (-8 -8 -8) (8 8 8) VIEWONLY X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY

Earthquake trigger - shakes players in it's radius when active.
Strength of tremor is greatest at the centre.
dmg Strength at center (default is 120)
wait Duration of shake (default is 1)
count Affect radius (defalt is 200)
noise Noise to play when starting to shake
noise1 Noise to play when stopping
targetname Must be triggered
Spawnflags
VIEWONLY		Shakes the view, but player movement is not affected
*/
void() trigger_shake =
{
	if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
		return;

	if (!self.targetname) objerror("trigger_shake without name");

	if (self.noise != "") precache_sound (self.noise);
	if (self.noise1 != "") precache_sound (self.noise1);

	if (!self.dmg) self.dmg = 120;
	if (self.count <= 0) self.count = 200;
	if (self.wait <= 0) self.wait = 1.0;

	setorigin(self, self.origin);

	self.nextthink = -1;
	self.think = shake_think;
	self.use = shake_use;
};
