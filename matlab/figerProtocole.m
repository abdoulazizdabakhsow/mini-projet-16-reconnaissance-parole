% FIGERPROTOCOLE  Tire et enregistre les listes communes à tout le groupe (étape C4).
%   À lancer UNE SEULE FOIS. Produit dans donnees/listes/ :
%     liste_test.txt            100 fichiers par mot, locuteurs jamais vus (testing_list)
%     liste_validation.txt      30 fichiers par mot, pour régler les paramètres
%     liste_references.txt      20 références DTW par mot, un locuteur différent chacune
%     liste_test_dependant.txt  autres répétitions des locuteurs de référence
%                               (test "dépendant du locuteur", document 05, section 2.2)
%   Ces fichiers sont ensuite envoyés à A et B : tout le monde teste sur les mêmes.

cfg = configProjet();
rng(cfg.graine);                         % tirages reproductibles
D = chargerDonnees(cfg);

[motsApp, locApp] = infoFichiers(D.app);
motsVal  = infoFichiers(D.val);
motsTest = infoFichiers(D.test);

test = {};  val = {};  refs = {};  dep = {};
for k = 1:numel(cfg.mots)
    m = cfg.mots{k};

    % Test (indépendant du locuteur) et validation : tirage au hasard
    cand = D.test(strcmp(motsTest, m));
    test = [test; cand(randperm(numel(cand), cfg.nTestParMot))]; %#ok<AGROW>
    cand = D.val(strcmp(motsVal, m));
    val  = [val;  cand(randperm(numel(cand), cfg.nValParMot))];   %#ok<AGROW>

    % Références : mélange, puis un seul fichier par locuteur (diversité maximale)
    iMot = find(strcmp(motsApp, m));
    iMot = iMot(randperm(numel(iMot)));
    [~, premier] = unique(locApp(iMot), 'stable');
    choisis = iMot(premier(1:cfg.nRefParMot));
    refs = [refs; D.app(choisis)]; %#ok<AGROW>

    % Test dépendant : les AUTRES répétitions de ces mêmes locuteurs
    memeLoc = iMot(ismember(locApp(iMot), locApp(choisis)));
    autres  = setdiff(memeLoc, choisis);
    dep = [dep; D.app(autres)]; %#ok<AGROW>
end

if ~isfolder(cfg.dossierListes), mkdir(cfg.dossierListes); end
ecrireListe(fullfile(cfg.dossierListes, 'liste_test.txt'), test);
ecrireListe(fullfile(cfg.dossierListes, 'liste_validation.txt'), val);
ecrireListe(fullfile(cfg.dossierListes, 'liste_references.txt'), refs);
ecrireListe(fullfile(cfg.dossierListes, 'liste_test_dependant.txt'), dep);

fprintf('\nListes écrites dans %s\n', cfg.dossierListes);
fprintf('  test : %d   validation : %d   références : %d   test dépendant : %d\n', ...
        numel(test), numel(val), numel(refs), numel(dep));

function ecrireListe(fichier, liste)
    fid = fopen(fichier, 'w');
    fprintf(fid, '%s\n', liste{:});
    fclose(fid);
end
