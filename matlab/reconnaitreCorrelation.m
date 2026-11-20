function [motPredit, scores] = reconnaitreCorrelation(F, refsF, refsMots, L)
% RECONNAITRECORRELATION  Plus proche voisin au sens de la corrélation (étape B5).
%   [motPredit, scores] = reconnaitreCorrelation(F, refsF, refsMots)
%   [motPredit, scores] = reconnaitreCorrelation(F, refsF, refsMots, L)   (L = 50 par défaut)
%   On garde la référence de corrélation MAXIMALE (et non de distance minimale).

    if nargin < 4, L = 50; end
    scores = zeros(numel(refsF), 1);
    for r = 1:numel(refsF)
        scores(r) = scoreCorrelation(F, refsF{r}, L);
    end
    [~, iMax] = max(scores);
    motPredit = refsMots{iMax};
end
