function [motPredit, dists] = reconnaitreDTW(F, refsF, refsMots, cfg)
% RECONNAITREDTW  Reconnaissance par DTW et k plus proches voisins (étape B4, document 03, sections 5 et 6).
%   [motPredit, dists] = reconnaitreDTW(F, refsF, refsMots, cfg)
%   F        : caractéristiques du mot inconnu, UNE LIGNE PAR TRAME (sortie de mfcc ou caracteristiquesA)
%   refsF    : cellules des caractéristiques des références (même format)
%   refsMots : cellules du mot de chaque référence
%   cfg.dtwBande : demi-largeur de bande ; cfg.kVoisins : nombre de voisins qui votent
%
%   Quand cette fonction est validée, C remplace le corps de son adaptateur
%   classifierDTW.m par :   [motPredit, dists] = reconnaitreDTW(F, refsF, refsMots, configProjet());

    dists = zeros(numel(refsF), 1);
    for r = 1:numel(refsF)
        d = maDTW(F', refsF{r}', cfg.dtwBande);              % transposition : une colonne par trame
        dists(r) = d / (size(F, 1) + size(refsF{r}, 1));     % normalisation par I + J
    end

    [~, ordre] = sort(dists);
    voisins = refsMots(ordre(1:cfg.kVoisins));
    [mots, ~, ic] = unique(voisins);
    votes = accumarray(ic(:), 1);
    gagnants = mots(votes == max(votes));
    % en cas d'égalité, on garde le mot du voisin le plus proche
    motPredit = voisins{find(ismember(voisins, gagnants), 1)};
end
