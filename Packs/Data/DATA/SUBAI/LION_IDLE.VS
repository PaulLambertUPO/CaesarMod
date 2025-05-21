// void, Obj me

Unit this, u, packleader,mele;
point pt, v, vSum, ptMyOffset, ptOldLeaderPos;
Query qWolves;

ObjList olWolves;
int i;

this = me.AsUnit();
if (!.IsValid()) return;
qWolves = ObjsInCircle(.pos, .sight*2,"LionM,LionF");

.Idle(2000);
while (!.Stop(1000));

olWolves = qWolves.GetObjList();
olWolves.ClearDead();
for (i=0; i<olWolves.count; i+=1) 
{
	u=olWolves[i].AsUnit();
	if (!u.IsValid()) continue;
	if (u.IsHeirOf("LionM"))
	  {
		packleader = u;
		u.SetCommand("lead");
	  }
}

for (i=0; i<olWolves.count; i+=1) 
{
	u=olWolves[i].AsUnit();
	if (!u.IsValid()) continue;
	if(u.command == "engage")
	{
		.AddCommand(true, "engage");
		return;
	}
	if (!packleader.IsAlive() )
	  {
		packleader = u;
		u.SetCommand("lead");
	  }
}

	{ //follow the pack
		if(packleader.IsValid)
		{
			while(packleader.command == "lead")
			{
				ptOldLeaderPos = packleader.pos;
				if(.Goto(packleader, 15, 1000, false, 0))
				{
					while(!.Stop(1000));
					.Idle(700);
				}
				if(!packleader.IsValid)
					break;
				if(!.IsValid)
					break;
				if(ptOldLeaderPos == packleader.pos )
					.Heal(.maxhealth/3);
                if (!.IsAlive()) return;
				while(ptOldLeaderPos == packleader.pos && .DistTo(packleader) < 50)
				{
					if (!packleader.IsAlive()) return;
					if(rand(20) == 0)
					{
						pt = .pos - packleader.pos;
						pt.SetLen(pt.Len + 30);
						for(i = 0; i < 6; i+=1)
						{
							pt.Rot(45);
							pt.SetLen(pt.Len + 10);
							
							while(!.Goto(pt + packleader.pos, 0, 1500, false, 0))
								if(!packleader.IsAlive)
									return;
							if(ptOldLeaderPos != packleader.pos)
							{
								while(!.Stop(1000));
								break;
							}
						}
					} else
					{
						while(!.Stop(1000));
						.Idle(1500);
					}
				 if (!.IsAlive()) return;
				}

				if(!packleader.IsValid)
					break;	
			}
			if(packleader.IsValid) {
				if (packleader.command == "engage")	{
					.AddCommand(true, "advance", packleader.pos);
					.AddCommand(true, "engage");
				}
			}
			return;
		} else
		{
			.AddCommand(true, "lead");
		}
		return;
	}
	 
	return;
