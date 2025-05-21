// void, Obj me

Hero  this;

this = me.AsUnit();
if (!.IsValid())
  return;
if (.stamina < cmdcost_stamina)  
  return;
if (.health >= .maxhealth)
  return;

CreateFeedback("Heal", this);
.SetStamina(.stamina - cmdcost_stamina);
.Heal(100);	
