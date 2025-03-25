clear
%% 

function [x_k, y_k, z_k] = calculate_satellite_position(t_oe, t, sqrtA, e, i0, Omega0, omega, M0, Delta_n, idot, Omegadot, Cuc, Cus, Crc, Crs, Cic, Cis, mu, Omega_e)
    % 计算时间差
    dt = t - t_oe;
    
    % 计算平均运动角
    A = sqrtA^2;
    n = sqrt(mu / A^3) + Delta_n; % 平均角速度
    M = M0 + n * dt; % 平均运动角
    
    % 计算偏近点角
    E = M; % 初始估计
    for k = 1:100 % 迭代求解
        deltaE = (E - e * sin(E) - M);
        E = E - deltaE;
        if abs(deltaE) < 1e-12
            break;
        end
    end
    
    % 计算真近点角
    v = 2 * atan2(sqrt(1 + e) * sin(E/2), sqrt(1 - e) * cos(E/2));
    phi = v + omega;
    
    % 计算修正量
    delta_u_k = Cus * sin(2 * phi) + Cuc * cos(2 * phi);
    delta_r_k = Crs * sin(2 * phi) + Crc * cos(2 * phi);
    delta_i_k = Cis * sin(2 * phi) + Cic * cos(2 * phi);
    
    % 计算修正后的角度和距离
    u_k = phi + delta_u_k;
    r_k = A * (1 - e * cos(E)) + delta_r_k;
    i_k = i0 + idot * dt + delta_i_k;
    
    % 计算卫星位置
    x_p_k = r_k * cos(u_k);
    y_p_k = r_k * sin(u_k);
    Omega_k = Omega0 + (Omegadot - Omega_e) * dt - Omega_e * t_oe;
    
    x_k = x_p_k * cos(Omega_k) - y_p_k * cos(i_k) * sin(Omega_k);
    y_k = x_p_k * sin(Omega_k) + y_p_k * cos(i_k) * cos(Omega_k);
    z_k = y_p_k * sin(i_k);
end

% 定义WGS-84基本参数
mu = 3.986005e14; % 地球引力常数 GM（m^3/s^2）
Omega_e = 7.2921151467e-5; % 地球自转角速度（rad/s）

% 定义卫星星历参数（以G03卫星为例）
t_oe = 216000; % 星历参考时间
sqrtA = 5153.672052; % 卫星轨道半长轴A的平方根
e = 0.005733325; % 卫星轨道偏心率
i0 = 0.985287094; % t0时的轨道倾角
Omega0 = 1.570003762; % 周内时为0时的轨道升交点赤经
omega = 1.150087769; % 近地点角距
M0 = 1.065212914; % t0时的平近点角
Delta_n = 4.45375694543e-9; % 卫星平均角速度校正值
idot = 6.78599694973e-11; % 轨道倾角的变化率
Omegadot = -8.43892294359e-9; % 轨道升交点赤经的变化率
Cuc = 2.25380063057e-6; % 升交点角距余弦调和校正振幅
Cus = 1.81049108505e-6; % 升交点角距正弦调和校正振幅
Crc = 358.46875; % 轨道半径余弦调和校正振幅
Crs = 44.03125; % 轨道半径正弦调和校正振幅
Cic = -1.06170773506e-7; % 轨道倾角余弦调和校正振幅
Cis = 1.09896063805e-7; % 轨道倾角正弦调和校正振幅

% 计算卫星在给定信号发射时刻t的WGS-84地心固直角坐标系中的（x,y,z）坐标
t = 216910.922424771; % GPS时间（单位s）

% 定义卫星星历参数
satellites = struct(...
    't_oe', {}, ...
    't', {}, ...
    'sqrtA', {}, ...
    'e', {}, ...
    'i0', {}, ...
    'Omega0', {}, ...
    'omega', {}, ...
    'M0', {}, ...
    'Delta_n', {}, ...
    'idot', {}, ...
    'Omegadot', {}, ...
    'Cuc', {}, ...
    'Cus', {}, ...
    'Crc', {}, ...
    'Crs', {}, ...
    'Cic', {}, ...
    'Cis', {} ...
);

