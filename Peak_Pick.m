function Thresh=Peak_Pick(histogram)

%Detects the lowest threshold point in a bimodal histogram.
%Remove semi-colon from Threshold variable at end to view output
%Not sure if this bit works correctly!

peak=find(histogram == max(histogram));

xmaxl = -1;
for i = 2 : peak-1
    if histogram(i-1) < histogram(i) & histogram(i) >= histogram(i+1) ...
    & histogram(i)>xmaxl
        xmaxl=histogram(i);
        pkl=i;
    end
end
   
xminl=max(histogram)+1;
for i = pkl+1 : peak-1
    if histogram(i-1) > histogram(i) & histogram(i) <= histogram(i+1) ...
    & histogram(i)<xminl
        xminl=histogram(i);
        Threshold=i;
    end
end

