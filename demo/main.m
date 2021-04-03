clear
clc

addpath(genpath(pwd));

rng(1);
%% Network Parameters
topo=GetTopo(2);

opt=3;
[paraT,paraB,link_bandwidth]=GetPara(topo,opt);

%% Bandwidth Allocation && Figure Drawing
marker=["-o","-+","-*","-x","-s","-d"];
curve_LineWidth=5.6;
curve_MarkerSize=20;
box_LineWidth=3.6;
box_FontSize=48;
lgd_FontSize=40;

switch opt
    
    case 1
        II=length(paraT.provision);
        JJ=length(paraT.path_bandwidth);
        revenue=zeros(II,JJ);
        link_result=cell(II,JJ);
        for ii=1:II
            for jj=1:JJ
                paraT_copy=paraT;
                paraT_copy.path_bandwidth=paraT.path_bandwidth(jj);
                
                link_bandwidth_copy=link_bandwidth;
                % tactile traffic allocation
                solution_T=SolveMILP(topo,paraT_copy,link_bandwidth_copy);
                
                % update link bandwidth
                link_bandwidth_copy=link_bandwidth_copy-solution_T.link*(1+paraT.provision(ii));
                link_bandwidth_copy(link_bandwidth_copy<0)=0;
                
                % best effort traffic allocation
                solution_B=SolveMILP(topo,paraB,link_bandwidth_copy);
                
                % the rest link bandwidth
                link_result{ii,jj}=link_bandwidth_copy-solution_B.link;
                
                revenue(ii,jj)=solution_T.fval+solution_B.fval;
            end
        end
        
        xx=paraT.path_bandwidth;
        hold on;
        for ii=1:II
            plot(xx,revenue(ii,:),marker(ii),'LineWidth',curve_LineWidth,'MarkerSize',curve_MarkerSize);
        end
        hold off;
        xlabel('Tactile Demand');
        ylabel('Total Revenue');
        set(gca,'LineWidth',box_LineWidth,'FontSize',box_FontSize,'FontWeight','bold')
        lgd=legend({'20%','40%','60%','80%','100%'},'Orientation','horizontal','Location','south','FontSize',lgd_FontSize);
        title(lgd,'Tactile Bandwidth Provision');
        grid minor;
        box on;
        
    case 2
        II=length(paraT.provision);
        JJ=length(paraB.path_bandwidth);
        revenue=zeros(II,JJ);
        link_result=cell(II,JJ);
        for ii=1:II
            for jj=1:JJ
                paraB_copy=paraB;
                paraB_copy.path_bandwidth=paraB.path_bandwidth(jj);
                
                link_bandwidth_copy=link_bandwidth;
                % tactile traffic allocation
                solution_T=SolveMILP(topo,paraT,link_bandwidth_copy);
                
                % update link bandwidth
                link_bandwidth_copy=link_bandwidth_copy-solution_T.link*(1+paraT.provision(ii));
                link_bandwidth_copy(link_bandwidth_copy<0)=0;
                
                % best effort traffic allocation
                solution_B=SolveMILP(topo,paraB_copy,link_bandwidth_copy);
                
                % the rest link bandwidth
                link_result{ii,jj}=link_bandwidth_copy-solution_B.link;
                
                revenue(ii,jj)=solution_T.fval+solution_B.fval;
            end
        end
        
        xx=paraB.path_bandwidth;
        hold on;
        for ii=1:II
            plot(xx,revenue(ii,:),marker(ii),'LineWidth',curve_LineWidth,'MarkerSize',curve_MarkerSize);
        end
        hold off;
        xlabel('Best-effort Demand');
        ylabel('Total Revenue');
        set(gca,'LineWidth',box_LineWidth,'FontSize',box_FontSize,'FontWeight','bold')
        lgd=legend({'20%','40%','60%','80%','100%'},'Orientation','horizontal','Location','south','FontSize',lgd_FontSize);
        title(lgd,'Tactile Bandwidth Provision');
        grid minor;
        box on;
        
    case 3
        II=length(paraT.earning);
        JJ=length(paraT.provision);
        revenue=zeros(II,JJ);
        link_result=cell(II,JJ);
        for ii=1:II
            paraT_copy=paraT;
            paraT_copy.earning=paraT.earning(ii);
            for jj=1:JJ
                link_bandwidth_copy=link_bandwidth;
                % tactile traffic allocation
                solution_T=SolveMILP(topo,paraT_copy,link_bandwidth_copy);
                
                % update link bandwidth
                link_bandwidth_copy=link_bandwidth_copy-solution_T.link*(1+paraT.provision(jj));
                link_bandwidth_copy(link_bandwidth_copy<0)=0;
                
                % best effort traffic allocation
                solution_B=SolveMILP(topo,paraB,link_bandwidth_copy);
                
                % the rest link bandwidth
                link_result{ii,jj}=link_bandwidth_copy-solution_B.link;
                
                revenue(ii,jj)=solution_T.fval+solution_B.fval;
            end
        end
        
        xx=paraT.provision;
        hold on;
        for ii=1:II
            plot(xx,revenue(ii,:),marker(ii),'LineWidth',curve_LineWidth,'MarkerSize',curve_MarkerSize);
        end
        hold off;
        xlabel('Tactile Bandwdith Provisioning');
        ylabel('Total Revenue');
        set(gca,'LineWidth',box_LineWidth,'FontSize',box_FontSize,'FontWeight','bold')
        lgd=legend({'1','1.2','1.4','1.6','1.8','2'},'Orientation','horizontal','Location','south','FontSize',lgd_FontSize);
        title(lgd,'Tactile Earning Unit');
        grid minor;
        box on;

end