satellites(1) = struct(...
    't_oe', 216000,...
    't', 216910.922424771, ...
    'sqrtA', 5153.672052, ...
    'e', 0.005733325, ...
    'i0', 0.985287094, ...
    'Omega0', 1.570003762, ...
    'omega', 1.150087769, ...
    'M0', 1.065212914, ...
    'Delta_n', 4.45375694543e-9, ...
    'idot', 6.78599694973e-11, ...
    'Omegadot', -8.43892294359e-9, ...
    'Cuc', 2.25380063057e-6, ...
    'Cus', 1.81049108505e-6, ...
    'Crc', 358.46875, ...
    'Crs', 44.03125, ...
    'Cic', -1.06170773506e-7, ...
    'Cis', 1.09896063805e-7 ...
);

satellites(2) = struct(...
    't_oe', 216000,...
    't', 216910.927126034, ...
    'sqrtA', 5153.596405029, ...
    'e', 0.01387373835314, ...
    'i0', 0.9608274124898, ...
    'Omega0', -1.489287022577, ...
    'omega', 0.8419807772047, ...
    'M0', -0.8829103006894, ...
    'Delta_n', 5.072711298787e-9, ...
    'idot', 2.728685089258e-10, ...
    'Omegadot', -8.560713730946e-9, ...
    'Cuc', 1.326203346252e-6, ...
    'Cus', 3.90037894249e-6, ...
    'Crc', 300.4375, ...
    'Crs', 18.03125, ...
    'Cic', 1.620501279831e-7, ...
    'Cis', 2.458691596985e-7 ...
);

% 定义G26卫星的星历参数
satellites(3) = struct(...
    't_oe', 216000,...
    't', 216910.932830770, ...       % 发射时刻
    'sqrtA', 5153.675210953, ...      % 卫星轨道半长轴A的平方根
    'e', 0.009066505823284, ...       % 卫星轨道偏心率
    'i0', 0.9301997303239, ...        % t0时的轨道倾角
    'Omega0', -1.658764013494, ...    % 周内时为0时的轨道升交点赤经
    'omega', 0.5475090446694, ...     % 近地点角距
    'M0', 0.0336406789836, ...        % t0时的平近点角
    'Delta_n', 5.748453731886e-9, ... % 卫星平均角速度校正值
    'idot', 4.450185368083e-10, ...   % 轨道倾角的变化率
    'Omegadot', -8.920014411547e-9, ... % 轨道升交点赤经的变化率
    'Cuc', 2.032145857811e-6, ...     % 升交点角距余弦调和校正振幅
    'Cus', 4.392117261887e-6, ...     % 升交点角距正弦调和校正振幅
    'Crc', 278.0625, ...              % 轨道半径余弦调和校正振幅
    'Crs', 36.25, ...                 % 轨道半径正弦调和校正振幅
    'Cic', 5.960464477539e-8, ...     % 轨道倾角余弦调和校正振幅
    'Cis', 9.499490261078e-8 ...      % 轨道倾角正弦调和校正振幅
);

satellites(4) = struct(...
    't_oe', 216000,...
    't', 216910.928905475, ...
    'sqrtA', 5153.71152878, ...
    'e', 0.000335887423716, ...
    'i0', 0.961761795822, ...
    'Omega0', -2.65525561325, ...
    'omega', 1.44030091811, ...
    'M0', 0.458405154849, ...
    'Delta_n', 4.433041796842e-9, ...
    'idot', 4.76448417418e-10, ...
    'Omegadot', -7.74532262378e-9, ...
    'Cuc', -2.84984707832e-7, ...
    'Cus', 1.37574970722e-5, ...
    'Crc', 116.15625, ...
    'Crs', -8.1875, ...
    'Cic', -1.49011611938e-8, ...
    'Cis', -5.77419996262e-8 ...
);

