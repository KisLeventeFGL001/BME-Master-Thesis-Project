function P_new = localcoord3D(P,S,i,j,k)

IJK=[i j k];
P_1=IJK\P;
S_1=IJK\S;
P_nb=[eye(3) S_1;
    zeros(1,3) 1]*[P_1;-1];

P_new=P_nb(1:3);

end