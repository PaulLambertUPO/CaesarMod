//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

if (objs.count == 1)
	if (!ControllableObjs(player, "Hero").Contains(objs[0]))//prevent a player from activating another's hero skill from the UI top menu
		return;

{
	Hero h;
	int i, skill_id, skill_cost;

	skill_id = HeroSkillId(cmdparam);
	skill_cost = cmdcost_stamina;

	for (i = objs.count - 1; i >= 0; i -= 1) {
		h = objs[i].AsHero();
		if (h.IsValid)
			if (h.IsAlive)
				if (h.stamina >= skill_cost)
					if (h.GetSkill(skill_id) > 0)
						if (!h.SkillInEffect(skill_id))
							if (h.UseSkill(skill_id))
								h.SetStamina(h.stamina - skill_cost);
	}
}