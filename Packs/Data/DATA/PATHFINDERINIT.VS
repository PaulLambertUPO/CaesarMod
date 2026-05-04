//void

while (SPFFindAreas_Quant())
	Sleep(35);

SPFInitData();
Sleep(250);

SPFInitDirectionData();
Sleep(400);

SPFInitPointToAreaData();
Sleep(250);

SPFInitConnectData();
Sleep(250);

while (SPFCalcConnectHighRes_Quant())
	Sleep(35);

SPFIncreaseConnect();
Sleep(250);

while (SPFIncreaseConnect_Quant())
	Sleep(35);

SPFDone();