function [motPredit, logp] = hmmDiscretReconnaitre(F, modele)
% HMMDISCRETRECONNAITRE  Choisit le mot dont le HMM discret donne la plus grande vraisemblance.
%   [motPredit, logp] = hmmDiscretReconnaitre(F, modele)
%   logp(k) = log P(O | HMM du mot k), calculé par hmmdecode (algorithme Forward).

    seq = quantifierTrames(F, modele.dictionnaire);
    logp = zeros(numel(modele.mots), 1);
    for k = 1:numel(modele.mots)
        [~, logp(k)] = hmmdecode(seq, modele.TR{k}, modele.EM{k});
    end
    [~, kMax] = max(logp);
    motPredit = modele.mots{kMax};
end
