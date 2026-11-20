function r = scoreCorrelation(A, B, L)
% SCORECORRELATION  Template matching par corrélation normalisée (étape B5, document 03, section 3).
%   r = scoreCorrelation(A, B, L)
%   A, B : caractéristiques, UNE LIGNE PAR TRAME ; L : longueur commune (par exemple 50 trames)
%   r    : coefficient de corrélation entre -1 et 1 (1 = formes identiques)
%
%   Les deux mots sont d'abord rééchantillonnés à L trames par interpolation linéaire :
%   c'est la « représentation temporelle normalisée » demandée par l'énoncé.

    A = interp1(linspace(0, 1, size(A, 1)), A, linspace(0, 1, L));   % L x D
    B = interp1(linspace(0, 1, size(B, 1)), B, linspace(0, 1, L));
    a = A(:) - mean(A(:));
    b = B(:) - mean(B(:));
    r = (a' * b) / (norm(a) * norm(b));
end
