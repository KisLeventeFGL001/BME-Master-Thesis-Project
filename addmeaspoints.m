function [DT_geometry,DT_mes_0,dX_mes,dY_mes,dZ_mes,mesvector] = addmeaspoints(m,x,y,z,DT_geometry)

Mes_0 = readmatrix(m); % coordinates and node numbers of measurment points
dX = readmatrix(x); % original coordinates and x-displacements of all points
dY = readmatrix(y); % original coordinates and y-displacements of all points
dZ = readmatrix(z); % original coordinates and z-displacements of all points

X_mes_0=Mes_0(:,2); % original X-coords of measurement points
Y_mes_0=Mes_0(:,3); % original Y-coords of measurement points
Z_mes_0=Mes_0(:,4); % original Z-coords of measurement points

X_0=DT_geometry.Points(:,1); % X-coords of the imported stl model
Y_0=DT_geometry.Points(:,2); % Y-coords of the imported stl model
Z_0=DT_geometry.Points(:,3); % Z-coords of the imported stl model

T=sort(DT_geometry.ConnectivityList,2); % rendezi a triangulation kapcsolatlistát

mesvector=zeros(size(X_mes_0)); % vektor a mérési pontok sorszámának

for i_run=1:length(X_mes_0)
    P=[X_mes_0(i_run);Y_mes_0(i_run);Z_mes_0(i_run)];
    S=zeros(3,size(T,1));
    S1=zeros(3,size(T,1));
    S2=zeros(3,size(T,1));
    S3=zeros(3,size(T,1));
    i=zeros(3,size(T,1));
    j=zeros(3,size(T,1));
    k=zeros(3,size(T,1));
    n=zeros(3,size(T,1));
    vn=zeros(1,size(T,1));
    d=zeros(7,size(T,1));
    P_prjt=zeros(3,size(T,1));
    P_prjt_local=zeros(3,size(T,1));
    S1_local=zeros(3,size(T,1));
    S2_local=zeros(3,size(T,1));
    S3_local=zeros(3,size(T,1));
    lambda=zeros(3,size(T,1));
    for j_run=1:size(T,1)
        S1i=T(j_run,1);
        S2i=T(j_run,2);
        S3i=T(j_run,3);
        S1(:,j_run)=[X_0(S1i);Y_0(S1i);Z_0(S1i)];
        S2(:,j_run)=[X_0(S2i);Y_0(S2i);Z_0(S2i)];
        S3(:,j_run)=[X_0(S3i);Y_0(S3i);Z_0(S3i)];
        [n(:,j_run),S(:,j_run),i(:,j_run),j(:,j_run),k(:,j_run)]=lcoordsys3D(S1(:,j_run),S2(:,j_run),S3(:,j_run));
        v=P-S(:,j_run);
        vn(j_run)=dot(v,n(:,j_run));
        d(:,j_run)=[norm(P-S1(:,j_run));
            norm(P-S2(:,j_run));
            norm(P-S3(:,j_run));
            dist_P_section(P,S1(:,j_run),S2(:,j_run));
            dist_P_section(P,S1(:,j_run),S3(:,j_run));
            dist_P_section(P,S2(:,j_run),S3(:,j_run));
            vn(j_run)];
        P_prjt(:,j_run)=P-vn(j_run)*n(:,j_run);
        P_prjt_local(:,j_run)=localcoord3D(P_prjt(:,j_run),S(:,j_run),i(:,j_run),j(:,j_run),k(:,j_run));
        S1_local(:,j_run)=localcoord3D(S1(:,j_run),S(:,j_run),i(:,j_run),j(:,j_run),k(:,j_run));
        S2_local(:,j_run)=localcoord3D(S2(:,j_run),S(:,j_run),i(:,j_run),j(:,j_run),k(:,j_run));
        S3_local(:,j_run)=localcoord3D(S3(:,j_run),S(:,j_run),i(:,j_run),j(:,j_run),k(:,j_run));
        R=[S1_local(1,j_run) S2_local(1,j_run) S3_local(1,j_run);
            S1_local(2,j_run) S2_local(2,j_run) S3_local(2,j_run);
            1 1 1];
        r=[P_prjt_local(1,j_run);P_prjt_local(2,j_run);1];
        lambda(:,j_run)=R\r;
    end
    lambda_abs_sum=sum(abs(lambda));
    minlambda_index=find(lambda_abs_sum==min(lambda_abs_sum));
    min_vn_index=find(d(7,:)==min(d(7,:)));
    
    if length(minlambda_index)>1
       'anyád'; % :-D 
    end
    
    member=ismember(minlambda_index,min_vn_index);
    minlambda_index_single=minlambda_index(member);
    
    if (isempty(minlambda_index_single)~=false)
        if all(lambda(:,minlambda_index_single)>=0)
            T_selected=minlambda_index;
            Triangle_not_needed=T(T_selected,:);
            X_0(end+1)=P_prjt(1,T_selected);
            Y_0(end+1)=P_prjt(2,T_selected);
            Z_0(end+1)=P_prjt(3,T_selected);
            newpoint_id=length(X_0);
            T(end+1,:)=[Triangle_not_needed(1) Triangle_not_needed(2) newpoint_id];
            T(end+1,:)=[Triangle_not_needed(1) Triangle_not_needed(3) newpoint_id];
            T(end+1,:)=[Triangle_not_needed(2) Triangle_not_needed(3) newpoint_id];
            T(T_selected,:)=[];
            mesvector(i_run)=newpoint_id;
        else
            d_sections=d(4:6,:);
            [row,col]=find(d_sections==min(d_sections(:)));
            lambda_section=zeros(3,length(row));
            check=false(1,length(3));
            for k_run=1:length(row)
                section_index=row(k_run);
                T_selected=col(k_run);
                if section_index==1
                    Ai=T(T_selected,1);
                    Bi=T(T_selected,2);
                end
                if section_index==2
                    Ai=T(T_selected,1);
                    Bi=T(T_selected,3);
                end
                if section_index==3
                    Ai=T(T_selected,2);
                    Bi=T(T_selected,3);
                end
                A=[X_0(Ai);Y_0(Ai);Z_0(Ai)];
                B=[X_0(Bi);Y_0(Bi);Z_0(Bi)];
                v=P-A;
                v_AB=(B-A)/norm(B-A);
                P_prjt_section=A+dot(v,v_AB)*v_AB;
                P_prjt_section_local=localcoord3D(P_prjt_section,S(:,T_selected),i(:,T_selected),j(:,T_selected),k(:,T_selected));
                R=[S1_local(1,T_selected) S2_local(1,T_selected) S3_local(1,T_selected);
                    S1_local(2,T_selected) S2_local(2,T_selected) S3_local(2,T_selected);
                    1 1 1];
                r=[P_prjt_section_local(1);P_prjt_section_local(2);1];
                lambda_section(:,k_run)=R\r;
                if all(lambda_section(:,k_run)>=0)
                    check(k_run)=true;
                end
            end
            if all(check==false)
                d_points=d(1:3,:);
                [row,col]=find(d_points==min(d_points(:)));
                point_index=row(1);
                T_selected=col(1);
                mesvector(i_run)=T(T_selected,point_index);
            else
                selected=find(check==true);
                T_selected=col(selected);
                section_index=row(selected);
                if section_index==1
                    Ai=T(T_selected,1);
                    Bi=T(T_selected,2);
                end
                if section_index==2
                    Ai=T(T_selected,1);
                    Bi=T(T_selected,3);
                end
                if section_index==3
                    Ai=T(T_selected,2);
                    Bi=T(T_selected,3);
                end
                A=[X_0(Ai);Y_0(Ai);Z_0(Ai)];
                B=[X_0(Bi);Y_0(Bi);Z_0(Bi)];
                v=P-A;
                v_AB=(B-A)/norm(B-A);
                P_prjt_section=A+dot(v,v_AB)*v_AB;
                X_0(end+1)=P_prjt_section(1);
                Y_0(end+1)=P_prjt_section(2);
                Z_0(end+1)=P_prjt_section(3);
                newpoint_id=length(X_0);
                Edge_all=sort([T(:,1) T(:,2); T(:,1) T(:,3); T(:,2) T(:,3)],2);
                Triangles=[(1:size(T,1))';(1:size(T,1))';(1:size(T,1))'];
                Edges=find(ismember(Edge_all,[Ai Bi],'rows'));
                Triangles_not_needed=T(Triangles(Edges),:);
                E1_1=find(Triangles_not_needed(1,:)==Ai);
                E1_2=find(Triangles_not_needed(1,:)==Bi);
                if all([E1_1 E1_2]==[1 2])
                    EV11=[1 3];
                    EV12=[2 3];
                end
                if all([E1_1 E1_2]==[1 3])
                    EV11=[1 2];
                    EV12=[2 3];
                end
                if all([E1_1 E1_2]==[2 3])
                    EV11=[1 2];
                    EV12=[1 3];
                end
                E2_1=find(Triangles_not_needed(2,:)==Ai);
                E2_2=find(Triangles_not_needed(2,:)==Bi);
                if all([E2_1 E2_2]==[1 2])
                    EV21=[1 3];
                    EV22=[2 3];
                end
                if all([E2_1 E2_2]==[1 3])
                    EV21=[1 2];
                    EV22=[2 3];
                end
                if all([E2_1 E2_2]==[2 3])
                    EV21=[1 2];
                    EV22=[1 3];
                end
                T(end+1,:)=[Triangles_not_needed(1,EV11) newpoint_id];
                T(end+1,:)=[Triangles_not_needed(1,EV12) newpoint_id];
                T(end+1,:)=[Triangles_not_needed(1,EV21) newpoint_id];
                T(end+1,:)=[Triangles_not_needed(1,EV22) newpoint_id];
                T(Triangles(Edges),:)=[];
                mesvector(i_run)=newpoint_id;
            end
        end
    else
        d_sections=d(4:6,:);
        [row,col]=find(d_sections==min(d_sections(:)));
        lambda_section=zeros(3,length(row));
        check=false(1,length(3));
        for k_run=1:length(row)
            section_index=row(k_run);
            T_selected=col(k_run);
            if section_index==1
                Ai=T(T_selected,1);
                Bi=T(T_selected,2);
            end
            if section_index==2
                Ai=T(T_selected,1);
                Bi=T(T_selected,3);
            end
            if section_index==3
                Ai=T(T_selected,2);
                Bi=T(T_selected,3);
            end
            A=[X_0(Ai);Y_0(Ai);Z_0(Ai)];
            B=[X_0(Bi);Y_0(Bi);Z_0(Bi)];
            v=P-A;
            v_AB=(B-A)/norm(B-A);
            P_prjt_section=A+dot(v,v_AB)*v_AB;
            P_prjt_section_local=localcoord3D(P_prjt_section,S(:,T_selected),i(:,T_selected),j(:,T_selected),k(:,T_selected));
            R=[S1_local(1,T_selected) S2_local(1,T_selected) S3_local(1,T_selected);
                S1_local(2,T_selected) S2_local(2,T_selected) S3_local(2,T_selected);
                1 1 1];
            r=[P_prjt_section_local(1);P_prjt_section_local(2);1];
            lambda_section(:,k_run)=R\r;
            if all(lambda_section(:,k_run)>=0)
                check(k_run)=true;
            end
        end
        if all(check==false)
            d_points=d(1:3,:);
            [row,col]=find(d_points==min(d_points(:)));
            point_index=row(1);
            T_selected=col(1);
            mesvector(i_run)=T(T_selected,point_index);
        else
            selected=find(check==true);
            T_selected=col(selected);
            section_index=row(selected);
            if section_index==1
                Ai=T(T_selected,1);
                Bi=T(T_selected,2);
            end
            if section_index==2
                Ai=T(T_selected,1);
                Bi=T(T_selected,3);
            end
            if section_index==3
                Ai=T(T_selected,2);
                Bi=T(T_selected,3);
            end
            A=[X_0(Ai);Y_0(Ai);Z_0(Ai)];
            B=[X_0(Bi);Y_0(Bi);Z_0(Bi)];
            v=P-A;
            v_AB=(B-A)/norm(B-A);
            P_prjt_section=A+dot(v,v_AB)*v_AB;
            X_0(end+1)=P_prjt_section(1);
            Y_0(end+1)=P_prjt_section(2);
            Z_0(end+1)=P_prjt_section(3);
            newpoint_id=length(X_0);
            Edge_all=sort([T(:,1) T(:,2); T(:,1) T(:,3); T(:,2) T(:,3)],2);
            Triangles=[(1:size(T,1))';(1:size(T,1))';(1:size(T,1))'];
            Edges=find(ismember(Edge_all,[Ai Bi],'rows'));
            Triangles_not_needed=T(Triangles(Edges),:);
            E1_1=find(Triangles_not_needed(1,:)==Ai);
            E1_2=find(Triangles_not_needed(1,:)==Bi);
            if all([E1_1 E1_2]==[1 2])
                EV11=[1 3];
                EV12=[2 3];
            end
            if all([E1_1 E1_2]==[1 3])
                EV11=[1 2];
                EV12=[2 3];
            end
            if all([E1_1 E1_2]==[2 3])
                EV11=[1 2];
                EV12=[1 3];
            end
            E2_1=find(Triangles_not_needed(2,:)==Ai);
            E2_2=find(Triangles_not_needed(2,:)==Bi);
            if all([E2_1 E2_2]==[1 2])
                EV21=[1 3];
                EV22=[2 3];
            end
            if all([E2_1 E2_2]==[1 3])
                EV21=[1 2];
                EV22=[2 3];
            end
            if all([E2_1 E2_2]==[2 3])
                EV21=[1 2];
                EV22=[1 3];
            end
            T(end+1,:)=[Triangles_not_needed(1,EV11) newpoint_id];
            T(end+1,:)=[Triangles_not_needed(1,EV12) newpoint_id];
            T(end+1,:)=[Triangles_not_needed(1,EV21) newpoint_id];
            T(end+1,:)=[Triangles_not_needed(1,EV22) newpoint_id];
            T(Triangles(Edges),:)=[];
            mesvector(i_run)=newpoint_id;
        end
    end
end

DT_geometry=triangulation(T,X_0,Y_0,Z_0);

DT_0=delaunay(X_mes_0,Y_mes_0,Z_mes_0);
DT_mes_0=triangulation(DT_0,X_mes_0,Y_mes_0,Z_mes_0);

dX_mes=dX(Mes_0(:,1),5);
dY_mes=dY(Mes_0(:,1),5);
dZ_mes=dZ(Mes_0(:,1),5);

end

