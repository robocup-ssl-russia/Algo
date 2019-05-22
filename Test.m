% %�������� �����
% SpeedX = 40 * cos(angR);
% SpeedY = 40 * sin(angR);
% 
% %�������� � �����
% angF = arctg ((y2 - y1) / (x2 - x1));
% angE = angF - angR;
% r = 100; %������ ������
% err = 50; %������, �������, ��� ������
% const = r + err;
% if (abs(RP.agent.x - RP.ball.x) > const || abs(RP.agent.y - RP.ball.y > const))
%     if (angR == angF)  %�������� �����; �������� ������ ���� �������� �������
%         Rule(Agent, 0, 40, 0, 0);
%     else
%         Rule(Agent, 0, 0, 0, angE * 2);
%     end 
% end

%���� � �����, ����� ��������������(�� ����� ��������)
% 1 - �����, 2 - ���
SpeedX = 40 * cos(RP.Blue(N).ang);
SpeedY = 40 * sin(RP.Blue(N).ang);

angF = arctg ((RP.Ball.y - RP.Blue(N).y) / (RP.Ball.x - RP.Blue(N).x));
angE = angF - angR;

r = 100; %������ ������
err = 50; %������, �������
const = r + err;
if (abs(RP.Blue(N).x - RP.Ball.x) > const || abs(RP.Blue(N).y - RP.Ball.y > const))
    Rule(SpeedX, SpeedY, 0, angE * 2)
end

