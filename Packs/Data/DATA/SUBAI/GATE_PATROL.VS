// void, Obj This

Building this;
str sentry_class_name;
point wp;
point ae, aa1, aa2; // exit, attack1, attack2
point be, ba1, ba2; // exit, attack1, attack2
bool slot_a1, slot_a2;
bool slot_b1, slot_b2;
Obj sent_a1, sent_a2;
Obj sent_b1, sent_b2;
Obj invalid_handle;
point observation_point;
int player;
int level, new_level;
int k, l, m;

Sleep(rand(1000) + 500);

if (GetConst("NoSentries") != 0)
{	// disable sentries
	while (1)
		Sleep(100000);
}

if (!This.IsValid()) {
	//pr("Ivalid gate!");
	while(1) Sleep(100000);  // fixme!!
}

this = This.AsBuilding();
sentry_class_name = .GetSentryClassName();


{
	IntArray inds, dists;
	point tp;
	ae = .GetPoint(2, 0);
	be = .GetPoint(2, 1);
	if (ae.x == -32768 || be.x == -32768) {
		//pr("Gate exit point not defined!");
		while(1) Sleep(100000);  // fixme!!
	}
	for (k = 0; k < 4; k += 1) {
		tp = .GetPoint(3, k);
		if (tp.x == -32768) {
			//pr("Gate attack point not defined!");
			while(1) Sleep(100000);  // fixme!!
		}
		tp = tp - ae;
		dists[k] = tp.x*tp.x + tp.y*tp.y;
		inds[k] = k;
	}
	for (k = 0; k < 3; k += 1)
	for (l = k + 1; l < 4; l += 1)
	if (dists[inds[k]] > dists[inds[l]]) {
		m = inds[k];
		inds[k] = inds[l];
		inds[l] = m;
	}
	ae = .pos + ae;
	aa1 = .pos + .GetPoint(3, inds[0]);
	aa2 = .pos + .GetPoint(3, inds[1]);
	ba2 = .pos + .GetPoint(3, inds[2]);
	ba1 = .pos + .GetPoint(3, inds[3]);
	be = .pos + be;
	
	observation_point = (aa1 + ba1) / 2;
}


//Place("Feedback", ae, .player);
//Place("Feedback", aa1, .player);
//Place("Feedback", aa2, .player);
//Place("Feedback", ba2, .player);
//Place("Feedback", ba1, .player);
//Place("Feedback", be, .player);

slot_a1 = false;
slot_a2 = false;
slot_b2 = false;
slot_b1 = false;

while (!.settlement().IsValid()) Sleep(1000);
.settlement().AddMaxSentries(4);

level = 1;
player = .player;
while (1)
{
	new_level = EnvReadInt(.settlement, "SentriesLevel");
	if (new_level > level) {
		if (slot_a1)
		if (sent_a1.IsAlive())
			sent_a1.AsUnit().SetLevel(new_level);
		if (slot_a2)
		if (sent_a2.IsAlive())
			sent_a2.AsUnit().SetLevel(new_level);
		if (slot_b2)
		if (sent_b2.IsAlive())
			sent_b2.AsUnit().SetLevel(new_level);
		if (slot_b1)
		if (sent_b1.IsAlive())
			sent_b1.AsUnit().SetLevel(new_level);
		level = new_level;
	}

	if (.IsVeryBroken() || (player != .player)) {
		if (slot_a1)
		if (!sent_a1.IsDead()) {
			Sleep(rand(200) + 300);
			sent_a1.Damage(10000);
			if (player == .player) .settlement().DelSentry();
		}
		if (slot_a2)
		if (!sent_a2.IsDead()) {
			Sleep(rand(200) + 300);
			sent_a2.Damage(10000);
			if (player == .player) .settlement().DelSentry();
		}
		if (slot_b1)
		if (!sent_b1.IsDead()) {
			Sleep(rand(200) + 300);
			sent_b1.Damage(10000);
			if (player == .player) .settlement().DelSentry();
		}
		if (slot_b2)
		if (!sent_b2.IsDead()) {
			sent_b2.Damage(10000);
			if (player == .player) .settlement().DelSentry();
		}
		slot_a1 = false;
		slot_a2 = false;
		slot_b2 = false;
		slot_b1 = false;
		player = .player;
	} else {
	
		// process first half
		if (slot_a1) {
			if (sent_a1.IsDead()) {
				.settlement().DelSentry();
				sent_a1 = invalid_handle;
				slot_a1 = false;
			} else if (sent_a1.command() == "idle")
				sent_a1.SetCommand("guard", This);
		}
		if (!slot_a1) {
			if (.settlement().GetSentry()) {
				sent_a1 = Place(sentry_class_name, ae, .player);
				sent_a1.AsUnit().SetLevel(level);
				sent_a1.SetCommand("goto", aa1);
				sent_a1.AddCommand(false, "guard", This);
				slot_a1 = true;
			}
		}
		if (slot_a2) {
			if (sent_a2.IsDead()) {
				.settlement().DelSentry();
				sent_a2 = invalid_handle;
				slot_a2 = false;
			} else if (sent_a2.command() == "idle")
				sent_a2.SetCommand("guard", This);
		}
		if (!slot_a2) {
			if (slot_a1) {
				sent_a1.SetCommand("goto", aa2);
				sent_a1.AddCommand(false, "guard", This);
				sent_a2 = sent_a1;
				sent_a1 = invalid_handle;
				slot_a1 = false;
				slot_a2 = true;
			}
		}


		// process second half
		if (slot_b1) {
			if (sent_b1.IsDead()) {
				.settlement().DelSentry();
				sent_b1 = invalid_handle;
				slot_b1 = false;
			} else if (sent_b1.command() == "idle")
				sent_b1.SetCommand("guard", This);
		}
		if (!slot_b1) {
			if (.settlement().GetSentry()) {
				sent_b1 = Place(sentry_class_name, be, .player);
				sent_b1.AsUnit().SetLevel(level);
				sent_b1.SetCommand("goto", ba1);
				sent_b1.AddCommand(false, "guard", This);
				slot_b1 = true;
			}
		}
		if (slot_b2) {
			if (sent_b2.IsDead()) {
				.settlement().DelSentry();
				sent_b2 = invalid_handle;
				slot_b2 = false;
			} else if (sent_b2.command() == "idle")
				sent_b2.SetCommand("guard", This);
		}
		if (!slot_b2) {
			if (slot_b1) {
				sent_b1.SetCommand("goto", ba2);
				sent_b1.AddCommand(false, "guard", This);
				sent_b2 = sent_b1;
				sent_b1 = invalid_handle;
				slot_b1 = false;
				slot_b2 = true;
			}
		}
	}

	if (slot_a1 || slot_a2 || slot_b2 || slot_b1)
		RevealHiddenEnemyUnits(observation_point, 570, .player);

	Sleep(1000);	
}
