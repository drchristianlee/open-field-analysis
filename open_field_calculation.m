clear;
myFolder = uigetdir;
cd(myFolder);

load('files.mat')

for result = 1:size(tiffiles, 1);
    load(char(strcat(tiffiles(result, 1).name(1:end-4), '.mat')))
    full_result{:, :, result} = res_keeper;
end

for count = 1: size(full_result, 3);
calc = full_result{:, :, count};
x = calc(:, 1);
y = calc(:, 2);
d = hypot(diff(x), diff(y));
d_tot = sum(d)
end
