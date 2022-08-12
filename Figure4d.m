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

file=load('../data/利奇马/利奇马浙江3D/u30m');
u30m=file.u30m;
clear file
file=load('../data/利奇马/利奇马浙江3D/v30m');
v30m=file.v30m;
clear file
file=load('../data/利奇马/利奇马浙江3D/w30m');
w30m=file.w30m;
clear file
averagetime=10*60*10;
u30m=dataquality(u30m);
v30m=dataquality(v30m);
w30m=dataquality(w30m);
u30m=u30m(1:fix(length(u30m)/(averagetime))*(averagetime));
ureshape=reshape(u30m,[averagetime length(u30m)/(averagetime)]);
v30m=v30m(1:fix(length(v30m)/(averagetime))*(averagetime));
vreshape=reshape(v30m,[averagetime length(v30m)/(averagetime)]);
umean=nanmean(ureshape);
vmean=nanmean(vreshape);
wind30m=sqrt(umean.^2+vmean.^2);

file=load('../data/利奇马/利奇马浙江3D/u60m');
u60m=file.u60m;
clear file
file=load('../data/利奇马/利奇马浙江3D/v60m');
v60m=file.v60m;
clear file
file=load('../data/利奇马/利奇马浙江3D/w60m');
w60m=file.w60m;
clear file
u60m=dataquality(u60m);
v60m=dataquality(v60m);
w60m=dataquality(w60m);
u60m=u60m(1:fix(length(u60m)/(averagetime))*(averagetime));
ureshape=reshape(u60m,[averagetime length(u60m)/(averagetime)]);
v60m=v60m(1:fix(length(v60m)/(averagetime))*(averagetime));
vreshape=reshape(v60m,[averagetime length(v60m)/(averagetime)]);
umean=nanmean(ureshape);
vmean=nanmean(vreshape);
wind60m=sqrt(umean.^2+vmean.^2);



figure(1)
obsstart=1*6*(24*1+10)+3;
obsend=1*6*(24*3-8)+3;
plot(windwrfold30m(1:43-12),'b-o','linewidth',3,'Markersize',20,'MarkerFaceColor','b')
hold on;
plot(windwrfnew30m(1:43-12),'r-o','linewidth',3,'Markersize',20,'MarkerFaceColor','r')
plot(wind30m(obsstart:1*6:obsend),'k-o','linewidth',3,'Markersize',20,'MarkerFaceColor','k')
plot(windwrfold60m(1:43-12),'b--o','linewidth',3,'Markersize',20)
plot(windwrfnew60m(1:43-12),'r--o','linewidth',3,'Markersize',20)
plot(wind60m(obsstart:1*6:obsend),'k--o','linewidth',3,'Markersize',20)

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






