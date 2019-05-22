function rul = MoveToWithFastBuildPath(agent, aimPoint, aimVicinity, obstacles)
    step = 80;
    NormalSpeed = 50;
    infinity = 1000000;
    minSpeed = 10;
    minMovement = 100;
    coef = 2/750;

    
    [obst, ~] = getNearestObstacle(agent.z, obstacles);
    agentPos = agent.z;
    
    %{
        ���� ����� �������� ������ ����������
        (�������� ��-�� ������������ ������ ��� ������ ������� �� �������)
        ����� �������� ������� �������� �������� ���������, ������� �������
        �� �� ������, � �� ����� ������� ��������� ����� � ������������
    %}
    if isObstaclePoint(agentPos, [obstacles(obst, 1), obstacles(obst, 2)], obstacles(obst, 3))
        agentPos = getPointOutOfObstacle(agentPos, [obstacles(obst, 1), obstacles(obst, 2)], obstacles(obst, 3), 10);
    end
    
    if r_dist_points(agent.z, aimPoint) < aimVicinity
        rul = Crul(0, 0, 0, 0, 0);
        %{
    elseif ~CheckIntersect([agent.x, agent.y], aimPoint, obstacles)
        rul = MoveToLinear(agent, aimPoint, 0, NormalSpeed, 0);
        %}
    else
        % �������� ��� ���� (������� ���������� � ��������� ������)
        firstPath = fastBuildPath(agentPos, aimPoint, obstacles, -step, 0);
        secondPath = fastBuildPath(agentPos, aimPoint, obstacles, step, 0);
        
        firstLength = 0;
        if (~firstPath.isEmpty())
            prevPnt = firstPath.pop();
            firstPoint = firstPath.getFirst();
            % ��������� ����� ������� ��������
            while ~firstPath.isEmpty()
                firstLength = firstLength + r_dist_points(prevPnt, firstPath.getFirst());
                prevPnt = firstPath.pop();
            end
        else
            firstLength = infinity;
        end
        
        secondLength = 0;
        if (~secondPath.isEmpty())
            prevPnt = secondPath.pop();
            secondPoint = secondPath.getFirst();
            % ��������� ����� ������� �������
            while ~secondPath.isEmpty()
                secondLength = secondLength + r_dist_points(prevPnt, secondPath.getFirst());
                prevPnt = secondPath.pop();
            end
        else
            secondLength = infinity;
        end
    
        if (firstLength ~= infinity || secondLength ~= infinity)
            if (firstLength < secondLength)
                point = [firstPoint(1), firstPoint(2)];
            else
                point = [secondPoint(1), secondPoint(2)];
            end
            rul = MoveToLinear(agent, point, 0, NormalSpeed, 0);
        else
            rul = Crul(0, 0, 0, 0, 0);  
        end
    end
end

function [res] = isObstaclePoint(point, obstCenter, obstRadius)
    res = r_dist_points(point, obstCenter) < obstRadius;
end

function [res] = getPointOutOfObstacle(point, obstCenter, obstRadius, step)
    vect = point - obstCenter;
    vect = vect / sqrt(vect(1) ^ 2 + vect(2) ^ 2) * (step + obstRadius * sign(step));
    res = obstCenter + vect;
end
