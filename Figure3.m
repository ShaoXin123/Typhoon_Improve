clear;close all
fontsize=20;

pre_lekima=load('data_read/lekima_pressure.txt');
speed_lekima=load('data_read/lekima_speed.txt');
pre_mangkhut=load('data_read/mangkhut_pressure.txt');
speed_mangkhut=load('data_read/mangkhut_speed.txt');
pre_yanhua=load('data_read/Infa_pressure.txt');
speed_yanhua=load('data_read/Infa_speed.txt');




subplot(2,2,1)
plot([0:length(pre_lekima(:,1))-2]*6,pre_lekima(2:end,1),'b-o','linewidth',3);hold on
plot([0:length(pre_lekima(:,1))-2]*6,pre_lekima(2:end,2),'r-o','linewidth',3);hold on
plot([0:length(pre_lekima(:,1))-2]*6,pre_lekima(2:end,3),'k-o','linewidth',3);hold on
% box on;axis square
set(gca,'fontsize',fontsize)
set(gca,'xlim',[0 (length(pre_lekima(:,1))-2)*6])
set(gca,'ylim',[960 1010])
set(gca,'xtick',[0:length(pre_lekima(:,1))-2]*6)
xlabel('Time (hour)');ylabel('Minimum Pressure (hPa)');title('Typhoon Lekima')
legend('Operational','New formula','Observed')
text(0,1015,'(a)','fontsize',25)

subplot(2,2,3)
plot([0:length(speed_lekima(:,1))-2]*6,speed_lekima(2:end,1),'b-o','linewidth',3);hold on
plot([0:length(speed_lekima(:,1))-2]*6,speed_lekima(2:end,2),'r-o','linewidth',3);hold on
plot([0:length(speed_lekima(:,1))-2]*6,speed_lekima(2:end,3),'k-o','linewidth',3);hold on
% box on;axis square
set(gca,'fontsize',fontsize)
set(gca,'xlim',[0 (length(speed_lekima(:,1))-2)*6])
set(gca,'ylim',[20 50])
set(gca,'xtick',[0:length(speed_lekima(:,1))-2]*6)
xlabel('Time (hour)');ylabel('Maximum U10 (m/s)');title('Typhoon Lekima')
text(0,55,'(c)','fontsize',25)




subplot(2,2,2)
plot([0:length(pre_yanhua(:,1))-2]*6,pre_yanhua(2:end,1),'b-o','linewidth',3);hold on
plot([0:length(pre_yanhua(:,1))-2]*6,pre_yanhua(2:end,2),'r-o','linewidth',3);hold on
plot([0:length(pre_yanhua(:,1))-2]*6,pre_yanhua(2:end,3),'k-o','linewidth',3);hold on
% box on;axis square
set(gca,'fontsize',fontsize)
set(gca,'xlim',[0 (length(pre_yanhua(:,1))-2)*6])
set(gca,'ylim',[960 1010])
set(gca,'xtick',[0:2:length(pre_yanhua(:,1))-2]*6)
xlabel('Time (hour)');ylabel('Minimum Pressure (hPa)');title('Typhoon In-fa')
text(0,1015,'(b)','fontsize',25)

subplot(2,2,4)
plot([0:length(speed_yanhua(:,1))-6]*6,speed_yanhua(2:end-4,1),'b-o','linewidth',3);hold on
plot([0:length(speed_yanhua(:,1))-6]*6,speed_yanhua(2:end-4,2),'r-o','linewidth',3);hold on
plot([0:length(speed_yanhua(:,1))-6]*6,speed_yanhua(2:end-4,3),'k-o','linewidth',3);hold on
% box on;axis square
set(gca,'fontsize',fontsize)
set(gca,'xlim',[0 (length(speed_yanhua(:,1))-6)*6])
set(gca,'ylim',[10 40])
set(gca,'xtick',[0:2:length(speed_yanhua(:,1))-6]*6)
xlabel('Time (hour)');ylabel('Maximum U10 (m/s)');title('Typhoon In-fa')

text(0,40,'(d)','fontsize',25)















