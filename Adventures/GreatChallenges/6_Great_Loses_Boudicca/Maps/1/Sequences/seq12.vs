WaitEmptyQuery(DungeonGuards11, -1);

{
	Obj o1, o2;
	Conversation conv;

	WaitConvRequest(ClassPlayerObjs(cUnit, 1), NO_Lleldoryn, -1, o1, o2);
	conv.Init("GetDungeonReward");
	conv.SetActor("Dreamer", o1.AsUnit());
	conv.Run();
}

if (IsNoteActive("Cave"))
	RemoveNote("Cave");