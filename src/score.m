function s = score(M,n)

s = zeros(n,3);
for i = 1:n
    j = M(i).o(2,3);
    s(i,j) = 1;
end
s = cumsum(s(:,1));
return 