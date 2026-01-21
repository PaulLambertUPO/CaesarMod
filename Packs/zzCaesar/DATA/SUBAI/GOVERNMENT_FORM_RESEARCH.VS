//void, Obj This

Building this;
str gov_form;
int player;

this = This.AsBuilding();
gov_form = cmdparam;
player = .player;

EnvWriteString(this, "researching", "yes");
EnvWriteString(player, gov_form + "_researching", "yes");

.Progress();

StopPlayerScript(player, "Data/Subai/Government_Form.vs");
EnvWriteString(player, "GovernmentForm", gov_form);
StartPlayerScript(player, "Data/Subai/Government_Form.vs");