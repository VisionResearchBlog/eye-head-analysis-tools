function fill = cba_compute_plottable_drops(drops, t_win)

%computes drops that can be plotted as a fill struct

fill = [drops - t_win(1), drops + t_win(2) ];