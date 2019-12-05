classdef Spinner
    properties
        end_text,
        spin
    end
    methods
        function obj = Spinner(start_text, end_text)
            obj.end_text = end_text;
            
            iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
            iconsSizeEnums = javaMethod('values',iconsClassName);
            SIZE_32x32 = iconsSizeEnums(2);  % (1) = 16x16,  (2) = 32x32
            spin = com.mathworks.widgets.BusyAffordance(SIZE_32x32, start_text);  % icon, label
            spin.setPaintsWhenStopped(true);  % default = false
            spin.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
            javacomponent(spin.getComponent, [10,10,80,80], gcf);
            spin.start;
            
            obj.spin = spin;
        end
        function obj = close(obj)
            obj.spin.stop;
            obj.spin.setBusyText(obj.end_text);
            pause(0.5);
        end
    end
end