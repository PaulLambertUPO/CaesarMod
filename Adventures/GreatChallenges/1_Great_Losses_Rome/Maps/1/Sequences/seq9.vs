int difficulty, timer, ret_point, i, r;

difficulty = GetDifficulty();

Sleep(300000 - difficulty * 60000);

while (1) {
	timer = 120000;
	if (NO_OuterTown.obj.player == 4)
		timer += 15000;
	for (i = 1; i < 8; i += 1)
		if (GetNamedObj("NO_InnerTown" + i).obj.player == 4)
			timer += 15000;
	Sleep(timer - difficulty * 30000);

	ret_point += 1;
	if (ret_point > 8)
		ret_point = 1;

	if (ret_point == 1) {
		if (NO_InnerTown1.obj.player == 4)
			if (Q_UpperHelper1.IsEmpty()) {
				SpawnGroupInHolder("Q_UpperRightRA", "S_InnerTown1");
				SpawnGroupInHolder("Q_RomanHeroUR", "S_InnerTown1");
				Q_UpperRightRA.SetCommand("attach", NO_RomanHeroUR);
				NO_RomanHeroUR.obj.AsHero().SetAutocast(true);
			}
	}
	else if (ret_point == 2) {
		if (NO_InnerTown2.obj.player == 4) {
			SpawnGroupInHolder("Q_LowerHelper2", "S_InnerTown2");
			if (!Q_OstiaReinforcementRome.IsEmpty()) {
				Q_OstiaReinforcementRome.AddToGroup("Q_LowerHelper2");
				Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
			}
		}
	}
	else if (ret_point == 3) {
		if (NO_InnerTown3.obj.player == 4) {
			SpawnGroupInHolder("Q_UpperHelper2", "S_InnerTown3");
			if (!Q_OstiaReinforcementRome.IsEmpty()) {
				Q_OstiaReinforcementRome.AddToGroup("Q_UpperHelper2");
				Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
			}
		}
	}
	else if (ret_point == 4) {
		if (NO_InnerTown4.obj.player == 4)
			if (Q_UpperHelper1.IsEmpty()) {
				SpawnGroupInHolder("Q_UpperRightRA", "S_InnerTown4");
				SpawnGroupInHolder("Q_RomanHeroUR", "S_InnerTown4");
				Q_UpperRightRA.SetCommand("attach", NO_RomanHeroUR);
				NO_RomanHeroUR.obj.AsHero().SetAutocast(true);
			}
	}
	else if (ret_point == 5) {
		if (NO_InnerTown5.obj.player == 4)
			if (Q_LowerHelper1.IsEmpty()) {
				SpawnGroupInHolder("Q_LowerRightRA", "S_InnerTown5");
				SpawnGroupInHolder("Q_RomanHeroLR", "S_InnerTown5");
				Q_LowerRightRA.SetCommand("attach", NO_RomanHeroLR);
				NO_RomanHeroLR.obj.AsHero().SetAutocast(true);
			}
	}
	else if (ret_point == 6) {
		if (NO_InnerTown6.obj.player == 4) {
			SpawnGroupInHolder("Q_LowerHelper2", "S_InnerTown6");
			if (!Q_OstiaReinforcementRome.IsEmpty()) {
				Q_OstiaReinforcementRome.AddToGroup("Q_LowerHelper2");
				Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
			}
		}
	}
	else if (ret_point == 7) {
		if (NO_InnerTown7.obj.player == 4) {
			SpawnGroupInHolder("Q_UpperHelper2", "S_InnerTown7");
			if (!Q_OstiaReinforcementRome.IsEmpty()) {
				Q_OstiaReinforcementRome.AddToGroup("Q_UpperHelper2");
				Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
			}
		}
	}
	else if (ret_point == 8)
		if (NO_OuterTown.obj.player == 4)
			if (Q_LowerHelper1.IsEmpty()) {
				SpawnGroupInHolder("Q_LowerRightRA", "S_OuterTown");
				SpawnGroupInHolder("Q_RomanHeroLR", "S_OuterTown");
				Q_LowerRightRA.SetCommand("attach", NO_RomanHeroLR);
				NO_RomanHeroLR.obj.AsHero().SetAutocast(true);
			}

	while (Q_UpperHelper1.IsEmpty() && Q_LowerHelper1.IsEmpty() && Q_UpperHelper2.IsEmpty() && Q_LowerHelper2.IsEmpty()) {
		Sleep(200);
		r = rand(8);
		if (r == 0) {
			if (NO_InnerTown1.obj.player == 4) {
				SpawnGroupInHolder("Q_UpperRightRA", "S_InnerTown1");
				SpawnGroupInHolder("Q_RomanHeroUR", "S_InnerTown1");
				Q_UpperRightRA.SetCommand("attach", NO_RomanHeroUR);
				NO_RomanHeroUR.obj.AsHero().SetAutocast(true);
				break;
			}
		}
		else if (r == 1) {
			if (NO_InnerTown2.obj.player == 4) {
				SpawnGroupInHolder("Q_LowerHelper2", "S_InnerTown2");
				if (!Q_OstiaReinforcementRome.IsEmpty()) {
					Q_OstiaReinforcementRome.AddToGroup("Q_LowerHelper2");
					Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
				}
				break;
			}
		}
		else if (r == 2) {
			if (NO_InnerTown3.obj.player == 4) {
				SpawnGroupInHolder("Q_UpperHelper2", "S_InnerTown3");
				if (!Q_OstiaReinforcementRome.IsEmpty()) {
					Q_OstiaReinforcementRome.AddToGroup("Q_UpperHelper2");
					Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
				}
				break;
			}
		}
		else if (r == 3) {
			if (NO_InnerTown4.obj.player == 4) {
				SpawnGroupInHolder("Q_LowerHelper2", "S_InnerTown4");
				if (!Q_OstiaReinforcementRome.IsEmpty()) {
					Q_OstiaReinforcementRome.AddToGroup("Q_LowerHelper2");
					Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
				}
				break;
			}
		}
		else if (r == 4) {
			if (NO_InnerTown5.obj.player == 4) {
				SpawnGroupInHolder("Q_UpperHelper2", "S_InnerTown5");
				if (!Q_OstiaReinforcementRome.IsEmpty()) {
					Q_OstiaReinforcementRome.AddToGroup("Q_UpperHelper2");
					Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
				}
				break;
			}
		}
		else if (r == 5) {
			if (NO_InnerTown6.obj.player == 4) {
				SpawnGroupInHolder("Q_LowerHelper2", "S_InnerTown6");
				if (!Q_OstiaReinforcementRome.IsEmpty()) {
					Q_OstiaReinforcementRome.AddToGroup("Q_LowerHelper2");
					Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
				}
				break;
			}
		}
		else if (r == 6) {
			if (NO_InnerTown7.obj.player == 4) {
				SpawnGroupInHolder("Q_UpperHelper2", "S_InnerTown7");
				if (!Q_OstiaReinforcementRome.IsEmpty()) {
					Q_OstiaReinforcementRome.AddToGroup("Q_UpperHelper2");
					Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
				}
				break;
			}
		}
		else if (r == 7)
			if (NO_OuterTown.obj.player == 4) {
				SpawnGroupInHolder("Q_LowerRightRA", "S_OuterTown");
				SpawnGroupInHolder("Q_RomanHeroLR", "S_OuterTown");
				Q_LowerRightRA.SetCommand("attach", NO_RomanHeroLR);
				NO_RomanHeroLR.obj.AsHero().SetAutocast(true);
				break;
			}
	}
}