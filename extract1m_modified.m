% The original author of this function is Catherine de Groot-Hedlin (SIO, chedlin@ucsd.edu).
% Credit belongs to Catherine, and any introduced mistake is likely my own. -lnferris

function  [image_data,vlat,vlon] = extract1m_modified(region,ssfname)
%    [Z,LAT,LON] = extract1m_modified(REGION) extracts 1-minute data from Sandwell and Smith bathymetry

%                                               Author: Catherine de Groot-Hedlin (UCSD)
%                                               modified Rich Pawlowicz (UBC), added post-v9 option
%                                               modified L.N. Ferris, removed pre-v9 option
%       input:
%               REGION =[west east south north]; % limits [-180 180 -80.738 80.738]
%       output:
%               Z - matrix of sandwell bathymetry/topography
%               LAT - vector of latitudes associated with image_data
%               LON - vector of longitudes


% determine the requested region
wlon = region(1);
elon = region(2);
slat = region(3);
nlat = region(4);

% Setup the parameters for reading Sandwell data version 
db_res         = 1/60;          % 1 minute resolution
db_loc         = [-80.738  80.738 0.0 360-db_res];
db_size        = [17280 21600];     
nbytes_per_lat = db_size(2)*2;  % 2-byte integers

% Check ranges

if slat<db_loc(1)
    slat=db_loc(1);
end

if nlat>db_loc(2)
    nlat=db_loc(2);
end


% Determine if the database needs to be read twice (overlapping prime meridian)
if ((wlon<0)&&(elon>=0))
      wlon      = [wlon           0];
      elon      = [360-db_res  elon];
end

% Calculate number of "records" down to start (latitude) (0 to db_size(1)-1)
% (mercator projection)
rad=pi/180;

arg1=log(tand(45+db_loc(1)/2));
arg2=log(tand(45+slat/2));
islat = fix(db_size(1) +1 - (arg2-arg1)/(db_res*rad));

arg2=log(tand(45+nlat/2));
inlat = fix(db_size(1) +1 - (arg2-arg1)/(db_res*rad));

if (islat < 0 ) || (inlat > db_size(1)-1)
        errordlg(' Requested latitude is out of file coverage ');
end

% Go ahead and read the database
% Open the data file
fid = fopen( ssfname, 'r','b');
if (fid < 0)
        error(['Could not open database: '  ssfname],'Error');
end

image_data     = [];
for i = 1:length(wlon)


        % Make sure the longitude data goes from 0 to 360
        if wlon(i) < 0
                wlon(i) = 360 + wlon(i);
        end

        if elon(i) < 0
                elon(i) = 360 + elon(i);
        end

        % Calculate the longitude indices into the matrix (0 to db_size(1)-1)
        iwlon(i) = fix((wlon(i)-db_loc(3))/db_res);
        ielon(i) = fix((elon(i)-db_loc(3))/db_res);
        if (iwlon(i) < 0 ) || (ielon(i) > db_size(2)-1)
               error([' Requested longitude is out of file coverage ']);
        end

        % allocate memory for the data
        data = zeros(islat-inlat+1,ielon(i)-iwlon(i)+1);

        % Skip into the appropriate spot in the file, and read in the data
        disp('Reading in bathymetry data');
        for ilat = inlat:islat
                offset = ilat*nbytes_per_lat + iwlon(i)*2;
                status = fseek(fid, offset, 'bof');
                data(islat-ilat+1,:)=fread(fid,[1,ielon(i)-iwlon(i)+1],'integer*2');
        end

        % put the two files together if necessary
        if (i>1)
                image_data = [image_data data];
        else
                image_data = data;
        end
end
% close the file
fclose(fid);
disp('Done reading');

% Determine the coordinates of the image_data
vlat=zeros(1,islat-inlat+1);
arg2 = log(tand(45+db_loc(1)/2.));
for ilat=inlat+1:islat+1
        arg1 = rad*db_res*(db_size(1)-ilat+0.5);
        term=exp(arg1+arg2);
        vlat(islat-ilat+2)=2*atand(term)-90;
end
vlon=db_res*((iwlon+1:ielon+1)-0.5);
end
