function cfg = configProjet()
% CONFIGPROJET  Réglages communs à tout le projet (chemins, vocabulaire, protocole).
%   cfg = configProjet() renvoie une structure utilisée par tous les scripts.
%   Tous les réglages sont ici : on ne les écrit jamais "en dur" ailleurs.
%
%   Exemple :
%       cfg = configProjet();
%       disp(cfg.mots)

    % Dossier mini-projet (ce fichier est dans mini-projet/matlab/)
    racineProjet = fileparts(fileparts(mfilename('fullpath')));

    % Chemins
    cfg.racineDonnees    = fullfile(racineProjet, 'donnees', 'speech_commands');
    cfg.dossierListes    = fullfile(racineProjet, 'donnees', 'listes');
    cfg.dossierResultats = fullfile(racineProjet, 'rapport', 'resultats');

    % Vocabulaire : les 10 mots du protocole à 12 classes de Speech Commands
    cfg.mots = {'yes','no','up','down','left','right','on','off','stop','go'};

    % Protocole (document 05, section 1.5)
    cfg.fs          = 16000;   % fréquence d'échantillonnage (Hz)
    cfg.nTestParMot = 100;     % fichiers de test par mot
    cfg.nValParMot  = 30;      % fichiers de validation par mot (réglages)
    cfg.nRefParMot  = 20;      % références DTW par mot (un locuteur différent chacune)
    cfg.graine      = 0;       % graine aléatoire : tirages reproductibles

    % Expériences de robustesse (document 05, section 5)
    cfg.snrs   = [Inf 30 20 10 5 0];                  % Inf = signal propre
    cfg.bruits = {'white_noise.wav', 'running_tap.wav'};

    % Prétraitement et caractéristiques (personne A, documents 01 et 02)
    cfg.alpha        = 0.97;       % préaccentuation
    cfg.dureeTrame   = 0.025;      % 25 ms
    cfg.pasTrame     = 0.010;      % 10 ms
    cfg.fenetre      = 'hamming';  % ou 'hann'
    cfg.nfft         = 512;
    cfg.nFiltres     = 26;         % filtres Mel
    cfg.nCoeffs      = 13;         % MFCC gardés
    cfg.vadSeuilDB   = 12;         % seuil VAD = bruit de fond + 12 dB
    cfg.vadMinTrames = 5;          % détections plus courtes (50 ms) supprimées
    cfg.vadMarge     = 2;          % trames ajoutées de chaque côté du mot

    % Reconnaissance (personne B, documents 03 et 04)
    cfg.dtwBande       = Inf;      % demi-largeur de la bande de Sakoe-Chiba (Inf = sans bande)
    cfg.kVoisins       = 1;        % 1 = plus proche voisin
    cfg.hmmEtats       = 6;        % états par mot
    cfg.hmmGaussiennes = 2;        % gaussiennes par état
    cfg.hmmSymboles    = 64;       % taille du dictionnaire (HMM discret)
    cfg.hmmIterations  = 8;        % itérations de l'entraînement de Viterbi
    cfg.nAppHMMParMot  = 200;      % exemples d'apprentissage par mot pour les HMM
end
