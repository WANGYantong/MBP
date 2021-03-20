clear
clc

addpath(genpath('NetPara'));
% rmpath(genpath('NetTopo'));

rng(1);
%% Network Parameters
topo=GetTopo(2);
[num_link,num_a,num_e,num_path]=size(topo.B_laep);

% tactile traffic
paraT.earning=ones(num_a,num_e,num_path);
paraT.path_bandwidth=ones(num_a,num_e)*20;
paraT.lambda=[1,0,0,0,0,1];

% best effort flow
paraB.earning=ones(num_a,num_e,num_path);
paraB.path_bandwidth=ones(num_a,num_e)*60;
paraB.lambda=[1,1,1,1,1,1];

% link bandwidth
link_bandwidth=zeros(num_link,1);
level1=1:5;
level2=6:14;
level3=15:26;
level4=27:41;
link_bandwidth(level1)=randi([360,400],length(level1),1);
link_bandwidth(level2)=randi([200,240],length(level2),1);
link_bandwidth(level3)=randi([140,180],length(level3),1);
link_bandwidth(level4)=randi([60,100],length(level4),1);

%% Bandwidth Allocation

% tactile traffic allocation
solution_T=SolveMILP(topo,paraT,link_bandwidth);

% update link bandwidth
link_bandwidth=link_bandwidth-solution_T.link;

% best effort traffic allocation
solution_B=SolveMILP(topo,paraB,link_bandwidth);

% the rest link bandwidth
link_bandwidth=link_bandwidth-solution_B.link;



