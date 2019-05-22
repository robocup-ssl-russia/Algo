%rul = TrackAvoidance(agent,[],Ball,Cang,algN,Opponent,C_dist,BallDangArea);
%[Left,Right] = TrackAvoidance(Xagent,Xang,Ball,Cang,algN,Opponent,C_dist,BallDangArea);
%[Left,Right] = TrackAvoidance(Xagent,Xang,Ball,Cang,algN,Opponent,C_dist), BallDangArea=0;
%[Left,Right] = TrackAvoidance(Xagent,Xang,Ball,Cang,algN,Opponent), C_dist=200, BallDangArea=5;
% �������� ������ Xagent � ���� Ball ��� ����� Cang.
% algN - ��� ������� ������ ������ ���� ���� �����.
% Opponent - ������ ��������� ����������.
% C_dis - ���������� ����������� ������ �� ����.
% BallDangArea - ���������� ����������� ������� ����..
function [Left,Right] = TrackAvoidance(Xagent,Xang,Ball,Cang,algN,Opponent,...
C_dist,BallDangArea)
%% ������������� ���������
Stop_Range=300;
show=0;
depth=4;%4
MAX_WEIGHT=150000;
%MAX_FF=1000;
%% �����������
if (isstruct(Xagent))
    if ~isempty(Xang)
        warning('use Xang=[] if Xagent is struct');
    end
    agent=Xagent;
    Xagent=agent.z;
    Xang=agent.ang;
else
    agent=[];
end
if (nargin==6)
    BallDangArea=4;
    C_dist=100;
end
if (nargin==7)
    BallDangArea=0;
end  
if isempty(algN)
    if isempty(agent)
        error('algN & agent is empty');
    end
    algN=agent.id;
end
if size(Opponent,2)==4
    Opponent=Opponent(Opponent(:,1)>0,2:3);
end
Opponent=Opponent(or(Opponent(:,1)-Xagent(1)~=0,Opponent(:,2)-Xagent(2)~=0),:);
%% ALR{N} PAR
TrAv_WorkTime=tic();
C=Ball-C_dist*[cos(Cang),sin(Cang)];
global trackavoi
if isempty(trackavoi) || ~isfield(trackavoi,'weight')
    TrackAvoi_INI();
    trackavoi.weight=[];
    trackavoi.MAP=[];
end
szX=trackavoi.PAR.szX;
szY=trackavoi.PAR.szY;
X=trackavoi.PAR.X;
Y=trackavoi.PAR.Y;
lsloy=trackavoi.PAR.lsloy;
sdvig=trackavoi.PAR.sdvig;
sdvig1=trackavoi.PAR.sdvig1;
sdvig2=trackavoi.PAR.sdvig2;
lsd=trackavoi.PAR.lsd;
algK=trackavoi.PAR.algK;
algStep=trackavoi.PAR.algStep;
d=trackavoi.PAR.d;
if ((length(trackavoi.weight)>=algN) ...
    && ~isempty(trackavoi.weight{algN})...
    && size(trackavoi.weight{algN},1)==szY ...
    && size(trackavoi.weight{algN},2)==szX)
    weight=trackavoi.weight{algN};
else
    weight=ones(szY,szX)*inf;
end
[~,ICang]=min(abs(azi(Cang-angV(sdvig(:,1),sdvig(:,2)))));
%%
FF=ones(szY,szX);
for i=1:size(Opponent,1)
    FF=FF+algK./(((X-Opponent(i,1)).^2+(Y-Opponent(i,2)).^2).^(algStep/2));
end
FF(FF>100)=100;
if ~isnan(Cang)
    rz=coor(C,X,Y);   
    rz2=coor(Ball,X,Y);
    for i=-BallDangArea:BallDangArea
        for j=-BallDangArea:BallDangArea
            if ((rz(2)+i<=szY) && (rz(2)+i>0) && (rz(1)+j<=szX) && (rz(1)+j>0))
                qwert=[X(rz(2)+i,rz(1)+j)-X(rz(2),rz(1)),...
                       Y(rz(2)+i,rz(1)+j)-Y(rz(2),rz(1))];
                if ((abs(azi(angV(qwert)-Cang))<4*pi/6) && norm(qwert)>d*2)
                    FF(rz(2)+i,rz(1)+j)=50;            
                end
            end
            if ((rz2(2)+i<=szY) && (rz2(2)+i>0) && (rz2(1)+j<=szX) && (rz2(1)+j>0))
                qwert=[X(rz2(2)+i,rz2(1)+j)-X(rz2(2),rz2(1)),...
                       Y(rz2(2)+i,rz2(1)+j)-Y(rz2(2),rz2(1))];
                if ((abs(azi(angV(qwert)-Cang))<4*pi/6) && norm(qwert)>d*2)
                    FF(rz2(2)+i,rz2(1)+j)=50;            
                end
            end
        end
    end
end
FF=[ones(lsloy+szY+lsloy,lsloy)*inf,...
    [ones(lsloy,szX)*inf;FF;ones(lsloy,szX)*inf],...
    ones(lsloy+szY+lsloy,lsloy)*inf];

