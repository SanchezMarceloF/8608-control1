clc, clear all, close all
pkg load symbolic control signal

syms omega_n;
syms xi;
syms s

% Transferencia generica
G = (omega_n^2)/(s^2+2*xi*omega_n*s);
H = simplify(G/(1+G))

%% Ahora necesito darle valores el resultado numerico
% elijo omega_n y xi
omega_n = 20;
xi = 0.3;
% definiciones
sigma_d = xi*omega_n;
omega_d = omega_n * sqrt( 1 - xi^2 );
beta = acos (xi);

% Defino la transferencia H
s = tf('s');
G = (omega_n^2)/(s^2+2*xi*omega_n*s);
H = G/(1+G)

% Grafico la respuesta al escalon
[y_simulado, t, X] = step(H);
y_calculado = 1 + ( e.^(-sigma_d.*t)./sqrt( 1 - xi^2 ) ) .* sin ( omega_d.*t - pi + beta );

hold on
plot(t, y_calculado)
plot(t, y_simulado,'ro')
title('Respuesta al escalon');
legend('y(t) calculado', 'y(t) simulado');
grid
hold off

% magnitud del pico
[mag_pico_simulado, idx_tr] = max(y_simulado);
mag_pico_simulado 
mag_pico_calculado = 1 + e^( ( -pi*xi)/sqrt( 1 - xi^2) )

% tr
tr_simulado = t(idx_tr)
tr_calculado = pi/omega_d

%ts 

%Datos
A = 1;
tolerancia = A*0.005; % 1%

% Calculo a partir del vector simulado
t_idx = 1;
LEN_Y = length(y_simulado);
do
    y_1_porc = abs(A - y_simulado(t_idx));
    y_derivada = abs(y_simulado(t_idx+1)) - abs(y_simulado(t_idx));
   t_idx ++;
until( (y_1_porc < tolerancia & y_derivada < 0) | ( t_idx >= (LEN_Y - 1) ) )

% Muestro el resultado
if (t_idx < LEN_Y-2)
    ts_simulado = t(t_idx)
else
    printf("No se encontró el ts al 1 porciento  en esta simulación \n")
endif
ts_calculado = 4/sigma_d
    

step(H)


