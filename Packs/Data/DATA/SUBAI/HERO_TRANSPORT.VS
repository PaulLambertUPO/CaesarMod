//void, Obj This, Obj other

Hero this;

this = This.AsHero();

.FormSetupAndMoveTo(other, other.sight / 3, other.radius, true);

while (.HasPath())
  .FormKeepMoving (1497);

other.SetCommand("transport_request");