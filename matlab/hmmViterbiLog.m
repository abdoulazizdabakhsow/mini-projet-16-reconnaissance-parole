function [score, chemin] = hmmViterbiLog(logB, logA, logPi)
% HMMVITERBILOG  Algorithme de Viterbi en logarithme (étape B9, document 04, section 6).
%   [score, chemin] = hmmViterbiLog(logB, logA, logPi)
%   logB  : N x T, logB(j, t) = log b_j(o_t), log-vraisemblance de la trame t dans l'état j
%   logA  : N x N, log des probabilités de transition
%   logPi : N x 1, log des probabilités initiales
%   score : log de la probabilité du meilleur chemin (fin imposée dans le dernier état
%           si c'est possible, comme pour un mot gauche-droite)
%   chemin: 1 x T, la meilleure suite d'états

    [N, T] = size(logB);
    delta = -inf(N, T);                  % delta(j, t) = meilleur log-score pour être en j à t
    psi = zeros(N, T);                   % psi(j, t)   = état précédent sur ce meilleur chemin
    delta(:, 1) = logPi(:) + logB(:, 1);

    for t = 2:T
        
        [meilleur, precedent] = max(delta(:, t- 1) + logA, [], 1); % 1 x N : max sur i pour chaque j
         delta(:, t) = meilleur' + logB(:, t);
         psi(:, t) = precedent';
       
    end

    % Fin : dernier état si atteignable, sinon le meilleur état final
    if isinf(delta(N, T))
        [score, fin] = max(delta(:, T));
    else
        score = delta(N, T);  fin = N;
    end
    chemin = zeros(1, T);
    chemin(T) = fin;
    for t = T-1:-1:1
        chemin(t) = psi(chemin(t + 1), t + 1);
    end
end
