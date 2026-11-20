function [debut, fin, info] = vad(x, cfg)
% VAD  Détection d'activité vocale par énergie (étape A4, document 01, sections 7 et 8).
%   [debut, fin, info] = vad(x, cfg)
%   x          : signal (vecteur colonne)
%   debut, fin : indices (en échantillons) du segment de parole à garder
%   info       : énergie E (dB) et ZCR Z de chaque trame, décision, niveau du bruit
%   Si aucune trame n'est détectée, on garde tout le signal.

    N = round(cfg.dureeTrame * cfg.fs);
    H = round(cfg.pasTrame * cfg.fs);
    T = decouperTrames(x, N, H);
    K = size(T, 2);
    w = feval(cfg.fenetre, N, 'periodic');

    % 1. Énergie (dB) et taux de passage par zéro de chaque trame
    E = 10 * log10(sum((T .* w).^2, 1) + 1e-10);     % 1 x K
    Z = sum(abs(diff(sign(T), 1, 1)), 1) / 2;        % 1 x K

    % 2. Niveau du bruit de fond : 10e percentile des énergies (robuste)
    Etri = sort(E);
    Ebruit = Etri(max(1, round(0.10 * K)));

    % 3. Décision trame par trame : parole(k) = true si la trame k contient de la parole
    parole = E > Ebruit + cfg.vadSeuilDB;

    % 4. Nettoyage : suppression des détections trop courtes
    bords = diff([0, parole, 0]);
    debuts = find(bords == 1);
    fins   = find(bords == -1) - 1;
    for i = 1:numel(debuts)
        if fins(i) - debuts(i) + 1 < cfg.vadMinTrames
            parole(debuts(i):fins(i)) = false;
        end
    end

    % 5. Bornes du mot (avec une marge), converties en échantillons
    k1 = find(parole, 1, 'first');
    k2 = find(parole, 1, 'last');
    if isempty(k1)
        debut = 1;  fin = numel(x);
    else
        k1 = max(k1 - cfg.vadMarge, 1);
        k2 = min(k2 + cfg.vadMarge, K);
        debut = (k1 - 1) * H + 1;
        fin   = min((k2 - 1) * H + N, numel(x));
    end
    info = struct('E', E, 'Z', Z, 'parole', parole, 'Ebruit', Ebruit);
end
