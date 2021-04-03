function solution=SolveMILP(topo,para,link_bw)

[num_link,num_a,num_e,num_path]=size(topo.B_laep);

% decision variables
x=optimvar('X_aep',num_a,num_e,num_path,'Type','continuous','LowerBound',0);

% Constraints
path_constr=sum(sum(x,3),2)<=para.path_bandwidth;

x_b=reshape(x,1,num_a*num_e*num_path);
x_b=repmat(x_b,[num_link,1]);
x_b=reshape(x_b,num_link,num_a,num_e,num_path);
link_constr=sum(sum(sum(topo.B_laep.*x_b,4),3),2)<=link_bw;

lambda_x=zeros(num_a,num_e,num_path);
for ii=1:num_e
    for jj=1:num_path
        lambda_x(:,ii,jj)=para.lambda;
    end
end
access_constr=x<=1e3*lambda_x;

% Objective
benefit=-sum(x*para.earning,'all');

% Optimization Model
MILP=optimproblem;

MILP.Objective=benefit;
MILP.Constraints.constr1=path_constr;
MILP.Constraints.constr2=link_constr;
MILP.Constraints.constr3=access_constr;

opts=optimoptions('linprog','Display','off');

[sol,fval,~,~]=solve(MILP,'Options',opts);
solution.X=sol.X_aep;
solution.fval=-fval;

X_link=reshape(solution.X,1,num_a*num_e*num_path);
X_link=repmat(X_link,[num_link,1]);
X_link=reshape(X_link,num_link,num_a,num_e,num_path);
solution.link=sum(sum(sum(topo.B_laep.*X_link,4),3),2);


end




