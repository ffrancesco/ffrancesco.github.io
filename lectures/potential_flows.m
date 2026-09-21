% potential_flows.m
% Visualize velocity potential (phi) and streamfunction (psi) for:
% 1) Uniform flow
% 2) Source/Sink flow
% 3) Vortex flow
%
% Select which flow type to plot using the FLOW_TYPE parameter below
% Author: Corrected version
% Date: 2025

clear; close all; clc;

%% SELECT FLOW TYPE TO PLOT
% Options: 'uniform', 'source', 'sink', 'vortex'
FLOW_TYPE = 'source';

%% Common grid setup
Nx = 300; Ny = 300;
Xlim = [-4 4];
Ylim = [-4 4];
x = linspace(Xlim(1), Xlim(2), Nx);
y = linspace(Ylim(1), Ylim(2), Ny);
[X, Y] = meshgrid(x, y);
r = sqrt(X.^2 + Y.^2);
theta = atan2(Y, X);

%% Physical parameters
U = 1.0;           % uniform flow speed (x-direction)
Q = 5.0;           % source/sink strength (positive = source, negative = sink)
Gamma = 3.0;       % circulation (vortex strength)

% Plotting settings
nContours = 50;
arrow_step = 15;   % subsample for quiver arrows

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% UNIFORM FLOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(FLOW_TYPE, 'uniform')
    % Velocity potential: phi = U * x
    % Streamfunction: psi = U * y
    
    phi = U * X;
    psi = U * Y;
    
    % Velocity components
    u = U * ones(size(X));
    v = zeros(size(Y));
    
    flow_name = 'Uniform Flow';
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SOURCE FLOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(FLOW_TYPE, 'source')
    % Velocity potential: phi = (Q/(2*pi)) * ln(r)
    % Streamfunction: psi = (Q/(2*pi)) * theta
    
    phi = (Q/(2*pi)) * log(r);
    psi = (Q/(2*pi)) * theta;
    
    % Velocity components (radial flow from origin)
    u = (Q/(2*pi)) * (X ./ (r.^2 + 1e-10));
    v = (Q/(2*pi)) * (Y ./ (r.^2 + 1e-10));
    
    % Mask singularity at origin
    mask = r < 0.2;
    phi(mask) = NaN;
    psi(mask) = NaN;
    u(mask) = NaN;
    v(mask) = NaN;
    
    flow_name = 'Source Flow';
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SINK FLOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(FLOW_TYPE, 'sink')
    % Sink is negative source
    Q_sink = -abs(Q);
    
    phi = (Q_sink/(2*pi)) * log(r);
    psi = (Q_sink/(2*pi)) * theta;
    
    % Velocity components (radial flow toward origin)
    u = (Q_sink/(2*pi)) * (X ./ (r.^2 + 1e-10));
    v = (Q_sink/(2*pi)) * (Y ./ (r.^2 + 1e-10));
    
    % Mask singularity
    mask = r < 0.2;
    phi(mask) = NaN;
    psi(mask) = NaN;
    u(mask) = NaN;
    v(mask) = NaN;
    
    flow_name = 'Sink Flow';
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VORTEX FLOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(FLOW_TYPE, 'vortex')
    % Velocity potential: phi = -(Gamma/(2*pi)) * theta
    % Streamfunction: psi = (Gamma/(2*pi)) * ln(r)
    
    phi = -(Gamma/(2*pi)) * theta;
    psi = (Gamma/(2*pi)) * log(r);
    
    % Velocity components (tangential flow around origin)
    u = -(Gamma/(2*pi)) * (Y ./ (r.^2 + 1e-10));
    v = (Gamma/(2*pi)) * (X ./ (r.^2 + 1e-10));
    
    % Mask singularity
    mask = r < 0.2;
    phi(mask) = NaN;
    psi(mask) = NaN;
    u(mask) = NaN;
    v(mask) = NaN;
    
    flow_name = 'Vortex Flow';
else
    error('Unknown flow type. Choose: uniform, source, sink, or vortex')
end

%% Speed field for visualization
speed = sqrt(u.^2 + v.^2);
%% Speed field for visualization
speed = sqrt(u.^2 + v.^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOTTING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name', flow_name, 'NumberTitle', 'off', 'Position', [100 100 1200 500]);

% --- Left subplot: Streamfunction (psi) with velocity arrows ---
subplot(1, 2, 1)
contourf(X, Y, psi, nContours, 'LineStyle', 'none')
hold on
contour(X, Y, psi, nContours, 'LineColor', 'k', 'LineWidth', 0.3, 'LineStyle', '-')
colormap(parula)
colorbar
title(sprintf('Streamfunction \\psi — %s', flow_name), 'FontSize', 12, 'FontWeight', 'bold')
xlabel('x'); ylabel('y')
axis equal tight

% Overlay velocity vectors (quiver)
quiver(X(1:arrow_step:end, 1:arrow_step:end), Y(1:arrow_step:end, 1:arrow_step:end), ...
       u(1:arrow_step:end, 1:arrow_step:end), v(1:arrow_step:end, 1:arrow_step:end), 1.5, ...
       'LineWidth', 1, 'Color', 'w')
hold off

% --- Right subplot: Velocity potential (phi) with speed contours ---
subplot(1, 2, 2)
contourf(X, Y, phi, nContours, 'LineStyle', 'none')
hold on
contour(X, Y, phi, nContours, 'LineColor', 'k', 'LineWidth', 0.3, 'LineStyle', '-')
colormap(parula)
colorbar
title(sprintf('Velocity Potential \\phi — %s', flow_name), 'FontSize', 12, 'FontWeight', 'bold')
xlabel('x'); ylabel('y')
axis equal tight
hold off

% --- Print flow parameters to console ---
fprintf('\n%s\n', flow_name)
fprintf('================================\n')
switch FLOW_TYPE
    case 'uniform'
        fprintf('Freestream speed (U): %.2f\n', U)
    case 'source'
        fprintf('Source strength (Q): %.2f\n', Q)
    case 'sink'
        fprintf('Sink strength (Q): %.2f\n', -abs(Q))
    case 'vortex'
        fprintf('Circulation (Gamma): %.2f\n', Gamma)
end
fprintf('Grid size: %d x %d\n', Nx, Ny)
fprintf('Domain: [%.1f, %.1f] x [%.1f, %.1f]\n', Xlim(1), Xlim(2), Ylim(1), Ylim(2))
