//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

if (objs.count == 1)
	if (!DiplGetShareControl(objs[0].player, player))//prevent a player from activating another's hero skill from the UI top menu
		return;

{
	ObjList h_army;
	Hero h;
	int i, j, skill_id, skill_cost, skill_level;
	bool is_frenzy;

	skill_id = HeroSkillId(cmdparam);
	skill_cost = cmdcost_stamina;
	is_frenzy = skill_id == hsFrenzy;

	for (i = objs.count - 1; i >= 0; i -= 1) {
		h = objs[i].AsHero();
		if (h.IsAlive)
			if (h.stamina >= skill_cost) {
				skill_level = h.GetSkill(skill_id);
				if (skill_level > 0)
					if (!h.SkillInEffect(skill_id))
						if (h.UseSkill(skill_id)) {
							h.SetStamina(h.stamina - skill_cost);
							if (is_frenzy) {
								h_army = h.army;
								for (j = h_army.count - 1; j >= 0; j -= 1) {
									obj = h_army[j];
									if (obj.IsAlive)
										obj.Heal(obj.health * skill_level / 25);//heal for the double of the damage reduction per level to compensate initial damage
								}
							}
						}
			}
	}
}