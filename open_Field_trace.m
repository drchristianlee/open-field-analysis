clear;
[file,path] = uigetfile;
cd(path);
load(file);

plot(res_keeper(:,1),res_keeper(:,2));
axis([0 168 0 75])