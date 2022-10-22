# progs_dump_qc
This is the most current version of progs_dump .qc source.

Then latest official release is version 3.0.0. which can be downloaded here:
http://www.quaketastic.com/files/single_player/mods/progs_dump_devkit_v300.zip

Changes from version 2.0.0 to 3.0.0

September 2022

* Fixed QSS crash in mobot.qc (paavohuhtala)
* Fixed syntax error in Enforcer.qc (paavohuhtala)
* Added in-fighting modes to monsters (ILike80sRock)
* Added breakable spawnflags to func_fall2 (whirledtsar)
* Added explosive projectiles to HellKnight (ILike80sRock)
* Renamed potentially offensive file name (progs.src, spawn.qc)
* Fixed Voreballs not homing in func_monster_spawner Shalraths (ILike80sRock)
* Added trigger_changetarget (ILike80sRock)
* Added Wait for retrigger spawnflag to trigger_multiple (ILike80sRock)
* Added style 4 to Ogre - shoots lavaballs (JaycieErysdren)
* Quake Info Pool fixes: https://www.quake-info-pool.net/q1/qcfix.htm
* Fixed armor affected by drowning damage (dumptruck_ds)
* Added gravity, solidity, back-and-forth, only once and play count
  spawnflags to misc_model (Inky, bmFbr)
* Added trigger/toggle animations to misc_model using target_setstate (bmFbr)
* Added info_intermissiontext for custom intermission messages (ILike80sRock)
* Added skip_id1_overrides worldspawn key to disable hardcoded map features
  like intermissions and E1M8 gravity (ILike80sRock)
* Added PASSIVE_ALWAYS and PASSIVE_UNTIL_ATTACKED spawnflags (dumptruck_ds)
* Added Looping spawnflag to play_sound_triggered which allows triggered,
  looping sounds to restart after a save (bmFbr)
* Added Turret Mode spawnflag for Grunts, Enforcers, Ogres, Ogre Marksmen,
  Hellknight, Shalrath, Shamblers and Zombies. (dumptruck_ds, ILike80sRock)
* Fixed armor taking damage with Pentagram of Protection (johnfitz)
* Added custom sound keys and new options for func_new_plat (Alkaline, bmFbr)
* Made Zombies partially z-aware only in Turret Mode (dumptruck_ds, Preach)
* Removed "in wall" dprint on monster with I_AM_TURRET spawnflag (dumptruck_ds)
* Fixed Fiend and Dog instakill bug (dumptruck_ds, Preach)
* Added custom projectiles with exploding options to Wizard (ILike80sRock)
* Added trigger_textstory and target_textstory to show long centerprint texts
  can fade background and trigger sounds (bmFbr)
* Fixed missing sound_attack keys on Grunts (ILike80sRock)
* Added Style 1 to Shambler (throws lavaballs, works in turret mode)
  (dumptruck_ds)
* Added misc_modeltrain allowing custom triggered animations for monster models
  and other trains (Alkaline, bmFbr)
* Consolidated TrenchBroom FGDs into one file that now displays custom models
  and skins (dumptruck_ds, bmFbr)
* Added homing key to monsters and styles that shoot projectiles (ILike80sRock)
* Added proj_speed_mod to modify monster projectile speeds (ILike80sRock)
* Added custom path alignment using origin textures to func_train (TheRektafire)
* Added in-fighting mode -1 Never in-fight (ILike80sRock)
* Added Spawn Silently spawnflag to monsters (wait 1 can still be used)
  (dumptruck_ds)
* Added trigger_monsterface: Running monsters that do not see their target and
  touch this will face in the direction of the trigger's angle instead of the
  unseen target. (TheSolipsist)
* Added func_shadow, misc_shadowcontroller and switchable shadow support to
  doors and brushmodels (bmFbr)
* Added func_togglevisiblewall, a toggleable version of func_wall (bmFbr)
* Added SILENT spawnflag to func_fall (dumptruck_ds)
* Added START_HIDDEN spawnflag to misc_model (Alkaline, dumptruck_ds)
* Added random delay to triggerspawned monsters [delay -1] (dumptruck_ds)
* Added rapid fire Nailgun styles to Grunt and Enforcer (ILike80sRock)
* Added KexDynamicLight to entity files (dumptruck_ds)
* Added custom sound support for func_rotate_door (Inky)
* Added custom model support to Silver and Gold keys (dumptruck_ds)
* Replaced sound effects with public domain alternatives (dumptruck_ds)
* Added custom noise key to misc_sparks (dumptruck_ds)
* Added light_sprite_flame (dumptruck_ds)
* Added missing spawnflags to fog entities (dumptruck_ds)
* item_health_vial will over heal player and rot like Megahealth (dumptruck_ds)
* Added NO_LAVASPLASH spawnflag to boss2 (dumptruck_ds)
* Fixed error in item_backpack (dumptruck_ds)
* Added new spawnflags to func_bossgate and func_episodegate that reverse their
  functionality (ILike80sRock)
