%Movement of the robot Agent to the point G.
%Stop in the vicinity of the ball and turn to it.

function rul = MoveToPointPD(agent, G) 
angFinal = atan2((G(2) - agent.y), (G(1) - agent.x));
dif = angFinal - agent.ang;

pcoef = 1 / 750; %linear velocity coefficient
dcoef = 0; %derivative velocity coefficient
angVelocity = 15;      %angular velocity coefficient

dist = sqrt((agent.x - G(1)) ^ 2 + (agent.y - G(2)) ^ 2);
persistent oldDist;
if (isempty(oldDist))
    oldDist = dist;
end
deltaDist = oldDist - dist;
oldDist = dist;

Speed = 15 + 60 * (pcoef * dist + dcoef * deltaDist);
direction = pi / 2 + dif;
SpeedX = Speed * cos(direction); 
SpeedY = Speed * sin(direction);

r = 100;    %radius of the robot
err = 75;   %radius of the vicinity of G
vicinity = r + err;

if (dist > vicinity)
     rul = Crul(SpeedX, SpeedY, 0, 0, 0);
else
    rul = Crul(0, 0, 0, dif * angVelocity, 0);
end
end