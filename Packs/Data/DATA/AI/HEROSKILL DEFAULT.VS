// void, Hero hero, int skill, int *skill_points, int *weight

// 'skill_points' contains the current skill points. The new goal points should be returned also here.
// 'weight' contains a deafault value(100). It's recomended to multiply or divide it 
//   when you want to boost or hold a skill. (weight *= 5 or weight /= 2)
//   set 'weight=0' when you want to stop developing this skill at the moment (be carefull with this!)
//   Chance to develop this skill is = 'weight' / Sum('weight of all hero skills')

// 'Default.vs' script is run when there is no script file for the respective hero skill.
// Below is a list of possible scripts.
// Every such script file should have the same params with the 'Default.vs' script.
// Different scripts could be set in the different AI profile folders ("Defensive", "Chaotic")

/*
	"Administration.vs",
	"Team attack.vs",
	"Team defense.vs",
	"Quick March.vs",
	"Epic endurance.vs",
	"Discipline.vs",
	"Leadership.vs",
	"Epic attack.vs",
	"Battle cry.vs",
	"Healing.vs",
	"Ceasefire.vs",
	"Vigor.vs",
	"Frenzy.vs",
	"Rush.vs",
	"Egoism.vs",
	"Wisdom.vs",
	"Recovery.vs",
	"Survival.vs",
	"Charge.vs",
	"Scout.vs",
	"Assault.vs",
	"Epic armor.vs",
	"Concealment.vs",
	"Defensive cry.vs",
	"Euphoria.vs"
*/

skill_points = MIN(skill_points + 5, 10);
