function solution = SolveMILP2(topo,paraT,paraB,link_bw)

[num_link,num_a,num_e,num_path]=size(topo.B_laep);

x=optimvar('X_aep',num_a,num_e,num_path,'Type','continuous','LowerBound',0);
y=optimvar('Y_aep',num_a,num_e,num_path,'Type','continuous','LowerBound',0);

constr1=sum(sum(x,3),2)>=paraT.constr;

x_b=reshape(x,1,num_a*num_e*num_path);
x_b=repmat(x_b,[num_link,1]);
x_b=reshape(x_b,num_link,num_a,num_e,num_path);

y_b=reshape(y,1,num_a*num_e*num_path);
y_b=repmat(y_b,[num_link,1]);
y_b=reshape(y_b,num_link,num_a,num_e,num_path);

constr2=sum(sum(sum(topo.B_laep.*(x_b+y_b),4),3),2)<=link_bw;

benefit=-sum(x*paraT.earningC+y*paraB.earningC,'all');

MILP=optimproblem;

MILP.Objective=benefit;
MILP.Constraints.constr1=constr1;
MILP.Constraints.constr2=constr2;

opts=optimoptions('linprog','Display','off');
[~,fval,~,~]=solve(MILP,'Options',opts);
solution.fval=-fval;

end

