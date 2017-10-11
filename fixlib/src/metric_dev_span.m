% takes the deviations (from 1, the "ideal value"). of the span of
% 1 over 2
% uses variance then gets "standard deviation" (using biased estimator)

function ans = metric_dev_span(fix1, fix2)

span = fix_span(fix1, fix2);

dev_span = (span - 1).^2;

ans = sqrt(mean(dev_span));