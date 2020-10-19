function stopNewFile( self )
global dataBVA

fprintf('[%s]: saving in %s ... ', mfilename, self.fpath)
if exist(self.dpath, 'dir')~=7
    mkdir(self.dpath)
end

% trim data
dataBVA = dataBVA(1:self.RDA.idx,:);

save( self.fpath, 'self', 'dataBVA' )
fprintf('done ! \n')

self.resetData();

end % function
