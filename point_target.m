classdef point_target
    %POINT_TARGET Summary of this class goes here
    %   Detailed explanation goes here

    properties
        x = 0
        y = 0
        refelctivity = 1
    end

    methods
        function obj = point_target(x,y)
            %POINT_TARGET Construct an instance of this class
            %   Detailed explanation goes here
            obj.x = x;
            obj.y = y;
        end

        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

