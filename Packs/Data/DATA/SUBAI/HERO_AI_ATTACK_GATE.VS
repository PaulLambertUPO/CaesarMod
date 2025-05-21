// void, Obj h, Obj g
Hero  this;
Gate  gate;

this = h.AsHero;
gate = g.AsGate;

if (!gate.IsValid || !.IsAlive)
	return;

//pr("hero_ai_attack_gate.vs");
if (.PathTo(gate, .FormRadius, 0) > .sight)
{
	.FormSetupAndMoveTo(gate.pos, .sight, 0, true);
	while (.IsAlive)
	{
		if (!.HasPath) break;
		if (.DistTo(gate) <= .sight) break;
		.FormKeepMoving(1500);
	}
}

if (!.IsAlive)
	return;

//pr("done moving in formation!");
.army.SetCommand("ai_attack_gate", gate);

.AddCommand(false, "idle");
