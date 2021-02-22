function topo=GetTopo()

edges=[1,2;1,3;1,4;2,5;3,5;3,6;4,6;5,7;5,8;6,8;6,9;7,10;8,10;9,10];
g=digraph(edges(:,1),edges(:,2)); % a DAG topo
s=1; % source
d=10; % destination
allpaths=getpaths(g); % get all paths

% only keep those paths that link s and d 
% and only that part of the path between s and d (or e and d)
keep=false(size(allpaths));
for pidx=1:numel(allpaths)
    [found,where]=ismember([s,d],allpaths{pidx});
    if all(found)
        keep(pidx)=true;
        allpaths{pidx}=allpaths{pidx}(min(where):max(where));         
    end
end
selected_paths=allpaths(keep);

topo.path_link=GetLink(selected_paths,edges);

end

