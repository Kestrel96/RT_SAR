
final_results_figure=figure('Name','FInal Output','NumberTitle','off','Position', [0 0 1600 900]);
tiledlayout(1,3)
nexttile
imagesc(real(radar.SAR_raw_data))
xlabel("Samples")
ylabel("Pulse (Azimuth)")
title("SAR Raw Data")
nexttile
imagesc(raxis,azimuth_axis,db(abs(SAR_range_compressed)))
xlabel("Range [m]")
ylabel("Azimuth [m]")
title("Range Compressed Data")

saveas(final_results_figure,"./graphics/final_results.png");