// void, Obj This

Unit this;
int lifetime;

this = This.AsUnit;
if( .IsValid ) {
    if( .IsAlive ) {
        lifetime = GetConst("ShamanGhostBaseLifetime") + .level * GetConst("ShamanGhostLifetimePerLevel"); 
        Sleep(lifetime);
        .Damage(.health * 2);
    }
}

Sleep(500); // 