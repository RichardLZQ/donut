function donut_loadfuncIoana(ImRaw)

global gh

gh.data.ImRaw=ImRaw;
gh.data.ImRawAvg=mean(gh.data.ImRaw,3);
gh.data.ImRawMax=max(gh.data.ImRaw,[],3);
gh.param.InferFlag=0;