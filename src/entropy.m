function [negentropy] = entropy(f)

spm_log = @(x)log(x + exp(-16));
 
negentropy = zeros([1,1]);

xx = f(:);
negentropy = xx'*(-spm_log(xx));
return 