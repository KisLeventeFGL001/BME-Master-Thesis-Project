function Fig = baryc(STLNAME,ZOOM,MODE,REFINE)

DT_geometry=refinement(STLNAME,REFINE); % az stl fájl beolvasása, és finomítása
MODEstr=num2str(MODE); % segéd string a módusnak megfelelő textfile kiválasztásához
% a mérési pontok megfeleltetése:
[DT_geometry,DT_mes_0,dX_mes,dY_mes,dZ_mes,mesvector]=addmeaspoints("mes_0.txt","x_mes_"+MODEstr+".txt","y_mes_"+MODEstr+".txt","z_mes_"+MODEstr+".txt",DT_geometry); %#ok<ASGLU>
DT_modeshape_orig=stlread("modeshape_"+MODEstr+".stl"); % a valós lengéskép beolvasása (összehasonlításnak)
DT_modeshape_interp=b3D(DT_geometry,DT_mes_0,dX_mes,dY_mes,dZ_mes,ZOOM); %interpoláció, a mért lengéskép meghatározása

Fig=figure(1);
subplot(1,2,1)
trisurf(DT_modeshape_interp,'FaceColor','c')
axis equal
subplot(1,2,2)
trisurf(DT_modeshape_orig)
axis equal

end