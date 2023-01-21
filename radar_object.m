classdef radar_object

    %RADAR Summary of this class goes here
    %   Detailed explanation goes here

    properties
        c=3e8;

        x=0; %radar position (in range)
        y=0; % radar position (in azimuth)

        max_ant_length =0;
        ant_y_upper=0;
        ant_y_lower=0;
        ant_x=0;


        fc=4e9; % carrier
        B=25e6; % Bandwidth
        T=5e-3; % Chirp time

        PRI=1e-3;

        Beta=0 % slope
        lambda=0; % Wavelength
        ant_angle=deg2rad(30); % antenna beam angle
        %         sigma_a=L/2; % azimuth resolution
        %         sigma_r=c/(2*B);% range resolution
        v=10; % platform velocity
        pulses=1000;
        az_step=0;

        SAR_raw_data=[];
        SAR_range_compressed=[];
        SAR_rage_corrected=[];
        SAR_aziuth_compressed=[];
        signal_length=0;

        fs = 500e3; % ADC smapling rate
        

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
            obj.az_step=obj.PRI*obj.v;


        end

        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end

        function obj=get_fs(obj,max_distance)

            
            f_max=obj.Beta*2*max_distance/(obj.T*obj.c);
            obj.fs = 3*f_max;
        end

        function max_sig_length = get_max_signal_length(obj,max_distance)


            max_distance = max_distance+5;
            f_max=obj.Beta*2*max_distance/(obj.T*obj.c);
            max_sig_length = 3*f_max*obj.PRI;
            obj.signal_length=max_sig_length;

        end
        function obj=get_ant_vertices(obj,max_distance)
            
            L = 2*max_distance*tan(obj.ant_angle/2);

            obj.ant_y_lower=obj.y-L/2;
            obj.ant_y_upper=obj.y+L/2;
            obj.ant_x=max_distance;
            obj.max_ant_length=L;
            

            
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