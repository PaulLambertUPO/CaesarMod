//void, Obj this

.PlaySound("Data/Sound Entities/CoverOfMercy.xml");

.PlayAnim(1, .pos);

while (.stamina > 0) {
	.PlayAnim(2, .pos);
	.CoverOfMercyAction();
}

.PlayAnim(3, .pos);

//wait for "summoning_behavior.vs" to erase the object
while (true)
	Sleep(86400000);