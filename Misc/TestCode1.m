figure;
for ii=61:90
    ii
    xL=max(gh.data.ix(ii,1)-HlfWid,1);
    xR=min(gh.data.ix(ii,1)+HlfWid,gh.data.sze(1));
    yL=max(gh.data.iy(ii,1)-HlfWid,1);
    yR=min(gh.data.iy(ii,1)+HlfWid,gh.data.sze(2));
    
    
    subplot(10,20,3*(ii-60)-2);
    imagesc(gh.data.ImRegAvg(xL:xR,yL:yR));
    axis off
    subplot(10,20,3*(ii-60)-1);
    imagesc(gh.data.LblMask(xL:xR,yL:yR));
    title(gh.data.CRMax(1,ii));
    axis off
    subplot(10,20,3*(ii-60));
    imagesc(gh.data.MaskPatchFin{1,ii});
    title(gh.data.EigValRetained(1,ii))
    axis off
end

figure;
for ii=1:30
    subplot(5,6,ii);
    imagesc(reshape(gh.data.Ma{1,ii}(:,1),15,15));
    colorbar;
end

figure;
for ii=1:60
    ii
    xL=max(gh.data.ix(ii,1)-HlfWid,1);
    xR=min(gh.data.ix(ii,1)+HlfWid,gh.data.sze(1));
    yL=max(gh.data.iy(ii,1)-HlfWid,1);
    yR=min(gh.data.iy(ii,1)+HlfWid,gh.data.sze(2));
    
    
    subplot(10,20,3*(ii)-2);
    imagesc(gh.data.ImRegAvg(xL:xR,yL:yR));
    axis off
    subplot(10,20,3*(ii)-1);
    imagesc(gh.data.LblMask(xL:xR,yL:yR));
    title(gh.data.CRMax(1,ii));
    axis off
    subplot(10,20,3*(ii));
    imagesc(gh.data.MaskPatchFin{1,ii});
    title(gh.data.EigValRetained(1,ii))
    axis off
end

figure;
for ii=1:97
    if gh.data.MaskType(1,ii)==2
   subplot(10,10,ii);
   plot(gh.data.dFoF(ii,:));
   title(gh.data.MaskType(1,ii));
    end
end