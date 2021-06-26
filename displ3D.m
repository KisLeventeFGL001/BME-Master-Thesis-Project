function [X,Y,Z] = displ3D(X_0,Y_0,Z_0,dX,dY,dZ,zoom)

X=X_0+zoom*dX;
Y=Y_0+zoom*dY;
Z=Z_0+zoom*dZ;

end