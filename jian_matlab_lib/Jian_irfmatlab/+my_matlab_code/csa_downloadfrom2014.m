URL = 'https://csa.esac.esa.int/csa/aio/product-action';
fileName=tempname;
gzFileName = [fileName '.gz'];
options = weboptions( 'Timeout', Inf);

%options = weboptions('RequestMethod', 'get', 'Timeout', Inf);
tgzFileName = websave(gzFileName, URL, 'DATASET_ID', 'C1_CP_PEA_PITCH_SPIN_DPFlux', ...
    'START_DATE', '2008-04-24T21:40:00Z', 'END_DATE', '2008-04-24T21:45:00Z', ...
    'DELIVERY_FORMAT', 'CDF', 'NON_BROWSER', '1', 'DELIVERY_INTERVAL', 'HOURLY', ...
    'CSACOOKIE','2111526F2C146A6B7D59063978464F6238091D643809502F2E1B522F2206477D7F5C05317959073673284270650B5C6C', options);
gunzip(gzFileName);
fileNames=untar(fileName);
for iFile = 1:numel(fileNames), disp(fileNames{iFile}); end