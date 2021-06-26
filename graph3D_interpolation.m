function [dX_interp,dY_interp,dZ_interp] = graph3D_interpolation(alldistances,mesvector,dX_mes,dY_mes,dZ_mes)

p=3;

measured_distances=alldistances(:,mesvector);

% WEIGHTS=zeros(size(measured_distances)); 

% for i=1:length(WEIGHTS)
%     WEIGHTS(i,:)=(measured_distances(i,:).^p)/sum(measured_distances(i,:).^p);
% end

WEIGHTS=(measured_distances.^-1).^p;

dX_interp=WEIGHTS*dX_mes;
dY_interp=WEIGHTS*dY_mes;
dZ_interp=WEIGHTS*dZ_mes;

for i=1:length(dX_interp)
    dX_interp(i)=dX_interp(i)/sum(WEIGHTS(i,:));
end

for i=1:length(dY_interp)
    dY_interp(i)=dY_interp(i)/sum(WEIGHTS(i,:));
end

for i=1:length(dZ_interp)
    dZ_interp(i)=dZ_interp(i)/sum(WEIGHTS(i,:));
end

dX_interp(mesvector)=dX_mes;
dY_interp(mesvector)=dY_mes;
dZ_interp(mesvector)=dZ_mes;

dX_interp(isnan(dX_interp))=0;
dY_interp(isnan(dY_interp))=0;
dZ_interp(isnan(dZ_interp))=0;

end

