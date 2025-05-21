RunConv("FirstTalk");

BlockUserInput();
LockView();

TalkPriest.SetMessengerStatus(false);
IntroPretorian1.SetMessengerStatus(false);
IntroPretorian2.SetMessengerStatus(false);
IntroHighlanders.SetCommand("attach", Natasha);
Natasha.SetCommand("attack", TalkPriest);
Sleep(2500);

CreateFeedback("Lightning3", ElectrocutedDruid.obj.AsUnit());
ElectrocutedDruid.Damage(700);
TalkPriest.Damage(700);

WaitEmptyQuery(IntroEnemies, -1);

RunConv("Situation");
TalkDruid.obj.AsUnit().SetMessengerStatus(false);

UnlockView();
UnblockUserInput();

SpawnGroupInHolder("BoudiccaArmy", "S_IceniTown").SetCommand("attach", Natasha);

GiveNote("Boudicca");
GiveNote("KeepTown");
GiveNote("CaptureRome");

IntroGreenArmy.SetCommand("attach", IntroGreenHero);
IntroGreenHero.obj.AsHero().SetAutocast(true);

IntroRomanArmy.SetCommand("attach", IntroRomanHero);
IntroRomanHero.obj.AsHero().SetAutocast(true);

Sleep(2000);

RunAIHelper("IntroGreenSiege", "siege", "IntroGreenArmy", "S_IceniTown");
RunAIHelper("IntroRomanSiege", "siege", "IntroRomanArmy", "S_IceniTown");