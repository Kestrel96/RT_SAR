close all
clear


%% Platform Parameters
c=3e8;
fc=4e9; % carrier
B=25e6; % Bandwidth
T=5e-3; % Chirp time
Beta=B/T; % slope
ant_angle=30; %antenna aperture angle
v=100; % platform's velocity
max_range=30;

radar=radar_object(B,T,fc,v,ant_angle);
radar=radar.get_ant_vertices(max_range);
radar=radar.get_fs(max_range);


%% Create targets

% Determine antenna length for every target



t1=point_target(10,10);
t2=point_target(15,15);
t3=point_target(10,20);
t4=point_target(10,15);
targets=[t1];

for k=1:length(targets)
    targets(k)=targets(k).get_ant_width(ant_angle);
end

%% Display scene setup
show_scene

%% Sensing 

azimuth_distance = 30;
steps=azimuth_distance / radar.az_step;
%tmp_signal=zeros(1,radar.get_max_signal_length(max_range));
fs=radar.fs;
smps=500;
t=0:1/radar.fs:1/radar.fs*smps-1/radar.fs;

figure
radar.SAR_raw_data=zeros(steps,smps);
radar.fs=100e6;
for k=1:steps
    
     tmp_signal=zeros(1,smps);
     for l=1:length(targets)
         illuminated=targets(l).is_illuminated(radar.y);
         if(illuminated)
             targets(l)=targets(l).get_inst_range(radar.v,k*radar.az_step);
            tmp_signal=targets(l).get_beat(t,radar.lambda,radar.Beta,radar.T);
            %plot(real(tmp_signal));
         end  
     end
 
     radar.SAR_raw_data(k,:)=tmp_signal;

    radar.y=radar.y+radar.az_step;
    disp(k)

    
end


%% Range compression

 
for k=1:steps
    radar.SAR_range_compressed(k,:)=fft(radar.SAR_raw_data(k,:));
    disp(k);
end


%% 
figure
imagesc(real(radar.SAR_raw_data));
xlabel("Sample")
ylabel("Pulse")

figure
imagesc(db(abs(radar.SAR_range_compressed)));
xlabel("Sample")
ylabel("Pulse")

