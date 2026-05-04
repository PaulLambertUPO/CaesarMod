ItemHolder ih;

ih = Holder.obj.AsItemHolder();

while (true) {
	if (ih.HasItem("Poison Mushroom"))
		ih.RemoveItem("Poison Mushroom");
	Sleep(200);
}