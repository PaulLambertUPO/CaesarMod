str group;
int i, j;

EnvWriteInt("/BuildTime/L1U1", 8000);//Roman Archer (max 30 for human players)
EnvWriteInt("/BuildTime/L1U2", 4000);//Gaul Archer (max 60 for human players)
EnvWriteInt("/BuildTime/L1U3", 10000);//Hastatus (max 24 for human players)
EnvWriteInt("/BuildTime/L1U4", 8000);//Gaul Swordsman (max 30 for human players)
EnvWriteInt("/BuildTime/L2U1", 12000);//Gladiator (max 20 for human players)
EnvWriteInt("/BuildTime/L2U2", 15000);//Gaul Spearman (max 16 for human players)
EnvWriteInt("/BuildTime/L3U1", 20000);//Principle (max 12 for human players)
EnvWriteInt("/BuildTime/L3U2", 15000);//Gaul Axeman (max 16 for human players)
EnvWriteInt("/BuildTime/L4U1", 12000);//Scout (max 20 for human players)
EnvWriteInt("/BuildTime/L4U2", 16000);//Gaul Horseman (max 15 for human players)
EnvWriteInt("/BuildTime/L5U1", 16000);//Teuton Archer (max 15 for human players)
EnvWriteInt("/BuildTime/L5U2", 16000);//Teuton Rider (max 15 for human players)
EnvWriteInt("/BuildTime/L6U1", 24000);//Praetorian (max 10 for human players)
EnvWriteInt("/BuildTime/L6U2", 20000);//Woman Warrior (max 12 for human players)
EnvWriteInt("/BuildTime/L6U3", 30000);//Liberatus (max 8 for human players)
EnvWriteInt("/BuildTime/L6U4", 40000);//Viking Lord (max 6 for human players)

for (i = 1; i <= 12; i += 1) {
	group = "L1U" + (rand(4) + 1);
	EnvWriteString("/House" + i, group);
	for (j = 1; j <= 30; j += 1)
		SpawnGroupInHolder(group, "Out" + i);
	Group(group).AddToGroup("DefH" + i);
	Group(group).RemoveFromGroup(group);
}
for (i = 13; i <= 16; i += 1) {
	group = "L2U" + (rand(2) + 1);
	EnvWriteString("/House" + i, group);
	for (j = 1; j <= 22; j += 1)
		SpawnGroupInHolder(group, "Out" + i);
	Group(group).AddToGroup("DefH" + i);
	Group(group).RemoveFromGroup(group);
}
for (i = 17; i <= 20; i += 1) {
	group = "L3U" + (rand(2) + 1);
	EnvWriteString("/House" + i, group);
	for (j = 1; j <= 22; j += 1)
		SpawnGroupInHolder(group, "Out" + i);
	Group(group).AddToGroup("DefH"+i);
	Group(group).RemoveFromGroup(group);
}
for (i = 21; i <= 24; i += 1) {
	group = "L4U" + (rand(2) + 1);
	EnvWriteString("/House" + i, group);
	for (j = 1; j <= 22; j += 1)
		SpawnGroupInHolder(group, "Out" + i);
	Group(group).AddToGroup("DefH" + i);
	Group(group).RemoveFromGroup(group);
}
for (i = 25; i <= 28; i += 1) {
	group = "L6U" + (rand(4) + 1);
	EnvWriteString("/House" + i , group);
	for (j = 1; j <= 8; j += 1)
		SpawnGroupInHolder(group, "Out" + i);
	Group(group).AddToGroup("DefH" + i);
	Group(group).RemoveFromGroup(group);
}
for (i = 29; i <= 32; i += 1) {
	group = "L5U" + (rand(2) + 1);
	EnvWriteString("/House" + i, group);
	for (j = 1; j <= 22; j += 1)
		SpawnGroupInHolder(group, "Out" + i);
	Group(group).AddToGroup("DefH" + i);
	Group(group).RemoveFromGroup(group);
}