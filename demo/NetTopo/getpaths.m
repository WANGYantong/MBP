function paths = getpaths(g)
    %return all paths from a DAG.
    %the function will error in toposort if the graph is not a DAG
    % (c) 2019, G. de Sercey
    % licensed under BSD
    % All rights reserved.
    % 
    % Redistribution and use in source and binary forms, with or without
    % modification, are permitted provided that the following conditions are met:
    % 
    % 1. Redistributions of source code must retain the above copyright notice and this
    % list of conditions.
    % 2. Redistributions in binary form must reproduce the above copyright notice and
    % this list of conditions in the documentation
    % and/or other materials provided with the distribution.
    
    paths = {};     %path computed so far
    endnodes = [];  %current end node of each path for easier tracking
    for nid = toposort(g)    %iterate over all nodes
        if indegree(g, nid) == 0    %node is a root, simply add it for now
            paths = [paths; nid]; %#ok<AGROW>
            endnodes = [endnodes; nid]; %#ok<AGROW>
        end
        %find successors of current node and replace all paths that end with the current node with cartesian product of paths and successors
        toreplace = endnodes == nid;    %all paths that need to be edited
        s = successors(g, nid);
        if ~isempty(s)
            [p, tails] = ndgrid(find(toreplace), s);  %cartesian product
            paths = [arrayfun(@(p, t) [paths{p}, t], p(:), tails(:), 'UniformOutput', false);  %append paths and successors
                 paths(~toreplace)];
            endnodes = [tails(:); endnodes(~toreplace)];
        end
    end
end