function T = decouperTrames(x, N, H)
% DECOUPERTRAMES  Découpe un signal en trames qui se chevauchent (document 01, section 4).
%   T = decouperTrames(x, N, H)
%   x : signal (vecteur), N : longueur d'une trame, H : pas entre deux trames
%   T : matrice N x K, UNE TRAME PAR COLONNE, avec K = 1 + floor((L - N) / H)
%
%   Exemple : 1 s à 16 kHz, N = 400, H = 160  ->  T est de taille 400 x 98.

    x = x(:);
    if numel(x) < N                          % signal trop court : on complète par des zéros
        x = [x; zeros(N - numel(x), 1)];
    end
    K = 1 + floor((numel(x) - N) / H);
    indices = (1:N)' + (0:K-1) * H;          % matrice N x K des indices de chaque trame
    T = x(indices);
end
