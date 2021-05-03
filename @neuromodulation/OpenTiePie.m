function OpenTiePie( self )

fprintf('[neuromodulation.%s]: opening TiePie... \n', mfilename)


%% Path from Thomas

fprintf('[neuromodulation.%s]: adding path... \n', mfilename)

addpath(genpath('fichiers_thomas'))


%% Path of the TiePie libs

parentdir = fileparts(fileparts(fileparts(which('neuromodulation'))));
addpath(fullfile(parentdir,'matlab-libtiepie'));

res = dir(fullfile(parentdir,'libtiepie-*'));
assert(~isempty(res),'no "libtiepie-*" found in %s', parentdir)

if ispc
    platform = 'WindowsNT';
elseif isunix
    platform = 'GNULinux';
else
    error('??')
end
idx = find(contains({res.name},platform));
assert(~isempty(idx), 'no libtiepie-*%s* found in %s', platform, parentdir)

addpath(fullfile(parentdir,res(idx).name));
addpath(fullfile(parentdir,res(idx).name,'C'));


%% Init TiePie for INSIGHTEC

fprintf('[neuromodulation.%s]: opening TiePie device... \n', mfilename)

% w = instrfind;
% if ~isempty(w)
%     fclose(w); delete(w);
% end
% clear w;

scp = setdefault_scp_INSIGHTEC('SamplingFrequency', self.fs_tiepie, ...
    'AcquisitionTime', self.acq_time_tiepie, 'ScopeRange', self.scp_range);

fprintf('Temps d enregistrement %2.2f sec \n', scp.RecordLength/self.fs_tiepie);

import LibTiePie.Const.*
import LibTiePie.Enum.*

triggerInput = scp.getTriggerInputById(TIID.EXT3);
if triggerInput == false
    clear triggerInput;
    clear scp;
    error('Unknown trigger input!');
end

triggerInput.Enabled = true;
clear triggerInput;


%% Save

self.scp = scp; % @Oscilloscope object (from libtiepie)
self.use_tiepie = 1;

fprintf('[neuromodulation.%s]: ... done \n', mfilename)


end % function
