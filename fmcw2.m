close all
clear


%% Platform Parameters
c=3e8;
fc=4e9; % carrier
B=100e6; % Bandwidth
T=10e-3; % Chirp time
Beta=B/T; % slope
ant_angle=30; %antenna aperture angle
v=75; % platform's velocity
PRI=1e-3; % Pulse repetition interval
max_range=100;% max range of radar, used to calculate antenna max width and
% azimuth reference functions


% create radar
radar=radar_object(B,T,fc,v,PRI,ant_angle);
radar=radar.get_ant_vertices(max_range);
radar=radar.get_fs(max_range);

samples=floor(radar.PRI*radar.fs);% Max no. of samples of beat signal
radar=radar.get_azimuth_reference(max_range);

azimuth_samples=750;% samples in azimuth (related to distance covered by platform)
azimuth_distance = radar.az_step*azimuth_samples;
disp(samples)

%% Create targets


t1=point_target(85,floor(azimuth_distance/2));
t2=point_target(90,15);
t3=point_target(80,20);
t4=point_target(70,25);
t5=point_target(20,10);
t6=point_target(70,20);
t7=point_target(20,30);
t8=point_target(80,25);
targets=[t1,t2,t3,t4,t5,t6,t7,t8];

% Determine antenna length for every target
for k=1:length(targets)
    targets(k)=targets(k).get_ant_width(ant_angle);
end

%% Display scene setup
show_scene

%% Sensing


steps=floor(azimuth_distance / radar.az_step); % Azimuth steps
t=0:1/radar.fs:1/radar.fs*samples-1/radar.fs;% Time vector of beat signal

radar.SAR_raw_data=zeros(steps,samples);% init Raw Data array

for k=1:steps

    tmp_signal=zeros(1,samples);
    for l=1:length(targets)
        illuminated=targets(l).is_illuminated(radar.y);

        if(illuminated) % Targets reflect only if illuminated
            targets(l)=targets(l).get_inst_range2(radar.x,radar.y);
            tmp_signal=tmp_signal+targets(l).get_beat(t,radar.lambda,radar.Beta,radar.T);

        else
            tmp_signal=tmp_signal+ones(1,samples).*randn(1,samples)*1;% add noise
        end


    end

    radar.SAR_raw_data(k,:)=tmp_signal;

    radar.y=radar.y+radar.az_step;% move the platform, recalculate antenna
    radar=radar.get_ant_vertices(max_range);
    disp(k)


end


%% Range compression

% FFT in range direction for every pulse.
for k=1:steps
    radar.SAR_range_compressed(k,:)=fft(radar.SAR_raw_data(k,:));
    disp(k);
end



%% Azimuth compression
% Filtering azimuth signal by azimuth reference functions.
radar=radar.azimuth_compression(samples);



%%

figure
tiledlayout(1,3)
nexttile
imagesc(real(radar.SAR_raw_data));
ax = gca;
ax.YDir= 'normal';
title("Raw Data")
xlabel("Sample")
ylabel("Pulse")


nexttile
azimuth_axis=0:radar.az_step:30;
%imagesc(linspace(600,1200),linspace(0,666),db(abs(radar.SAR_range_compressed)));
imagesc(db(abs(radar.SAR_range_compressed)));
ax = gca;
ax.YDir= 'normal';

title("Range Compressed")
xlabel("Beat frequency [Hz]")
ylabel("Pulse")

nexttile
imagesc(real(radar.SAR_azimuth_compressed))
ax = gca;
ax.YDir= 'normal';
title("Azimuth Compressed")
colorbar
%colormap("gray")


compare_scene

% fix raxis in plots


%% BPA
% for k=1:steps
% 
%     % BPA
%     % Calculate position (x,y)
%     % r=sqrt((x_radar-x_point)^2+((y_radar-y_point)^2)
% 
%     x=PRI*k*v; % new x coordinate for signle pulse
%     y=R; % y is constant and does not change in time
%     R_ap(:,k)=sqrt((x-x_p)^2+(y-y_p)^2); % BPA distance
%     n=(R_ap-2*0)/(2*sigma_r); % Index of range cell, r_min is 0.
%     h(:,k)=exp(1i*2*pi*R_ap(k)/lambda); % vector of filter coefficients
%     % Define -j or +j (add some switch or smth)
% end

radar.y=0;
for k=1:steps

    tmp_signal=zeros(1,samples);
    targets(1)=targets(1).get_inst_range2(radar.x,radar.y);
    R_ap(k)=targets(1).r;
    
    f_base=(radar.Beta*2*targets(1).x/(T*c));
    f_if(k)=(radar.Beta*2*targets(1).r/(T*c));
    f_shift(k)=(radar.Beta*2*targets(1).r/(T*c))-f_base;

    samples_no(k)=round(f_if(k)/radar.fs*samples)+1;

    n=round((R_ap-2*0)/(2*radar.sigma_r));
    h(k)=exp(1i*2*pi*R_ap(k)/radar.lambda);

    radar.SAR_raw_data(k,:)=tmp_signal;
    radar.y=radar.y+radar.az_step;% move the platform, recalculate antenna
    radar=radar.get_ant_vertices(max_range);
    disp(k)

end



SAR_BPA=radar.SAR_range_compressed;
for k=1:steps

    

end

% extended abstract dla prof. Misurewicza
% BPA w druga stronę - przeliczyć odległość na częstoliwość i ją modulować
% jak zogniskować obraz dla celów które nie są centralnie w wiązce (RCMC?)
% jak podzielić to co mam na komórki odległościowe? 
% Gdzie ten doppler??



%%
% for k=1:samples
%     disp(k);
% end
%     radar.SAR_azimuth_compressed=fftshift(fft2(radar.SAR_raw_data));
%
% figure
% imagesc(db(abs(radar.SAR_azimuth_compressed)))
% ax = gca;
% ax.YDir= 'normal';