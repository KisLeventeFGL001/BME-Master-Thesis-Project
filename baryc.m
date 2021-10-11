function Fig = baryc(STLNAME,ZOOM,MODE,REFINE)

DT_geometry=refinement(STLNAME,REFINE); % az stl fájl beolvasása, és finomítása
MODEstr=num2str(MODE); % segéd string a módusnak megfelelő textfile kiválasztásához
% a mérési pontok megfeleltetése:
[DT_geometry,DT_mes_0,dX_mes,dY_mes,dZ_mes,mesvector]=addmeaspoints("mes_0.txt","x_mes_"+MODEstr+".txt","y_mes_"+MODEstr+".txt","z_mes_"+MODEstr+".txt",DT_geometry); %#ok<ASGLU>
DT_modeshape_orig=stlread("modeshape_"+MODEstr+".stl"); % a valós lengéskép beolvasása (összehasonlításnak)
DT_modeshape_interp=b3D(DT_geometry,DT_mes_0,dX_mes,dY_mes,dZ_mes,ZOOM); %interpoláció, a mért lengéskép meghatározása

DT_mes_X=DT_mes_0.Points(:,1)+ZOOM*dX_mes;
DT_mes_Y=DT_mes_0.Points(:,2)+ZOOM*dY_mes;
DT_mes_Z=DT_mes_0.Points(:,3)+ZOOM*dZ_mes;

% DT_mes_0=triangulation(DT_mes_0.ConnectivityList,DT_mes_X,DT_mes_Y,DT_mes_Z);

Fig=figure(1);
subplot(1,2,1)
trisurf(DT_modeshape_interp,'FaceColor','c')
axis equal
subplot(1,2,2)
plot3(DT_mes_X,DT_mes_Y,DT_mes_Z,'.','MarkerSize',20,'Color','r')
hold on
trisurf(DT_modeshape_orig)

axis equal

% Fig=figure(1);
% subplot(1,2,1)
% trisurf(DT_modeshape_interp,'FaceColor','c')
% axis equal
% hold on
% % tetramesh(DT_mes_0,"FaceColor","r")
% subplot(1,2,2)
% trisurf(DT_modeshape_orig)
% axis equal

end