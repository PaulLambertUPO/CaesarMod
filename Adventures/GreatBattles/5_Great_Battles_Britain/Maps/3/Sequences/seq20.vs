ObjList ol;
int i, j, c;

ol = ImportantB.GetObjList();
c = ol.count;

while (j != c) {
	j = 0;
	for (i = 0; i < c; i += 1)
		if (ol[i].player == 1)
			j += 1;
	Sleep(1000);
}

if (EnvReadInt("/CalgacusArmy") != 1) {
	EnvWriteInt("/CalgacusArmy", 1);
	RunConv("Calgacus");
	ClearSelection(1);
}