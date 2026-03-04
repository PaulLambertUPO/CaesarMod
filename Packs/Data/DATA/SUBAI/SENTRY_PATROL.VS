//void, Obj me, Obj wall_target

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Building wall;

		wall = wall_target.AsBuilding();

		if (wall.IsValid) {
			point route_1, route_2, dir_wall, dir_sentry;
			int i;
			bool go_forward;

			{
				point pt_pos, exit_1, exit_2, front_1, front_2, waypoint, exit_dist_1, exit_dist_2;//point validity checks have already been made by "wall_patrol.vs"

				exit_1 = wall.GetPoint(2, 0);
				exit_2 = wall.GetPoint(2, 1);
				front_1 = wall.GetPoint(3, 0);
				front_2 = wall.GetPoint(3, 1);
				waypoint = wall.GetPoint(17, 0);

				if (waypoint.x != -32768) {
					exit_dist_1 = exit_1 - waypoint;
					exit_dist_2 = exit_2 - waypoint;
					if (exit_dist_1.x * exit_dist_1.x + exit_dist_1.y * exit_dist_1.y < exit_dist_2.x * exit_dist_2.x + exit_dist_2.y * exit_dist_2.y)
						exit_1 = waypoint;
					else
						exit_2 = waypoint;
				}

				pt_pos = wall.pos + exit_1;
				exit_dist_1 = exit_2 - exit_1;
				i = exit_dist_1.x * exit_dist_1.x + exit_dist_1.y * exit_dist_1.y;

				exit_dist_2 = front_1 - exit_1;
				route_1 = pt_pos + exit_dist_1 * (exit_dist_1.x * exit_dist_2.x + exit_dist_1.y * exit_dist_2.y) * 100 / i / 100;

				exit_dist_2 = front_2 - exit_1;
				route_2 = pt_pos + exit_dist_1 * (exit_dist_1.x * exit_dist_2.x + exit_dist_1.y * exit_dist_2.y) * 100 / i / 100;

				pt_pos = .pos;
				exit_dist_1 = pt_pos - route_1;
				exit_dist_2 = pt_pos - route_2;
				go_forward = exit_dist_1.x * exit_dist_1.x + exit_dist_1.y * exit_dist_1.y <= exit_dist_2.x * exit_dist_2.x + exit_dist_2.y * exit_dist_2.y;

				exit_dist_1 = (route_2 * 4 + route_1) / 5;
				exit_dist_2 = (route_1 * 4 + route_2) / 5;
				route_1 = exit_dist_1;
				route_2 = exit_dist_2;
			}

			dir_wall = wall.GetPoint(8, 0);

			while (!.Stop(1000))
				;

			while (1) {
				if (go_forward)
					while (!.Goto(route_1, 0, 2000, true, 0))
						;
				else
					while (!.Goto(route_2, 0, 2000, true, 0))
						;
				go_forward = !go_forward;

				.Face(.pos - dir_wall);
				dir_sentry = dir_wall;
				for (i = 2 + rand(13); i >= 0; i -= 1) {
					Sleep(200 + rand(101));
					dir_sentry = dir_sentry + Point(rand(81) - 40, rand(81) - 40);
					.Face(.pos - dir_sentry);
				}
			}
		}
	}