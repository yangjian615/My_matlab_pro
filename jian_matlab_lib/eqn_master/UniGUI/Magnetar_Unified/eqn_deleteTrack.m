function Magnetar = eqn_deleteTrack(Magnetar, Track_No, columnId)
%eqn_deleteTrack Deletes Track of a Magnetar structure
% 
%   Magnetar = eqn_deleteTrack(Magnetar, Track_No, columnId)
%   erases the track that corresponds to 'Track_No', e.g. for Track_No = 1
%   it will completely remove the first track, for Track_No = 2, the second
%   track and so on. The 'columnId' indicates from which column (as
%   appearing in the signal_Plotter) the tracks will be removed.
% 

if nargin < 3
    columnId = 1;
end

Magnetar.Bind{columnId,1}(Track_No, :) = [];
Magnetar.Rind{columnId,1}(Track_No, :) = [];
Magnetar.dind{columnId,1}(Track_No, :) = [];

end
