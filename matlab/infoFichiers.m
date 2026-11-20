function [mots, locuteurs] = infoFichiers(liste)
% INFOFICHIERS  Extrait le mot et le locuteur de chemins Speech Commands.
%   [mots, locuteurs] = infoFichiers(liste)
%   liste : cellules de chemins relatifs, ex. 'yes/0a7c2a8d_nohash_0.wav'
%   mots  : {'yes'; ...}        locuteurs : {'0a7c2a8d'; ...}

    jetons = regexp(liste, '^([^/]+)/([0-9a-fA-F]+)_nohash_', 'tokens', 'once');
    mots      = cellfun(@(t) t{1}, jetons, 'UniformOutput', false);
    locuteurs = cellfun(@(t) t{2}, jetons, 'UniformOutput', false);
end
