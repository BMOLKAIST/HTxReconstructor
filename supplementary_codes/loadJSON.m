function json_data = loadJSON(fname)
    fid = fopen(fname);
    text = fread(fid,'*char');
    json_data = jsondecode(text');
    fclose(fid);
end