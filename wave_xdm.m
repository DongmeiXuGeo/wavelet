clear all
clc
global result;

cd('E:\ningxia\wavelet\ES_data')
[HQ,TT]=geotiffread('ESv2_300.tif');
HQ(HQ<0)=nan;
HQ=HQ';
[nrows,ncols]=size(HQ);
result=zeros(nrows,ncols);
limit=0.05;
%%
%选第400列计算小波方差得到最佳小波尺度
samplecol = HQ(:,400);
samplecol = samplecol - nanmean(samplecol);
samplecol = diff(samplecol,2);
samplecol_coif = cwt(samplecol,1:32,'db3');
for i=1:32
    HQ_var(i)= (nansum(samplecol_coif(i,:).^2))/length(samplecol_coif);
end
plot(HQ_var,'linewidth',1.5);xlabel("小波尺度");ylabel("小波方差");
%得到最佳小波尺度为3
%%
HQ400 = HQ(:,400);
HQ400 = HQ400 - nanmean(HQ400);
HQ400 = diff(HQ400,2);
HQ400_coef = cwt(HQ400,3,'db3','plot');
%%
for j=1:1:ncols-1
    HQj = HQ(:,j);
    HQj = HQj - nanmean(HQj);
    HQj = diff(HQj,2);
    HQj_coef = cwt(HQj,3,'db3');
    absHQj_coef=abs(HQj_coef);
    [nrowsj,ncolsj]=size(absHQj_coef);
    for i=2:1:ncolsj-2
%         if abs(absHQj_coef(1,i)-absHQj_coef(1,i-1))>limit
%         if absHQj_coef(1,i)>limit
        if abs(absHQj_coef(1,i)-absHQj_coef(1,i-1))>limit && (((HQ(i,j)>1 && HQ(i+1,j)>1 && HQ(i+2,j)>1))|| ((HQ(i-1,j)>1) && (HQ(i-2,j)>1) && (HQ(i-3,j)>1))) && (((HQ(i,j)<1&&HQ(i+1,j)<1&&HQ(i+2,j)<1))||((HQ(i-1,j)<1)&&(HQ(i-2,j)<1)&&(HQ(i-3,j)<1))) && ((HQ(i-1,j)<1)||(HQ(i,j)<1))
            result(i,j)=1;
        end
    end
end

b=sum(result);
a=sum(b);
xlswrite('ESmutationv2300_0.05.xlsx',result');