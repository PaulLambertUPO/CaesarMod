//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

int i;
Unit u;

if (EnvReadString(objs[0].player, "Teuton Master")!="researched")
  return;

for(i = 0; i < objs.count(); i += 1)
{
	u = objs[i].AsUnit;
	if(u.IsValid) {
		u.SneakCommand("convert");
	}
}
