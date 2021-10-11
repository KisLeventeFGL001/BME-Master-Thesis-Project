function [X_interp,Y_interp,Z_interp] = baryc3D_interpolation(LAMBDA,tri_LAMBDA,DT_mes,lambda_to_average,tri_to_average)

X_interp=zeros(length(tri_LAMBDA),1);
Y_interp=zeros(length(tri_LAMBDA),1);
Z_interp=zeros(length(tri_LAMBDA),1);

X_mes=DT_mes.Points(:,1);
Y_mes=DT_mes.Points(:,2);
Z_mes=DT_mes.Points(:,3);

T_mes=sort(DT_mes.ConnectivityList,2);

counter=1;

for num_step=1:length(tri_LAMBDA)
    if tri_LAMBDA(num_step)==0
        lambdas=lambda_to_average{counter};
        tris=tri_to_average{counter};
        X_temp=zeros(size(tris,1),1);
        Y_temp=zeros(size(tris,1),1);
        Z_temp=zeros(size(tris,1),1);
        for i=1:size(tris,1)
            triangle_id=tris(i);
            vertices=T_mes(triangle_id,:);
            x1=X_mes(vertices(1));
            x2=X_mes(vertices(2));
            x3=X_mes(vertices(3));
            x4=X_mes(vertices(4));
            y1=Y_mes(vertices(1));
            y2=Y_mes(vertices(2));
            y3=Y_mes(vertices(3));
            y4=Y_mes(vertices(4));
            z1=Z_mes(vertices(1));
            z2=Z_mes(vertices(2));
            z3=Z_mes(vertices(3));
            z4=Z_mes(vertices(4));
            R=[x1 x2 x3 x4;
               y1 y2 y3 y4;
               z1 z2 z3 z4;
               1 1 1 1];
            r=R*lambdas(i,:)';
            X_temp(i)=r(1);
            Y_temp(i)=r(2);
            Z_temp(i)=r(3);
        end
        X_interp(num_step)=mean(X_temp);
        Y_interp(num_step)=mean(Y_temp);
        Z_interp(num_step)=mean(Z_temp);
        counter=counter+1;
        
    else
        triangle_id=tri_LAMBDA(num_step);
        vertices=T_mes(triangle_id,:);
        x1=X_mes(vertices(1));
        x2=X_mes(vertices(2));
        x3=X_mes(vertices(3));
        x4=X_mes(vertices(4));
        y1=Y_mes(vertices(1));
        y2=Y_mes(vertices(2));
        y3=Y_mes(vertices(3));
        y4=Y_mes(vertices(4));
        z1=Z_mes(vertices(1));
        z2=Z_mes(vertices(2));
        z3=Z_mes(vertices(3));
        z4=Z_mes(vertices(4));
        R=[x1 x2 x3 x4;
           y1 y2 y3 y4;
           z1 z2 z3 z4;
           1 1 1 1];
        r=R*(LAMBDA(num_step,:))';
        X_interp(num_step)=r(1);
        Y_interp(num_step)=r(2);
        Z_interp(num_step)=r(3);
    end  
end

end