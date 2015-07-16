function [x]=yuce3(x03,Sy3,Sx3)
  %renew the value of the beginning of the next stage in area 3 after
     %vaccination
    global w3 u l3 T dd
    w3=Sy3;
    S0_=x03(1);
    S0=S0_-u*w3;
    I0=x03(2);
    Q0=x03(3);
    R0_=x03(4);
    R0=R0_+u*w3;
    x03(1)=S0;
    x03(2)=I0;
    x03(3)=Q0;
    x03(4)=R0;
        %renew l3
    l3=Sx3/T;
    ts=0:dd:T
    [t,x]=ode45('ill1',ts,x03); 
end
