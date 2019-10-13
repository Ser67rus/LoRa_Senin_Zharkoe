function k = getValue(spect,deltaF,fs)

    step = fs/length(spect);
    spect0 = spect(ceil(length(spect)/2):length(spect));
    idx = find(spect0 == max(spect0));
    freq = idx * step;
    k = floor(freq / deltaF) - 1;


end