function topo=GetTopo(case_number)

%% graph generation
switch case_number
    case 1
        s=[1,1,1,2,3,3,4,5,5,6,6,7,8,9];
        t=[2,3,4,5,5,6,6,7,8,8,9,10,10,10];
        XData=[0,2,2,2,4,4,6,6,6,8];
        YData=[2,4,2,0,3,1,4,2,0,2];
        weights=ones(size(s));
        G=graph(s,t,weights);
    case 2
        s=[1,1,1,2,3,2,2,3,3,4,4,5,6,7,5,5,6,6,7,7,8,8,9,10,11,12,9,9,10,10,11,11,12,12,13,13,14,15,16,17,18];
        t=[2,3,4,3,4,5,6,6,7,7,8,6,7,8,9,10,10,11,11,12,12,13,10,11,12,13,14,15,15,16,16,17,17,18,18,19,15,16,17,18,19];
        XData=[0,-2,0,2,-3,-1,1,3,-4,-2,0,2,4,-5,-3,-1,1,3,5];
        YData=[8,6,6,6,4,4,4,4,2,2,2,2,2,0,0,0,0,0,0];
        weights=ones(size(s));
        G=graph(s,t,weights);
    case 3
        s=[1,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,10,11,11,12,12,12,13,13];
        t=[2,3,4,5,7,5,8,6,8,9,10,9,11,11,13,12,13,14,15,14,15,16,16,17,17,18,19,18,19];
        XData=[0,-2,0,2,-3,-1,1,3,-4,-2,0,2,4,-5,-3,-1,1,3,5];
        YData=[8,6,6,6,4,4,4,4,2,2,2,2,2,0,0,0,0,0,0];
        weights=ones(size(s));
        G=graph(s,t,weights);
    otherwise
        error('The available topo option is 1-3');
end

% plot(G,'LineWidth',1.5,'Marker','o','MarkerSize',10,...
%     'XData',XData,'YData',YData);

%% multipath collection
source=14:19;
target=1;

paths=cell(length(source),length(target));
costs=paths;
path_num=10;
for ii=1:length(source)
    for jj=1:length(target)
        [paths{ii,jj},costs{ii,jj}]=MultiPath(G,source(ii),target(jj),path_num);
    end
end

%% N_{aep} generation
N_aep=ones([size(costs),path_num])*1e6;
N_aep(:,:,1)=0; % within the assumption every nodes are connected

for ii=1:size(costs,1)
    for jj=1:size(costs,2)
        if ~isempty(costs{ii,jj})
            for kk=1:length(costs{ii,jj})
                N_aep(ii,jj,kk)=costs{ii,jj}(kk);
            end
        end
    end
end

%% B_{laep} generation
B_laep=GetPathLinkRel(G,"undirected",paths,path_num);

%% Output loading
topo.N_aep=N_aep;
topo.B_laep=B_laep;

end

