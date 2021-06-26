function [n,S,i,j,k] = lcoordsys3D(A,B,C)

AB=B-A;
AC=C-A;

n=cross(AB,AC);
n=n/norm(n);

S=1/3*(A+B+C);

k=n;
i=A-S;
i=i/norm(i);

R=[k(1)^2 k(1)*k(2)-k(3) k(1)*k(3)+k(2);
            k(1)*k(2)+k(3) k(2)^2 k(2)*k(3)-k(1);
            k(1)*k(3)-k(2) k(2)*k(3)+k(1) k(3)^2];
j=R*i;        

end