weight(Z(C,X,Y))=0;
R(Z(C,X,Y))=ICang;

FShelp=zeros(szY,szX,size(sdvig1,1));
for i=1:size(sdvig1,1)
    FShelp(1:2:szY,1:szX,i)=lsd(i)*( FF((1:2:szY)+lsloy,(1:szX)+lsloy)+...
        FF((1:2:szY)+lsloy+sdvig2(i,2),(1:szX)+lsloy+sdvig2(i,1)) )/2;
    FShelp(2:2:szY,1:szX,i)=lsd(i)*( FF((2:2:szY)+lsloy,(1:szX)+lsloy)+...
        FF((2:2:szY)+lsloy+sdvig1(i,2),(1:szX)+lsloy+sdvig1(i,1)) )/2; 
end

TFS=zeros(szY,szX,size(sdvig1,1));
for j=1:depth
    %���������� T �� lsloy.
    TT=[ones(lsloy+szY+lsloy,lsloy)*inf,[ones(lsloy,szX)*inf;weight;ones(lsloy,szX)*inf],ones(lsloy+szY+lsloy,lsloy)*inf];
    %for i=1:size(sdvig1,1)
    %    TFS(1:2:szY,1:szX,i)=TT((1:2:szY)+lsloy+sdvig2(i,2),(1:szX)+lsloy+sdvig2(i,1));
    %    TFS(2:2:szY,1:szX,i)=TT((2:2:szY)+lsloy+sdvig1(i,2),(1:szX)+lsloy+sdvig1(i,1));
    %end    
    %TFS=TFS+FShelp;
    for i=1:size(sdvig1,1)  
        TFS(1:2:szY,1:szX,i)=TT((1:2:szY)+lsloy+sdvig2(i,2),(1:szX)+lsloy+sdvig2(i,1))+FShelp(1:2:szY,1:szX,i);
        TFS(2:2:szY,1:szX,i)=TT((2:2:szY)+lsloy+sdvig1(i,2),(1:szX)+lsloy+sdvig1(i,1))+FShelp(2:2:szY,1:szX,i);        
        %TFS(1:2:szY,1:szX,i)=TT((1:2:szY)+lsloy+sdvig2(i,2),(1:szX)+lsloy+sdvig2(i,1))+lsd(i)*(FF((1:2:szY)+lsloy,(1:szX)+lsloy)+FF((1:2:szY)+lsloy+sdvig2(i,2),(1:szX)+lsloy+sdvig2(i,1)))/2;
        %TFS(2:2:szY,1:szX,i)=TT((2:2:szY)+lsloy+sdvig1(i,2),(1:szX)+lsloy+sdvig1(i,1))+lsd(i)*(FF((2:2:szY)+lsloy,(1:szX)+lsloy)+FF((2:2:szY)+lsloy+sdvig1(i,2),(1:szX)+lsloy+sdvig1(i,1)))/2;        
    end
    [weight,R]=min(TFS,[],3);
    weight(Z(C,X,Y))=0;
    R(Z(C,X,Y))=ICang;
    weight([1,2,end-1,end],:)=MAX_WEIGHT;
    weight(:,[1,2,end-1,end])=MAX_WEIGHT;
%    weight([round(szX/4)],[round(szY/2)])=10000;
%   weight(:,[round(szY/2)]+[3:5])=1000000;

end

%% test_results
% Xtrack(1,:)=Xagent;
% MAX_LENGTH=500;
% for tracklen=1:MAX_LENGTH
%     Xtrack=Xtrack+sdvig(R(Z(Xtrack,X,Y)),:);
%     if weight(Z(Xtrack,X,Y))==0
%         break;
%     end    
% end
%% SaveResults
%if 1 %tracklen<MAX_LENGTH
    trackavoi.weight{algN}=weight;
%else
%    trackavoi.weight{algN}=[];
%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ReControl
if (~isnan(weight(Z(Xagent,X,Y))) && weight(Z(Xagent,X,Y))<=MAX_WEIGHT)% && tracklen<MAX_LENGTH) 
    dang=sdvig(R(Z(Xagent,X,Y)),:);
    Ub=azi(angV(dang)-Xang)/pi;
    V=1-abs(Ub);
    V=V*min(Stop_Range,weight(Z(Xagent,X,Y)))/Stop_Range;
    Left =100*(V-Ub);
    Right=100*(V+Ub);
else
%    fprintf('TrackAvoidance: stop=1\n');
    Left=0;
    Right=0;
end
if isstruct(agent)
    Left=Crul(Left,Right,0,0,0);
    Right=[];
end
%toc()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOTTING
if show
    ShowWeight(Xagent,weight,R,TrAv_WorkTime,algN);
end
%==========================================================================
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ShowWeight(Xagent,weight,R,TrAv_WorkTime,algN)
It=['TrAv_WorkTime=',sprintf('%f',toc(TrAv_WorkTime))];  
global trackavoi
if (~isfield(trackavoi.MAP,'algN'))
    trackavoi.MAP.algN=algN;
