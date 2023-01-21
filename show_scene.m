%figure
for k=1:length(targets)
    scatter(targets(k).x,targets(k).y);
    hold on
end

scatter(radar.x,radar.y,"x")
plot([radar.x,radar.ant_x], [radar.y,radar.ant_y_upper],'-.' ...
    ,[radar.x,radar.ant_x], [radar.y,radar.ant_y_lower],'-.')
xlim([0,25]);
%ylim([0,25]);
title("Scene setup")
xlabel("Range [m]")
ylabel("Azimuth [m]")
% h1 = axes;
% set(h1, 'Ydir', 'reverse')
% set(h1, 'YAxisLocation', 'Right')
hold off