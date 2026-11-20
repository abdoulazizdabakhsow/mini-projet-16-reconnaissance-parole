function liste = lireListe(fichier)
% LIRELISTE  Lit un fichier texte contenant un chemin relatif par ligne.
%   liste = lireListe(fichier) renvoie un tableau de cellules colonne,
%   par exemple {'yes/0a7c2a8d_nohash_0.wav'; ...}.
%   Les chemins sont relatifs à la racine de Speech Commands : les listes
%   fonctionnent donc sur l'ordinateur de A, de B et de C.

    texte = fileread(fichier);
    liste = regexp(texte, '\r?\n', 'split');     % une cellule par ligne
    liste = strtrim(liste(:));
    liste = liste(~cellfun('isempty', liste));   % retire les lignes vides
    liste = strrep(liste, '\', '/');             % séparateurs uniformes
end
