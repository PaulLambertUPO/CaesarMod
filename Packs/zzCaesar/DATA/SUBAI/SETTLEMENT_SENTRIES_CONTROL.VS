//void, Obj This

Sleep(1000 + rand(1001));

if (GetConst("NoSentries") == 0)
	if (This.AsBuilding().IsValid) {
		Settlement this;

		this = This.AsBuilding().settlement;

		{
			Settlement invalid;
			ObjList ol;
			Obj o;
			int i;
			bool no_sentries = true;

			if (.IsStronghold)
				if (.IsIndependent)
					if (EnvReadInt(this, "no_neutral_guards") != 1) {//the flag is thought for custom map/adventure sequences
						Hero h;
						Unit u;
						StrArray defenders_classes;
						str def_class;
						point pt_pos;
						int plr;

						pt_pos = This.pos;
						plr = .player;

						defenders_classes[Gaul] = "GaulHero";
						defenders_classes[RepublicanRome] = "RepublicanRomanHero";
						defenders_classes[Carthage] = "CarthaginianHero";
						defenders_classes[Iberia] = "IberianHero";
						defenders_classes[ImperialRome] = "GreekHero";
						defenders_classes[Britain] = "BritonHero";
						defenders_classes[Egypt] = "EgyptianHero";
						defenders_classes[Germany] = "GermanHero";

						h = Place(GetRandomHeroClass(defenders_classes[This.race], plr), pt_pos, plr).AsHero();
						.ForceAddUnit(h);
						h.SetLevel(12);
						h.SetFeeding(false);
						h.SetNoAIFlag(true);
						h.SetAutocast(true);

						if (This.race == ImperialRome)
							def_class = "HPeltast";
						else
							def_class = UType(0, This.race);

						for (i = 30; i > 0; i -= 1) {
							u = Place(def_class, pt_pos, plr).AsUnit();
							.ForceAddUnit(u);
							u.SetLevel(4);
							u.SetFeeding(false);
							u.SetNoAIFlag(true);
							u.AttachTo(h);
						}
					}

			ol = .Buildings;

			for (i = ol.count - 1; i >= 0; i -= 1) {
				o = ol[i];
				if (o.IsGate) {
					no_sentries = false;
					break;
				}
				if (o.IsHeirOf("Wall")) {
					no_sentries = false;
					break;
				}
			}

			if (no_sentries)
				this = invalid;
		}

		if (.IsValid) {
			while (.IsIndependent)
				Sleep(5000);

			{
				int plr, missing_sentries;

				.AddMaxSentries(20);//total max = 20 + 1 per wall + 4 per gate (total max is usually 50-52)

				while (true) {
					if (plr == .player) {
						missing_sentries = .GetMaxSentries() - .GetNumSentries();
						if (missing_sentries > 0)
							.AddSentries(MIN(4, missing_sentries));
					}
					else
						plr = .player;

					Sleep(45000);
				}
			}
		}
	}

//without this instruction, the game crashes
while (true)
	Sleep(86400000);