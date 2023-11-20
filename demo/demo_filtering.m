load PhysIO_Outputs\physio.mat

% Your ECG signal variable and sampling frequency
ecg_signal = physio.ons_secs.c;% (Your ECG signal data here)
Fs = 400; % Sampling frequency

% Call the custom filter function
filtered_ecg = s_ECG_Butterworth(ecg_signal, Fs);

% Plot the original and filtered ECG signal
t = (0:length(ecg_signal)-1) / Fs; % Time vector for plotting

figure;
subplot(2, 1, 1);
plot(t, ecg_signal);
title('Original ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t, filtered_ecg);
title('Filtered ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');
