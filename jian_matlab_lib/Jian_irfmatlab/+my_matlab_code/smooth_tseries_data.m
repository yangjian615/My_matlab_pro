function [ smooth_data ] = smooth_tseries_data( data_input,width)
%smooth_tseries_data Summary of this function goes here
%smooth tseries data
% 
% smooth_data=smooth_tseries_data(data_input,width)
%
%
%Detailed explanation goes here




%


smooth_data=data_input;
smooth_data(:,1)=data_input(:,1);
smooth_data(:,2)=smooth(data_input(:,2),width);
smooth_data(:,3)=smooth(data_input(:,3),width);
smooth_data(:,4)=smooth(data_input(:,4),width);


end

