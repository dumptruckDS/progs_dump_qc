/*
trigger_target_change

Changes an entity's target field

target = entity to change
message = new value for target field
cnt = target field to change, null defaults to target

*/
void() trigger_target_change_use =
{
    for (entity e = world; (e = find(e, targetname, self.target)); )
    {
      if (!self.cnt || self.cnt == 1)
      {
        e.target = self.message;
      }
      else if (self.cnt == 2)
      {
        e.target2 = self.message;
      }
      else if (self.cnt == 3)
      {
        e.target3 = self.message;
      }
      else if (self.cnt == 4)
      {
        e.target4 = self.message;
      }
    }
};

void() trigger_changetarget =
{
    if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
        return;

    self.use = trigger_target_change_use;
};
