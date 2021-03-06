clear
clc

rng(1);

%% Generate Network Topology
vertice_names = {'n1','n2','n3','n4','n5','n6',...
    'n7','n8','n9','n10','n11','n12',...
    'n13','n14','n15','n16','n17','n18','n19'};

numNode = length(vertice_names);

for v = 1:numNode
    eval([vertice_names{v},'=',num2str(v),';']);
end

gateWay=n1;
normalRouter=n2:n13;
accessRouter=n14:n19;

s=[n1,n1,n1,n2,n2,n3,n3,n4,n4,n5,n5,n5,n6,n6,n6,...
    n7,n7,n7,n8,n8,n9,n9,n9,n10,n10,n10,n11,n11,n11,...
    n12,n12,n12,n13,n13,n14,n15,n16,n17,n18];

t=[n2,n3,n4,n5,n6,n6,n7,n7,n8,n6,n9,n10,n7,n9,n10,...
    n8,n11,n12,n11,n13,n10,n14,n15,n15,n11,n16,n12,n16,n17,...
    n13,n17,n18,n18,n19,n15,n16,n17,n18,n19];

linkCapa=[randi([360 460],1,3),randi([200 240],1,9),...
    randi([140 180],1,12),randi([60 100],1,15)];

figure(1);

G=graph(s,t,linkCapa,vertice_names);

h=plot(G,'EdgeLabel',G.Edges.Weight,'NodeLabel',G.Nodes.Name);

highlight(h,gateWay,'NodeColor','g','Marker','p','Markersize',12);
highlight(h,normalRouter,'NodeColor','b','Marker','o','Markersize',10);
highlight(h,accessRouter,'NodeColor','k','Marker','d','Markersize',10);

h.XData=[6,4,6,8,3,5,7,9,2,4,6,8,10,1,3,5,7,9,11];
h.YData=[5,4,4,4,3,3,3,3,2,2,2,2,2,1,1,1,1,1,1];

title('Network Topology');

weight=[3 222 295 308;       3 150 199 472;
    3 78 463 492;         3 222 295 308;
    3 6 7 8;                   3 6 7 272;
    3 150 199 208;       3 6 367 392;
    3 78 103 108;         6 12 15 17;
    6 156 207 217;       6 84 111 117;
    6 12 135 145;         6 12 15 281;
    6 12 135 145;         6 12 255 273;
    6 84 111 117;         6 84 111 117;
    6 12 255 273;         6 84 111 117;
    6 12 15 193;           6 84 111 161;
    6 84 111 161;         6 12 15 193;
    6 12 135 145;         6 84 111 117;
    6 12 195 209;         6 12 75 257;
    6 84 111 117;         6 12 135 145;
    6 12 75 81;             6 84 111 117;
    6 12 135 145;         6 84 111 117;
    6 12 75 81;             6 12 15 17;
    6 12 15 149;           6 12 15 105;
    6 12 75 125];

numLink=size(weight,1);
numPlane=size(weight,2);
plane=cell(numPlane,1);
p=cell(size(plane));
for ii=1:numPlane
    figure(ii+1);
    
    plane{ii}=graph(s,t,weight(:,ii),vertice_names);
    
    p{ii}=plot(plane{ii},'EdgeLabel',plane{ii}.Edges.Weight,...
        'NodeLabel',plane{ii}.Nodes.Name);
    
    highlight(p{ii},gateWay,'NodeColor','g','Marker','p','Markersize',12);
    highlight(p{ii},normalRouter,'NodeColor','b','Marker','o','Markersize',10);
    highlight(p{ii},accessRouter,'NodeColor','k','Marker','d','Markersize',10);
    
    p{ii}.XData=[6,4,6,8,3,5,7,9,2,4,6,8,10,1,3,5,7,9,11];
    p{ii}.YData=[5,4,4,4,3,3,3,3,2,2,2,2,2,1,1,1,1,1,1];
    
    str=['Topology for plane ', num2str(ii)];
    title(str);
    
end

%% Network flow

Tac=2;   %tactile task assigned to each access router
Tac_ratio=4; % the ratio between tactile task and best effort

 flow_T=1:length(accessRouter)*Tac; % the set of all tactile tasks
 flow_B=1:length(accessRouter)*Tac*Tac_ratio; % the set of all best effort demands

%% Network Parameters
cost=zeros(numPlane,length(accessRouter));
path=cell(size(cost));
for ii=1:numPlane
    for jj=1:length(accessRouter)
        [path{ii,jj},data.N(ii,jj)]=shortestpath(plane{ii},accessRouter(jj),gateWay);
    end
end

