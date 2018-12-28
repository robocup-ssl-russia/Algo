function [rul] = MoveToAvoidance(agent, aimPoint, obstacles)
    step = 100;
    NormalSpeed = 40;
    minSpeed = 20;
    coef = 2/750;
    vicinity = 50;
    
    if ~CheckIntersect([agent.x, agent.y], aimPoint, obstacles)
        rul = MoveToLinear(agent, aimPoint, 0, NormalSpeed, vicinity);
    else
        path = buildPath(obstacles, [agent.x, agent.y], aimPoint, -2500, -200, -1250, 1250, step, step);
        rul = MoveToLinear(agent, [path(2, 1), path(2, 2)], 0, NormalSpeed, 0);
    end
end

function [res] = CheckIntersect(A, B, obstacles)
    res = false;
    eps = 30;
    for k = 1: size(obstacles, 1)
        if size(SegmentCircleIntersect(A(1), A(2), B(1), B(2), obstacles(k, 1), obstacles(k, 2), obstacles(k, 3) + eps), 1) > 0
            res = true;
        end
    end
end

