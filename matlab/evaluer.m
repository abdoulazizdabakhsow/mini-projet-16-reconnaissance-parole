function R = evaluer(vrais, predits, mots, afficher)
% EVALUER  Métriques de classification (étape C5, document 05, sections 3 et 7).
%   R = evaluer(vrais, predits, mots)
%   R = evaluer(vrais, predits, mots, true)   % affiche aussi la matrice de confusion
%
%   vrais, predits : cellules de chaînes (le vrai mot, le mot reconnu), même longueur
%   mots           : cellules des K mots du vocabulaire, dans l'ordre voulu
%
%   R contient :
%     R.accuracy, R.ic95        précision globale et demi-largeur de l'IC à 95 %
%     R.confusion               matrice K x K (ligne = vrai mot, colonne = mot reconnu)
%     R.precision, R.rappel, R.f1   vecteurs 1 x K, une valeur par mot
%     R.f1macro                 moyenne des F1

    if nargin < 4, afficher = false; end
    vrais = cellstr(vrais(:));  predits = cellstr(predits(:));
    K = numel(mots);

    % Précision globale et intervalle de confiance à 95 %
    R.n = numel(vrais);
    R.accuracy = mean(strcmp(vrais, predits));
    R.ic95 = 1.96 * sqrt(R.accuracy * (1 - R.accuracy) / R.n);

    % Matrice de confusion (calculée à la main : aucune toolbox nécessaire)
    [~, iv] = ismember(vrais, mots);
    [~, ip] = ismember(predits, mots);
    ok = iv > 0 & ip > 0;                       % ignore un éventuel mot hors vocabulaire
    C = accumarray([iv(ok) ip(ok)], 1, [K K]);
    R.confusion = C;

    % Précision, rappel et F1 par mot, puis F1 macro (document 05, section 3.3)
    tp     = diag(C)';          % bien classés, vecteur 1 x K
    nVrai  = sum(C, 2)';        % somme de chaque ligne : nombre de vrais exemples du mot
    nPred  = sum(C, 1);         % somme de chaque colonne : nombre de fois où le mot a été prédit

    R.rappel    = tp ./ max(nVrai, 1);
    R.precision = tp ./ max(nPred, 1);
    R.f1        = 2 * R.precision .* R.rappel ./ max(R.precision + R.rappel, eps);
    R.f1macro   = mean(R.f1);

    % Affichage
    fprintf('Accuracy = %.1f %% (IC 95 %% : +/- %.1f points), %d mots testés\n', ...
            100*R.accuracy, 100*R.ic95, R.n);
    fprintf('%-8s %10s %8s %8s\n', 'mot', 'précision', 'rappel', 'F1');
    for k = 1:K
        fprintf('%-8s %10.3f %8.3f %8.3f\n', mots{k}, R.precision(k), R.rappel(k), R.f1(k));
    end
    fprintf('F1 macro = %.3f\n', R.f1macro);
    if afficher
        figure;
        cc = confusionchart(C, mots);
        cc.RowSummary = 'row-normalized';
        cc.Title = sprintf('Accuracy = %.1f %%', 100*R.accuracy);
    end
end
