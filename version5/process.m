function process(filename)
file=textread(filename,'%s','delimiter','\n');
fid=fopen('transfer.txt','w');
for i=1:length(file)
    str=file{i};
    k=strfind(str,' ');
    crop=str(k(1)+1:end);
    fprintf(fid,'%s \n',crop);
end
fclose(fid);
type transfer.txt