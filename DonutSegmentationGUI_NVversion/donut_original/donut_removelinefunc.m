function donut_removelinefunc
global gh

gh.data.vess_ix=gh.data.vess_ix(1:end-1,:);
gh.data.vess_iy=gh.data.vess_iy(1:end-1,:);

gh.data.LblMaskV=zeros(size(gh.data.ImRawAvg));

donut_dispdrawfunc;


