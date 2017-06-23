count1=0;
count2=0;
global gh
for ii=1:size(gh.data.ix,1)   
    if gh.data.MaskType(1,ii)==1
        figure(1);
        count1=count1+1;
        subplot(8,10,count1);
        plot(gh.data.RawF(ii,:));
        ylim([0 20]);
        title(ii);
    else
        figure(2);
        count2=count2+1;
        subplot(8,10,count2);
        plot(gh.data.RawF(ii,:));
        ylim([0 20]);
        title(ii);
    end
end


count1=0;
count2=0;
global gh
for ii=1:size(gh.data.ix,1) 
    if gh.data.MaskType(1,ii)==1
        figure(1);
        count1=count1+1;
        subplot(8,14,count1);
        imagesc(bwareaopen(gh.data.MaskPatchBin{1,ii},5,4));
        title(ii);
    else
        figure(2);
        count2=count2+1;
        subplot(8,14,count2);
        imagesc(gh.data.MaskPatchBin{1,ii});
        title(ii);
    end
end