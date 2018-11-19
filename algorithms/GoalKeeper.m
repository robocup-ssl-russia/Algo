%goalkeeper who defends gates using circle trajectory(tactic: long distance goalkeeper)
%RP.Blue(1).rul = GoalKeeperNew(agent, B, G, V);

function rul = GoalKeeper(agent, B, G, V)
    v = 400;
    eps = 1e-3;
    radius = 5;
    
    persistent tmp;
    if (isempty(tmp))
        tmp = [B.x B.y];
    end 

    if (sqrt((tmp(1) - B.x) ^ 2 + (tmp(2) - B.y) ^ 2) >= radius) && (V(1) * (B.x - G(1)) + V(2) * (B.y - G(2)) >= 0)
        a = -tmp(2) + B.y;
        b = tmp(1) - B.x;
        c = (B.x - G(1))*(tmp(2) - G(2)) - (tmp(1) - G(1))*(B.y - G(2));
        d = a^2+b^2;
        point = [-a*c/d+G(1), -b*c/d+G(2)];

        r_to_point2 = c ^ 2 / d;
        if r_to_point2 + eps < v ^ 2
            length = sqrt(v ^ 2 - r_to_point2);
            %{
            angle = atan(tmp(1) - B.x, tmp(2) - B.y);
            X = point(1) + length * cos(angle);
            Y = point(2) + length * sin(angle);
            %}
            dir = [B.x - tmp(1), B.y - tmp(2)];
            dir = dir / sqrt(dir(1) ^ 2 + dir(2) ^ 2);
            fpnt1 = point + length * dir;
            fpnt2 = point - length * dir;
            
            if ((fpnt1(1) - B.x) ^ 2 + (fpnt1(2) - B.y) ^ 2 > (fpnt2(1) - B.x) ^ 2 + (fpnt2(2) - B.y) ^ 2)
                fpnt1 = fpnt2;
            end

            rul = MoveToPointForGoalKeeper(agent, fpnt1, B);
        else
            finalPoint = [B.x-G(1), B.y-G(2)];
            finalPoint = G + finalPoint*v/sqrt(finalPoint(1)^2+finalPoint(2)^2);
            rul = MoveToPointForGoalKeeper(agent, finalPoint, B);
        end
    else
        rul = Crul(0, 0, 0, 0, 0);
    end
    
    
    tmp = [B.x, B.y];
end    
 