//void, Obj This

Hero this;

this = This.AsHero();

if(.IsValid() == true && .army().count() >= 1)
{
	//idea: change with advance to each unit's position (idle if in holder)
	.army().SetCommand("idle");
}
this.AsHero().DetachArmy();
