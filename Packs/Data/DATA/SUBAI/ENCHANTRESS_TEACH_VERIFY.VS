// bool, Obj This, Obj target

Unit this;
Druid d;
Unit tgt;
int level, level1, level2;

this = This.AsUnit();
if (!.IsAlive)              return false;
if (!.HasSpecial(teaching)) return false;

tgt = target.AsUnit();
if (!tgt.IsAlive)  return false;
if (.IsEnemy(tgt)) return false;
if (tgt.InHolder)  return false;
if (!.CanSee(tgt)) return false;
if (tgt == this)   return false;


//TO WHAT LEVEL SHOULD WE TRAIN UNITS?
level1 = GetConst("TeachingLevel1");
level2 = GetConst("TeachingLevel2");

level = level1;
if (EnvReadString(.player, "Ancestral Knowledge") == "researched")
	level = level2;

if (tgt.inherentlevel >= level)
	return false;

//if (.stamina < cmdcost_stamina) return false;

return true;
