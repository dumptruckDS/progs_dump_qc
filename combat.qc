
void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity inflictor, entity attacker) ClientObituary;

void() monster_death_use;

//============================================================================

/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
float(entity targ, entity inflictor) CanDamage =
{
// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}

	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	return FALSE;
};


/*
============
Killed
============
*/
void(entity targ, entity inflictor, entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;

	if (self.health < -99)
		self.health = -99;		// don't let sbar look bad if a player

	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc
		self.th_die ();
		self = oself;
		return;
	}

	self.enemy = attacker;

// bump the monster counter
	if (self.flags & FL_MONSTER)
	{
		killed_monsters = killed_monsters + 1;
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
	}

	ClientObituary (self, inflictor, attacker);

	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;

	monster_death_use();
	self.th_die ();

	self = oself;
};


/*
============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============
*/
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage=
{
	local	vector	dir;
	local	entity	oldself;
	local	float	save;
	local	float	take;
	local 	float	ignore_armor; //johnfitz
	local 	string	death_type; //johnfitz

	// don't try to damage the world. Not healthy - bmFbr
	if (!targ)
		return;

	//johnfitz -- make sure targ.deathtype doesn't keep stale info after this function is done
	death_type = targ.deathtype;
	targ.deathtype = "";
	//johnfitz

	if (!targ.takedamage)
		return;

	//johnfitz -- some func_breakables ignore monster damage //added from Rubicon2 combat.qc dumptruck_ds
	if (targ.classname == "func_breakable")
	{
		if (targ.spawnflags & BREAKABLE_NO_MONSTERS && attacker.flags & FL_MONSTER)
			return;
	}
	//johnfitz

// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

// check for quad damage powerup on the attacker
	if (attacker.super_damage_finished > time)
		damage = damage * 4;

	// damage mod for monsters -- dumptruck_ds
	if (attacker.damage_mod)
	damage = damage * attacker.damage_mod;

	//don't deplete armor if drowning/burning, or protected by biosuit/pentagram/godmode (note: in ID1 pentagram/godmode doesn't actually protect your armor)
	if (death_type == "burning" || death_type == "drowning" || targ.invincible_finished >= time || targ.flags & FL_GODMODE)
		ignore_armor = TRUE;
	else
		ignore_armor = FALSE;
//johnfitz
// save damage based on the target's armor level
	if (ignore_armor)  //johnfitz -- some damage doesn't deplete armor
	{
		save = 0;
	}
	else
	{
	save = ceil(targ.armortype*damage);
	if (save >= targ.armorvalue)
	{
		save = targ.armorvalue;
		targ.armortype = 0;	// lost all armor
		targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	}
}
// // 1998-08-12 Drowning doesn't hurt armor by Maddes/Athos  start
// 	}
// 	else
// 		save = 0;
// 	// 1998-08-12 Drowning doesn't hurt armor by Maddes/Athos  end
	targ.armorvalue = targ.armorvalue - save;
	take = ceil(damage-save);

// add to the damage total for clients, which will be sent as a single
// message at the end of the frame
// FIXME: remove after combining shotgun blasts?
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

// figure momentum add
	if ( (inflictor != world) && (targ.movetype == MOVETYPE_WALK) )
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);
		targ.velocity = targ.velocity + dir*damage*8;
	}

// check for godmode or invincibility
	if (targ.flags & FL_GODMODE)
		return;
	if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}

// team play damage avoidance
// 1998-07-29 Teamplay 1 fix by Maddes  start
	if ( (teamplay == 1) && (targ.team > 0) && (targ.team == attacker.team)
	&& (targ != attacker)
	&& (attacker.classname == "player")
	&& (inflictor.classname != "door") )	// because squishing a teammate is still possible
// 1998-07-29 Teamplay 1 fix by Maddes  end
						return;

// do the damage
	targ.health = targ.health - take;

// fire pain_target if appropriate
	if ((targ.flags & FL_MONSTER) &&
			targ.pain_target != "" &&
			targ.health <= targ.pain_threshold)
	{
		oldself = self;
		self = targ;
		monster_pain_use ();
		self = oldself;
	}

	if (targ.health <= 0)
	{
		Killed (targ, inflictor, attacker);
		return;
	}

// react to the damage
	oldself = self;
	self = targ;

	if ( (self.flags & FL_MONSTER) && attacker != world)
	{
	// get mad unless of the same class (except for soldiers)
		if (self != attacker && attacker != self.enemy)
		{
			local float mode;
			mode = 0;
			// take highest mode so infighting happens consistently
			if (self.infight_mode == -1 || self.infight_mode > mode)
			{
				mode = self.infight_mode;
			}
			if (mode != -1 && attacker.infight_mode > mode)
			{
				mode = attacker.infight_mode;
			}
			//soldiers of the same style will infight -- dumptruck_ds - thanks for c0burn and Shamblernaut for your help!
			if (mode == -1)
			{
				if (attacker.classname == "player")
				{
					if (self.enemy.classname == "player")
						self.oldenemy = self.enemy;
					self.enemy = attacker;
					FoundTarget ();
				}
			}
			else if (
				(self.classname != attacker.classname) ||
			  ((self.classname == "monster_army") && (self.style == attacker.style)) ||
				(mode > 0 && self.mdl_body != attacker.mdl_body) || // infight if different models
				(mode > 1 && self.skin != attacker.skin) || // infight if different skin
				(mode > 2) // always infight
			)
			{
				if (self.enemy.classname == "player")
					self.oldenemy = self.enemy;
				self.enemy = attacker;
				FoundTarget ();
			}
		}
	}

	if (self.th_pain)
	{
		self.th_pain (attacker, take);
	// nightmare mode monsters don't go into pain frames often
		if (skill == 3)
			self.pain_finished = time + 5;
	}

	self = oldself;
};

/*
============
T_RadiusDamage
============
*/
void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage =
{
	local	float 	points;
	local	entity	head;
	local	vector	org;

	head = findradius(inflictor.origin, damage+40);

	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);
				if (points < 0)
					points = 0;
				points = damage - points;
				if (head == attacker)
					points = points * 0.5;
				if (points > 0)
				{
					if (CanDamage (head, inflictor))
					{	// shambler takes half damage from all explosions
						if (head.classname == "monster_shambler")
							T_Damage (head, inflictor, attacker, points*0.5);
						else
							T_Damage (head, inflictor, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};

/*
============
T_BeamDamage
============
*/
void(entity attacker, float damage) T_BeamDamage =
{
	local	float 	points;
	local	entity	head;

	head = findradius(attacker.origin, damage+40);

	while (head)
	{
		if (head.takedamage)
		{
			points = 0.5*vlen (attacker.origin - head.origin);
			if (points < 0)
				points = 0;
			points = damage - points;
			if (head == attacker)
				points = points * 0.5;
			if (points > 0)
			{
				if (CanDamage (head, attacker))
				{
					if (head.classname == "monster_shambler")
						T_Damage (head, attacker, attacker, points*0.5);
					else
						T_Damage (head, attacker, attacker, points);
				}
			}
		}
		head = head.chain;
	}
};
