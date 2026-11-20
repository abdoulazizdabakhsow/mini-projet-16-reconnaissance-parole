function [dist, chemin, Dcum] = maDTW(A, B, R)
% MADTW  Alignement temporel dynamique (étape B3, document 03, section 4).
%   [dist, chemin, Dcum] = maDTW(A, B)
%   [dist, chemin, Dcum] = maDTW(A, B, R)     avec une bande de Sakoe-Chiba de demi-largeur R
%   A : matrice D x I, B : matrice D x J, UNE COLONNE PAR TRAME (même convention que dtw)
%   dist   : coût cumulé D(I, J), non normalisé (comme dtw)
%   chemin : matrice L x 2 des couples (i, j) du chemin optimal
%   Dcum   : tableau des coûts cumulés (I+1) x (J+1), avec une ligne et une colonne fantômes

    if nargin < 3, R = Inf; end
    I = size(A, 2);  J = size(B, 2);

    % 1. Distances locales euclidiennes entre toutes les paires de trames (I x J)
    d = sqrt(max(sum(A.^2, 1)' + sum(B.^2, 1) - 2 * (A' * B), 0));

    % 2. Coûts cumulés : Dcum(i+1, j+1) correspond à la case (i, j) du document 03
    Dcum = inf(I + 1, J + 1);
    Dcum(1, 1) = 0;
    for i = 1:I
        jCentre = round(1 + (i - 1) * (J - 1) / max(I - 1, 1));   % diagonale de (1,1) à (I,J)
        for j = max(1, jCentre - R) : min(J, jCentre + R)
            Dcum(i + 1, j + 1) = d(i, j) + min([Dcum(i, j + 1), Dcum(i, j), Dcum(i + 1, j)]);

        end
    end
    dist = Dcum(I + 1, J + 1);

    % 3. Remontée du chemin optimal depuis (I, J)
    chemin = [];
    if isinf(dist), return; end
    i = I;  j = J;
    chemin = [i, j];
    while i > 1 || j > 1
        [~, k] = min([Dcum(i, j), Dcum(i, j + 1), Dcum(i + 1, j)]);   % (i-1,j-1), (i-1,j), (i,j-1)
        if k == 1
            i = i - 1;  j = j - 1;
        elseif k == 2
            i = i - 1;
        else
            j = j - 1;
        end
        chemin = [i, j; chemin]; %#ok<AGROW>
    end
end
