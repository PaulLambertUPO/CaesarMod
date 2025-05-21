// void, Obj This

Druid this;
Unit u;
this = This.AsDruid();
if (!.IsValid()) return;

.PlayAnim(19, .pos);
u=Place("EagleSummoned", .posRH, .player);
u.SetStamina(10);
SwapSelectedObj(this, u);
.SetSummoningDeath(true);
.Damage(.health);