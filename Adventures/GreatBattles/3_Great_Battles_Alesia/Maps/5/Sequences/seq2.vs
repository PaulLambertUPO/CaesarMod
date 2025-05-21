while (!Q_GaulGateDefEast.IsEmpty() || !Q_GaulGateDefWest.IsEmpty()) {
	Sleep(20000);
	if (!Q_GaulGateDefEast.IsEmpty())
		if (NO_Gate1.obj.health < 1000 || NO_Gate2.obj.health < 1000)
			if (!IsAIHelperRunning("DefEasternGate"))
				RunAIHelper("DefEasternGate", "guard area", "Q_GaulGateDefEast", "A_GateEast");
	if (!Q_GaulGateDefWest.IsEmpty())
		if (NO_Gate3.obj.health < 1000 || NO_Gate4.obj.health < 1000)
			if (!IsAIHelperRunning("DefWesternGate"))
				RunAIHelper("DefWesternGate", "guard area", "Q_GaulGateDefWest", "A_GateWest");
}