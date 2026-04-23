//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Unit u;
			int i, max_train_level;

			max_train_level = EnvReadInt(.player, "maxtrainlevel");

			.StartTraining();

			while (.inherentlevel < max_train_level) {
				if (.health <= .maxhealth / 10)
					break;

				u = .BestTrainingTarget;

				if (u.IsAlive) {
					if (.IsEnemy(u)) {
						UserNotification("cannot train", "", .posRH, .player);
						break;
					}
					if (.GotoAttack(u, 1500, true, 15000))
						for (i = 0; i < 3; i += 1) {
							if (!.TrainAttack(u))
								break; 
							if (.health <= .maxhealth / 10) {
								Sleep(15);//prevent possible loops with other commands
								return; 
							}
							if (.inherentlevel >= max_train_level) {
								Sleep(15);//prevent possible loops with other commands
								return;
							}
						}
				}
				else
					break;
			}
		}

Sleep(15);//prevent possible loops with other commands