satellites(5) = struct(...
    't', 216910.922563929, ...      % 发射时刻 (GPS时间, 单位: 秒)
    't_oe', 215984, ...               % 星历参考时间 (单位: 秒)
    'sqrtA', 5153.781337738, ...     % 卫星轨道半长轴A的平方根 (单位: 米)
    'e', 0.002931976108812, ...      % 卫星轨道偏心率
    'i0', 0.9702438006973, ...       % t0时的轨道倾角 (单位: 弧度)
    'Omega0', -0.4529498397046, ...  % 周内时为0时的轨道升交点赤经 (单位: 弧度)
    'omega', 2.649480276003, ...     % 近地点角距 (单位: 弧度)
    'M0', -1.871576302528, ...       % t0时的平近点角 (单位: 弧度)
    'Delta_n', 4.433041796842e-9, ... % 卫星平均角速度校正值 (单位: 弧度/秒)
    'idot', -6.164542492224e-10, ... % 轨道倾角的变化率 (单位: 弧度/秒)
    'Omegadot', -7.924615806343e-9, ... % 轨道升交点赤经的变化率 (单位: 弧度/秒)
    'Cuc', -2.354383468628e-6, ...    % 升交点角距余弦调和校正振幅
    'Cus', 1.130253076553e-5, ...     % 升交点角距正弦调和校正振幅
    'Crc', 172.59375, ...             % 轨道半径余弦调和校正振幅
    'Crs', -44.3125, ...              % 轨道半径正弦调和校正振幅
    'Cic', -2.421438694e-8, ...       % 轨道倾角余弦调和校正振幅
    'Cis', -5.960464477539e-8 ...     % 轨道倾角正弦调和校正振幅
);

satellites(6) = struct(...
    't', 216910.930387112, ...      % 发射时刻 (GPS时间, 单位: 秒)
    't_oe', 216000, ...                % 星历参考时间 (单位: 秒)
    'sqrtA', 5153.774834, ...         % 卫星轨道半长轴A的平方根 (单位: 米)
    'e', 0.010563692, ...             % 卫星轨道偏心率
    'i0', 0.954591923, ...            % t0时的轨道倾角 (单位: 弧度)
    'Omega0', -2.601298535, ...       % 周内时为0时的轨道升交点赤经 (单位: 弧度)
    'omega', 0.710956231, ...         % 近地点角距 (单位: 弧度)
    'M0', 0.638092284, ...            % t0时的平近点角 (单位: 弧度)
    'Delta_n', 4.29767901558e-9, ...  % 卫星平均角速度校正值 (单位: 弧度/秒)
    'idot', 4.52876006961e-10, ...    % 轨道倾角的变化率 (单位: 弧度/秒)
    'Omegadot', -7.9471167436e-9, ... % 轨道升交点赤经的变化率 (单位: 弧度/秒)
    'Cuc', 5.38304448128e-7, ...      % 升交点角距余弦调和校正振幅
    'Cus', 1.25169754028e-5, ...     % 升交点角距正弦调和校正振幅
    'Crc', 137.40625, ...             % 轨道半径余弦调和校正振幅
    'Crs', 4.71875, ...               % 轨道半径正弦调和校正振幅
    'Cic', -1.39698386192e-7, ...    % 轨道倾角余弦调和校正振幅
    'Cis', 1.73225998878e-7 ...      % 轨道倾角正弦调和校正振幅
);

ref_pos = [-2852335.3220435134, 4653403.146522228, 3289053.8582831006];
% 计算卫星在给定信号发射时刻t的WGS-84地心固直角坐标系中的（x,y,z）坐标
sat_pos = struct('x', num2cell(zeros(6, 1)), ...
                 'y', num2cell(zeros(6, 1)), ...
                 'z', num2cell(zeros(6, 1)));

name=["G03","G16","G26","G28","G29","G31"];
for i = 1:length(satellites)
    sat = satellites(i);
    [x_k, y_k, z_k] = calculate_satellite_position(...
        sat.t_oe, sat.t, sat.sqrtA, sat.e, sat.i0, sat.Omega0, sat.omega, sat.M0, sat.Delta_n, sat.idot, sat.Omegadot, ...
        sat.Cuc, sat.Cus, sat.Crc, sat.Crs, sat.Cic, sat.Cis, mu, Omega_e ...
    );
    sat_pos(i).x = x_k; 
    sat_pos(i).y = y_k; 
    sat_pos(i).z = z_k; 
    %fprintf('Satellite %s Position: x = %f, y = %f, z = %f\n', name(i), x_k, y_k, z_k);
    sat_vec = [x_k - ref_pos(1), y_k - ref_pos(2), z_k - ref_pos(3)];
