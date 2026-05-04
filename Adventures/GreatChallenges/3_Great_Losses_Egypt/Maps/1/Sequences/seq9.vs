ItemHolder ih;
int i;

while (true) {
	for (i = 1; i <= 4; i += 1) {
		ih = GetNamedObj("Obelisk" + i).obj.AsItemHolder();
		if (ih.HasItem("Boar tooth"))
			ih.RemoveItem("Boar tooth");
	}
	Sleep(200);
}