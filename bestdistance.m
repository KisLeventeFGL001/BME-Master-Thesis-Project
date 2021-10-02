function D = bestdistance(P,A,B,C)

triangle=[A'; B'; C'];
[N,S,I,J,K]=lcoordsys3D(A,B,C);
A_local=localcoord3D(A,S,I,J,K);
B_local=localcoord3D(B,S,I,J,K);
C_local=localcoord3D(C,S,I,J,K);
R=[A_local(1) B_local(1) C_local(1);
    A_local(2) B_local(2) C_local(2);
    1 1 1];

ds_plane=dist_ppl_ABC(P,A,B,C);
P_prjt=P-ds_plane*N;
P_prjt_local=localcoord3D(P_prjt,S,I,J,K);
r=[P_prjt_local(1);P_prjt_local(2);1];
lambda=R\r;
signs=sign(lambda);
nonneg=sum(signs>=0);

if nonneg==3
    D=abs(ds_plane);
else
    if nonneg==2
        section=triangle(signs>=0,:);
        [~,P_onsection]=point_to_line_distance(P_prjt',(section(1,:)-section(2,:))/norm(section(1,:)-section(2,:)),section(1,:));
        onsec=onsection(P_onsection,section(1,:)',section(2,:)');
        if onsec~=0
            if onsec==-1
                D=dist_pp(P,section(1,:)');
            else
                D=dist_pp(P,section(2,:)');
            end
        else
            D=dist_ps(P,section(1,:)',section(2,:)');
        end
    else
        if nonneg==1
            point=triangle(signs>=0,:);
            D=dist_pp(P,point');
        end
    end
end

end