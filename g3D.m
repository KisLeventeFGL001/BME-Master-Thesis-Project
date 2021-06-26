function DT_modeshape = g3D(DT_geometry,dX_mes,dY_mes,dZ_mes,mesvector,zoom)

[~,alldistances] = create_graph3D(DT_geometry);
[dX_interp,dY_interp,dZ_interp] = graph3D_interpolation(alldistances,mesvector,dX_mes,dY_mes,dZ_mes);

X_0=DT_geometry.Points(:,1);
Y_0=DT_geometry.Points(:,2);
Z_0=DT_geometry.Points(:,3);
T=DT_geometry.ConnectivityList;

[X_interp,Y_interp,Z_interp] = displ3D(X_0,Y_0,Z_0,dX_interp,dY_interp,dZ_interp,zoom);

DT_modeshape=triangulation(T,X_interp,Y_interp,Z_interp);

end