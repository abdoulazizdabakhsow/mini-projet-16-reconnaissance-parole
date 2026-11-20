function logB = logEmissions(gm, F)
% LOGEMISSIONS  Log-vraisemblance de chaque trame dans chaque état d'un HMM-GMM.
%   logB = logEmissions(gm, F)
%   gm : cellules de N objets gmdistribution (un GMM par état, sortie de fitgmdist)
%   F  : une ligne par trame (T trames)
%   logB : N x T, logB(j, t) = log b_j(o_t)

    N = numel(gm);
    logB = zeros(N, size(F, 1));
    for j = 1:N
        logB(j, :) = log(pdf(gm{j}, F) + realmin)';
    end
end
