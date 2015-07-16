clc
clear all
Ir=11649;
global T k x1 x2 x3 t0 p u SC1 SC2 l1 l2 l3 w1 w2 w3 dd
dd=1; %the time interval
u=0.5;% u denotes the rate of the immunizatiion after vaccination
T=2;    %the stage time
t0=T;    %the time interval between the ordering time and the arriving time 
l1=0;     %the usage rate of the new drug of the area 1
l2=0;    %the usage rate of the new drug of the area 2
l3=0;    %the usage rate of the new drug of the area 3
w1=0;   %the manufacturing rate of the vaccine for the area 1
w2=0;   %the manufacturing rate of the vaccine for the area 2
w3=0;   %the manufacturing rate of the vaccine for the area 3
ts=0:dd:t0; 
k=0;     %the stage number
x01=[25409,4578,3867,2009];  %the initial value of SIQR of the area 1
[t,x]=ode45('ill1',ts,x01); % As to x,the first column is S，the second  I，the third Q，the fourth R
x1=x;
x02=[10708,1067,897,468];  %the initial value of SIQR of the area 2
[t,x]=ode45('ill2',ts,x02);
x2=x;
x03=[18090,1822,1458,799];  %the initial value of SIQR of the area 3
[t,x]=ode45('ill3',ts,x03);
x3=x;

p=0.15;    %the rate of the vaccination
VX1=2000;  %the maximum manufacturing speed of the new drug of the factory 1
VY1=600;  %the maximum manufacturing speed of the vaccine of the factory 1
VX2=3000;  %the maximum manufacturing speed of the new drug of the factory 2
VY2=700;  %the maximum manufacturing speed of the vaccine of the factory 2

C=[1 2 2;2 3 4];% C(i,j) denotes the unit transportation price from factory i to area j 
SC1=[];
SC2=[];
ll1=[0,0];%ll(k,1) denotes the quantity of the drug used in k stage in area 1
          %ll(k,1) denotes the quantity of the vaccine used in k stage in area 1
ll2=[0,0];
ll3=[0,0];
judge1=true;%the indicator of whether the epidemic is controlled or not
N0=3;
kkk=0;
while judge1
    % the demand of the new drug and vaccine in this stage
    %DX1,DY1 denotes the demand of the new drug and vaccine in the end of
      %this stage in area 1
    %x01 denotes the number of the SIQR in the end of this stage
    [DX1,DY1,x01]=DXDY(x1);
    [DX2,DY2,x02]=DXDY(x2);
    [DX3,DY3,x03]=DXDY(x3);
    % renew the manufacturing speed of the vaccine and drug and their real
         % production
    %renew the quantity which is given to the warehouses
    %Dxi,Dyi denotes the real production of factory i
    %Vxi,Vyi denotes the real manufacturing speed of the factory i
    %Sxj,Syj denotes the practical quantity provided for the warehouse j
    if DX1+DX2+DX3<=(VX1+VX2)*T
        %the demand < the maximum production
        Dx1=VX1/(VX1+VX2)*(DX1+DX2+DX3);
        Vx1=Dx1/T;
        Dx2=(DX1+DX2+DX3)-Dx1;
        Vx2=Dx2/T;
        Sx1=DX1;
        Sx2=DX2;
        Sx3=DX3;
    else
        %the demand > the maximum production
        Vx1=VX1;
        Vx2=VX2;
        %the total production
        Dx=(Vx1+Vx2)*T;
        Sx1=DX1/(DX1+DX2+DX3)*Dx;
        Sx2=DX2/(DX1+DX2+DX3)*Dx;
        Sx3=Dx-Sx1-Sx2;
    end
    if DY1+DY2+DY3<=(VY1+VY2)*T
        %the demand < the maximum production
        Dy1=VY1/(VY1+VY2)*(DY1+DY2+DY3);
        Vy1=Dy1/T;
        Dy2=(DY1+DY2+DY3)-Dy1;
        Vy2=Dy2/T;
        Sy1=DY1;
        Sy2=DY2;
        Sy3=DY3;
    else
        %the demand > the maximum production
        Vy1=VY1;
        Vy2=VY2;
        %the total production Dy
        Dy=(Vy1+Vy2)*T;
        Sy1=DY1/(DY1+DY2+DY3)*Dy;
        Sy2=DY2/(DY1+DY2+DY3)*Dy;
        Sy3=Dy-Sy1-Sy2;
    end
    
    %linear programming for the transportation price
    [h,fval,exitflag]=sfb(C,Vx1*T,Vx2*T,Sx1,Sx2,Sx3);
    SC1=[SC1;Vx1*T,Vx2*T,Sx1,Sx2,Sx3,h' fval];
    [h,fval,exitflag]=sfb(C,Vy1*T,Vy2*T,Sy1,Sy2,Sy3);
    SC2=[SC2;Vy1*T,Vy2*T,Sy1,Sy2,Sy3,h' fval];
    
    
    %predict S0，I0，R0，Q0 of the end of the next stage
       %as for area 1
    x=yuce1(x01,Sy1,Sx1);
    ll1=[ll1;Sx1,Sy1];
    x1=[x1;x];
       %area 2
    x=yuce2(x02,Sy2,Sx2);
    ll2=[ll2;Sx2,Sy2];
    x2=[x2;x];
       %area 3
    x=yuce3(x03,Sy3,Sx3);
    ll3=[ll3;Sx3,Sy3];
    x3=[x3;x];
    xx=x1((T+1)*(k+1),2)+x2((T+1)*(k+1),2)+x3((T+1)*(k+1),2);
    if kkk>N0
        judge1=false;
    else
        if (xx<Ir) & (judge2 || kkk==0)
            kkk=kkk+1;
            judge2=true; % whether it is < Ir in the last stage
        else
            kkk=0;
            judge2=false
        end
    end
    %renew the stage
    k=k+1;
end
% output the result
length=size(x1);
figure
plot(x1(:,2),'k');
hold on
plot(1:length,x2(:,2),'k--');
hold on
plot(1:length,x3(:,2),'kp',1:length,x3(:,2),'k');
legend('area1','area2','area3')
title(' The Number of Infected People ')
figure
plot(x1(:,3),'k');
hold on
plot(1:length,x2(:,3),'k--');
hold on
plot(1:length,x3(:,3),'kp',1:length,x3(:,3),'k');
legend('area1','area2','area3')
title('The Number of Quarantined People');
figure
plot(x1(:,4),'k');
hold on
plot(1:length,x2(:,4),'k--');
hold on
plot(1:length,x3(:,4),'kp',1:length,x3(:,4),'k');
legend('area1','area2','area3')
title('The Number of People Removed from the System')
figure
plot(x1(:,1),'k');
hold on
plot(1:length,x2(:,1),'k--');
hold on
plot(1:length,x3(:,1),'kp',1:length,x3(:,1),'k');
legend('area1','area2','area3')
title('The Number of Susceptible People ')
Index=SC1<10^-4;
SC1(Index)=0;
Index=SC2<10^-4;
SC2(Index)=0;
SC1=vpa(SC1,5)
SC2=vpa(SC1,5)
