close all
clear


%% Platform Parameters
c=3e8;
fc=4e9; % carrier
B=15e6; % Bandwidth
T=5e-3; % Chirp time
Beta=B/T; % slope
ant_angle=30; %antenna aperture angle
v=50; % platform's velocity





max_range=100;


radar=radar_object(B,T,fc,v,ant_angle);
radar=radar.get_ant_vertices(max_range);
radar=radar.get_fs(max_range);


samples=floor(radar.PRI*radar.fs);
radar=radar.get_azimuth_reference(300);


%% Create targets


t1=point_target(100,10);
t2=point_target(90,15);
t3=point_target(80,20);
t4=point_target(70,25);
t5=point_target(10,30);
t6=point_target(70,20);
t7=point_target(20,20);
t8=point_target(80,25)
targets=[t1,t2,t3,t4,t5,t6,t7,t8];

% Determine antenna length for every target
for k=1:length(targets)
    targets(k)=targets(k).get_ant_width(ant_angle);
end

%% Display scene setup
show_scene

%% Sensing

azimuth_distance = 50;
steps=floor(azimuth_distance / radar.az_step);


fs=radar.fs;
smps=samples;
t=0:1/radar.fs:1/radar.fs*smps-1/radar.fs;

figure
radar.SAR_raw_data=zeros(steps,smps);
% radar.fs=100e6;
for k=1:steps

    tmp_signal=zeros(1,smps);
    for l=1:length(targets)
        illuminated=targets(l).is_illuminated(radar.y);

        if(illuminated)
            targets(l)=targets(l).get_inst_range2(radar.x,radar.y);
            tmp_signal=tmp_signal+targets(l).get_beat(t,radar.lambda,radar.Beta,radar.T);
            %plot(real(tmp_signal));

        else
            tmp_signal=tmp_signal+ones(1,smps).*randn(1,smps)*1;
        end


    end

    radar.SAR_raw_data(k,:)=tmp_signal;

    radar.y=radar.y+radar.az_step;
    radar=radar.get_ant_vertices(max_range);
    disp(k)


end


%% Range compression


for k=1:steps
    radar.SAR_range_compressed(k,:)=fft(radar.SAR_raw_data(k,:));
    disp(k);
end



%% Azimuth compression
radar=radar.azimuth_compression(samples);



%%

figure
tiledlayout(1,3)
nexttile
imagesc(real(radar.SAR_raw_data));
title("Raw Data")
xlabel("Sample")
ylabel("Pulse")


nexttile
azimuth_axis=0:radar.az_step:30;
imagesc(db(abs(radar.SAR_range_compressed)));

title("Range Compressed")
xlabel("Beat frequency [Hz]")
ylabel("Pulse")

nexttile
imagesc(real(radar.SAR_azimuth_compressed))
title("Azimuth Compressed")
colorbar


% fix raxis in plots



