function maxc=maxchar(lpfd1)
numc=zeros(size(lpfd1));
for i=1:size(lpfd1,1)
    for j=1:size(lpfd1,2)
        numc(i,j)=strlength(lpfd1(i,j));
    end
end
maxc=max(max(numc));