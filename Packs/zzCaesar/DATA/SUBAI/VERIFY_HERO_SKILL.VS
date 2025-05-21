//bool, ObjList objs, str OUT reasonText

if (objs.count == 1) {
	Hero this;

	this = objs[0].AsHero();

	if (.IsValid) {
		int skill;

		skill = HeroSkillId(cmdparam);

		if (skill >= 0) {
			int level;

			level = .GetSkill(skill);

			if (level > 0)
				if (!.SkillInEffect(skill))
					if (cmdcost_stamina <= .stamina)
						return true;
					else
						reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Insufficient stamina");
				else
					reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Skill already in effect");
			else if (level == 0)
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("You need at least 1 point to use this skill");
		}
	}
}

return false;