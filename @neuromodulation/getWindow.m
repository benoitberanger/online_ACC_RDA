function window = getWindow(~,data,fs,windowlength)

window = data(end-fs*windowlength-1:end,:);

end % function
