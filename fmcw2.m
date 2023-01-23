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
max_range=100;

radar=radar_object(B,T,fc,v,ant_angle);
radar=radar.get_ant_vertices(max_range);
radar=radar.get_fs(max_range);
radar=radar.get_azimuth_reference(100);


%% Create targets

% Determine antenna length for every target



t1=point_target(100,10);
t2=point_target(15,25);
t3=point_target(10,20);
t4=point_target(15,10);
targets=[t1,t2,t3,t4];

for k=1:length(targets)
    targets(k)=targets(k).get_ant_width(ant_angle);
end

%% Display scene setup
show_scene

%% Sensing

azimuth_distance = 50;
steps=floor(azimuth_distance / radar.az_step);
%tmp_signal=zeros(1,radar.get_max_signal_length(max_range));
fs=radar.fs;
%radar.fs=radar.fs*10000;
smps=700;
t=0:1/radar.fs:1/radar.fs*smps-1/radar.fs;

figure
radar.SAR_raw_data=zeros(steps,smps);
radar.fs=100e6;
for k=1:steps

    tmp_signal=zeros(1,smps);
    for l=1:length(targets)
        illuminated=targets(l).is_illuminated(radar.y);

        if(illuminated)
            targets(l)=targets(l).get_inst_range2(radar.x,radar.y);
            tmp_signal=tmp_signal+targets(l).get_beat(t,radar.lambda,radar.Beta,radar.T);
            %plot(real(tmp_signal));

        else
            tmp_signal=tmp_signal+ones(1,smps).*randn(1,smps)*2;
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



% %% Azimuth compression
%
%
% for k=1:smps
%     radar.SAR_azimuth_compressed(:,k)=fft(radar.SAR_raw_data(:,k));
%     disp(k);
% end

%%
close all
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
show_scene



%%

chrp=radar.SAR_range_compressed(:,234);
chrp=radar.SAR_range_compressed(:,36);

chrp=chrp/max(abs(chrp));



%%
r=zeros(1,steps);
radar.y=0;
radar=radar.get_ant_vertices(max_range);

l=1;
t5=point_target(25,10);
t5=t5.get_ant_width(ant_angle);
for k=1:steps
    
    il=t5.is_illuminated(radar.y);
    disp(il)
    if(il)
    t5=t5.get_inst_range2(radar.x,radar.y);
    r(l)=t5.r;
    end

    radar.y=radar.y+radar.az_step;
    radar=radar.get_ant_vertices(max_range);
    l=l+1;

end

% r(1:100)=0;
% r(500:end)=0;

lambda=radar.lambda;
%phi=4*pi*R/lambda;
phase_shifts=4*pi*r/lambda;
%f_if=Beta*2*R/(T*c);

chrp2=exp(1i*(phase_shifts));

%y=filter(radar.SAR_azimuth_reference_LUT(15,455:end),1,chrp);
h=radar.SAR_azimuth_reference_LUT(15,:);
h=h(h~=997);
w=blackman(length(h));
h=h.*w';
y=conv(h,chrp);
y=y(40:end);



figure
tiledlayout(3,1)
% plot(imag(chrp/max(chrp)))
% hold on
nexttile
plot(real(chrp));
hold on
plot(abs(y)/max(abs(y)));
%plot(abs(y));
hold off
title("azimuth chirp")
xlim([0,600])
nexttile
plot(real(h))
xlim([0,600])
title("Reference")

nexttile

plot(db(real(y)));
title("Azimuth compressed")
% move either reference or signal by size of reference s(t-t_imp)





