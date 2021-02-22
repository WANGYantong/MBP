clear
clc

addpath(genpath(pwd));

rng(1);
%% Network Parameters
topo=GetTopo();
[num_path,num_link]=size(topo.path_link);

% tactile traffic
num_T=2;
paraT.earning=randi([2,8],num_T,num_path);
paraT.path_bandwidth=randi([10,20],num_T,1);
paraT.flow=num_T;

% best effort flow
num_B=8;
paraB.earning=ones(num_B,num_path);
paraB.path_bandwidth=randi([40,80],num_B,1);
paraB.flow=num_B;

% link bandwidth
link_bandwidth=ones(num_link,1)*60;
link_bandwidth(4:11)=link_bandwidth(4:11)+40;

%% Bandwidth Allocation

% tactile traffic allocation
solution_T=SolveMILP(topo,paraT,link_bandwidth);

% update link bandwidth
link_bandwidth=link_bandwidth-squeeze(sum(sum(solution_T.sol.X_tpe)));

% best effort traffic allocation
solution_B=SolveMILP(topo,paraB,link_bandwidth);

% the rest link bandwidth
link_bandwidth=link_bandwidth-squeeze(sum(sum(solution_B.sol.X_tpe)));