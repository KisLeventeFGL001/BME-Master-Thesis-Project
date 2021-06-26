function  [DT_modeshape,DT_mes] = b3D(DT_geometry,DT_mes_0,dX_mes,dY_mes,dZ_mes,zoom)

[LAMBDA,tri_LAMBDA]=baryc_weights3D(DT_geometry,DT_mes_0);

X_mes_0=DT_mes_0.Points(:,1);
Y_mes_0=DT_mes_0.Points(:,2);
Z_mes_0=DT_mes_0.Points(:,3);

[X_mes,Y_mes,Z_mes]=displ3D(X_mes_0,Y_mes_0,Z_mes_0,dX_mes,dY_mes,dZ_mes,zoom);
T_mes=DT_mes_0.ConnectivityList;
DT_mes=triangulation(T_mes,X_mes,Y_mes,Z_mes);

[X_interp,Y_interp,Z_interp] = baryc3D_interpolation(LAMBDA,tri_LAMBDA,DT_mes);
T=DT_geometry.ConnectivityList;
DT_modeshape=triangulation(T,X_interp,Y_interp,Z_interp);

end

