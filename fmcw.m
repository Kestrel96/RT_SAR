close all
clear

%% Radar setup
c=3e8;
fc=4e9; % carrier
B=5e6; % Bandwidth
T=5e-3; % Chirp time
Beta=B/T; % slope
lambda=c/fc;
ant_angle=deg2rad(30);


delta_R=c/2/B; %range resoultion
delta_fz=1/T; %


%% Platform Setup
R=10;
L=2*R*tan(ant_angle);
pulses =1000; % pulses during target ilumination
v=10;
time=L/v; % time of ilumination

PRI=time/pulses;
PRF=1/PRI;


f0=Beta*2*R/(T*c);
phi=4*pi*R/lambda;

fs=f0*5; % ADC sampling - at least 2 times higher than highest beat frequency
step=PRI*v; % distance traveled by platform in one PRI

d_max=fs*c/(2*Beta);


% Preallocate SAR memory
%t=0:1/fs:0.001*PRI*fs-1/fs;
samples=500;
t=0:1/fs:1/fs*samples-1/fs;
SAR_raw=zeros(100,length(t));
SAR_range_compressed=zeros(100,length(t));

% t=2*d/c;
d=f0*T*c/(2*Beta);

% figure
% tmp=exp(i*(2*pi*f0*t+phi));
% plot(real(tmp(1:100)))



%% Sensing
for k=1:pulses
    % Calculate distance
    r=sqrt(R^2+(L/2-step*k)^2);
    % Receive echo (get beat)
    SAR_raw(k,:)=get_beat(r,t,lambda,Beta,T);

end


%% Range compression
for k=1:pulses
    SAR_range_compressed(k,:)=fft(SAR_raw(k,:));
end


%% Azimuth
figure
achp=SAR_raw(:,200);
plot(real(achp));


%% Display Data

faxis=0:1/fs:samples*1/fs-1/fs;
figure
tiledlayout(1,3)
nexttile
imagesc(real(SAR_raw));
xlabel("Sample")
ylabel("Pulse")
nexttile
title("Range compressed data")
imagesc(db((SAR_range_compressed)));

% plot(real(SAR_raw(1,1:100))

% Range FFT, racalualte beat frequency/range

% azimuth - get overalapping parts of RX/TX
% get cycle through columns - get chrirp like azimuth signal
% fftilt?







%%
% close all
% clear
% f0=1.5e4;
% tc=1/f0;
% fs=3*f0;
% t=0:1/fs:1/fs*1000-1/fs;
% % figure
% tmp=exp(i*(2*pi*f0*t));
% %tmp=cos(2*pi*f0*t);
% plot(real(tmp(1:100)))



















