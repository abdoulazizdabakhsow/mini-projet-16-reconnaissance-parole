% EXP01_CHAINE_COMPLETE  Première chaîne de bout en bout : DTW sur signal propre (étape C7).
%   Produit le premier chiffre du projet (la baseline) et une matrice de confusion.
%   Résultats : rapport/resultats/exp01_dtw_propre.mat

cfg = configProjet();
rng(cfg.graine);

refs = lireListe(fullfile(cfg.dossierListes, 'liste_references.txt'));
test = lireListe(fullfile(cfg.dossierListes, 'liste_test.txt'));
motsRef  = infoFichiers(refs);
motsTest = infoFichiers(test);

fprintf('Extraction des %d références...\n', numel(refs));
refsF = extraireListe(refs, cfg);

fprintf('Reconnaissance des %d mots de test...\n', numel(test));
preds = cell(numel(test), 1);
temps = zeros(numel(test), 1);
for t = 1:numel(test)
    x = audioread(fullfile(cfg.racineDonnees, test{t}));
    tic;
    F = extraireCaracteristiques(x, cfg);
    preds{t} = classifierDTW(F, refsF, motsRef);
    temps(t) = toc;
    if mod(t, 100) == 0, fprintf('  %d / %d\n', t, numel(test)); end
end

R = evaluer(motsTest, preds, cfg.mots, true);
fprintf('Temps moyen par mot (extraction + reconnaissance) : %.1f ms\n', 1000*mean(temps));

if ~isfolder(cfg.dossierResultats), mkdir(cfg.dossierResultats); end
save(fullfile(cfg.dossierResultats, 'exp01_dtw_propre.mat'), 'R', 'preds', 'temps');
