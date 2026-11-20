
function [Hm, fBords] = bancFiltresMel(cfg)
% BANCFILTRESMEL Matrice des filtres triangulaires sur l'échelle Mel
% Hm     : matrice M x (nfft/2 + 1), une ligne par filtre
% fBords : les M + 2 fréquences (Hz) des sommets et des pieds des triangles

    M = cfg.nFiltres;
    nfft = cfg.nfft;
    fs = cfg.fs;

    hz2mel = @(f) 2595 * log10(1 + f / 700);
    mel2hz = @(m) 700 * (10.^(m / 2595) - 1);

    % M + 2 points régulièrement espacés en mels
    fBords = mel2hz(linspace(hz2mel(0), hz2mel(fs / 2), M + 2));

    % Indices des cases FFT correspondantes
    b = floor((nfft + 1) * fBords / fs);

    Hm = zeros(M, nfft / 2 + 1);

    % Construction des filtres triangulaires
    for m = 1:M
        g = b(m);
        c = b(m + 1);
        d = b(m + 2);

        for k = g:c
            Hm(m, k + 1) = (k - g) / max(c - g, 1);
        end

        for k = c:d
            Hm(m, k + 1) = (d - k) / max(d - c, 1);
        end
    end
end

