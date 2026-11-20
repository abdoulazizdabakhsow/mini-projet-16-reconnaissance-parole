function Fs = extraireListe(liste, cfg)
% EXTRAIRELISTE  Caractéristiques de tous les fichiers d'une liste.
%   Fs = extraireListe(liste, cfg) renvoie une cellule par fichier.

    Fs = cell(numel(liste), 1);
    for i = 1:numel(liste)
        x = audioread(fullfile(cfg.racineDonnees, liste{i}));
        Fs{i} = extraireCaracteristiques(x, cfg);
    end
end
