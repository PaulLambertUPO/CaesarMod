//void, Hero hero, IntArray* aSkills, IntArray* aSkillLevels

if (hero.IsValid)
	if (hero.IsAlive)
		if (aSkills.size > 0)
			if (aSkillLevels.size > 0) {
				int avblPts;

				avblPts = hero.AvailableSkillPoints;
				if (avblPts > 0) {
					int i, ptsToSpend, currSklLvl;

					for (i = 0; i < aSkills.size; i += 1) {
						currSklLvl = hero.GetSkill(aSkills[i]);
						if (currSklLvl > -1) {
							ptsToSpend = CLAMP(aSkillLevels[i], 0, 10) - currSklLvl;
							if (ptsToSpend > 0) {
								ptsToSpend = MIN(avblPts, ptsToSpend);
								hero.SetSkill(aSkills[i], currSklLvl + ptsToSpend);
								avblPts -= ptsToSpend;
								if (avblPts <= 0)
									break;
							}
						}
					}
				}
			}