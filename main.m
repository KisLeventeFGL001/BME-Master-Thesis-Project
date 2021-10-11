clear all;
clc;
close all;
%%

INTERPMODE = "BARYC"; % Interpolálási mód kiválasztása. "BARYC" vagy "GRAF"
STLNAME = "T_junction.stl"; % STL file neve
ZOOM = 2.6e-002; % Mekkora nagyításban lássuk az elmozdulást?
MODE = 3; % Hanyadik sajátfrekvenciához tartozó lengésképet jelenítsük meg?
REFINE = 0.01; % Mennyire sűrítsük az eredeti STL hálót? (első elem: maximálisan megengedett élhossz [m] az stl mérétkegységében;


if INTERPMODE == "BARYC"
    Fig = baryc(STLNAME,ZOOM,MODE,REFINE); % baricentrikus súlyok alapján interpolál
else
    if INTERPMODE == "GRAF"
        Fig = graf(STLNAME,ZOOM,MODE,REFINE); % gráfpontok közötti távolság alapján interpolál
    else
        "Input error: az  INTERPMODE változó értéke csak BARYC vagy GRAF lehet!" %#ok<NOPTS>
    end
end

Fig %#ok<NOPTS>