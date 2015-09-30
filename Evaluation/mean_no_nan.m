function rs = mean_no_nan(data)

nanFlag = isnan(data); 
index   = find(nanFlag==1);
data(index) = [];
rs = mean(data);