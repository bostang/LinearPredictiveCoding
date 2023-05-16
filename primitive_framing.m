% mengatur frameLength, overlapFactor, dan order
frameLength = 80;
overlapFactor = 0;
order = 20;

% Membaca sinyal suara dari file .wav dan mengubah menjadi mono
[speechSignal, Fs] = audioread('speech_4k.wav');
speechSignal = mean(speechSignal, 2);

% Menghitung jumlah frame
numFrames = ceil(length(speechSignal)/(frameLength*(1-overlapFactor)));

% Inisiasi matrix untuk menyimpan koefisien LPC untuk setiap frame
lpcCoeffs = zeros(numFrames, order+1);

% Inisiasi array error
errorSignalNew = zeros(numFrames, frameLength);

reconstructedSignalNew = zeros(numFrames, frameLength);

% Menganalisis masing-masing frame
for i = 1:numFrames
    % Mengekstrak sampel suara pada frame sekarang
    startIdx = round((i-1)*frameLength*(1-overlapFactor))+1;
    endIdx = startIdx + frameLength - 1;
    if endIdx > length(speechSignal)
        endIdx = length(speechSignal);
        startIdx = endIdx - frameLength + 1;
    end

    currentFrame = speechSignal(startIdx:endIdx);
    % Mencari koefisien LPC untuk frame yang sedang dianalisis
    lpcCoeffs(i,:) = lpc_autocorr(currentFrame, order);
    
    % Mencfunction y = filt( x, N )
% filter function
    if(~isvector(x))
        error('Input must be a vector')
    end
    y = zeros(1,length(x));

    %///// CHANGE
    for n = 1 : numel(x)
        if (n <= N)
            y(n) = max(x(1:n));
        else
            y(n) = max(x(n:-1:n-N+1));
        end    
    end
endari nilai error untuk masing-masing frame
    frameError = filter(lpcCoeffs(i,:), 1, currentFrame);
    errorSignalNew(i,:) = transpose(frameError);
end

% Melakukan inversi filter untuk mendapatkan sinyal suara yang telah direkonstruksi
for i = 1:numFrames
    reconstructedSignalNew(i,:) = filter(1, lpcCoeffs(i,:), errorSignalNew(i,:));
end
k=1;
for i = 1:numFrames
    for j = 1:frameLength
        reconstSignalNewOneD(k) = reconstructedSignalNew(i,j);
        k=k+1;
    end
end
reconstSignalNewOneD = transpose(reconstSignalNewOneD);

% Memperbaiki overlap antar frame
startIdx = round(frameLength*(1-overlapFactor))+1;
endIdx = length(speechSignal);
reconstructedSignal(startIdx:endIdx) = reconstructedSignal(startIdx:endIdx) + errorSignalNew(startIdx:endIdx);

error = errorSignalNew(:);

% Memainkan sinyal suara yang telah direkonstruksi
sound(speechSignal, Fs);
pause(length(speechSignal)/Fs);
sound(reconstSignalNewOneD,Fs);

% Membuat plot sinyal original dan hasil rekonstruksi
t = (0:length(speechSignal)-1) / Fs;
tr = (0:length(reconstSignalNewOneD)-1) / Fs;
subplot(3,1,1); plot(t, speechSignal); xlabel('Time (s)'); ylabel('Amplitude');
title('Original Speech Signal');
subplot(3,1,2); plot(tr, reconstSignalNewOneD); xlabel('Time (s)'); ylabel('Amplitude');
title('Reconstructed Speech Signal (MATLAB Function)');
subplot(3,1,3); plot(tr, error); xlabel('Time (s)'); ylabel('Amplitude');
title('Error');

