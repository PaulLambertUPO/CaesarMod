//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Hero this;

if (objs.count != 1)
	return;

this = objs[0].AsHero;
if (!.IsValid)
	return;

if(!ControllableObjs(player,"Hero").Contains(this))
	return;

if (cmdcost_stamina > .stamina)
	return;

if (.UseSkill(HeroSkillId(cmdparam))) {
//	.AddCommand(true, "taunt");
	.SetStamina(.stamina - cmdcost_stamina);
//	.SetCommand("taunt");
}



