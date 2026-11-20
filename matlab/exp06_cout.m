% EXP06_COUT  Temps de calcul, facteur temps réel et mémoire.

cfg = configProjet();
refs = lireListe(fullfile(cfg.dossierListes, 'liste_references.txt'));
test = lireListe(fullfile(cfg.dossierListes, 'liste_test.txt'));
motsRef = infoFichiers(refs);
refsF = extraireListe(refs, cfg);

x = audioread(fullfile(cfg.racineDonnees, test{1}));
duree = numel(x) / cfg.fs;                                   % durée du clip (s)
F = extraireCaracteristiques(x, cfg);

tExtr  = timeit(@() extraireCaracteristiques(x, cfg));       % s
tClass = timeit(@() classifierDTW(F, refsF, motsRef));       % s
RTF = (tExtr + tClass) / duree;

nNombres = sum(cellfun(@numel, refsF));                      % valeurs stockées par la DTW
fprintf('Extraction     : %.1f ms\n', 1000*tExtr);
fprintf('Reconnaissance : %.1f ms (%d références)\n', 1000*tClass, numel(refs));
fprintf('Facteur temps réel : %.3f (utilisable en temps réel si < 1)\n', RTF);
fprintf('Mémoire des références : %d nombres, soit %.1f Ko en double, %.1f Ko en 8 bits\n', ...
        nNombres, nNombres*8/1024, nNombres/1024);
fprintf('Machine : %s\n', computer);

if ~isfolder(cfg.dossierResultats), mkdir(cfg.dossierResultats); end
save(fullfile(cfg.dossierResultats, 'exp06_cout.mat'), 'tExtr', 'tClass', 'RTF', 'nNombres');
