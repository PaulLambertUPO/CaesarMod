// void
int         nSetIdx, nMaxSet;
Settlement  Set;
int         AIPlayer;
int         script;

Sleep(rand(500) + 500);

AIPlayer = AIGetPlayer();
nMaxSet = MaxSetIdx();
while( true )
{
	for( nSetIdx = 0; nSetIdx < nMaxSet; nSetIdx += 1 )
	{
		Set = IdxToSet( nSetIdx );
		if (!Set.IsOwn(AIPlayer)) continue;
		if( Set.TacticScript != TS_NONE ) continue;
		script = Set.GetTacticScript( AIPlayer );
		if( script != TS_NONE )
			Set.RunTacticScript( script );
	}
	Sleep(1000);
}
