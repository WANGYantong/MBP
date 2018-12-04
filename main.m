clear
clc

rng(1);

%% Generate Network
vertice_names = {'n0','n1','n2','n3','n4','n5','n6',...
    'n7','n8','n9','n10','n11','n12',...
    'n13','n14','n15','n16','n17','n18'};

numNode = length(vertice_names);

for v = 1:numNode
    eval([vertice_names{v},'=',num2str(v),';']);
end

gateWay=n0;
normalRouter=n1:n12;
accessRouter=n13:n18;

s=[n0,n0,n0,n1,n1,n2,n2,n3,n3,n4,n4,n4,n5,n5,n5,...
    n6,n6,n6,n7,n7,n8,n8,n8,n9,n9,n9,n10,n10,n10,...
    n11,n11,n11,n12,n12,n13,n14,n15,n16,n17];

t=[n1,n2,n3,n4,n5,n5,n6,n6,n7,n5,n8,n9,n6,n8,n9,...
    n7,n10,n11,n10,n12,n9,n13,n14,n14,n10,n15,n11,n15,n16,...
    n12,n16,n17,n17,n18,n14,n15,n16,n17,n18];

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

%% Network Parameters



%% Decision Variable




%% Optimization Objective & Constraints




%% Solve the Problem




%% Visualize Solution





