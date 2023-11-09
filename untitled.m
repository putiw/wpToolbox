
nTime = 300; % 5 min


A1 = repmat(repelem([1 0 0],1,10),1,10)';
A2 = repmat(repelem([0 1 0],1,10),1,10)';
A3 = repmat(repelem([0 0 1],1,10),1,10)';
B1 = repmat(repelem([1 0 ],1,15),1,10)';
B2 = repmat(repelem([0 1 ],1,15),1,10)';

X = [A1 A2 A3 B1 B2];
%%
figure(1);clf
imagesc(X);
colormap(gray)

%%
figure(2);clf
A1B1 = A1 .* B1;
imagesc([A1 B1 A1B1])
colormap(gray)

%%
figure(3);clf

subplot(1,2,1)
A1 = repmat(repelem([1 0 0],1,10),1,10)';
A2 = repmat(repelem([0 1 0],1,10),1,10)';
A3 = repmat(repelem([0 0 1],1,10),1,10)';
B1 = repmat(repelem([1 0 ],1,15),1,10)';
B2 = repmat(repelem([0 1 ],1,15),1,10)';

A1B1 = A1 .* B1;
A1B2 = A1 .* B2;
A2B1 = A2 .* B1;
A2B2 = A2 .* B2;
A3B1 = A3 .* B1;
A3B2 = A3 .* B2;

X = [A1 A2 A3 B1 B2 A1B1 A1B2 A2B1 A2B2 A3B1 A3B2];
imagesc(X)
set(gca,'XTickLabel',{'A1' 'A2' 'A3' 'B1' 'B2' 'A1B1' 'A1B2' 'A2B1' 'A2B2' 'A3B1' 'A3B2'});
colormap(gray)

subplot(1,2,2)

AB = A1 .* B1 + A2 .* B1 + A3 .* B1 + A1 .* B2 + A2 .* B2 + A3 .* B2;
X = [A1 A2 A3 B1 B2 AB];
imagesc(X)
set(gca,'XTickLabel',{'A1' 'A2' 'A3' 'B1' 'B2' 'AB'});
colormap(gray)

% %%
% b = X \ y;
% 
% yhat = X * b;
% 
% e =  y - yhat;
% 
% SSR = ||e||^2;
% SSTO = ||y-mean(y)||^2
% 
% 
% 
% R^2 = SSR/SSTO;
% 






