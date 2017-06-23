clear y

for ii=1:4
    FileName=(['AxonAvg' num2str(ii) '.tif']);
    y(:,:,ii)=single(squeeze(ldmultitif(FileName,1)));
end

for ii=1:4
    for jj=1:4
        y2(:,:,4*jj-3)=rot90(y(:,:,ii),jj);
        y2(:,:,4*jj-2)=rot90(y(:,:,ii),jj);
        y2(:,:,4*jj-1)=rot90(y(:,:,ii),jj);
        y2(:,:,4*jj)=rot90(y(:,:,ii),jj);
    end
end

y=y2(11:438,11:438,:);
