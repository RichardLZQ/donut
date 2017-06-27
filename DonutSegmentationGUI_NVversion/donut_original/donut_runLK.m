function donut_runLK

global gh

gh.data.ImReg=gh.data.ImRaw;

if get(gh.main.Chckbx_TransOnly,'Value')
    gh.data.ImRef=mean(gh.data.ImRaw(:,:,1:50),3);
    for i=1:gh.data.sze(3)
        [gh.data.ImReg(:,:,i)]=donut_ImReg(gh.data.ImReg(:,:,i),gh.data.ImRef);
        disp(i)
    end
else
    gh.data.ImRef=mean(gh.data.ImRaw,3);
    [gh.data.ImReg]=correctstackv16r(gh.data.ImReg,gh.data.ImRef,...
        gh.param.NumParam,1/gh.param.ConvCret,gh.param.NumLoop);
end

set(gh.disp.ChckbxLKDisp,'Value',1);

gh.data.ImRegAvg=mean(gh.data.ImReg,3);
gh.data.ImRegMax=max(gh.data.ImReg,[],3);