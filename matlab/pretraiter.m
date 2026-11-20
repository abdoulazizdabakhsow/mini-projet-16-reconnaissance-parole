function [y, info] = pretraiter(x, cfg)
% PRETRAITER  Chaîne de prétraitement complète (étape A6, document 01).
%   [y, info] = pretraiter(x, cfg)
%   x : signal lu par audioread ; y : mot isolé et préaccentué, prêt pour mesMFCC
%   info : sorties de la VAD (pour les figures et la vérification)
%
%   Étapes : un canal -> centrage -> normalisation -> VAD -> préaccentuation.

    x = x(:, 1);
    x = x - mean(x);                         % retire la composante continue
    m = max(abs(x));
    if m > 0
        x = x / m;                           % amplitude entre -1 et 1
    end

    [debut, fin, info] = vad(x, cfg);        % on cherche le mot sur le signal brut
    info.debut = debut;  info.fin = fin;
    x = x(debut:fin);

    y = filter([1 -cfg.alpha], 1, x);        % préaccentuation y(n) = x(n) - alpha x(n-1)
end
