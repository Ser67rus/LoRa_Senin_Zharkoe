function k = getValue(spect,deltaF,fs)

    step = fs/length(spect);
    spect0 = spect(length(spect)/2:length(spect));
    [s_max, idx] = max(spect0);
    freq = idx * step;
    k = floor(freq / deltaF) - 1;


end