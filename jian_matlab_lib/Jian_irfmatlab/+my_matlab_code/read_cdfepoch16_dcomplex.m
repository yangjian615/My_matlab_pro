function [ data_time ] = read_cdfepoch16_dcomplex(file,flag)
%%  cdfepoch16 picoseconds from since 1-Jan-0000
%read_cdfepoch16_dcomplex Summary of this function goes here
%   Detailed explanation goes here
%read_cdfepoch16_dcomplex  read cdfepoch16 dcomplex class
%and Convert time to other formats
%
%   data_time=read_cdfepoch16_dcomplex(file,flag)
%
%   Input:
%       file: cdf file contain cdfEpoch16 picoseconds
%       flag:default is epochtt
%   Output:
%       t_out: other time formats default is epochtt
%
%   Formats flag can be (default 'in' is 'epochtt'):%
%       epoch: seconds since the epoch 1 Jan 1970, default, used by the ISDAT system.
%      vector: [year month date hour min sec] last five columns optional
%     vector6: [year month date hour min sec]
%     vector9: [year month date hour min sec msec micros nanosec]
%         iso: deprecated, same as 'utc'
%        date: MATLAB datenum format
%     datenum: same as 'date'
%         doy: [year, doy]
%          tt: Terrestrial Time, seconds past  January 1, 2000, 11:58:55.816 (UTC)
%        ttns: Terrestrial Time, nanoseconds past  January 1, 2000, 11:58:55.816 (UTC)
%         utc: UTC string (see help spdfparsett2000 for supported formats)
%  utc_format: only output, where 'format' can be any string where 'yyyy' is
%              changed to year, 'mm' month, 'dd' day, 'HH' hour, 'MM'
%              minute, 'SS' second, 'mmm' milisceonds, 'uuu' microseconds,
%              'nnn' nanoseconds. E.g. 'utc_yyyy-mm-dd HH:MM:SS.mmm'
%              Values exceeding the requested precision are truncated,
%              e.g. 10:40.99 is returned as "10:40" using format "utc_HH:MM".
%    cdfepoch: miliseconds since 1-Jan-0000
%  cdfepoch16: [seconds since 1-Jan-0000, picoseconds within the second]
%     epochtt: return class EPOCHTT
%
%
%  Example: data_time= read_cdfepoch16_dcomplex(file,'utc')
%
%----writen by Jian Yang at BUAA (2015-11-13)----
if nargin==1,
    flag='epochtt';
    fprintf(strcat(['Time out in ' flag ' object',':','\n']));
    
end
cdfid = cdflib.open(file);
info_g=cdflib.inquire(cdfid)
info_var=cdflib.inquireVar(cdfid,0)

star_record=7065166;
end_record=10357679;

h = waitbar(0,'Please wait...');
for i = star_record:1:end_record%info_g.maxRec
    if i==star_record
        epoch_star=cdflib.getVarRecordData(cdfid,0,i);
        epoch=epoch_star;
    else
        epoch_step=cdflib.getVarRecordData(cdfid,0,i);
        
        epoch=[epoch,epoch_step];
    end
    display(i)
    waitbar(i/end_record,h);
end
close(h);
cdflib.close(cdfid);
data_time=irf_time(epoch',['cdfepoch16>' flag]);


end





