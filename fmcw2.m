close all
clear


c=3e8;
fc=4e9; % carrier
B=25e6; % Bandwidth
T=5e-3; % Chirp time
Beta=B/T; % slope
ant_angle=30; %antenna aperture angle
v=10; % platform's velocity
max_range=30;


radar=radar_object(B,T,fc,v,ant_angle);
radar=radar.get_ant_vertices(max_range);
radar=radar.get_fs(max_range);

t1=point_target(10,10);
t2=point_target(15,15);
t3=point_target(10,20);
t4=point_target(10,15);
targets=[t1,t2,t3,t4];

figure




for k=1:length(targets)
    scatter(targets(k).x,targets(k).y);
    hold on
end

scatter(radar.x,radar.y,"x")
plot([radar.x,radar.ant_x], [radar.y,radar.ant_y_upper],'-.' ...
    ,[radar.x,radar.ant_x], [radar.y,radar.ant_y_lower],'-.')
xlim([-5,25]);
ylim([-5,25]);
title("Scene setup")
xlabel("Range [m]")
ylabel("Azimuth [m]")
% h1 = axes;
% set(h1, 'Ydir', 'reverse')
% set(h1, 'YAxisLocation', 'Right')
hold off