end
%%
function [enu] = xyz2enu(Xr, Yr, Zr, Xs, Ys, Zs)
    blh = xyz2blh(Xr, Yr, Zr);
    lat=blh.L;
    lon=blh.B;
    % lat = deg2rad(lat);
    % lon = deg2rad(lon);
    
    sinL = sin(lat);
    cosL = cos(lat);
    sinB = sin(lon);
    cosB = cos(lon);
    
    % Calculate differences in ECEF coordinates
    dx = Xs - Xr;
    dy = Ys - Yr;
    dz = Zs - Zr;
    
    % Calculate ENU coordinates
    enu.E = -sinL*dx + cosL*dy;
    enu.N = -sinB.*cosL*dx - sinB.*sinL*dy + cosB*dz;
    enu.U = cosB.*cosL*dx + cosB.*sinL*dy + sinB*dz;
end

function blh = xyz2blh(X, Y, Z)
    % WGS-84 基本参数
    a = 6378137.0; % 基准椭球体长半径（米）
    f = 1/298.257223563; % 基准椭球体扁率
    e2 = f * (2 - f); % 第一偏心率的平方

    % 初始化变量
    B = 0.0; % 纬度的初始估计
    R1 = sqrt(X^2 + Y^2 + Z^2); % 地心到点的直线距离
    N = a; %卯酉圈半径的初始估计
    H = R1 - a; % 高度的初始估计
    R0 = sqrt(X^2 + Y^2); % 东西方向上的半径
    B = atan2(Z .* (N + H), R0 .* (N .* (1 - e2) + H));
    % 经度直接求解
    L = atan2(Y, X);

    % 迭代求纬度和高度
    deltaH = inf; % 判断收敛所用
    deltaB = inf;
    while abs(deltaH - H) > 1e-3 && abs(deltaB - B) > 1e-9
        deltaH = N;
        deltaB = B;
        N = a ./ sqrt(1 - e2 .* sin(B).^2);
        H = R0 ./ cos(B) - N;
        B = atan2(Z .* (N + H), R0 .* (N .* (1 - e2) + H));
    end

    % 构造输出结构体
    blh.L = L; % 经度
    blh.B = B; % 纬度
    blh.H = H; % 高度
end

function [rah] = xyz2rah(Xr, Yr, Zr, Xs, Ys, Zs)
    enu = xyz2enu(Xr, Yr, Zr, Xs, Ys, Zs);
    
    % Calculate Height (H)
    rah.H = atan2(enu.U, sqrt(enu.E^2 + enu.N^2));
    
    % Calculate Azimuth (A)
    rah.A = atan2(enu.E, enu.N);
    if rah.A < 0
        rah.A=rah.A+2*pi;
    end
    if rah.A > 2*pi
        rah.A=rah.A-2*pi;
    end
    % Calculate Range (R)
    rah.R = sqrt(enu.E^2 + enu.N^2 + enu.U^2);
end

%计算方位角和高度角
ref_pos = [-2852335.3220435134, 4653403.146522228, 3289053.8582831006];
rah_array = struct('R', {}, 'A', {}, 'H', {});
for i = 1:length(sat_pos)
    rah = xyz2rah(ref_pos(1), ref_pos(2), ref_pos(3), sat_pos(i).x, sat_pos(i).y, sat_pos(i).z);
    rah_array(i).R = rah.R;
    rah_array(i).A = rah.A;
    rah_array(i).H = rah.H;
end

% 绘制天空图
for i = 1:length(rah_array)
    az=rad2deg(rah_array(i).A);
    el=rad2deg(rah_array(i).H);
    fprintf('Satellite %s 高度角: %f 方位角:  %f\n', name(i), el, az);
    polarplot(az, 90 - el, 'o-','MarkerSize', 6); % 极径=90度-高度角(deg)
    hold on;
end
legend("G03","G16","G26","G28","G29","G31");
title('Sky Map');
rlim([0 90]); % 设置半径限制为0到90度
thetaticks(linspace(0, 360, 13)); % 设置方位角的刻度
thetaticklabels({'0°','30°','60°','90°','120°','150°','180°','210°','240°','270°','300°','330°','360°'});
ax = gca;
ax.RTick = 0:15:90; % 设置半径刻度
ax.ThetaZeroLocation = 'top'; % 设置0度方位角的位置在顶部
ax.ThetaDir = 'clockwise'; % 设置方位角方向为顺时针
set(gca, 'FontName', 'Times New Roman', 'ThetaDir', 'clockwise', 'GridLineStyle', '--', 'GridAlpha', 0.5, 'Fontsize', 11);
hold off;

