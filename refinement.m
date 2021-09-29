function DT_geometry = refinement(geometry,desired_EL) % longest_EL must be higher than desired_EL to start the iteration

geom_read=stlread(geometry);

X=geom_read.Points(:,1);
Y=geom_read.Points(:,2);
Z=geom_read.Points(:,3);
T=sort(geom_read.ConnectivityList,2);
longest_EL=desired_EL*2;%Inf
while longest_EL>desired_EL
    size_T=size(T);
    triangles=[(1:size_T(1))';(1:size_T(1))';(1:size_T(1))'];
    Edge_all=sort([T(:,2) T(:,3); T(:,1) T(:,3); T(:,1) T(:,2)],2);
    Edge_Lengths=(diff(X(Edge_all),1,2).^2+diff(Y(Edge_all),1,2).^2+diff(Z(Edge_all),1,2).^2).^0.5;
    longest_EL=max(Edge_Lengths);
    if longest_EL<desired_EL
        break;
    end
   
    [row,~]=find(Edge_Lengths==longest_EL);
    triangle_1_index=triangles(row(1));
    E_1_vertice=Edge_all(row(1),:);
    E_1_index=row(1);
    
    Triangle_1=T(triangle_1_index,:);
    if all(Triangle_1(2:3)==E_1_vertice)
        E_1_index=1;
    end
    if all(Triangle_1(1:2:3)==E_1_vertice)
        E_1_index=2;
    end
    if all(Triangle_1(1:2)==E_1_vertice)
        E_1_index=3;
    end

    triangle_2_indexes=triangles(ismember(Edge_all,E_1_vertice,'rows'));
    triangle_2_index=triangle_2_indexes(triangle_2_indexes~=triangle_1_index);
   
    Triangle_2=T(triangle_2_index,:);
    if all(Triangle_2(2:3)==E_1_vertice)
        E_2_index=1;
    end
    if all(Triangle_2(1:2:3)==E_1_vertice)
        E_2_index=2;
    end
    if all(Triangle_2(1:2)==E_1_vertice)
        E_2_index=3;
    end
   
    X_1=X(E_1_vertice(1));
    Y_1=Y(E_1_vertice(1));
    Z_1=Z(E_1_vertice(1));
   
    X_2=X(E_1_vertice(2));
    Y_2=Y(E_1_vertice(2));
    Z_2=Z(E_1_vertice(2));
   
    new_X=0.5*(X_1+X_2);
    new_Y=0.5*(Y_1+Y_2);
    new_Z=0.5*(Z_1+Z_2);
   
    X(end+1)=new_X;
    Y(end+1)=new_Y;
    Z(end+1)=new_Z;
    Triangle_1_excluded=Triangle_1(Triangle_1~=Triangle_1(E_1_index));
    Triangle_2_excluded=Triangle_2(Triangle_2~=Triangle_2(E_2_index));
    Triangle_1_new_1=sort([Triangle_1(E_1_index) Triangle_1_excluded(1) length(X)]);
    T(end+1,:)=Triangle_1_new_1;
    Triangle_1_new_2=sort([Triangle_1(E_1_index) Triangle_1_excluded(2) length(X)]);
    T(end+1,:)=Triangle_1_new_2;
    Triangle_2_new_1=sort([Triangle_2(E_2_index) Triangle_2_excluded(1) length(X)]);
    T(end+1,:)=Triangle_2_new_1;
    Triangle_2_new_2=sort([Triangle_2(E_2_index) Triangle_2_excluded(2) length(X)]);
    T(end+1,:)=Triangle_2_new_2;
   
    T(triangle_1_index,:)=0;
    T(triangle_2_index,:)=0;
    T( ~any(T,2), : ) = [];
end

DT_geometry=triangulation(T,X,Y,Z);

end

