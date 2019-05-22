%[Left,Right,Kick]=GoalKeeper(X,Xang,B,G)
%rul=GoalKeeper(Agent,B,G)
%������� �������� �������� � ����� X � ����� Xang
%B - ��������� ����. G - ��������� ������ �����.
%��������
%�1)�������� � ������.
%�2)������ �� �������� ����� � ������� ��� ��������� ����. 
%�3)������ �������� ���.
%---v0.7--- 
function [Left,Right,Kick]=GoalKeeperM(X,Xang,B,G)
if (nargin==3)
    Agent=X;
    X=Agent.z;
    G=B;
    B=Xang;
    Xang=Agent.ang;
end
if isstruct(B)
    Ball=B;
    B=Ball.z;
end
X=rotV(X,pi/2);
Xang=Xang+pi/2;
B=rotV(B,pi/2);
G=rotV(G,pi/2);
global RP;
RP.Ball.ang=RP.Ball.ang+pi/2;
[Left,Right,Kick]=GoalKeeper(X,Xang,B,G);
RP.Ball.ang=RP.Ball.ang-pi/2;
if (nargin==3)
    rul=Crul(Left,Right,Kick,0,0);
    Left=rul;
    Right=0;
    Kick=0;
end
end