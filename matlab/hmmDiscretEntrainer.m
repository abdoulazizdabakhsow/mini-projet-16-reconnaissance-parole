function modele = hmmDiscretEntrainer(Fapp, motsApp, cfg)
% HMMDISCRETENTRAINER  Un HMM discret gauche-droite par mot (étape B8, document 04, section 9, option A).
%   modele = hmmDiscretEntrainer(Fapp, motsApp, cfg)
%   Fapp    : cellules de caractéristiques d'apprentissage (une ligne par trame)
%   motsApp : cellules du mot de chaque exemple
%   modele  : dictionnaire de quantification + matrices TR et EM de chaque mot
%
%   1. Quantification vectorielle : kmeans sur toutes les trames -> cfg.hmmSymboles vecteurs types.
%   2. Initialisation par découpage uniforme de chaque exemple en cfg.hmmEtats segments.
%   3. Baum-Welch avec hmmtrain (Statistics and Machine Learning Toolbox).

    N = cfg.hmmEtats;  M = cfg.hmmSymboles;
    X = vertcat(Fapp{:});
    [~, dictionnaire] = kmeans(X, M, 'MaxIter', 200);
    modele.dictionnaire = dictionnaire;
    modele.mots = cfg.mots;

    % Transitions initiales gauche-droite : rester 0,8, avancer 0,2, dernier état absorbant
    TR0 = diag(0.8 * ones(1, N)) + diag(0.2 * ones(1, N - 1), 1);
    TR0(N, N) = 1;

    for k = 1:numel(cfg.mots)
        seqs = cellfun(@(F) quantifierTrames(F, dictionnaire), ...
                       Fapp(strcmp(motsApp, cfg.mots{k})), 'UniformOutput', false);
        % Émissions initiales : comptage après découpage uniforme (+1 pour éviter les zéros)
        EM0 = ones(N, M);
        for s = 1:numel(seqs)
            T = numel(seqs{s});
            etats = ceil((1:T) * N / T);
            EM0 = EM0 + accumarray([etats(:), seqs{s}(:)], 1, [N M]);
        end
        EM0 = EM0 ./ sum(EM0, 2);
        [modele.TR{k}, modele.EM{k}] = hmmtrain(seqs, TR0, EM0, ...
            'Pseudoemissions', 1e-3 * ones(N, M), 'Maxiterations', 100);
        fprintf('HMM discret appris pour « %s » (%d exemples)\n', cfg.mots{k}, numel(seqs));
    end
end
