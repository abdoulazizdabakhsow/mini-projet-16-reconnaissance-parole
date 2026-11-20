function modele = hmmGMMEntrainer(Fapp, motsApp, cfg)
% HMMGMMENTRAINER  HMM-GMM gauche-droite par entraînement de Viterbi (étape B10, document 04, section 7.2).
%   modele = hmmGMMEntrainer(Fapp, motsApp, cfg)
%   Pour chaque mot :
%     1. découpage uniforme de chaque exemple en cfg.hmmEtats segments ;
%     2. un GMM par état (fitgmdist) sur les trames attribuées à cet état ;
%        transitions estimées en comptant les trames qui restent dans l'état ;
%     3. réalignement de chaque exemple par Viterbi (hmmViterbiLog) ;
%     4. on recommence 2 et 3 cfg.hmmIterations fois.

    N = cfg.hmmEtats;  K = cfg.hmmGaussiennes;
    logPi = log([1; zeros(N - 1, 1)]);
    options = statset('MaxIter', 200);
    modele.mots = cfg.mots;

    for k = 1:numel(cfg.mots)
        Fs = Fapp(strcmp(motsApp, cfg.mots{k}));
        etats = cellfun(@(F) ceil((1:size(F, 1))' * N / size(F, 1)), Fs, 'UniformOutput', false);

        for it = 1:cfg.hmmIterations
            % 2a. Un GMM par état
            X = vertcat(Fs{:});  E = vertcat(etats{:});
            gm = cell(N, 1);
            for j = 1:N
                gm{j} = fitgmdist(X(E == j, :), K, 'CovarianceType', 'diagonal', ...
                                  'RegularizationValue', 1e-3, 'Options', options);
            end
            % 2b. Transitions : a_jj = trames restées en j / trames passées en j
            reste = zeros(N, 1);  total = zeros(N, 1);
            for s = 1:numel(etats)
                e = etats{s};
                for j = 1:N
                    total(j) = total(j) + sum(e(1:end-1) == j);
                    reste(j) = reste(j) + sum(e(1:end-1) == j & e(2:end) == j);
                end
            end
            aii = (reste + 1) ./ (total + 2);              % +1 / +2 : évite 0 et 1 exacts
            A = diag(aii) + diag(1 - aii(1:N-1), 1);
            A(N, N) = 1;
            logA = log(A);
            % 3. Réalignement par Viterbi
            for s = 1:numel(Fs)
                [~, ch] = hmmViterbiLog(logEmissions(gm, Fs{s}), logA, logPi);
                etats{s} = ch(:);
            end
        end
        modele.gm{k} = gm;
        modele.logA{k} = logA;
        fprintf('HMM-GMM appris pour « %s » (%d exemples)\n', cfg.mots{k}, numel(Fs));
    end
end
