% EXP07_DTW_VARIANTES  Corrélation contre DTW, et effet de la bande de Sakoe-Chiba (étape B6).
%   Utilise TA DTW (maDTW) : plus lente que dtw, d'où un test réduit (1 fichier sur 5).

cfg = configProjet();
refs = lireListe(fullfile(cfg.dossierListes, 'liste_references.txt'));
test = lireListe(fullfile(cfg.dossierListes, 'liste_test.txt'));
test = test(1:5:end);
motsRef  = infoFichiers(refs);
motsTest = infoFichiers(test);
refsF = extraireListe(refs, cfg);
testF = extraireListe(test, cfg);

% 1. Template matching par corrélation
preds = cellfun(@(F) reconnaitreCorrelation(F, refsF, motsRef), testF, 'UniformOutput', false);
accCorr = mean(strcmp(preds, motsTest));
fprintf('Corrélation normalisée : %.1f %%\n', 100 * accCorr);

% 2. DTW avec différentes largeurs de bande
bandes = [Inf 20 10 5];
accDTW = zeros(size(bandes));  tps = zeros(size(bandes));
for b = 1:numel(bandes)
    cfgb = cfg;  cfgb.dtwBande = bandes(b);
    tic;
    preds = cellfun(@(F) reconnaitreDTW(F, refsF, motsRef, cfgb), testF, 'UniformOutput', false);
    tps(b) = 1000 * toc / numel(test);
    accDTW(b) = mean(strcmp(preds, motsTest));
    fprintf('DTW, bande R = %g : %.1f %%, %.0f ms par mot\n', bandes(b), 100 * accDTW(b), tps(b));
end

if ~isfolder(cfg.dossierResultats), mkdir(cfg.dossierResultats); end
save(fullfile(cfg.dossierResultats, 'exp07_dtw_variantes.mat'), 'accCorr', 'bandes', 'accDTW', 'tps');
