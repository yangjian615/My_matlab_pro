function [shots,desc,scaninfo] = get2015run(sel)
% [shots,desc,scanShots,position,fcshift] = get2015run(sel)
%
% gets list of shots and description of run for 2015 MRX campaign from
% shotlist.xlsx
%
% sel:   number of run, returns full list when called without input
%
% shots: vector of shots in run
% desc:  description of run
% scaninfo:
%   scanShots: shots of LP scan
%   position: LP radial position
%   fcshift: flux core shift
% 
% Jan. 2016, Adrian von Stechow

[num, txt] = xlsread('shotlist.xlsx',1,'','basic');

purposeInd = find(strcmp(txt(1,:),'purpose'));
dateInd    = find(strcmp(txt(1,:),'date'));
GFInd      = find(strcmp(txt(1,:),'GF'));
startInd   = find(strcmp(txt(1,:),'shot start'));
endInd     = find(strcmp(txt(1,:),'shot end'));
gasStartInd= find(strcmp(txt(1,:),'gas start'));
gasInd     = find(strcmp(txt(1,:),'gas pulse'));
numberInd  = find(strcmp(txt(1,:),'number'));

if nargin == 0
    disp([num2cell(num(:,numberInd)),num2cell(num(:,dateInd)),...
        num2cell(num(:,startInd)),num2cell(num(:,GFInd)),txt(2:end,purposeInd)])
    shots = nan;
    desc  = nan;
    return
end

index           = find(num(:,numberInd)==sel);
shots           = num(index,startInd):num(index,endInd);
desc.date       = num(index,dateInd);
desc.GF         = num(index,GFInd);
desc.gasstart   = num(index,gasStartInd);
desc.gaspulse   = num(index,gasInd);
desc.purpose    = txt(index,purposeInd);

try
    [num, ~] = xlsread('shotlist.xlsx',['run' num2str(sel)],'','basic'); % load runX sheet
    scaninfo.scanShots = num(:,1);
    scaninfo.position  = num(:,2);
    scaninfo.fcshift   = num(:,3);
catch
    scaninfo = nan;
end