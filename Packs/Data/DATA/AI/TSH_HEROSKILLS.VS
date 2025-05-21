// void,Hero hero, IntArray* aSkills, IntArray* aSkillLevels

int nAvailabelPts,curLevel;
int i,j;
bool bSetPt;

if (!hero.IsValid)	return;
if (hero.IsDead)	  return;
if (aSkills.size()==0)      return;	
if (aSkillLevels.size()==0) return;	

nAvailabelPts = hero.AvailableSkillPoints();
while (nAvailabelPts>0)
{
	j = 0;
	bSetPt = false;
	while (!bSetPt && j<aSkills.size())
	{
		int nLevelsNeeded;	
		
		curLevel = hero.GetSkill(aSkills[j]);
		nLevelsNeeded = aSkillLevels[j] - curLevel;
		if (nLevelsNeeded>0)
		{
			if (nAvailabelPts<=nLevelsNeeded)
			{
			  hero.SetSkill(aSkills[j],curLevel + nAvailabelPts);
			  nAvailabelPts =0;
			}
			else
			{
			  hero.SetSkill(aSkills[j],curLevel + nLevelsNeeded);
			  nAvailabelPts -=nLevelsNeeded;
			}
			bSetPt = true;
		}
		j+=1;
	}
	if (!bSetPt && j>=aSkills.size())
		return; // No more 
}