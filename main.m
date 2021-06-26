clear all;
clc;
close all;

INTERPMODE = "BARYC"; % Interpolálási mód kiválasztása. "BARYC" vagy "GRAF"
STLNAME = "hangvilla.stl"; % STL file neve
ZOOM = 4.3e-003; % Mekkora nagyításban lássuk az elmozdulást?
MODE = 1; % Hanyadik sajátfrekvenciához tartozó lengésképet jelenítsük meg?
REFINE = [0.01 1];  % Mennyire sűrítsük az eredeti STL hálót? (első elem: maximálisan megengedett élhossz;
%                                                              második elem: az első elemnél nagyobb, tetszőlegesen választott szám)

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