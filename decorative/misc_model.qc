/*
 * misc_model.qc requires math.qc
 *
 * Author: Joshua Skelton joshua.skelton@gmail.com
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
void() misc_model = {
    if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
        return;

    precache_model(self.mdl);
    setmodel(self, self.mdl);

    if (!self.frame) {
        self.frame = self.first_frame;
    }

    // Only animate if given a frame range
    if (!self.last_frame) {
        makestatic(self);
        return;
    }

    // Default animation speed to 10 fps
    if (!self.speed) {
        self.speed = 10 / 60;
    }

    self.nextthink = time + self.speed;
    self.think = misc_model_think;
};

/*
 * misc_model_think
 *
 * Handles animation for misc_model entity.
 */
void() misc_model_think = {
    self.nextthink = time + fabs(self.speed);
    self.frame = self.frame + sign(self.speed);
    self.frame = wrap(self.frame, self.first_frame, self.last_frame);
};
