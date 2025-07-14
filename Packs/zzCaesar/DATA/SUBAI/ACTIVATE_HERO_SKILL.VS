//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

if (objs.count == 1) {
	Hero this;

	this = objs[0].AsHero();

	if (.IsValid)
		if (.stamina >= cmdcost_stamina)
			if (ControllableObjs(player, "Hero").Contains(this)) {
				int skill;

				skill = HeroSkillId(cmdparam);

				if (.GetSkill(skill) > 0)
					if (!.SkillInEffect(skill))
						if (.UseSkill(skill))
							.SetStamina(.stamina - cmdcost_stamina);
			}
}