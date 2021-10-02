function [LAMBDA,tri_LAMBDA] = baryc_weights3D(DT_geometry,DT_mes_0)

X_0=DT_geometry.Points(:,1);
Y_0=DT_geometry.Points(:,2);
Z_0=DT_geometry.Points(:,3);
X_mes_0=DT_mes_0.Points(:,1);
Y_mes_0=DT_mes_0.Points(:,2);
Z_mes_0=DT_mes_0.Points(:,3);

T_mes=sort(DT_mes_0.ConnectivityList,2);

size_DT_mes_0=size(DT_mes_0);

LAMBDA=zeros(length(X_0),4);
tri_LAMBDA=zeros(length(X_0),1);
possible_lambda=zeros(size_DT_mes_0(1),4);
abs_sum=zeros(size_DT_mes_0(1),1);


%% különválasztott inverz megoldás
Rinvers=zeros(4,4,size_DT_mes_0(1));%ezt érdemes lenne későbbre is eltárolni
for dt_step=1:size_DT_mes_0(1)
    x1=X_mes_0(T_mes(dt_step,1));
    x2=X_mes_0(T_mes(dt_step,2));
    x3=X_mes_0(T_mes(dt_step,3));
    x4=X_mes_0(T_mes(dt_step,4));
    y1=Y_mes_0(T_mes(dt_step,1));
    y2=Y_mes_0(T_mes(dt_step,2));
    y3=Y_mes_0(T_mes(dt_step,3));
    y4=Y_mes_0(T_mes(dt_step,4));
    z1=Z_mes_0(T_mes(dt_step,1));
    z2=Z_mes_0(T_mes(dt_step,2));
    z3=Z_mes_0(T_mes(dt_step,3));
    z4=Z_mes_0(T_mes(dt_step,4));
    R=[x1 x2 x3 x4;
        y1 y2 y3 y4;
        z1 z2 z3 z4;
        1 1 1 1];
    Rinvers(:,:,dt_step)=inv(R);
end

%% vektorizált keresés
% ri_xyz1=[X_0';Y_0';Z_0';ones(size(X_0'))];
% 
% All_lambda=sum(permute(Rinvers(:,:,:),[2,1,3]).*permute(ri_xyz1,[1,3,4,2]),1);
% 
% smallestdistance=squeeze(sum(abs(All_lambda),2));
% [~,I] = min(smallestdistance,[],1);
% for num_step=1:length(X_0)
%   LAMBDA(num_step,:)=All_lambda(1,:,I(num_step),num_step);
% end
% tri_LAMBDA=I';

%%--------------

triangles=zeros(4,3,size(T_mes,1));

for i=1:size(T_mes,1)
    for j=1:4
        T=T_mes(i,:);
        T(j)=[];
        triangles(j,:,i)=T;
    end
end

for num_step=1:length(X_0)
    x=X_0(num_step);
    y=Y_0(num_step);
    z=Z_0(num_step);
    r=[x;y;z;1];
    for dt_step=1:size_DT_mes_0(1)
        possible_lambda(dt_step,:)=Rinvers(:,:,dt_step)*r;
        abs_sum(dt_step)=sum(abs(possible_lambda(dt_step,:)));
    end
    [~,tri_LAMBDA(num_step)]=min(abs_sum);
    if all(possible_lambda(tri_LAMBDA(num_step),:)>=0)
        LAMBDA(num_step,:)=possible_lambda(tri_LAMBDA(num_step),:);
    else
        P=r(1:3);
        bestdistances=zeros(4,size(triangles,3));
        for i=1:size(triangles,3)
            for j=1:4
                A=[X_mes_0(triangles(j,1,i));Y_mes_0(triangles(j,1,i));Z_mes_0(triangles(j,1,i))];
                B=[X_mes_0(triangles(j,2,i));Y_mes_0(triangles(j,2,i));Z_mes_0(triangles(j,2,i))];
                C=[X_mes_0(triangles(j,3,i));Y_mes_0(triangles(j,3,i));Z_mes_0(triangles(j,3,i))];
                bestdistances(j,i)=bestdistance(P,A,B,C);
            end
        end
        smallestbestdistance = min(min(bestdistances));
        [~,small_col]=find(bestdistances==smallestbestdistance);
        LAMBDA(num_step,:)=possible_lambda(small_col(1),:);
        tri_LAMBDA(num_step)=small_col(1);
    end
end

end
