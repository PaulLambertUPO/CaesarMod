//bool, Obj this, Obj other
Unit me,him;
Building bld;
me = this.AsUnit();
him = other.AsUnit();  

if (!me.IsValid())
	return false;
if (him.IsValid()) 
	return me.IsEnemy(him) && me.IsValidTarget(him);

bld = other.AsBuilding();
if (bld.IsValid())
	return me.IsEnemy(bld);

return false; //in all other cases