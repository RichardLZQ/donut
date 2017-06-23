ImRef=ImRaw(:,:,1);
RefMean=mean(ImRef(:));

for ii=1:265
    ImTemp=ImRaw(:,:,ii);
    SclFact=mean(ImTemp(:))/RefMean;
    ImRaw(:,:,ii)=max(min(ImRaw(:,:,ii)/SclFact,256),0);
end