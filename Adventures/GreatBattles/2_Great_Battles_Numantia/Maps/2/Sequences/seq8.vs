str area_name;

while (area_name == "") {
	if (!ClassPlayerAreaObjs(cUnit, 1, "A_RearAttack1").IsEmpty())
		area_name = "A_RearAttack1";
	else if (!ClassPlayerAreaObjs(cUnit, 1, "A_RearAttack2").IsEmpty())
		area_name = "A_RearAttack2";
	Sleep(500);
}

SpawnGroup("I_RearAttack");

RunAIHelper("CavRearAttack", "guard area", "I_RearAttack", area_name);