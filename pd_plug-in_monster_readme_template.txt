===============================================================================
===============================================================================
This is a plug-in monster for the progs_dump devkit version 1.2.0 and above.
progs_dump allows mappers to use models, sounds and other behaviors to make
monster variants without coding.
===============================================================================
===============================================================================
Monster Name:         name here e.g. Hellrath
Author:               author name here
Contact Info:         contact info here
Description:          e.g. mini-boss replacement for Sharath
===============================================================================
===============================================================================
Installation:

Copy the contents of this zip file into your mod folder. Then copy and paste the
entity selection below into your map. If all the paths are set correctly, the
monster should appear in your map at (0, 0, 0). Monster sounds should always be
in the `sound` folder of your mod (or a sub-folder under 'sound').
===============================================================================
===============================================================================
Notes:


===============================================================================
===============================================================================
Credits:


===============================================================================
===============================================================================
Entity for map file:

***Back up your map first!***

Paste this at the bottom of your map file using a text editor.
MAKE SURE to change the entity number to the next unused number in sequence!

e.g. if the last entity in your map is // entity 17
change // entity 1 below to // entity 18

Paste everything below this line at the bottom of you map file and save.
// entity 1
{
"classname" "monster_shalrath"
"origin" "0 0 0"
"mdl_head" "hellrath/chillo_h_shal.mdl"
"mdl_body" "hellrath/chillo_shalrath.mdl"
"damage_mod" "1.5"
"health" "600"
"obit_method" "banished"
"obit_name" "a Hellrath"
"snd_death" "hrath_snds/hrath_death1.wav"
"snd_attack" "hrath_snds/hrath_attk1.wav"
"snd_idle" "hrath_snds/hrath_idle1.wav"
"snd_pain" "hrath_snds/hrath_pain1.wav"
"snd_sight" "hrath_snds/hrath_sight1.wav"
"mdl_proj" "hellrath/nsoe_w_ball2.mdl"
"snd_misc" "blob/death1.wav"
}
