clear;

file=load('data_read/lekima_hangzhou_speed.txt');
windwrfold10m=file(:,1);
windwrfnew10m=file(:,2);
file=load('data_read/lekima_hangzhou_ustar.txt');
ustarwrfold=file(:,1);
ustarwrfnew=file(:,2);
clear file

z0normwrfold=ustarwrfold/0.4*log(10)-windwrfold10m;
windwrfold30m=ustarwrfold/0.4*log(30)-z0normwrfold;
windwrfold60m=ustarwrfold/0.4*log(60)-z0normwrfold;
z0normwrfnew=ustarwrfnew/0.4*log(10)-windwrfnew10m;
windwrfnew30m=ustarwrfnew/0.4*log(30)-z0normwrfnew;
windwrfnew60m=ustarwrfnew/0.4*log(60)-z0normwrfnew;

file=load('wind30m_CIXI');
wind30m=file.wind30m;
clear file
file=load('wind60m_CIXI');
wind60m=file.wind60m;
clear file



figure(1)
plot(windwrfold30m(1:43-12),'b-o','linewidth',3,'Markersize',20,'MarkerFaceColor','b')
hold on;
plot(windwrfnew30m(1:43-12),'r-o','linewidth',3,'Markersize',20,'MarkerFaceColor','r')
plot(wind30m,'k-o','linewidth',3,'Markersize',20,'MarkerFaceColor','k')
plot(windwrfold60m(1:43-12),'b--o','linewidth',3,'Markersize',20)
plot(windwrfnew60m(1:43-12),'r--o','linewidth',3,'Markersize',20)
plot(wind60m,'k--o','linewidth',3,'Markersize',20)

lgd=legend('Operational (30m)','New formula (30m)','Observed (30m)',...
    'Operational (60m)','New formula (60m)','Observed (60m)','NumColumns',2);
lgd.ItemTokenSize=[10 10 10 10 10 10]*6;
set(gca,'xlim',[6 30-1])
set(gca,'xlim',[6 12])
set(gca,'xtick',6:1:30-1)
set(gca,'xticklabel',0:1:23)
set(gca,'fontsize',25)
xlabel('Time (hour)')
ylabel('U (m/s)')
text(6,20,'(d)','fontsize',40)






