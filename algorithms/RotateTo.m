%agent - robot info
%aimPoint - point to which robot is rotating
%SpeedFunction - function which characterize influence of angle changing to angle speed

function [angSpeed] = RotateTo(agent, aimPoint, angFunction)
    v = [agent.x, agent.y] - aimPoint;                                  %vector to aim
    u = [-cos(agent.ang), -sin(agent.ang)];                             %direction vector of the robot  
    angDifference = -atan2(v(1)*u(2)-u(1)*v(2), v(1)*u(1)+v(2)*u(2));   %amount of angles to which robot should rotate
    
    angSpeed = angFunction(angDifference);
end

