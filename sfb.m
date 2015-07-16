function [x,fval,exitflag]=sfb(C,D1,D2,S1,S2,S3)
   %C denotes the unit transportation price matrix
   %D1,D2 is the production of the factory 1 or 2
   %S1,S2,S3 is the amount provided for the area 1,2,3
   f=[C(1,1);C(1,2);C(1,3);C(2,1);C(2,2);C(2,3)];
   Aeq=[1 1 1 0 0 0;0 0 0 1 1 1;1 0 0 1 0 0;0 1 0 0 1 0;0 0 1 0 0 1];
   beq=[D1;D2;S1;S2;S3];
   lb=zeros(6,1);
   [x,fval,exitflag]=linprog(f,[],[],Aeq,beq,lb);
end
