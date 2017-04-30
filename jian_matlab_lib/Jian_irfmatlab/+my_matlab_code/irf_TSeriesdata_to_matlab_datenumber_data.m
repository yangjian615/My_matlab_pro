function [ matlab_datenumber_data ] = irf_TSeriesdata_to_matlab_datenumber_data( irf_TSeriesdata ,varargin)
%irf_TSeriesdata_to_matlab_datenumber_data Summary of this function goes here
%
%   Detailed explanation goes here
%   irf TSeriesdata to matlab datenumber data
%   TSeriesdata转换成matlab自带识别的时间序列 可以用plot画出和datetick标注X时间轴
%   Input:
%        TSeriesdata: TSeries 数据 MMS cluster
%        varargin:
%          display:0 or 1
%        dateFormat: just like datetick
%	Table 1: Standard MATLAB Date format definitions
%
%   DATEFORM number   DATEFORM string         Example
%   ===========================================================================
%      0             'dd-mmm-yyyy HH:MM:SS'   01-Mar-2000 15:45:17
%      1             'dd-mmm-yyyy'            01-Mar-2000
%      2             'mm/dd/yy'               03/01/00
%      3             'mmm'                    Mar
%      4             'm'                      M
%      5             'mm'                     03
%      6             'mm/dd'                  03/01
%      7             'dd'                     01
%      8             'ddd'                    Wed
%      9             'd'                      W
%     10             'yyyy'                   2000
%     11             'yy'                     00
%     12             'mmmyy'                  Mar00
%     13             'HH:MM:SS'               15:45:17
%     14             'HH:MM:SS PM'             3:45:17 PM
%     15             'HH:MM'                  15:45
%     16             'HH:MM PM'                3:45 PM
%     17             'QQ-YY'                  Q1-96
%     18             'QQ'                     Q1
%     19             'dd/mm'                  01/03
%     20             'dd/mm/yy'               01/03/00
%     21             'mmm.dd,yyyy HH:MM:SS'   Mar.01,2000 15:45:17
%     22             'mmm.dd,yyyy'            Mar.01,2000
%     23             'mm/dd/yyyy'             03/01/2000
%     24             'dd/mm/yyyy'             01/03/2000
%     25             'yy/mm/dd'               00/03/01
%     26             'yyyy/mm/dd'             2000/03/01
%     27             'QQ-YYYY'                Q1-1996
%     28             'mmmyyyy'                Mar2000
%     29 (ISO 8601)  'yyyy-mm-dd'             2000-03-01
%     30 (ISO 8601)  'yyyymmddTHHMMSS'        20000301T154517
%     31             'yyyy-mm-dd HH:MM:SS'    2000-03-01 15:45:17
%
%   Table 2: Free-form date format symbols
%
%   Symbol  Interpretation of format symbol
%   ===========================================================================
%   yyyy    full year, e.g. 1990, 2000, 2002
%   yy      partial year, e.g. 90, 00, 02
%   mmmm    full name of the month, according to the calendar locale, e.g.
%           "March", "April" in the UK and USA English locales.
%   mmm     first three letters of the month, according to the calendar
%           locale, e.g. "Mar", "Apr" in the UK and USA English locales.
%   mm      numeric month of year, padded with leading zeros, e.g. ../03/..
%           or ../12/..
%   m       capitalized first letter of the month, according to the
%           calendar locale; for backwards compatibility.
%   dddd    full name of the weekday, according to the calendar locale,
%           e.g. "Monday", "Tuesday", for the UK and USA calendar locales.
%   ddd     first three letters of the weekday, according to the calendar
%           locale, e.g. "Mon", "Tue", for the UK and USA calendar locales.
%   dd      numeric day of the month, padded with leading zeros, e.g.
%           05/../.. or 20/../..
%   d       capitalized first letter of the weekday; for backwards
%           compatibility
%   HH      hour of the day, according to the time format. In case the time
%           format AM | PM is set, HH does not pad with leading zeros. In
%           case AM | PM is not set, display the hour of the day, padded
%           with leading zeros. e.g 10:20 PM, which is equivalent to 22:20;
%           9:00 AM, which is equivalent to 09:00.
%   MM      minutes of the hour, padded with leading zeros, e.g. 10:15,
%           10:05, 10:05 AM.
%   SS      second of the minute, padded with leading zeros, e.g. 10:15:30,
%           10:05:30, 10:05:30 AM.
%   FFF     milliseconds field, padded with leading zeros, e.g.
%           10:15:30.015.
%   PM      set the time format as time of morning or time of afternoon. AM
%           or PM is appended to the date string, as appropriate.
%
%
%
%
%
%   Output:
%        matlab_datenumber_data:
%         第一列X为时间第二列Y为数据
%
%Example:
% %  matlab_datenumber_data=irf_TSeriesdata_to_matlab_datenumber_data();%test
%
%   T=EpochTT('2002-03-04T09:30:00Z'):.2:EpochTT('2002-03-04T10:30:00Z');
%   t=T.tts - T.tts(1); x = exp(0.001*(t)).*sin(2*pi*t/180); TS1 = irf.ts_scalar(T,x);
%   dateFormat='HH:MM';
%   matlab_datenumber_data= irf_TSeriesdata_to_matlab_datenumber_data(TS1 ,'display',1,'dateFormat',dateFormat);
%
%----writen by Jian Yang at BUAA (2016-11-20)----
%% Test data
if nargin<1,
    T   = EpochTT('2002-03-04T09:30:00Z'):.2...
        :EpochTT('2002-03-04T10:30:00Z');      % define time line as EpochTT object
    t   = T.tts - T.tts(1);                     % define relative time in s from start
    x   = exp(0.001*(t)).*sin(2*pi*t/180);      % define function x(t)=exp(0.001(t-to))*sin(t-to)
    TS1 = irf.ts_scalar(T,x);                   % define scalar TSeries object
    h = irf_plot(1);
    hca = irf_panel('panel A');
    irf_plot(hca,TS1);
    title(hca,'IRF plot TSeries data');
    
    time_ISDAT=TS1.time.epochUnix;
    %epoch2iso(time_ISDAT);
    
    time_matlab=epoch2date(time_ISDAT);  %ISDAT epoch is the number of seconds since 1-Jan-1970 and
    data=TS1.data;
    
    matlab_datenumber_data=[time_matlab data];
    
    h_m= irf_plot(1,'newfigure');
    plot(h_m,time_matlab,data,'b');
    dateFormat='HH:MM';
    datetick(h_m,'x',dateFormat);
    title(h_m,'MATLAB plot datenumber data','color','blue');
    
    
else
    time_ISDAT=irf_TSeriesdata.time.epochUnix;
    
    time_matlab=epoch2date(time_ISDAT);  %ISDAT epoch is the number of seconds since 1-Jan-1970 and
    data=irf_TSeriesdata.data;
    matlab_datenumber_data=[time_matlab data];
    if nargin>=2,
        if ~isempty(varargin),
            if varargin{1}=='display',
                if varargin{2}==1,
                    h_m= irf_plot(1,'newfigure');
                    plot(h_m,time_matlab,data,'b');
                    if nargin==5,
                        dateFormat=varargin{4};
                        
                        datetick(h_m,'x',dateFormat);
                        title(h_m,'MATLAB plot datenumber data','color','blue');
                    else
                        datetick(h_m,'x');
                        title(h_m,'MATLAB plot datenumber data','color','blue');
                    end
                    
                end
                
            end
        end
    end
    
end



end

