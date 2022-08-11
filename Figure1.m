clear;close;
fontsize=32;
linewidth=6;
markersize=400;
capsize=12;
colorBR=[0, 146, 255;
    229, 93, 19]/255;
file=load('data_cd/cd-10m-160m-5ms.mat');
cd160m=file.cd2;
clear file
file=load('data_cd/cdup-10m-160m-5ms.mat');
cd160mup=file.cd2errorup;
clear file
file=load('data_cd/cddown-10m-160m-5ms.mat');
cd160mdown=file.cd2errordown;
clear file
file=load('data_cd/cdumean-10m-160m-5ms.mat');
cd160mumean=file.umean;
clear file

z0=zeros(1,41);
z0(z0==0)=0.28;
u10=5:20/40:25;
cdold=0.4^2./(log(10./z0)).^2;
z0(u10>15)=10./(10./z0(u10>15)).^(u10(u10>15)/15);
cdnew=0.4^2./(log(10./z0)).^2;
u10shao=[11.57 15.76 16.34 16.94];
cdshao=[0.02141 0.01969 0.0161 0.01384];


% scatter(u10shao,cdshao,markersize,'filled','k')
p1=errorbar(cd160mumean(:,1),cd160m,cd160m-cd160mdown,cd160mup-cd160m,...
    's','color',colorBR(2,:),'markersize',markersize-390,'capsize',capsize-8,'LineWidth',linewidth-4);
hold on;
p2=plot(u10,cdnew,'color',colorBR(1,:),'linewidth',3);
box on;axis square
lgd=legend([p1,p2],'Shao et al. (2022)','Modified drag relation');
set(lgd,'ItemTokenSize',[10 10 10 10 10 10]*5);
xlabel('$U_{10}$ $(m/s)$','interpreter','latex')
ylabel('$Cd$','interpreter','latex')
set(gca,'fontsize',25)
set(gca,'ylim',[0.005 0.025])
set(gca,'xlim',[5 20])
set(gca,'ticklength',[0.02 0.05]);set(gca,'linewidth',1.2);
set(gca,'fontname','Times New Roman');


