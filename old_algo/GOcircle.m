% rul = GOcircle(agent,C,Cang)
% agent - ��������� ������; C - ���������� ����; Cang - ���� ����
% ������� ������ �� ����.
% ����� �������� ��������� ���������� ��������� �������, ��������� �� ����.
% � �������� ��������� � ���������� ���������� ��������� �� RP
function rul = GOcircle(agent,C,Cang)
%% ��������� ���������
Crad=300; %����������� ������ ������.
Cradmax=500; %������������ ������ ������.
dYmax=100; % ������ ������� ������.
dANGmax=pi/180; %���������� ����������� �������� �����.
SpeedKick=1; %100�����, ���� kick
%% �����������
if (isstruct(C))
    C=C.z;
end
if (~isstruct(agent))
    error('GOcircle: ''agent'' is not struct!');
end
%% ���������
global PAR;
KICK_DIST=PAR.KICK_DIST;
[x,y]=rotV(agent.x-C(1),agent.y-C(2),-Cang);
Aang=agent.ang-Cang;

%% �������� �����������
y(y==0)=0.001;
GCy=(x.^2+y.^2)./(2*y); %�������� �������������� ������������
angF=azi(angV(-x,GCy-y)-sign(GCy)*( pi/2 )); %����������� �����������
angC=azi(angV(-x-Crad,-y)); %����������� ���������� ����� �������
%angC2=azi(angV(-x,-y)); %����������� ���������� ����
N=sqrt(x.^2+y.^2); %����������
%% ������� �����
%�������� �����
ang=angF+azi((angC-angF)).*max( 0,min((N-Crad)/Cradmax,0.8));
%����� �� ������
ang2=ang;
ang2(x>0)=azi(ang(x>0))./(1-max(-0.5,min((N(x>0)-Crad)/Crad,0)));
ang2(x<=0)=azi(ang(x<=0)).*(1-max(-0.5,min((N(x<=0)-Crad)/Crad,0)));
%% Kick
% azi(Aang)
% dANGmax
% x
% KICK_DIST
% abs(azi(Aang))
% dANGmax
if (x<0 && x>-KICK_DIST && abs(y)<dYmax && abs(azi(Aang))<dANGmax)
    kick=1;
else
    kick=0;
end

%% �������� ����������
if (x<0 && abs(y)<dYmax)
    if (x>-KICK_DIST)
        ang2=0;
    end
    V_=max(0.2,min(1,(-x-200)/200));
else
    V_=1;
end
%% ����� �����
Rsize=400;
if ((norm([x,y])<Rsize) && (abs(azi(ang2-Aang))>pi/2))
    V_=min(1,max(-1,(norm([x,y])-Rsize)/100));
end
%% ���������� ���������
%Ub - ������� ��������, V - �������� ��������.
Ub=azi(ang2-Aang)/pi; 
Ub=sign(Ub)*min(1,max(2*min(1/5,abs(Ub)),abs(Ub)));
V=V_*(1-abs(Ub));
if (kick && SpeedKick)
    V=1;
    Ub=0;
end
%% ������� � �������
rul=Crul(100*(V-Ub),100*(V+Ub),kick,0,0);
%% debug
%fprintf(' x=%f ,y=%f, Aang=%f, Dang=%f, \n Dangpi=%f, Ub=%f, V_=%f, V=%f, kick=%f\n',x,y,Aang,azi(ang2-Aang),azi(ang2-Aang)/pi,Ub,V_,V,kick);
%fprintf(' Left=%f ,Right=%f, Kick=%f,\n',rul.left,rul.right,rul.kick);

end