function d = dist_ppl_ABC(P,A,B,C) % signed distance

[N,S,~,~,~]=lcoordsys3D(A,B,C);
v=P-S;
d=dot(v,N);

end
