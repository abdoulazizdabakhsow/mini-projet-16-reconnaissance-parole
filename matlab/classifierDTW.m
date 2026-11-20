function [motPredit, dists] = classifierDTW(F, refsF, refsMots)
    [motPredit, dists] = reconnaitreDTW(F, refsF, refsMots, configProjet());
end
