%% Loading The State Space Matrices for wing-level flight
% @ 10000 ft, 600 ft/s

matrices = open('ABCD_ac_MAtrices.mat');

A_long = matrices.A_ac_long; 
B_long = matrices.B_ac_long;
C_long = matrices.C_ac_long; 
D_long = matrices.D_ac_long;


sys_long = ss(A_long, B_long, C_long, D_long);


%% Motion Characteristics

p_long = pole(sys_long);


[wn_long,zeta_long] = damp(sys_long);


wn_sp = wn_long(3); % Short Period
zeta_sp = zeta_long(3);
wd_sp = damped_freq(wn_sp, zeta_sp);
Th_sp = halfamp_period(wn_sp, zeta_sp);
P_sp = (2*pi)/wn_sp;
wn_ph = wn_long(1); % Phugoid
zeta_ph = zeta_long(1);
wd_ph = damped_freq(wn_ph, zeta_ph);
Th_ph = halfamp_period(wn_ph, zeta_ph);
P_ph = (2*pi)/wn_ph;

clear wn_long zeta_long ;

%% Useful Constants

dt = 0.001;
x0_long = [2.058*pi/180 ; 600.0; 2.058*pi/180; 0.0];
  

long_vars = ["Pitch Angle - \theta [ \circ ]", "Velocity - V_t [m/s]" ,"Angle of Attack - \alpha [ \circ ]", "Pitch Rate - q [ \circ/s]"]; 

opt = stepDataOptions;
opt.StepAmplitude = -1;


%% Periodic Motions
%% Short Period

t_short = 0:dt:10;
y_short = transpose(x0_long) + impulse(sys_long(:,2),  t_short, opt)*-1;

%% Phugoid

t_phugoid = 0:dt:1000;
y_phugoid = transpose(x0_long) + impulse(sys_long(:,2),  t_phugoid, opt)*-1;


%% Plots
%  Short Period - Phugoid 
to_plot = [ 0 1 ];
%  use either to_plot = [0 1]  for phugoid



    figure
    for i = 1:4
        set(gca,'FontSize',15);
        subplot(2, 2, i);
        plot(t_short, y_short(:, i), 'b-'); hold on;
        plot(Th_sp, intersection_point(Th_sp, t_short, y_short(:,i)), 'ro'); hold on;
        plot(P_sp,  intersection_point(P_sp, t_short, y_short(:,i)), 'ko'); hold off;
        set(gca,'FontSize',15);
        legend('Response', 'Half-Amplitude Period', 'Period');
        grid on
        title(long_vars(i));
        xlabel("Time [s]")
        ylabel(long_vars(i));
        
    end
    title("Short Period", "FontSize", 20);
    end
    
 figure
    figure
    for i = 1:4
        set(gca,'FontSize',15);
        subplot(2, 2, i);
        plot(t_phugoid, y_phugoid(:, i), 'b-'); hold on;
        plot(Th_ph, intersection_point(Th_ph, t_phugoid, y_phugoid(:,i)), 'ro'); hold on;
        plot(P_ph,  intersection_point(P_ph, t_phugoid, y_phugoid(:,i)), 'ko'); hold off;
        set(gca,'FontSize',15);
        legend('Response', 'Half-Amplitude Period', 'Period');
        grid on
        title(long_vars(i));
        xlabel("Time [s]")
        ylabel(long_vars(i));
    end
    title("Phugoid", "FontSize", 20);
end


function y = damped_freq(wn, zeta)
    y = wn*sqrt(1 - zeta^2);
end

function y = halfamp_period(wn, zeta)
    y = log(2)/(wn*zeta);
end

function y = time_const(wn, zeta)
    y = 1.0/(wn*zeta);
end

function y = intersection_point(t0, ti, yi)
    
    epsilon = 10000000000.0;
    
    for i = 1:length(ti)
        diff = abs(ti(i) - t0);
        if diff < epsilon
            epsilon = diff;
        else
            y = yi(i-1);
            break;
        end
    end
end
