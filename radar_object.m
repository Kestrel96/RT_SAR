classdef radar_object

    %RADAR Summary of this class goes here
    %   Detailed explanation goes here

    properties
        c=3e8;

        x=0; %radar position (in range)
        y=0; % radar position (in azimuth)

        fc=4e9; % carrier
        B=25e6; % Bandwidth
        T=5e-3; % Chirp time

        Beta=0 % slope
        lambda=0; % Wavelength
        ant_angle=deg2rad(30); % antenna beam angle
%         sigma_a=L/2; % azimuth resolution
%         sigma_r=c/(2*B);% range resolution
        v=10; % platform velocity
        pulses=1000;
    end

    methods
        function obj = radar_object(B,T,fc,v,ant_angle)
            %RADAR Construct an instance of this class
            %   Detailed explanation goes here

            obj.v=v;
            obj.B=B;
            obj.T=T;
            obj.fc=fc;
            obj.ant_angle=deg2rad(ant_angle);
            
            obj.Beta=B/T;
            obj.lambda=obj.c/fc;
            
    
        end

        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

% determine max range (this range determines maximum length of returned signal)
% , antenna footprint, time of ilumination for every
% target
% get range to all targets
% Calculate 0 doppler frequnecy for each range
% star sensing - get beat signal from every target and mix it
% range compression - fft on every pulse - separate beat frequencies (skip
% phase for now)
% RCMC - perform for every tone
% Azimuth