data.delta=zeros(numPlane,length(accessRouter),numLink);
for ii=1:numPlane
    data.delta(ii,:,:)=GetPathLinkRel(plane{ii},'undirected',path(ii,:)',length(accessRouter),length(gateWay));
end

data.bandwidthT=0.15; % bandwidth request of tactile demand, 150kbps
data.bandwidthB=0.5;  % bandwidth request of best effort demand, 500kbps 
data.bandwidthL=linkCapa; % bandwidth upperbound for each link, unit: Mbps

data.probabilityT=zeros(length(flow_T),length(accessRouter));
for ii=1:length(flow_T)
    data.probabilityT(ii,ceil(ii/Tac))=1;
end
data.probabilityB=zeros(length(flow_B),length(accessRouter));
for ii=1:length(flow_B)
    data.probabilityB(ii,ceil(ii/(Tac*Tac_ratio)))=1;
end

%% Decision Variable
x_T=optimvar('x_T',length(flow_T),numPlane,length(accessRouter),...
    'Type','integer','LowerBound',0,'UpperBound',1);
x_B=optimvar('x_B',length(flow_B),numPlane,length(accessRouter),...
    'Type','integer','LowerBound',0,'UpperBound',1);

y=optimvar('y',numLink,'LowerBound',0);
z_T=optimvar('z_T',length(flow_T),numPlane,length(accessRouter),...
    numLink,'LowerBound',0);
z_B=optimvar('z_B',length(flow_B),numPlane,length(accessRouter),...
    numLink,'LowerBound',0);

%% Constraints
Tpath_constr=sum(sum(x_T,3),2)==1;

probT_x=repmat(data.probabilityT,[numPlane,1,1]);
probT_x=reshape(probT_x,length(flow_T),numPlane,length(accessRouter));
accessT_constr=x_T<=probT_x;
probB_x=repmat(data.probabilityB,[numPlane,1,1]);
probB_x=reshape(probB_x,length(flow_B),numPlane,length(accessRouter));
accessB_constr=x_B<=probB_x;

[m,n,l]=size(data.delta);
delta_mid=reshape(data.delta,1,m*n*l);
delta_T=repmat(delta_mid,[length(flow_T),1]);
delta_T=reshape(delta_T,length(flow_T),numPlane,length(accessRouter),numLink);
delta_B=repmat(delta_mid,[length(flow_B),1]);
delta_B=reshape(delta_B,length(flow_B),numPlane,length(accessRouter),numLink);
x_Tz=repmat(x_T,[1,1,1,numLink]);
x_Bz=repmat(x_B,[1,1,1,numLink]);
bandwidth_constr=squeeze(sum(sum(sum(data.bandwidthT*delta_T.*x_Tz,3),2),1)+...
    sum(sum(sum(data.bandwidthB*delta_B.*x_Bz,3),2),1))<=data.bandwidthL';

relax_constr=data.bandwidthL'.*y-squeeze(sum(sum(sum(data.bandwidthT*delta_T.*z_T,3),2),1)+...
    sum(sum(sum(data.bandwidthB*delta_B.*z_B,3),2),1))==1;

M=1000;
y_Tz=repmat(y',[length(flow_T)*numPlane*length(accessRouter),1]);
y_Tz=reshape(y_Tz,length(flow_T),numPlane,length(accessRouter),numLink);
zTdefine1_constr=z_T<=y_Tz;
zTdefine2_constr=z_T<=M*x_Tz;
zTdefine3_constr=z_T>=M*(x_Tz-1)+y_Tz;

y_Bz=repmat(y',[length(flow_B)*numPlane*length(accessRouter),1]);
y_Bz=reshape(y_Bz,length(flow_B),numPlane,length(accessRouter),numLink);
zBdefine1_constr=z_B<=y_Bz;
zBdefine2_constr=z_B<=M*x_Bz;
zBdefine3_constr=z_B>=M*(x_Bz-1)+y_Bz;

%% Objective Function
cost_T=sum(sum(sum(sum(data.bandwidthT*delta_T.*z_T,4),3),2),1);
cost_B=sum(sum(sum(sum(data.bandwidthB*delta_B.*z_B,4),3),2),1);

%% Optimization Model
MBP=optimproblem;

MBP.Objective=cost_T+cost_B;

MBP.Constraints.Tpath_constr=Tpath_constr;
MBP.Constraints.accessT_constr=accessT_constr;
MBP.Constraints.accessB_constr=accessB_constr;
MBP.Constraints.bandwidth_constr=bandwidth_constr;
MBP.Constraints.relax_constr=relax_constr;
MBP.Constraints.zTdefine1_constr=zTdefine1_constr;
MBP.Constraints.zTdefine2_constr=zTdefine2_constr;
MBP.Constraints.zTdefine3_constr=zTdefine3_constr;
MBP.Constraints.zBdefine1_constr=zBdefine1_constr;
MBP.Constraints.zBdefine2_constr=zBdefine2_constr;
MBP.Constraints.zBdefine3_constr=zBdefine3_constr;

%% Solve the Problem
opts=optimoptions('intlinprog','Display','iter','MaxTime',1800);

tic;
[sol,fval,exitflag,output]=solve(MBP,'Options',opts);
MILP_time=toc;


%% Visualize Solution





