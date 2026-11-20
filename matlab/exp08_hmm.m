% EXP08_HMM  Apprentissage et évaluation des HMM discret et HMM-GMM.
%   1. Tire cfg.nAppHMMParMot exemples d'apprentissage par mot (reproductible).
%   2. Règle le nombre d'états et de gaussiennes sur la VALIDATION (jamais sur le test).
%   3. Évalue les deux modèles sur la liste de test commune, avec evaluer.

cfg = configProjet();
rng(cfg.graine);

% --- 1. Données d'apprentissage : tirées dans l'ensemble d'apprentissage officiel
D = chargerDonnees(cfg);
motsApp = infoFichiers(D.app);
app = {};
for k = 1:numel(cfg.mots)
    cand = D.app(strcmp(motsApp, cfg.mots{k}));
    app = [app; cand(randperm(numel(cand), cfg.nAppHMMParMot))]; %#ok<AGROW>
end
motsApp = infoFichiers(app);
val  = lireListe(fullfile(cfg.dossierListes, 'liste_validation.txt'));
test = lireListe(fullfile(cfg.dossierListes, 'liste_test.txt'));
motsVal = infoFichiers(val);  motsTest = infoFichiers(test);

fprintf('Extraction des caractéristiques...\n');
Fapp = extraireListe(app, cfg);
Fval = extraireListe(val, cfg);
Ftest = extraireListe(test, cfg);

% --- 2. Réglage du HMM-GMM sur la validation
etatsTestes = [4 6 8];  gaussTestees = [1 2 4];
accVal = zeros(numel(etatsTestes), numel(gaussTestees));
for a = 1:numel(etatsTestes)
    for b = 1:numel(gaussTestees)
        cfgr = cfg;  cfgr.hmmEtats = etatsTestes(a);  cfgr.hmmGaussiennes = gaussTestees(b);
        modele = hmmGMMEntrainer(Fapp, motsApp, cfgr);
        preds = cellfun(@(F) hmmGMMReconnaitre(F, modele), Fval, 'UniformOutput', false);
        accVal(a, b) = mean(strcmp(preds, motsVal));
        fprintf('N = %d états, K = %d gaussiennes : %.1f %% (validation)\n', ...
                etatsTestes(a), gaussTestees(b), 100 * accVal(a, b));
    end
end
[~, iMax] = max(accVal(:));
[a, b] = ind2sub(size(accVal), iMax);
cfg.hmmEtats = etatsTestes(a);  cfg.hmmGaussiennes = gaussTestees(b);
fprintf('Réglage retenu : N = %d, K = %d\n', cfg.hmmEtats, cfg.hmmGaussiennes);

% --- 3. Évaluation finale sur le test
modeleGMM = hmmGMMEntrainer(Fapp, motsApp, cfg);
tic;
predsGMM = cellfun(@(F) hmmGMMReconnaitre(F, modeleGMM), Ftest, 'UniformOutput', false);
tpsGMM = 1000 * toc / numel(test);
disp('--- HMM-GMM ---');
R_gmm = evaluer(motsTest, predsGMM, cfg.mots, true);

modeleVQ = hmmDiscretEntrainer(Fapp, motsApp, cfg);
tic;
predsVQ = cellfun(@(F) hmmDiscretReconnaitre(F, modeleVQ), Ftest, 'UniformOutput', false);
tpsVQ = 1000 * toc / numel(test);
disp('--- HMM discret ---');
R_vq = evaluer(motsTest, predsVQ, cfg.mots, true);
fprintf('Temps de reconnaissance : HMM-GMM %.1f ms, HMM discret %.1f ms par mot\n', tpsGMM, tpsVQ);

if ~isfolder(cfg.dossierResultats), mkdir(cfg.dossierResultats); end
save(fullfile(cfg.dossierResultats, 'exp08_hmm.mat'), 'accVal', 'etatsTestes', 'gaussTestees', ...
     'R_gmm', 'R_vq', 'tpsGMM', 'tpsVQ', 'predsGMM', 'predsVQ');
