function [ppconf idx]=Calcandidates(pdiff,opt)
result =pdiff;%(pdiff.^2+opt.lssParam.lambda*abs(perr))./opt.condenssig;
for i=1:9
    conf(i,:)=sum(result(1+(i-1)*256:i*256,:));
end
conf =exp(-conf);
sconf=sum(conf,2);
pconf=conf./repmat(sconf,[1 opt.numsample]);
ppconf=ones(1,opt.numsample);
for i=1:9
    ppconf=ppconf.*pconf(i,:);
end
ppconf=ppconf'/(sum(ppconf)+eps);
%conf =conf./repmat(sconf,[9,1]);
[~, idx]=max(ppconf);