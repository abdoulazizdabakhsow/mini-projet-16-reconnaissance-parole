function [motPredit, scores] = hmmGMMReconnaitre(F, modele)
% HMMGMMRECONNAITRE  Choisit le mot dont le HMM-GMM donne le meilleur score de Viterbi.
%   [motPredit, scores] = hmmGMMReconnaitre(F, modele)
%   F : caractéristiques du mot inconnu (une ligne par trame)

    nMots = numel(modele.mots);
    scores = zeros(nMots, 1);
    for k = 1:nMots
        N = numel(modele.gm{k});
        logPi = log([1; zeros(N - 1, 1)]);
        scores(k) = hmmViterbiLog(logEmissions(modele.gm{k}, F), modele.logA{k}, logPi);
    end
    [~, kMax] = max(scores);
    motPredit = modele.mots{kMax};
end
