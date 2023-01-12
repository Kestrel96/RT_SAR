classdef point_target
    %POINT_TARGET Summary of this class goes here
    %   Detailed explanation goes here

    properties
        x = 0
        y = 0
        vr=0
        refelctivity = 1
    end

    methods
        function obj = point_target(x,y)
            %POINT_TARGET Construct an instance of this class
            %   Detailed explanation goes here
            obj.x = x;
            obj.y = y;
        end
        function obj=get_vr(obj,vp,xp,yp)
            alfa=cot((xp-obj.x)/(yp-obj.y));
            obj.vr=vp*cos(alfa);


        end


        function beat = get_beat(obj,r,t,lambda,Beta,T)
            %GET_BEAT Summary of this function goes here
            %   Detailed explanation goes here

            c=3e8;

            phi=4*pi*r/lambda; % phase of IF signal
            %r=10;
            f_if=Beta*2*r/(T*c); % frequency of IF signal
            %r=f_if*T*c/(2*Beta);
            beat=obj.refelctivity* exp(1i*(2*pi*f_if*t+phi));



        end
    end
end


