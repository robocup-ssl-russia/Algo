function rul = attack(agent, ball, aim)
    global outBuffer;
    if (isState1(agent.z, ball.z))
        outBuffer(15) = 1;
        rul = MoveToWithRotation(agent, ball.z, ball.z, 1/1000, 20, 0, 3, 30, 0, -50, 0.1, false);
    else
        error_ang = errorAng(agent.z, ball.z, aim); 
        if (isState2(agent.z, ball.z, aim))
            outBuffer(15) = 2;
            rul = goAroundPoint(agent, ball.z, 250, 1000 * sign(error_ang), 5, 30 + 7 * abs(error_ang)); 
%         elseif (isState3(agent.z, agent.ang, aim))
%             outBuffer(15) = 3;
%             rul = RotateToPID(agent, aim, 4, 10, 0, -30, 0.04, false);
        elseif (isState4(agent.z, agent.ang, ball.z))
            outBuffer(15) = 4;
            rul = MoveToWithRotation(agent, ball.z, aim, 0, 25, 0, 4, 15, 0, -30, 0.04, false);
        else
            outBuffer(15) = 5;
            rul = Crul(0, 0, 1, 0, 0);
        end
    end
end

% Первый подъезд к мячу
function res = isState1(agent_pos, ball_pos)
    res = r_dist_points(agent_pos, ball_pos) > 450;
end

% Вращение вокруг точки до прицеливания
function res = isState2(agent_pos, ball_pos, aim)
    global outBuffer;
    outBuffer(14) = r_dist_point_line(ball_pos, agent_pos, aim);
    res = (r_dist_point_line(ball_pos, agent_pos, aim) > 50) || (scalMult(aim - agent_pos, ball_pos - agent_pos) < 0);
end

% Доворот до цели
function res = isState3(agent_pos, agent_ang, aim) 
    v = agent_pos - aim;                              %vector to aim
    u = [-cos(agent_ang), -sin(agent_ang)];           %direction vector of the robot  
    angDifference = -r_angle_between_vectors(u, v);   %amount of angles to which robot should rotate 
    
    res = abs(angDifference) > 0.1;
end


% Прицелились и близко (финальный подъезд к мячу)
function res = isState4(agent_pos, agent_ang, ball_pos)
    agent_dir = [cos(agent_ang), sin(agent_ang)];
    forward_center = agent_pos + 175 * agent_dir;
    res = scalMult(agent_pos - forward_center, ball_pos - forward_center) < 0;
end

function ang = errorAng(agent_pos, ball_pos, aim)
    wishV = aim - ball_pos;
    v = ball_pos - agent_pos;
    ang = r_angle_between_vectors(wishV, v);
end
