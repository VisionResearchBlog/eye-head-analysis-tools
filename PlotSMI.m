


llabs1=ttl;
llabs2={'S1','S2','S3','S4','S5','S6','S7','S8'};

for qq=1:4
    
    
    switch qq
        
        %plot sac orientation across tasks, per sub
        case 1
            zzz=sac_orient_Hist;
            tlabs1='Mean Saccade Orientation per Task';
            tlabs2='Mean Saccade Orientation per Subject';
            xlabs='Orientation (Radians)';
            ylabs='Proportion of Saccades';
            rng=sacOrient_rng;
            lim=[-pi pi];
            logax=0;
            
            %------------------
        case 2
            zzz=sacLength_Hist;
            tlabs1='Mean Saccade Length per Task';
            tlabs2='Mean Saccade Length per Subject';
            xlabs=['Length (' degs ')'];
            ylabs='Proportion of Saccades';
            llabs=ttl;
            rng=sacLength_rng;
            lim=[1 max(sacLength_rng)];
            logax=0;
            
            %-------------------
        case 3
            zzz=sacdur_Hist;
            tlabs1='Mean Saccade Duration per Task';
            tlabs2='Mean Saccade Duration per Subject';
            xlabs='Duration (s)';
            ylabs='Proportion of Saccades';
            rng=sacDur_rng;
            lim=[0 max(sacDur_rng)];
            logax=0;
            
            
            %-------------------
        case 4
            zzz=fixdur_Hist;
            tlabs1='Mean Fixation Duration per Task';
            tlabs2='Mean Fixation Duration per Subject';
            xlabs='Duration (s)';
            ylabs='Proportion of Fixations';
            rng=fixDur_rng;
            lim=[0 max(fixDur_rng)];
            logax=0;
    end
    
    
    
    
    
    figure(15+qq); clf; subplot(2,1,1)
    clear taskMean subMean taskSEM
    
    for i=1:size(zzz,2)
        tmp=find(sum(zzz(:,i,:))>0);
        
        taskMean(:,i)=mean(zzz(:,i,tmp),3);
        taskSEM(:,i)=std(zzz(:,i,tmp),[],3)/sqrt(numsubs);
    end
    
    for i=1:size(zzz,3)
        tmp=find(sum(zzz(:,:,i))>0);
        
        subMean(:,i)=mean(zzz(:,tmp,i),2);
    end
    
    %taskMean= MeanPerTask;
    if(~logax)
        plot(rng,taskMean, 'linewidth',lsz)
    else
        semilogx(rng,taskMean, 'linewidth',lsz)
    end
    
    xlim(lim)
    legend(llabs1)
    title(tlabs1,'FontSize', fsz+ccc)
    xlabel(xlabs,'FontSize', fsz+ccc)
    ylabel(ylabs,'FontSize', fsz+ccc)
    set(gca,'FontSize', fsz)
    
    %across subs, per task
    subplot(2,1,2)
    %subMean= mean(zzz,2);
    %subMean=reshape(subMean,size(zzz,1),size(zzz,3));
    if(~logax)
        plot(rng,subMean, 'linewidth',lsz)
        xlim(lim)
    else
        semilogx(rng,subMean)
    end
    xlim(lim)
    legend(llabs2)
    title(tlabs2,'FontSize', fsz+ccc)
    xlabel(xlabs,'FontSize', fsz+ccc)
    ylabel(ylabs,'FontSize', fsz+ccc)
    set(gca,'FontSize', fsz)
    
    figure(19+qq); clf; hold on
    
    
    GrandMean=mean(subMean,2);
    GrandMedian=median(subMean,2);
    GrandSEM=std(subMean,[],2)./sqrt(numsubs);
    %GrandSTD=std(mean(zzz,2),[],3)./sqrt(size(zzz,3));
    plot(rng,GrandMean, 'linewidth',lsz)
    line(rng,GrandMean)
    fill([rng'; flipud(rng')],[GrandMean-GrandSEM;flipud(GrandMean+GrandSEM)],...
        [.9 .9 .9],'linestyle','none');
    line(rng,GrandMean)
    xlim(lim)
    xlabel(xlabs,'fontsize',fsz+ccc)
    ylabel(ylabs,'fontsize',fsz+ccc)
    set(gca,'FontSize', fsz)
    
    
    [Y,I] = max(GrandMean);
    if(qq==1)
        figure(23+qq); clf;
        set(gca,'FontSize', fsz);
        polar([rng(1:end-1)'; rng(1)],[GrandMean(1:end-1);GrandMean(1)],'k')
        hold on;
        polar([rng(1:end-1)'; rng(1)],[GrandMean(1:end-1)+GrandSEM(1:end-1);...
            GrandMean(1)+GrandSEM(1)], 'b--')
        polar([rng(1:end-1)'; rng(1)],[GrandMean(1:end-1)-GrandSEM(1:end-1);...
            GrandMean(1)-GrandSEM(1)], 'b--')
        
        figure(43); clf;
        for zp=1:numTasks
            
            subplot(1,numTasks,zp);
            set(gca,'FontSize', fsz);
            fake=.1;
            polar(0,fake,'w');
            hold on;
            polar([rng(1:end-1)'; rng(1)],[taskMean(1:end-1,zp);taskMean(1,zp)],'k')
            polar([rng(1:end-1)'; rng(1)],[taskMean(1:end-1,zp)+taskSEM(1:end-1,zp);...
                taskMean(1,zp)+taskSEM(1,zp)], 'b--')
            polar([rng(1:end-1)'; rng(1)],[taskMean(1:end-1,zp)-taskSEM(1:end-1,zp);...
                taskMean(1,zp)-taskSEM(1,zp)], 'b--')
            title(ttl{zp})
        end
    end
    
%    print('-dpdf','-r300',[tlabs1 '.pdf'])
    
    %do some KL calcs
    %are individual means diff from grand mean?
    for vv=1:size(subMean,2)
        kl_sub2grand(vv)=KL_calc(subMean(:,vv),GrandMean);
    end
    
    %are task means diff from grand mean?
    for vv=1:size(taskMean,2)
        kl_task2grand(vv)=KL_calc(taskMean(:,vv),GrandMean);
    end
    
    %how different are subs means between each other
    for vv=1:size(subMean,2)
        for hh=1:size(subMean,2)
            kl_sub2sub(vv,hh)=KL_calc(subMean(:,vv),subMean(:,hh));
        end
    end
    
    %how different is a subject between tasks
    for xx=1:size(zzz,3) %for subject xx
        for vv=1:size(zzz,2) %for task vv, held
            for hh=1:size(zzz,2) %compare all hh tasks
                kl_withinSub(vv,hh,xx)=KL_calc(zzz(:,vv,xx),zzz(:,hh,xx));
            end
        end
    end
    %each row is a task - and has the ave. kl between that tasks and
    %all others ave. over subs.
    aveDiffBetweenTasks(:,qq)=mean(sum(kl_withinSub,2)/4,3);
    
    %how different is a task between subjects
    for xx=1:size(zzz,2) %for task xx
        for vv=1:size(zzz,3) %for subj. vv, hold &
            for hh=1:size(zzz,3) %compare all hh subs
                kl_withinTasks(vv,hh,xx)=KL_calc(zzz(:,xx,vv),zzz(:,xx,hh));
            end
        end
    end
    
    %average kl between subs per task
    %each row is a subject - and has the ave. kl between that subjects and
    %all others ave. over tasks.
    kl_ave_between_subs_perTask(:,qq)=mean(sum(kl_withinTasks,2)/3,3);
    
    if(qq==1)
        GrandMean1=GrandMean; rng1=rng;
    elseif(qq==2)
        GrandMean2=GrandMean(4:end); rng2=rng(4:end);
    elseif(qq==3)
        GrandMean3=GrandMean(3:end); rng3=rng(3:end);
    elseif(qq==4)
        GrandMean4=GrandMean(5:end); rng4=rng(5:end);
    end
    
    if(qq==2)
        x=0:.1:100;
        old_fit=.15*exp(-.1316*x);
        new_fit=.1986*exp(-.1653*x);
        plot(x,old_fit,'k--', 'linewidth',lsz)
        plot(x,new_fit,'r--', 'linewidth',lsz)
        legend('Bahill et al 1975', 'Exp. Model', 'Data')
        set(gca,'FontSize', fsz)
    elseif(qq==4)
        x=0:.1:100;
        new_fit=.304*exp(-5.56*x);
        plot(x,new_fit,'r--', 'linewidth',lsz)
        legend('Data', 'Exp. Model')
    end
    
end

save('nums.mat', 'GrandMean1', 'rng1','GrandMean2', 'rng2',...
    'GrandMean3', 'rng3','GrandMean4', 'rng4')
