function rul = GoalKeeperOnLine(agent, B, G, V)
v = 800; % окрестность ворот, их ширина, радиус окружности
    eps = 50;
    radius = 5;
    
    
    persistent tmp;
    if (isempty(tmp))
        tmp = [B.x B.y];
    end 
    
    SpeedX = StabilizationXPID(agent, G(1), 10, 1/750, 0.000005, -0.8, 50);
    if (sqrt((tmp(1) - B.x) ^ 2 + (tmp(2) - B.y) ^ 2) >= radius) && (V(1) * (B.x - G(1)) + V(2) * (B.y - G(2)) >= 0)
       [x,y] = getPointForGoalkeeper(tmp, B, G, V);
       if ( sqrt((x - G(1))^2 + (y - G(2))^2) <= v + eps)
           SpeedY = StabilizationYPID(agent, y, 60, 5/750, 0.000000, -2 , 100);
           Speed = SpeedX + SpeedY;
           rul = Crul(Speed(1), Speed(2), 0, 0, 0);
       else
           rul = Crul(SpeedX(1), SpeedX(2), 0, 0, 0);
       end
    else
        rul = Crul(SpeedX(1), SpeedX(2), 0, 0, 0);
    end
    tmp = [B.x B.y];
end