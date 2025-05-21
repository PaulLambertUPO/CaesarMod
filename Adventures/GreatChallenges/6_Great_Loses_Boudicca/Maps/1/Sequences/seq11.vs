ItemHolder holder;

holder = Lel.obj.AsItemHolder();

while (holder.HasItem("Bloodstone"))
	Sleep(5000);

RemoveNote("GetBloodstone");