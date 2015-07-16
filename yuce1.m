function [x]=yuce1(x01,Sy1,Sx1)
    %renew the value of the beginning of the next stage in area 1 after
     %vaccination
    global w1 u l1 T dd
    w1=Sy1;
    S0_=x01(1);
    S0=S0_-u*w1;
    I0=x01(2);
    Q0=x01(3);
    R0_=x01(4);
    R0=R0_+u*w1;
    x01(1)=S0;
    x01(2)=I0;
    x01(3)=Q0;
    x01(4)=R0;
        %renew l1
    l1=Sx1/T;
    ts=0:dd:T
    [t,x]=ode45('ill1',ts,x01); 
end
