%% MAIN START HEADER

global Blues Yellows Balls Rules RP PAR Modul

if isempty(RP)

    addpath tools RPtools MODUL

end

%

mainHeader();

MAP(); 

if (RP.Pause) 

    return;

end

zMain_End=RP.zMain_End;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PAR.HALF_FIELD=-1;

PAR.MAP_X=4000;

PAR.MAP_Y=3000;

PAR.RobotSize=200;

PAR.KICK_DIST=200;

PAR.DELAY=0.15;

PAR.WhellR=5;



PAR.LGate.X=-2000;

PAR.RGate.X=2000;

%PAR.BorotArm=225;



%% CONTRIL BLOCK

%{
robots = [8, 7, 1, 4, 3, 2];

%{
for k = robots
    RP.Blue(k).Nrul = k;
end
%}
RP.Blue(robots(1)).Nrul = robots(1);
RP.Blue(robots(2)).Nrul = robots(2);

R = 400;
obst = zeros(numel(robots), 3);
for k = 1: numel(robots)
    rid = robots(k);
    obst(k, 1) = RP.Blue(rid).x;
    obst(k, 2) = RP.Blue(rid).y;
    obst(k, 3) = R;
end

%RP.Blue(7).rul = Attacker(RP.Blue(7), RP.Ball, [-2000, 0]);

G1 = [-2270, 147];
G2 = [-283, -168];
RP.Blue(robots(1)).rul = MoveToAvoidance(RP.Blue(robots(1)), G1, obst(2:6, 1:3));
RP.Blue(robots(2)).rul = MoveToAvoidance(RP.Blue(robots(2)), G1, obst([1, 3:6], 1:3));

%RP.Blue(robots(1)).rul = MoveToLinear(RP.Blue(robots(1)), G, 2/750, 30, 50); 
%}
V = [1, 0];
G = [-2011, -96];
RP.Blue(7).Nrul = 7;
RP.Blue(4).Nrul = 4;

%RP.Blue(4).rul = kickBall(RP.Blue(4), RP.Ball, RP.Blue(7).z, kickBallPreparation());
%RP.Blue(4).rul = RotateToPID(RP.Blue(4), RP.Ball.z, 3, 10, 0.1, -30, 0.01);
%Speed1 = StabilizationXPID(RP.Blue(4), -2300, 10, 1/750, 0.000005, -0.8, 50);
%Speed2 = StabilizationYPID(RP.Blue(4), -187, 40, 4/750, 0, -1.5, 100);
%Speed = Speed1;
%RP.Blue(4).rul = Crul(Speed(1), Speed(2), 0, 0, 0);
% RP.Blue(4).rul = RotateToPID(RP.Blue(4), RP.Ball.z, 3, 30, 0, -50, 0.05, false);
% RP.Blue(4).rul = kickBall(RP.Blue(4), RP.Ball, RP.Blue(7).z, kickBallPreparation());
%RP.Blue(4).rul = attack(RP.Blue(4), RP.Ball, RP.Blue(7).z);
RP.Blue(4).rul = GoalKeeperOnLine(RP.Blue(4), RP.Ball, G, V);
%RP.Blue(4).rul = TakeAim(RP.Blue(4), RP.Ball.z, RP.Blue(7).z);
%RP.Blue(7).rul = goAroundPoint(RP.Blue(7), RP.Ball.z, 220, 1000, 5, 40);
%RP.Blue(7).rul = RotateToLinear(RP.Blue(7), RP.Ball.z, 5, 2, 0);
%RP.Blue(7).rul = MoveToLinear(RP.Blue(7), G, 0, 40, 50);

%% END CONTRIL BLOCK

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MAIN END

%Rules

zMain_End = mainEnd();