//void, Hero hero, int skill, int *skill_points, int *weight

/*
NOTES ABOUT HEKO SKILL SCRIPTS:
- skill_points contains the current/goal skill points
- weight contains a default value (100) and affects the development of a skill (weight = 0 stops it, be careful with that)
- the chance to develop a skill is equal to the weight divided by the sum of all hero skill weights
- Every such script file should have the same params of "Default.vs"
- it is possible to use different scripts for different AI profiles in their respective folders

This is the list of all possible hero skill scripts:
- "Default.vs", which is run when there is no script file for the respective skill
- "Administration.vs"
- "Team attack.vs"
- "Team defense.vs"
- "Quick March.vs"
- "Epic endurance.vs"
- "Discipline.vs"
- "Leadership.vs"
- "Epic attack.vs"
- "Battle cry.vs"
- "Healing.vs"
- "Ceasefire.vs"
- "Vigor.vs"
- "Frenzy.vs"
- "Rush.vs"
- "Egoism.vs"
- "Wisdom.vs"
- "Recovery.vs"
- "Survival.vs"
- "Charge.vs"
- "Scout.vs"
- "Assault.vs"
- "Epic armor.vs"
- "Concealment.vs"
- "Defensive cry.vs"
- "Euphoria.vs"
*/

skill_points = MIN(skill_points + 5, 10);