function solution=SolveMILP(topo,para,link_bw)

[num_path,num_link]=size(topo.path_link);

% decision variables
x1=optimvar('X_tp',para.flow,num_path,'Type','continuous','LowerBound',0);
x2=optimvar('X_tpe',para.flow,num_path,num_link,'Type','continuous',...
    'LowerBound',0);

% Constraints
x1_constr=sum(x1,2)<=para.path_bandwidth;
x2_constr=squeeze(sum(sum(x2)))<=link_bw;

path_linkx=zeros(para.flow,num_path,num_link);
for ii=1:para.flow
    path_linkx(ii,:,:)=topo.path_link;
end
force_constr=x2<=path_linkx.*x2;

x1_x=repmat(x1,[1,1,num_link]);
bridge_constr=x1_x.*path_linkx<=x2;

% Objective
benefit=-sum(x1.*para.earning,'all');

% Optimization Model
MILP=optimproblem;

MILP.Objective=benefit;
MILP.Constraints.constr1=x1_constr;
MILP.Constraints.constr2=x2_constr;
MILP.Constraints.constr3=force_constr;
MILP.Constraints.constr4=bridge_constr;

opts=optimoptions('linprog','Display','iter');

[sol,fval,~,~]=solve(MILP,'Options',opts);
solution.sol=sol;
solution.fval=-fval;

end

