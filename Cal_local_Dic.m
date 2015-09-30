function [Local_Dic]=Cal_local_Dic(D,patch_idx, patch_num,patch_size)
%函数功能：
% 计算每一个图像patch多对应的稀疏表示词典
Re_D=D(patch_idx,:);
Local_Dic=zeros(prod(patch_size),size(Re_D,2),patch_num);
for i=1:patch_num
    Local_Dic(:,:,i)=Re_D(1+prod(patch_size)*(i-1):prod(patch_size)*i,:);
end