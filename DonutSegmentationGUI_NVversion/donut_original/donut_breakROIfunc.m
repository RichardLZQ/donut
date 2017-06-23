function [MaskOut]=donut_breakROIfunc(MaskOut,MaskIn)

global gh

se=strel('disk',1);
EdgeMask=zeros(size(gh.data.ImRawAvg));
for ii=1:size(gh.data.ix,1)
    EdgeMask=EdgeMask+(imdilate(MaskIn==ii,se)-(MaskIn==ii));
end

MaskOut(EdgeMask>0)=0;