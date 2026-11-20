function D = chargerDonnees(cfg)
% CHARGERDONNEES  Inventaire de Speech Commands et partage officiel (étape C3).
%   D = chargerDonnees(cfg) renvoie une structure avec trois champs :
%       D.app  : fichiers d'apprentissage (ni validation, ni test)
%       D.val  : fichiers listés dans validation_list.txt
%       D.test : fichiers listés dans testing_list.txt
%   Chaque champ est un tableau de cellules de chemins relatifs
%   ('mot/locuteur_nohash_n.wav'). Le partage officiel garantit qu'un
%   locuteur n'apparaît jamais dans deux ensembles (document 05, section 1.2).
%
%   N'utilise aucune toolbox : seulement dir et fileread.

    racine = cfg.racineDonnees;
    if ~isfolder(racine)
        error('Dossier introuvable : %s. As-tu décompressé la base ?', racine);
    end

    % 1. Inventaire de tous les .wav, dossier de mot par dossier de mot
    dossiers = dir(racine);
    dossiers = dossiers([dossiers.isdir]);
    noms = {dossiers.name};
    noms = noms(~ismember(noms, {'.', '..', '_background_noise_'}));

    tous = {};
    for k = 1:numel(noms)
        f = dir(fullfile(racine, noms{k}, '*.wav'));
        tous = [tous; strcat(noms{k}, '/', {f.name}')]; %#ok<AGROW>
    end

    % 2. Partage officiel
    listeVal  = lireListe(fullfile(racine, 'validation_list.txt'));
    listeTest = lireListe(fullfile(racine, 'testing_list.txt'));
    estVal  = ismember(tous, listeVal);
    estTest = ismember(tous, listeTest);

    D.app  = tous(~estVal & ~estTest);
    D.val  = tous(estVal);
    D.test = tous(estTest);

    % 3. Résumé pour les 10 mots du projet
    motsApp  = infoFichiers(D.app);
    motsVal  = infoFichiers(D.val);
    motsTest = infoFichiers(D.test);
    fprintf('%-8s %8s %8s %8s\n', 'mot', 'app', 'val', 'test');
    for k = 1:numel(cfg.mots)
        m = cfg.mots{k};
        fprintf('%-8s %8d %8d %8d\n', m, sum(strcmp(motsApp, m)), ...
                sum(strcmp(motsVal, m)), sum(strcmp(motsTest, m)));
    end
    fprintf('Total base : %d fichiers (%d app, %d val, %d test)\n', ...
            numel(tous), numel(D.app), numel(D.val), numel(D.test));
end
