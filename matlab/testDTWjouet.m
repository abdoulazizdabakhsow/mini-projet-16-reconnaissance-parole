% TESTDTWJOUET  Vérifie maDTW sur les exemples calculés à la main (document 03) et contre dtw.

A = [2 5 6 3];
B = [1 2 5 7 6 3];
C = [6 3 2 5];

[dAB, cheminAB] = maDTW(A, B);
dAC = maDTW(A, C);
fprintf('DTW(A, B) = %g   (attendu : 2)\n', dAB);
fprintf('DTW(A, C) = %g   (attendu : 8)\n', dAC);
disp('Chemin A-B (attendu : (1,1) (1,2) (2,3) (3,4) (3,5) (4,6)) :');
disp(cheminAB);

% Comparaison avec la fonction dtw de MATLAB sur des vecteurs aléatoires de dimension 13
rng(0);
X = randn(13, 40);  Y = randn(13, 55);
fprintf('Écart avec dtw : %.2e   (attendu : quasi nul)\n', abs(maDTW(X, Y) - dtw(X, Y)));
