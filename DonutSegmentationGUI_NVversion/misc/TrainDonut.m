% Algorithm training
clear all
ops.cell_diam        = 9;
ops.ex               = 10;
ops.cells_per_image  = 130;
ops.NSS              = 1;
ops.KS               = 5;
ops.MP               = 0;
ops.inc              = 20;
ops.fig              = 1;
ops.learn            = 1;

NormalizeFlag=1;
TrainingDataFileName = 'GCamp6_DataMFSoma8.mat';
ModelSaveFileName    = 'GCamp6_ModelMFSoma8.mat';

% TrainingDataFileName = 'Demo2.mat';
% ModelSaveFileName    = 'DemoModel';

MPCC2_KSVD;