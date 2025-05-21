// void, Obj me

Unit this;
this = me.AsUnit();

.Stop(2000);

while (.IsAlive)
{
	if (.CmdCount != 1)
		break;
	Sleep(500);
}
