c=3e8;
fc=4e9; % carrier
B=25e6; % Bandwidth
T=5e-3; % Chirp time
Beta=B/T; % slope
ant_angle=30; %antenna aperture angle
v=10; % platform's velocity

radar=radar_object(B,T,fc,v,ant_angle);
