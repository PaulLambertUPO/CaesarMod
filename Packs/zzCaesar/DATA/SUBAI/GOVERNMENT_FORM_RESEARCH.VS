//void, Obj this

str gov_form;
int plr;

gov_form = cmdparam;
plr = .player;

EnvWriteString(.AsBuilding(), "researching", "yes");
EnvWriteString(plr, gov_form + "_researching", "yes");

.Progress();

StopPlayerScript(plr, "Data/Subai/Government_Form.vs");
EnvWriteString(plr, "GovernmentForm", gov_form);
StartPlayerScript(plr, "Data/Subai/Government_Form.vs");