classdef radar
    %RADAR Summary of this class goes here
    %   Detailed explanation goes here

    properties
        c=3e8;
        fc=4e9; % carrier
        B=25e6; % Bandwidth
        T=5e-3; % Chirp time
        Beta=B/T; % slope
        lambda=c/fc; % Wavelength
        ant_angle=deg2rad(30); % antenna beam angle
        sigma_a=L/2; % azimuth resolution
        sigma_r=c/(2*B);% range resolution
        v=10; % platform velocity
    end

    methods
        function obj = radar(inputArg1,inputArg2)
            %RADAR Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
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