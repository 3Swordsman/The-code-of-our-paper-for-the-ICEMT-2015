function y=ill3(t,x)
    global l3
    %l1 denotes the usage rate of the area 3,whose medical care is best
    w=0.005;   %the rate of birth and death
    namita=1*10^-4;   %infection rate
    pq=0.9;      % isolation rate
    r1=0.01;      %recovery rate of the previous drug
    r2=0.9;       %recovery rate of the new drug
    apha1=0.6;   %the death rate of the infected
    apha2=0.4;       %the death rate of the  quarantined
    theta=0.8;            %the recovery rate of the  quarantined
    N=1*10^6;            %the total number of the people
    y(1)=w*N-(namita*x(2)+w)*x(1);
    y(2)=namita*x(1)*x(2)-(pq+w+apha1)*x(2)-r1*(x(2)-l3)-r2*l3;
    y(3)=pq*x(2)-(w+apha2+theta)*x(3);
    y(4)=theta*x(3)-w*x(4)+r1*(x(2)-l3)+r2*l3;
    y=[y(1);y(2);y(3);y(4)];
end
