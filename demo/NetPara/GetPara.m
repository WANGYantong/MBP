function [paraT,paraB,link_bandwidth] = GetPara(topo,opt)

[num_link,~,~,~]=size(topo.B_laep);

% link bandwidth
link_bandwidth=zeros(num_link,1);

switch opt
    case {1,2,3,4}
        level1=1:5;
        level2=6:14;
        level3=15:26;
        level4=27:41;
    case 5
        level1=1:3;
        level2=4:9;
        level3=10:17;
        level4=18:29;
    otherwise
        error('The available topo option is 1,2,3,4!');
end

link_bandwidth(level1)=randi([240,280],length(level1),1);
link_bandwidth(level2)=randi([160,200],length(level2),1);
link_bandwidth(level3)=randi([100,140],length(level3),1);
link_bandwidth(level4)=randi([40,80],length(level4),1);

switch opt
   
    case 1
        % tactile traffic
        paraT.earning=1;
        paraT.path_bandwidth=40:5:65;
        paraT.lambda=[1,0,0,0,0,1];
        paraT.provision=0.2:0.2:1;
        
        % best effort flow
        paraB.earning=1;
        paraB.path_bandwidth=120;
        paraB.lambda=[1,1,1,1,1,1];
        
    case 2
        % tactile traffic
        paraT.earning=1;
        paraT.path_bandwidth=40;
        paraT.lambda=[1,0,0,0,0,1];
        paraT.provision=0.2:0.2:1;
        
        % best effort flow
        paraB.earning=1;
        paraB.path_bandwidth=90:10:140;
        paraB.lambda=[1,1,1,1,1,1];
        
    case 3
        % tactile traffic
        paraT.earning=1:0.2:2;
        paraT.path_bandwidth=40;
        paraT.lambda=[1,0,0,0,0,1];
        paraT.provision=0.2:0.2:1;
        
        % best effort flow
        paraB.earning=1;
        paraB.path_bandwidth=120;
        paraB.lambda=[1,1,1,1,1,1];
        
    case 4
        % tactile traffic
        paraT.earning=[1:0.2:2,3:1:8];
        paraT.path_bandwidth=[40:-2:30,25:-5:0];
        paraT.lambda=[1,0,0,0,0,1];
        paraT.provision=0.2:0.2:1;
        
        % best effort flow
        paraB.earning=1;
        paraB.path_bandwidth=120;
        paraB.lambda=[1,1,1,1,1,1];
        
    case 5
        paraT.earning=0.1:0.1:0.6;
        paraT.lambda=10:5:80;
        paraB.earning=1-paraT.earning;
    otherwise
        error('The available topo option is 1,2,3,4!');
        
end

end