else
    if (trackavoi.MAP.algN~=algN)
        return
    end
end
sdvig=trackavoi.PAR.sdvig;
X=trackavoi.PAR.X;
Y=trackavoi.PAR.Y;
    if (get(0,'CurrentFigure')==100)
        hold on;
        %plot(X,Y,'K.')
        %p=plot(C(1),C(2),'Y*',Opponent(:,1),Opponent(:,2),'R*');
        %set(p,'linewidth',3);

        %for i=1:size(sdvig,1)
        %    Q=[-62,-508];
        %    plot([Q(1),Q(1)+30*sdvig(i,1)],[Q(2),Q(2)+30*sdvig(i,2)],'R');    
        %end

        Tmax=weight(Z(Xagent,X,Y));%10000;
        Tmax=max(Tmax,0);
        if (Tmax==inf)
            Tmax=10000000;
        end
        weight(weight>Tmax)=NaN;
        if (~isfield(trackavoi.MAP,'weight') || ~ishandle(trackavoi.MAP.weight))
            trackavoi.MAP.weight=surf(X,Y,weight-Tmax);
        else
            set(trackavoi.MAP.weight,'zdata',weight-Tmax);
        end
        colormap(cool);

        Xtrack(1,:)=Xagent;
        for i=1:15
            Xtrack(i+1,:)=Xtrack(i,:)+sdvig(R(Z(Xtrack(i,:),X,Y)),:);
            %rnm=repmat(Xtrack,[size(Opponent,1),1])-Opponent;
            %sqrt(min(rnm(:,1).^2+rnm(:,2).^2));
        end             
        if (~isfield(trackavoi.MAP,'text_stat') || ~ishandle(trackavoi.MAP.text_stat))
            trackavoi.MAP.text_stat=text(min(min(X)),max(max(Y))+100,It);
        else
            set(trackavoi.MAP.text_stat,'String',It);
        end
        if ~isfield(trackavoi.MAP,'track') || ~ishandle(trackavoi.MAP.track)
            trackavoi.MAP.track=plot(Xtrack(:,1),Xtrack(:,2),'Y');
            set(trackavoi.MAP.track,'linewidth',3');
        else
            set(trackavoi.MAP.track,'xdata',Xtrack(:,1),'ydata',Xtrack(:,2));
        end
    end
end
function z = Z(r,X,Y)
    [~,ryi]=min(abs(r(2)-Y(:,1)));
    [~,rxi]=min(abs(r(1)-X(ryi,:)));
    z=ryi+(rxi-1)*size(Y,1);
end

function TrackAvoi_INI()
 global trackavoi;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% ALG PAR
 %%OST PAR
    algStep=10;
    d=50;
    algr0=500;
 %%
 algK=(algr0^algStep)/(algStep-1);
 
%global MAP_X MAP_Y;
global PAR;
 dx=d;
 dy=dx*sqrt(3)/2;
 MX=[fliplr(-(dx:dx:((PAR.MAP_X)/2+dx))),0,(dx:dx:((PAR.MAP_X)/2+dx))];
 MY=[fliplr(-(dy:dy:((PAR.MAP_Y)/2+dy))),0,(dy:dy:((PAR.MAP_Y)/2+dy))];
 sdvig=[[0,2];...
    [-1.5,1];[-0.5,1];[0.5,1];[1.5,1];...
    [-1,0];[1,0];...
    [-1.5,-1];[-0.5,-1];[0.5,-1];[1.5,-1];...
    [0,-2]].*repmat([dx,dy],[12,1]);  
 normsdvig=sdvig./repmat([dx,dy],[12,1]);
 modsdvig=[[0;1;1;1;1;0;0;1;1;1;1;0],zeros(12,1)]/2;
 sdvig1=normsdvig+modsdvig;
 sdvig2=normsdvig-modsdvig;
 lsd=sqrt(sdvig(:,1).^2+sdvig(:,2).^2);
 lsloy=max(max(max(max(sdvig1,sdvig2))));
 [X,Y]=meshgrid(MX,MY);
 szX=size(X,2);
 szY=size(X,1);
 X(1:2:szY,:)=X(1:2:szY,:)+dx/2;
 %xi=(1:szX)+lsloy;
 %yi=(1:szY)+lsloy;
 trackavoi.PAR.szX=szX;
 trackavoi.PAR.szY=szY;
 trackavoi.PAR.X=X;
 trackavoi.PAR.Y=Y;
 trackavoi.PAR.lsloy=lsloy;
 trackavoi.PAR.sdvig=sdvig;
 trackavoi.PAR.sdvig1=sdvig1;
 trackavoi.PAR.sdvig2=sdvig2;
 trackavoi.PAR.lsd=lsd;
 trackavoi.PAR.algK=algK;
 trackavoi.PAR.algStep=algStep;
 trackavoi.PAR.d=d;
end
%%
function rz = coor(r,X,Y)
[~,ryi]=min(abs(r(2)-Y(:,1)));
[~,rxi]=min(abs(r(1)-X(ryi,:)));
rz=[rxi,ryi];
end


