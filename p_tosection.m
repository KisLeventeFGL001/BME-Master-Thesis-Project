function P_onsection = p_tosection(P,A,B)

v=(B-A)/norm(B-A);
PA=A-P;
P_onsection=P+PA-dot(PA,v)*v;

end