// Methodes numeriques 2 -- TP1 : De la mesure a une decision sur l'energie
// Groupe : ...   Membres : TRAORE Imane, WANGRAOUA Immaculée Marielle, SACKO Fatoumata
clear;

// PARTIE 1 (Membre 1) : routines du CM1 + controle du cours

function q = trapezes(t, y)
    n = length(t) - 1;
    if n < 1 | length(y) <> length(t) then
        error("Deux vecteurs de meme longueur sont requis.");
    end
    q = 0;
    for i = 1:n
        h = t(i+1) - t(i);
        if h <= 0 then error("Les abscisses doivent croitre."); end
        q = q + h * (y(i) + y(i+1)) / 2;
    end
endfunction

function q = simpson(t, y)
    n = length(t) - 1;
    if n < 2 | length(y) <> length(t) then
        error("Vecteurs incompatibles ou trop courts.");
    end
    if modulo(n, 2) <> 0 then error("Simpson exige n pair."); end
    h = t(2) - t(1);
    for i = 1:n
        pas = t(i+1) - t(i);
        if pas <= 0 then error("Les abscisses doivent croitre."); end
        if abs(pas-h) > 1e-10 * max(1, abs(h)) then
            error("Simpson exige des pas egaux.");
        end
    end
    q = y(1) + y(n+1);
    for i = 2:n
        if modulo(i, 2) == 0 then
            q = q + 4*y(i);
        else
            q = q + 2*y(i);
        end
    end
    q = h*q/3;
endfunction

function [t, y] = echantillonner(f, a, b, n)
    if n < 1 | b <= a then error("Intervalle ou maillage incorrect."); end
    t = zeros(1, n+1);
    y = zeros(1, n+1);
    for i = 1:n+1
        t(i) = a + (i-1)*(b-a)/n;
        y(i) = f(t(i));
    end
endfunction

function p = ordre_observe(E_n, E_2n)
    if E_n <= 0 | E_2n <= 0 then
        p = %nan;
    else
        p = log(E_n/E_2n)/log(2);
    end
endfunction

// ---- Controle du cours : P(t) = 10 + 4t - t^2 (W) aux temps 0..4 s ----
tc = [0 1 2 3 4];
Pc = 10 + 4*tc - tc.^2;
mprintf("Controle CM1 : T4=%.6f J (attendu 50) ; S4=%.6f J (attendu %.6f)\n", ..
        trapezes(tc, Pc), simpson(tc, Pc), 152/3);

// PARTIE 2 (Membre 2) : cas continu f(x) = exp(x) sur [0,1]

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
            n,n+1, ET(k), ES(k), errT(k), errS(k));
end

for k = 1:length(ns)-1
    // TODO 3 : ordres observes entre n et 2n
    pT = ordre_observe(errT(k), errT(k+1));
    pS = ordre_observe(errS(k), errS(k+1));
    mprintf("n=%d -> %d : pT=%.3f pS=%.3f\n", ns(k), ns(k+1), pT, pS);
end

// PARTIE 3 (Membre 3) : releves de puissance de la pompe

tmin = [0 10 20 30 40];            // temps en minutes
Pkw  = [2.0 2.6 3.0 2.5 1.9];      // puissance en kW

th = zeros(1, length(tmin));
for i = 1:length(tmin)
    // TODO 4 : conversion minutes -> heures
    th(i) = tmin(i) / 60;
end

// TODO 5 : energie par les deux quadratures (en kWh)
Etrap = trapezes(th, Pkw);
Esimp = simpson(th, Pkw);

mprintf("Pompe : trapezes=%.6f kWh ; Simpson=%.6f kWh\n", Etrap, Esimp);
mprintf("Ecart=%.6f kWh ; borne des lectures=%.6f kWh\n", ..
        abs(Etrap-Esimp), 0.1*40/60);
