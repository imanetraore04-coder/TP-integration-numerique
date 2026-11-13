// Partie 2 : cas continu f(x) = exp(x) sur [0,1]
clear;
exec("TP_01_Outils_Quadrature.sce", -1);

function y = modele(x)
    y = exp(x);
endfunction

Iref = %e - 1;            // Integrale exacte sur [0,1]
ns = [4 8 16 32];
ET = zeros(1, length(ns)); ES = ET;
errT = ET; errS = ET;

for k = 1:length(ns)
    n = ns(k);
    [t, y] = echantillonner(modele, 0, 1, n);
    // TODO 1 : les deux quadratures
    ET(k) = trapezes(t, y);
    ES(k) = simpson(t, y);
    // TODO 2 : erreurs absolues
    errT(k) = abs(ET(k) - Iref);
    errS(k) = abs(ES(k) - Iref);
    mprintf("n=%d (%d evaluations) T=%.9f S=%.9f ET=%.3e ES=%.3e\n", ..
            n, n+1, ET(k), ES(k), errT(k), errS(k));
end

for k = 1:length(ns)-1
    // TODO 3 : ordres observes entre n et 2n
    pT = ordre_observe(errT(k), errT(k+1));
    pS = ordre_observe(errS(k), errS(k+1));
    mprintf("n=%d -> %d : pT=%.3f pS=%.3f\n", ns(k), ns(k+1), pT, pS);
end
