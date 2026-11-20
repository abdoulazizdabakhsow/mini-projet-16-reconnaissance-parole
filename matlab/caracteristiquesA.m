function F = caracteristiquesA(x, cfg)
% CARACTERISTIQUESA  Chaîne complète de la personne A : signal brut -> 39 caractéristiques par trame.
%   F = caracteristiquesA(x, cfg)
%   pretraiter -> mesMFCC -> deltas et delta-deltas -> CMVN.
%   Quand cette fonction est validée, C remplace le corps de son adaptateur
%   extraireCaracteristiques.m par :   F = caracteristiquesA(x, cfg);

    y = pretraiter(x, cfg);
    C = mesMFCC(y, cfg);
    D1 = deltas(C);
    D2 = deltas(D1);
    F = cmvn([C, D1, D2]);                   % 13 + 13 + 13 = 39 colonnes
end
