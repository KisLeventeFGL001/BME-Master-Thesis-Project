function Fig = graf(STLNAME,ZOOM,MODE,REFINE)

DT_geometry=refinement(STLNAME,REFINE(1),REFINE(2));
MODEstr=num2str(MODE);
[DT_geometry,DT_mes_0,dX_mes,dY_mes,dZ_mes,mesvector]=addmeaspoints("mes_0.txt","x_mes_"+MODEstr+".txt","y_mes_"+MODEstr+".txt","z_mes_"+MODEstr+".txt",DT_geometry); %#ok<ASGLU>
DT_modeshape_orig=stlread("modeshape_"+MODEstr+".stl");
DT_modeshape_interp=g3D(DT_geometry,dX_mes,dY_mes,dZ_mes,mesvector,ZOOM);

Fig=figure(1);
subplot(1,2,1)
trisurf(DT_modeshape_interp,'FaceColor','c')
axis equal
subplot(1,2,2)
trisurf(DT_modeshape_orig)
axis equal

end