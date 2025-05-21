IntArray r_outposts;
int i, n, r, k, difficulty;

difficulty = GetDifficulty();

r_outposts[0] = 21;
r_outposts[1] = 18;
r_outposts[2] = 11;
r_outposts[3] = 5;
r_outposts[4] = 1;

while (1) {
	Sleep(120000 + difficulty * 60000);
	for (i = 0; i < 5; i += 1) {
		n = r_outposts[i];
		if (GetNamedObj("NO_" + n).obj.player == 1) {
			r = rand(8) + 1;
			SpawnGroupInHolder("R_Reinforcements" + r, "S_" + n);
			Group("R_Reinforcements" + r).RemoveFromAllGroups();
			for (r = 0; r < 5; r += 1) {
				k = r_outposts[r];
				if (IsNoteActive("Reinforcements_S" + k))
					RemoveNote("Reinforcements_S" + k);
			}
			GiveNote("Reinforcements_S" + n);
			break;
		}
	}
}