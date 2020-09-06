function [negentropy] = entropy(f, t)

% ========================================
%--------------------------------------------------------------------------
% preclude numerical overflow
%--------------------------------------------------------------------------
spm_log = @(x)log(x + exp(-16));
% ========================================

% Specifying model components:
Nf = numel(f); 


% Negative entropy:
negentropy = zeros(Nf,t);
for nf = 1:Nf
    for i = 1:t
       ax = f{nf}(:,i);
       negentropy(nf,i) = ax'*(-spm_log(ax));
    end
end

return 