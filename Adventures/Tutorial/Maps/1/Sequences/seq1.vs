Instructor2.obj.SetVisible(false);

WaitUnitsInArea(Caesar, "A_Items", -1);
Sleep(2000);

Holder.obj.AsItemHolder().AddItem("Elephant Tusk");
Holder.obj.AsItemHolder().AddItem("Finger of death");
View(AreaCenter("A_Items"), false);
RunConv("9A Get items");
GiveNote("ItemHolders");

while (1) {
	if (Caesar.obj.HasItem("Finger of death"))
		break;
	if (Caesar.obj.HasItem("Elephant Tusk"))
		break;
	Sleep(200);
}
Sleep(500);

RunConv("9B Nice items");
GiveNote("Items");