% TESTVITERBIJOUET  Vérifie hmmViterbiLog sur l'exemple jouet du document 04 (section 6).
%   2 états, observations N (non voisée) et V (voisée), O = (N, N, V).
%   Attendu : meilleur chemin (1, 1, 2), probabilité 0,10752.

logPi = log([1; 0]);
logA  = log([0.6 0.4; 0 1]);
b = [0.8 0.2;      % état 1 (consonne) : b1(N), b1(V)
     0.3 0.7];     % état 2 (voyelle)  : b2(N), b2(V)
obs = [1 1 2];     % N, N, V
logB = log(b(:, obs));          % 2 x 3

[score, chemin] = hmmViterbiLog(logB, logA, logPi);
fprintf('Chemin trouvé : %s   (attendu : 1 1 2)\n', num2str(chemin));
fprintf('Probabilité   : %.5f (attendu : 0.10752)\n', exp(score));
