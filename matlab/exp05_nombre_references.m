% EXP05_NOMBRE_REFERENCES  Accuracy et temps selon le nombre de références par mot.
%   Illustre le compromis performance / coût de calcul de la DTW.
%   liste_references.txt contient 20 références par mot ; on garde les n premières de chaque mot.

cfg = configProjet();

refs = lireListe(fullfile(cfg.dossierListes, 'liste_references.txt'));
test = lireListe(fullfile(cfg.dossierListes, 'liste_test.txt'));
motsRef  = infoFichiers(refs);
motsTest = infoFichiers(test);
refsF = extraireListe(refs, cfg);
testF = extraireListe(test, cfg);            % extrait une seule fois

% rang de chaque référence à l'intérieur de son mot (1, 2, ..., 20)
rang = zeros(numel(refs), 1);
for k = 1:numel(cfg.mots)
    i = find(strcmp(motsRef, cfg.mots{k}));
    rang(i) = 1:numel(i);
end

nRefs = [1 5 10 20];
acc = zeros(size(nRefs));  tps = zeros(size(nRefs));
for k = 1:numel(nRefs)
    garde = rang <= nRefs(k);
    preds = cell(numel(test), 1);
    tic;
    for t = 1:numel(test)
        preds{t} = classifierDTW(testF{t}, refsF(garde), motsRef(garde));
    end
    tps(k) = 1000 * toc / numel(test);
    acc(k) = mean(strcmp(preds, motsTest));
    fprintf('%2d références par mot : %.1f %%, %.1f ms par mot\n', nRefs(k), 100*acc(k), tps(k));
end

figure;                                       % deux graphiques séparés, pas de double axe
subplot(1, 2, 1);  plot(nRefs, 100*acc, '-o');  grid on;
xlabel('Références par mot');  ylabel('Accuracy (%)');  title('Précision');
subplot(1, 2, 2);  plot(nRefs, tps, '-s');  grid on;
xlabel('Références par mot');  ylabel('ms par mot');  title('Temps de reconnaissance');
if ~isfolder(cfg.dossierResultats), mkdir(cfg.dossierResultats); end
save(fullfile(cfg.dossierResultats, 'exp05_references.mat'), 'nRefs', 'acc', 'tps');
saveas(gcf, fullfile(cfg.dossierResultats, 'exp05_references.png'));
