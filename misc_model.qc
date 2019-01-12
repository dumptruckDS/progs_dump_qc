/*
 * misc_model.qc
 *
 * Author: Joshua Skelton joshua.skelton@gmail.com
 */

// The starting frame of the animation
.float first_frame;

// The ending frame of the animation
.float last_frame;

// Forward declarations
void() misc_model_think;

/*
 * misc_model
 *
 * An entity for displaying models. A frame range can be given to animate the
 * model.
 *
 * mdl: The model to display. Can be of type mdl, bsp, or spr.
 *
 * frame: The frame to display. Can be used to offset the animation.
 *
 * first_frame: The starting frame of the animation.
 *
 * last_frame: The last frame of the animation.
 */
void() misc_model = {
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
