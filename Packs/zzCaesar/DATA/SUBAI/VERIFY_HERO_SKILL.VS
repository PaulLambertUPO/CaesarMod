//bool, ObjList objs, str OUT reasonText

int skill_id;

skill_id = HeroSkillId(cmdparam);

if (skill_id >= 0) {
	Hero h;
	int i, skill_cost, skill_level, h_skill_owned, h_skill_level_0, h_skill_leveled_up, h_skill_in_effect;

	skill_cost = cmdcost_stamina;

	for (i = objs.count - 1; i >= 0; i -= 1) {
		h = objs[i].AsHero();
		if (h.IsValid)
			if (h.IsAlive) {
				skill_level = h.GetSkill(skill_id);
				if (skill_level > 0) {
					h_skill_owned += 1;
					h_skill_leveled_up += 1;
					if (h.SkillInEffect(skill_id))
						h_skill_in_effect += 1;
					else if (h.stamina >= skill_cost) 
						return true;
				}
				else if (skill_level == 0) {
					h_skill_owned += 1;
					h_skill_level_0 += 1;
				}
			}
	}

	if (h_skill_owned > 0)
		if (h_skill_level_0 == h_skill_owned)
			reasonText = rollover(h, false) + "\n<color 255 0 0>" + Translate("You need at least 1 point to use this skill");
		else if (h_skill_in_effect == h_skill_leveled_up)
			reasonText = rollover(h, false) + "\n<color 255 0 0>" + Translate("Skill already in effect");
		else
			reasonText = rollover(h, false) + "\n<color 255 0 0>" + Translate("Not enough stamina");//using true is not good because h could be a hero with enough stamina
}

return false;