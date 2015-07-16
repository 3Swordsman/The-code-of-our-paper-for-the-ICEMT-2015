function [x]=yuce2(x02,Sy2,Sx2)
 %renew the value of the beginning of the next stage in area 2 after
     %vaccination
    global w2 u l2 T dd
    w2=Sy2;
    S0_=x02(1);
    S0=S0_-u*w2;
    I0=x02(2);
    Q0=x02(3);
    R0_=x02(4);
    R0=R0_+u*w2;
    x02(1)=S0;
    x02(2)=I0;
    x02(3)=Q0;
    x02(4)=R0;
        %renew l2
    l2=Sx2/T;
    ts=0:dd:T
    [t,x]=ode45('ill1',ts,x02); 
end
