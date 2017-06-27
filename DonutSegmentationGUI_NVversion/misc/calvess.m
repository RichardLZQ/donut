function calvess(I,xlist,ylist)

n=15; %get a mean frame from per n frames.
m=40; %sample points through a line on vessel.
p=0.2; %The cutoff to identify vessel width

piclen=size(I,3);
avg=zeros(512,512,piclen/n);


for i=1:(piclen/n)-1
    avg(:,:,i)=mean(I(:,:,(i*n):((i+1)*n)),3);
end

logires=zeros(m,piclen/n,size(xlist,1));
for j=1:size(xlist,1)
    
    diamat=zeros(m,piclen/n);
    
    for i=1:(piclen/n)
        diamat(:,i)=improfile(avg(:,:,i),xlist(j,:),ylist(j,:),m);
    end
    diamax=max(max(diamat));
    diamin=min(min(diamat));
    cutoff=p*(diamax-diamin);
    logires(:,:,j)=diamat(:,:)>=cutoff;
end

diamat=mean(logires,3);
wid=sum(diamat,1);

%Fiter the outliers
wstd=std(wid,1);
wmean=mean(wid);
for i=1:length(wid)
    if i<length(wid)
        if wid(i)>wmean+2*wstd || wid(i)<wmean-2*wstd
            %             wid(i)=(wid(i+1)+wid(i-1))/2;
            wid(i)=wmean;
        end
    else
        wid(i)=wid(i-1);
    end
end

%Plot the figure
figure;
plot(wid);
end