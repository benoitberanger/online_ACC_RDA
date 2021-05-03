function CloseTiePie( self )

fprintf('[neuromodulation.%s]: closing TiePie... \n', mfilename)

self.use_tiepie = 0;

% Close Oscilloscope
self.scp = [];

fprintf('[neuromodulation.%s]:... done \n', mfilename)

end % function
