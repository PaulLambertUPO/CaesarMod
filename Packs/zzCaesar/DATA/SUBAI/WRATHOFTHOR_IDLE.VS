//void, Obj this

point pt, pt_pos;
int rad;

pt_pos = .pos;
rad = .radius;

.PlaySound("Data/Sound Entities/WrathOfThor.xml");

while (.stamina > 0) {
	pt = RandomPointInCircle(pt_pos, rad);
	CreateFeedback("Lightning3", pt);
	ObjsInCircle(pt, 40, "Unit").Damage(60);
	Sleep(250 + rand(251));
}

//wait for "summoning_behavior.vs" to erase the object
while (true)
	Sleep(86400000);