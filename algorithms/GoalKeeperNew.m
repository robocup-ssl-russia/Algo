%доехать в точку А, развернуться к мячу
%agent - робот, В - мяч, G - центр ворот
%RP.Blue(1).rul = GoalKeeperNew(agent, B, G);

function rul = GoalKeeperNew(agent, B, G)
v = 150; % окрестность ворот, их ширина, радиус окружности
bg = norm(B - G);
b = abs(B(1) - G(1));
g = abs(B(2) - G(2));
sina = g / bg;
cosa = b / bg;
X = G(1) + v * cosa;
Y = G(2) + v * sina;
A = [X, Y]; %точка пересечения прямой, соед. центр ворот и мяч, с окружностью с центром в G и радиусом v

%angFinal = atan2((A(2) - agent.y), (A(1) - agent.x));
%angRobot = agent.ang;
dif = angV(A - agent.z) - agent.ang;

coef = 60 / 650; %linear velocity coefficient
coef1 = 15;      %angular velocity coefficient

dist = norm(agent.z - A);

SpeedX = coef * cos(pi / 2 + dif) * dist;
SpeedY = coef * sin(pi / 2 + dif) * dist;

r = 100;    %radius of the robot
err = 10;   %radius of the vicinity of A
vicinity = r + err;

if (dist > vicinity)
     rul = Crul(SpeedX, SpeedY, 0, 0, 0);
else
    dif1 = angV(ball.z - agent.z) - agent.ang; %angV возвращает угол направления вектора
    rul = Crul(0, 0, 0, dif1 * coef1, 0);
end

end