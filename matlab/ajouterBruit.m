function y = ajouterBruit(x, b, snrDB)
% AJOUTERBRUIT  Ajoute le bruit b au signal x avec un SNR donné (étape C6).
%   y = ajouterBruit(x, b, snrDB)
%   x     : signal propre (vecteur colonne)
%   b     : bruit (vecteur colonne, répété s'il est plus court que x)
%   snrDB : SNR voulu en dB (Inf = aucun bruit ajouté)
%
%   la puissance du signal Ps est calculée sur tout le clip, silences compris.
%   Le SNR réel sur la seule partie parlée est donc un peu plus élevé.
%
%   Formule : g = sqrt( Ps / (Pb * 10^(SNR/10)) ), puis y = x + g*b.

    if isinf(snrDB)
        y = x;
        return
    end
    x = x(:);  b = b(:);
    if numel(b) < numel(x)
        b = repmat(b, ceil(numel(x)/numel(b)), 1);
    end
    debut = randi(numel(b) - numel(x) + 1);      % extrait aléatoire du bruit
    b = b(debut : debut + numel(x) - 1);

    Ps = mean(x.^2);
    Pb = mean(b.^2);
    g  = sqrt(Ps / (Pb * 10^(snrDB/10)));
    y  = x + g * b;
end
