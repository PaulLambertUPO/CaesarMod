EGuards.SetCommand("attach", E_Hero);
E_Hero.obj.AsHero().SetAutocast(true);
EnvWriteInt(GetSettlement("EgyptTown"), "no_neutral_guards", 1);