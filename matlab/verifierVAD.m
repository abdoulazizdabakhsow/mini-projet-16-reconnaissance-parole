% VERIFIERVAD  Compare ta VAD à detectSpeech sur 20 fichiers de test.
%   Affiche l'écart des bornes en ms et trace un exemple.

cfg = configProjet();
test = lireListe(fullfile(cfg.dossierListes, 'liste_test.txt'));
fichiers = test(1:50:end);                       % 20 fichiers, 2 par mot

ecarts = zeros(numel(fichiers), 2);
for i = 1:numel(fichiers)
    x = audioread(fullfile(cfg.racineDonnees, fichiers{i}));
    x = x(:, 1) - mean(x(:, 1));
    x = x / max(abs(x));
    [d, f] = vad(x, cfg);                        % ta VAD
    idx = detectSpeech(x, cfg.fs);               % VAD de MATLAB
    if isempty(idx), idx = [1 numel(x)]; end
    ecarts(i, :) = 1000 * ([d f] - [idx(1,1) idx(end,2)]) / cfg.fs;
    fprintf('%-32s début %+6.0f ms   fin %+6.0f ms\n', fichiers{i}, ecarts(i, 1), ecarts(i, 2));
end
fprintf('Écart absolu moyen : début %.0f ms, fin %.0f ms\n', mean(abs(ecarts)));

% Figure d'un exemple : signal, énergie et seuil, zone retenue
x = audioread(fullfile(cfg.racineDonnees, fichiers{1}));
x = x(:, 1) - mean(x(:, 1));  x = x / max(abs(x));
[d, f, info] = vad(x, cfg);
t = (0:numel(x)-1) / cfg.fs;
tTrame = ((0:numel(info.E)-1) * cfg.pasTrame) + cfg.dureeTrame / 2;
figure;
subplot(2, 1, 1);  plot(t, x);  hold on;
xline([d f] / cfg.fs, 'r', 'LineWidth', 1.5);  title(strrep(fichiers{1}, '_', '\_'));
ylabel('Amplitude');
subplot(2, 1, 2);  plot(tTrame, info.E, '-o');  hold on;
yline(info.Ebruit + cfg.vadSeuilDB, '--r', 'seuil');
xlabel('Temps (s)');  ylabel('Énergie (dB)');
