function range_corrected = rcmc2(range_doppler_data,delta_samples)
%RCMC2 Summary of this function goes here
%   Detailed explanation goes here


range_corrected=zeros(length(range_doppler_data),width(range_doppler_data));


buffer_zone=50;

for k=1:length(range_doppler_data)
    for l=1:width(range_doppler_data)
        sample_pre=range_doppler_data(k,l);
        new_l=round(l-delta_samples(k,l));
        
        range_corrected(k,new_l)=sample_pre;
    end

end


end

