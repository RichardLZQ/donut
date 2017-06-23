function donut_clustersignal

global gh

gh.param.ClusterFlag=1;

corrMat=corr(gh.data.RawF');
dissimilarity=1-corrMat;
Z=linkage(dissimilarity,'average');
gh.data.groups=cluster(Z,'criterion','distance','cutoff',gh.param.ClusterCutoff);

gh.data.LblMaskC=max(gh.data.LblMaskM,gh.data.LblMaskI);
for ii=1:size(gh.data.ix,1)
    if gh.data.MaskType(1,ii)==1
        gh.data.LblMaskC(gh.data.LblMaskI==ii)=gh.data.groups(ii);
    elseif gh.data.MaskType(1,ii)==2
        gh.data.LblMaskC(gh.data.LblMaskM==ii)=gh.data.groups(ii);
    end
end