function b = chargerBruit(cfg, nom)
% CHARGERBRUIT  Lit un fichier du dossier _background_noise_ de Speech Commands.
%   b = chargerBruit(cfg, 'white_noise.wav')
%   Renvoie un vecteur colonne à cfg.fs (rééchantillonné si nécessaire).

    [b, fsb] = audioread(fullfile(cfg.racineDonnees, '_background_noise_', nom));
    b = b(:, 1);                              % mono
    if fsb ~= cfg.fs
        b = resample(b, cfg.fs, fsb);         % Signal Processing Toolbox
    end
end
