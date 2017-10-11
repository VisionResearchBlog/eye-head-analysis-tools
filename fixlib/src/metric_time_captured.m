%computes what percentage of time in t is spent in fix

function ans = metric_time_captured(fix, t)

ans = fix_area(fix) / (max(t) - min(t));