function [DX,DY,x0]=DXDY(x)
    %the demand of the new drug and vaccine in the end of this stage
    global T k t0 p
    S0=x((k+1)*(T+1),1);     
    I0=x((k+1)*(T+1),2);    
    Q0=x((k+1)*(T+1),3);
    R0=x((k+1)*(T+1),4);  
    x0=[S0,I0,Q0,R0];
    DX=I0;          %DX denotes the demand of the new drug in this stage
    DY=p*S0;        %Dy denotes the demand of the new vaccine in this stage
end
