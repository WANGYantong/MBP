clear
clc

addpath(genpath(pwd));

rng(1);
%% Network Parameters
topo=GetTopo(3);

opt=5;
[paraT,paraB,link_bandwidth]=GetPara(topo,opt);

%% Bandwidth Allocation && Figure Drawing
marker=["-o","-+","-*","-x","-s","-d",":o",":+",":*",":x",":s",":d"];
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
        
    case 4
        II=length(paraT.earning);
        JJ=length(paraT.provision);
        revenue=zeros(II,JJ);
        link_result=cell(II,JJ);
        for ii=1:II
            paraT_copy=paraT;
            paraT_copy.earning=paraT.earning(ii);
            paraT_copy.path_bandwidth=paraT.path_bandwidth(ii);
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
        
        figure(1);
        xx=paraT.provision;
        hold on;
        for ii=1:II
            plot(xx,revenue(ii,:),marker(ii),'LineWidth',curve_LineWidth,'MarkerSize',curve_MarkerSize);
        end
        hold off;
        xlabel('Tactile Bandwidth Provisioning');
        ylabel('Total Revenue');
        ylim([640 850]);
        set(gca,'LineWidth',box_LineWidth,'FontSize',box_FontSize,'FontWeight','bold')
        lgd=legend({'1','1.2','1.4','1.6','1.8','2','3','4','5','6','7','8'},...
            'Orientation','horizontal','Location','south','FontSize',lgd_FontSize-10);
        title(lgd,'Tactile Earning Unit');
        grid minor;
        box on;
        
        [px,~]=gradient(revenue);
        figure(2);
        s=surf(px,'FaceAlpha',0.5,'FaceColor','interp');
        ylabel('Tactice Earning Unit');
        xlabel('Tactile Bandwidth Provisioning');
        xticklabels({'0.2','0.4','0.6','0.8','1'});
        zlabel('Gradient');
        set(gca,'LineWidth',box_LineWidth,'FontSize',box_FontSize-10,'FontWeight','bold');
        colorbar;
        view(0,90);

    case 5
        II=length(paraT.earning);
        JJ=length(paraT.lambda);
        revenue=zeros(II,JJ);
        running_time=zeros(II,JJ);
        for ii=1:II
            paraT.earningC=paraT.earning(ii);
            paraB.earningC=paraB.earning(ii);
            for jj=1:JJ
                paraT.constr=paraT.lambda(jj);
                tic;
                for kk=1:20
                    solution=SolveMILP2(topo,paraT,paraB,link_bandwidth);
                end
                time=toc;
                revenue(ii,jj)=solution.fval;
                running_time(ii,jj)=time/20;
            end
        end

        figure(1);
        xx=paraT.lambda;
        hold on;
        for ii=1:II
            plot(xx,revenue(ii,:),marker(ii),'LineWidth',curve_LineWidth,...
                'MarkerSize',curve_MarkerSize);
        end
        hold off;
        xlabel('Tactile Demand');
        ylabel('Total Revenue');
        xlim([10,80]);
        set(gca,'LineWidth',box_LineWidth,'FontSize',box_FontSize,'FontWeight','bold')
        lgd=legend({'1:9','2:8','3:7','4:6','5:5','6:4'},...
            'Orientation','horizontal','Location','south','FontSize',lgd_FontSize-10);
        title(lgd,'Earning Ratio-Tactile:Best Effort');
        grid minor;
        box on;

        figure(2);
        hold on;
        for ii=1:II
            plot(xx,running_time(ii,:),marker(ii),'LineWidth',curve_LineWidth,...
                'MarkerSize',curve_MarkerSize);
        end
        hold off;
        xlabel('Tactile Demand');
        ylabel('Time Complexity');
        xlim([10,80]);
        set(gca,'LineWidth',box_LineWidth,'FontSize',box_FontSize,'FontWeight','bold')
        lgd=legend({'1:9','2:8','3:7','4:6','5:5','6:4'},...
            'Orientation','horizontal','Location','north','FontSize',lgd_FontSize-10);
        title(lgd,'Earning Ratio-Tactile:Best Effort');
        grid minor;
        box on;

end