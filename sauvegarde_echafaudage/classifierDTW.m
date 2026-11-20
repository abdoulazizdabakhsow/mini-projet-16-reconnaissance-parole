function [motPredit, dists] = classifierDTW(F, refsF, refsMots)
% CLASSIFIERDTW  Plus proche voisin par DTW (1-NN).
%   [motPredit, dists] = classifierDTW(F, refsF, refsMots)
%   F        : caractéristiques du mot inconnu (une ligne par trame)
%   refsF    : cellules des caractéristiques des références (une ligne par trame)
%   refsMots : cellules du mot de chaque référence
%

    dists = zeros(numel(refsF), 1);
    for r = 1:numel(refsF)
        d = dtw(F', refsF{r}');
        dists(r) = d / (size(F, 1) + size(refsF{r}, 1));   % normalisation par I + J
    end
    [~, iMin] = min(dists);
    motPredit = refsMots{iMin};
end
