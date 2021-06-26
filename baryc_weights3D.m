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

for num_step=1:length(X_0)
    x=X_0(num_step);
    y=Y_0(num_step);
    z=Z_0(num_step);
    r=[x;y;z;1];
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
        possible_lambda(dt_step,:)=R\r;
        abs_sum(dt_step)=sum(abs(possible_lambda(dt_step,:)));
    end
    [~,tri_LAMBDA(num_step)]=min(abs_sum);
    LAMBDA(num_step,:)=possible_lambda(tri_LAMBDA(num_step),:);
end

end
