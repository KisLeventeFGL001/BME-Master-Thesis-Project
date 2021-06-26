function [trigraph,alldistances] = create_graph3D(DT_geometry)

T=sort(DT_geometry.ConnectivityList,2);

size_T=size(T);
EndNodes=zeros(size_T(1)*3,2);

X=DT_geometry.Points(:,1);
Y=DT_geometry.Points(:,2);
Z=DT_geometry.Points(:,3);

for i=1:size_T(1)
    EndNodes(3*i-2,:)=[T(i,1) T(i,2)];
    EndNodes(3*i-1,:)=[T(i,2) T(i,3)];
    EndNodes(3*i,:)=[T(i,1) T(i,3)];
end

EndNodes=unique(EndNodes,'rows');

% weights

size_EndNodes=size(EndNodes);

distances_0=zeros(size_EndNodes(1),1);

for i=1:size_EndNodes(1)
    node_1=EndNodes(i,1);
    node_2=EndNodes(i,2);
    node_1_x=X(node_1);
    node_1_y=Y(node_1);
    node_1_z=Z(node_1);
    node_2_x=X(node_2);
    node_2_y=Y(node_2);
    node_2_z=Z(node_2);
    current_distance=norm([node_1_x-node_2_x node_1_y-node_2_y node_1_z-node_2_z]);
    distances_0(i)=current_distance;
end

% creating a graph

EdgeTable=table(EndNodes,distances_0,'VariableNames',{'EndNodes' 'Weight'});

trigraph=graph(EdgeTable);

alldistances=distances(trigraph);

end

