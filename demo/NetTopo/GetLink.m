function path_link=GetLink(path,edge)

l_path=length(path);
l_edge=length(edge);
path_link=zeros(l_path,l_edge);

for ii=1:l_path
    for jj=1:l_edge
        [found,where]=ismember(edge(jj,:),path{ii});
        if all(found) && max(where)-min(where)==1
            path_link(ii,jj)=1;
        end
    end
end

end

