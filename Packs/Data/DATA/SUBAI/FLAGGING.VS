// void, Obj me

Unit this;
this = me.AsUnit();

.SetFeeding( false );
.SetNoselectFlag( true );
.SetMinimapFlag( true );

.StartAnim(1, .pos);
Sleep(.GetAnimTime(1));