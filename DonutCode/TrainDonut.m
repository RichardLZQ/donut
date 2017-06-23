%% Algorithm learning
clear all
ops.cell_diam       = 9;
ops.ex              = 10;
ops.cells_per_image = 100;
ops.NSS             = 1;
ops.KS              = 5;
ops.MP              = 0;
ops.inc             = 20;
ops.fig             = 1;
ops.learn           = 1;
ops.data_path       = 'C:\Users\Ko Ho\Dropbox\My documents\Research\Matlab Programs\Own\GCaMP6';
ops.code_location   = 'C:\Users\Ko Ho\Dropbox\My documents\Research\Matlab Programs\Own\GCaMP6\DonutCode\learning_module';

NormalizeFlag=1;
TrainingDataFileName = 'GCamp6_DataMFSoma8.mat';
ModelSaveFileName    = 'GCamp6_ModelMFSoma8.mat';

MPCC2_KSVD;