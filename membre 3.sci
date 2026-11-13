// Partie 3 : releves de puissance de la pompe
clear;
exec("TP_01_Outils_Quadrature.sce", -1);

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

// Conclusion : ne pas calculer d'ordre de convergence avec ces 5 mesures.
