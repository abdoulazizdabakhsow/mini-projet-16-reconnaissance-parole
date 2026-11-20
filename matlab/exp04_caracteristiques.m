% EXP04_CARACTERISTIQUES  Comparaison des représentations avec la même DTW.
%   Variantes : FBANK, MFCC, MFCC + deltas, MFCC + deltas + CMVN (Hamming), puis la meilleure avec Hann.
%   Pour aller plus vite, le test est réduit à 1 fichier sur 2.

cfg = configProjet();
refs = lireListe(fullfile(cfg.dossierListes, 'liste_references.txt'));
test = lireListe(fullfile(cfg.dossierListes, 'liste_test.txt'));
%test = test(1:2:end);
motsRef  = infoFichiers(refs);
motsTest = infoFichiers(test);

noms = {'FBANK', 'MFCC', 'MFCC+delta', 'MFCC+delta+CMVN', 'idem, fenêtre Hann'};
acc = zeros(1, numel(noms));
for v = 1:numel(noms)
    cfgv = cfg;
    if v == 5, cfgv.fenetre = 'hann'; end
    extraire = @(x) variante(x, cfgv, min(v, 4));
    refsF = cellfun(@(f) extraire(audioread(fullfile(cfg.racineDonnees, f))), refs, 'UniformOutput', false);
    preds = cell(numel(test), 1);
    for t = 1:numel(test)
        F = extraire(audioread(fullfile(cfg.racineDonnees, test{t})));
        preds{t} = classifierDTW(F, refsF, motsRef);
    end
    acc(v) = mean(strcmp(preds, motsTest));
    fprintf('%-22s : %.1f %%\n', noms{v}, 100 * acc(v));
end

figure;  bar(100 * acc);  set(gca, 'XTickLabel', noms);  xtickangle(20);
ylabel('Accuracy (%)');  title('DTW : effet de la représentation');  grid on;
if ~isfolder(cfg.dossierResultats), mkdir(cfg.dossierResultats); end
save(fullfile(cfg.dossierResultats, 'exp04_caracteristiques.mat'), 'noms', 'acc');
saveas(gcf, fullfile(cfg.dossierResultats, 'exp04_caracteristiques.png'));

function F = variante(x, cfg, type)
    y = pretraiter(x, cfg);
    [C, fbank] = mesMFCC(y, cfg);
    switch type
        case 1, F = fbank;
        case 2, F = C;
        case 3, F = [C, deltas(C), deltas(deltas(C))];
        case 4, F = cmvn([C, deltas(C), deltas(deltas(C))]);
    end
end
