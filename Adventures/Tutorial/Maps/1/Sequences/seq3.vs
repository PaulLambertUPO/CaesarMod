ItemHolder ih;

ih = Holder.obj.AsItemHolder();

while (1) {
	if (ih.HasItem("Poison Mushroom"))
		ih.RemoveItem("Poison Mushroom");
	Sleep(200);
}