%rul=SCRIPT_GoToPoint(agent,C,Opponent)
%�������� � ����� � ������� �����������
function rul=SCRIPT_GoToPoint(agent,C,Opponent)
global Blues Yellows;
if (nargin==2)
    Opponent=[Blues;Yellows];
end
if (agent.I>0)
    rul=TrackAvoidance(agent,[],C,agent.ang,[],Opponent,0,0); %������� ����������� � ���� � ST  
    rul=RegControl(agent,rul);
else
    rul=RegControl(agent);
end
end