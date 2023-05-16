% Baca sinyal suara dari file .wav
[s, Fs] = audioread('speech.wav'); % ganti 'speech.wav' dengan nama file sinyal ucapan Anda
s = s(:, 1); % ekstrak satu saluran jika stereo

% Parameter LPC
p = 10; % orde koefisien LPC
frameLen = 256; % panjang setiap frame analisis
overlap = 0.5; % faktor tumpang tindih
frameShift = round(frameLen * (1-overlap)); % pergeseran antara frame yang tumpang tindih

% Hitung koefisien LPC untuk setiap frame
numFrames = floor((length(s)-frameLen)/(frameLen*(1-overlap))) + 1;
lpcCoeffs = zeros(numFrames, p+1);
for i = 1:numFrames
    % Ekstrak frame saat ini
    frame = s((i-1)*frameShift+1:(i-1)*frameShift+frameLen);

    % Hitung koefisien LPC
    [lpcCoeffs(i,:), ~] = lpc(frame, p);
end

% Inisialisasi sinyal keluaran dan error
y = zeros(size(s));
error = zeros(size(s));

% Proses sinyal frame per frame
for i = 1:numFrames
    % Ekstrak frame saat ini
    frame = s((i-1)*frameShift+1:(i-1)*frameShift+frameLen);

    % Terapkan filter analisis LPC
    e = filter(lpcCoeffs(i,:), 1, frame);

    % Sintesis sinyal menggunakan filter sintesis LPC
    y((i-1)*frameShift+1:(i-1)*frameShift+frameLen) = filter(1, lpcCoeffs(i,:), e);

    % Hitung sinyal error
    error((i-1)*frameShift+1:(i-1)*frameShift+frameLen) = e;

end

% Plot sinyal asli dan direkonstruksi
t = (0:length(s)-1) / Fs;
subplot(3,1,1); plot(t, s); xlabel('Waktu (s)'); ylabel('Amplitudo');
title('Sinyal Ucapan Asli');
subplot(3,1,2); plot(t, y); xlabel('Waktu (s)'); ylabel('Amplitudo');
title('Sinyal Ucapan Direkonstruksi');
subplot(3,1,3); plot(t, error); xlabel('Waktu (s)'); ylabel('Amplitudo');
title('Sinyal Error');

% Tampilkan koefisien LPC
%display(lpcCoeffs);

% Mainkan sinyal asli dan direkonstruksi
%sound(s, Fs);
%pause(length(s)/Fs);
%sound(y, Fs);
%pause(length(s)/Fs);
sound(error, Fs);