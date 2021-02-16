/*
trigger_target_change

Changes an entity's target field

target = entity to change
message = new value for target field

*/
void() trigger_target_change_use =
{
    for (entity e = world; (e = find(e, targetname, self.target)); )
    {
      bprint("Found a ");
      bprint(e.classname);
      bprint("\n");
      e.target = self.message;
    }
};

void() trigger_change_target =
{
    if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
        return;

    self.use = trigger_target_change_use;
};

/*
trigger_change_target2

Changes an entity's target2 field

target = entity to change
message = new value for target field

*/
void() trigger_target2_change_use =
{
    for (entity e = world; (e = find(e, targetname, self.target)); )
    {
      bprint("Found a ");
      bprint(e.classname);
      bprint("\n");
      e.target2 = self.message;
    }
};

void() trigger_change_target2 =
{
    if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
        return;

    self.use = trigger_target2_change_use;
};
