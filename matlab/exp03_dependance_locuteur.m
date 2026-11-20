% EXP03_DEPENDANCE_LOCUTEUR  Test dépendant contre indépendant du locuteur
%   Indépendant : liste_test.txt (locuteurs jamais vus, partage officiel).
%   Dépendant   : liste_test_dependant.txt (autres répétitions des locuteurs de référence).
%   L'écart mesure la sensibilité de la méthode à la variabilité du locuteur.

cfg = configProjet();

refs = lireListe(fullfile(cfg.dossierListes, 'liste_references.txt'));
motsRef = infoFichiers(refs);
refsF = extraireListe(refs, cfg);

noms   = {'indépendant', 'dépendant'};
listes = {'liste_test.txt', 'liste_test_dependant.txt'};
acc = zeros(1, 2);
for k = 1:2
    test = lireListe(fullfile(cfg.dossierListes, listes{k}));
    motsTest = infoFichiers(test);
    preds = cell(numel(test), 1);
    for t = 1:numel(test)
        x = audioread(fullfile(cfg.racineDonnees, test{t}));
        preds{t} = classifierDTW(extraireCaracteristiques(x, cfg), refsF, motsRef);
    end
    acc(k) = mean(strcmp(preds, motsTest));
    fprintf('Test %s : %.1f %% sur %d mots\n', noms{k}, 100*acc(k), numel(test));
end

figure;  bar(100*acc);  set(gca, 'XTickLabel', noms);
ylabel('Accuracy (%)');  title('DTW + MFCC : effet du locuteur');  grid on;
if ~isfolder(cfg.dossierResultats), mkdir(cfg.dossierResultats); end
save(fullfile(cfg.dossierResultats, 'exp03_locuteur.mat'), 'acc');
saveas(gcf, fullfile(cfg.dossierResultats, 'exp03_locuteur.png'));
