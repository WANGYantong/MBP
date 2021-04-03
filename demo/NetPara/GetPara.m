function [paraT,paraB,link_bandwidth] = GetPara(topo,opt)

[num_link,~,~,~]=size(topo.B_laep);

% link bandwidth
link_bandwidth=zeros(num_link,1);
level1=1:5;
level2=6:14;
level3=15:26;
level4=27:41;
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
        
    otherwise
        error('The available topo option is 1,2,3!');
        
end

end

