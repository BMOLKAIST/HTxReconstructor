# HTx data reconstructor

This package recontrust data from HTx, Tomocube.


## brief code explanation

- supplementary_codes: a lot of helper (sub)functions to reconstruct data.
-  recon_path.json.example: example file of `recon_path.json` used to specify the directories of reconstruction codes
- recon3D.m: User can reconstruction their data specified in `recon_path.json` through the program.

## usage

1. Write `recon_path.json`
2. execute `recon3D.m`

`recon_path.json` specifies PSF_path and data_pathes. Assuming "path":"/path/of/data", the path should have directory sturucture like "/path/of/data/\*/data3d". background image path is optionally specfied. otherwise, defualt path ("/path/of/data/\*/bgImages") is used.

Then execute `recon3D.m` to reconstruct the data. The data will be reconstructed into `*.mat` file

## bug report/enhancement request

Please report bug or request enhancement using github issues