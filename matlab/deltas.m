function D = deltas(C, K)
% DELTAS  Coefficients dynamiques par régression (étape A9, document 02, section 6).
%   D = deltas(C)      avec K = 2 (fenêtre de 5 trames)
%   D = deltas(C, K)
%   C : une ligne par trame ; D : même taille que C.
%   d_t = sum_{n=1..K} n (c_{t+n} - c_{t-n}) / (2 sum n^2), bords répétés.
%   Les delta-deltas s'obtiennent par deltas(deltas(C)).

    if nargin < 2, K = 2; end
    nT = size(C, 1);
    Cp = [repmat(C(1, :), K, 1); C; repmat(C(end, :), K, 1)];   % bords répétés
    D = zeros(size(C));
    for n = 1:K
        D = D + n * (Cp(K + n + (1:nT), :) - Cp(K - n + (1:nT), :));
    end
    D = D / (2 * sum((1:K).^2));
end
