//bool, Obj me, Obj other

Catapult this;
this = me.AsCatapult();

if (!other.IsValid()) return false;
if (!.IsEnemy(other) || !.IsValidTarget(other)) return false;
if (!.InRange(.GetPointOnTarget(other))) return false;

if (.race == Britain) return false;
if (.race == Germany) return false;
	         
return true;
	
