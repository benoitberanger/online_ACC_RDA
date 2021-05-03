clc
clear

addpath( fullfile( fileparts(pwd), 'vis_stim_prisma_neuromod'                               ) )
addpath( fullfile( fileparts(pwd), 'vis_stim_prisma_neuromod', 'functions'                  ) )
addpath( fullfile( fileparts(pwd), 'vis_stim_prisma_neuromod', 'external_lib', 'hline_vline') )

nm = neuromodulation();
disp(nm)

