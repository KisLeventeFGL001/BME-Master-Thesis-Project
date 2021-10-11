function d = dist_ps(P,A,B)

v=(B-A)/norm(B-A);
PB=B-P;
PBdotv=dot(PB,v);
d=sqrt(norm(PB)^2-PBdotv^2);

end