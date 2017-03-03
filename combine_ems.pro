; procedure to read in source files from MACCity etc and combine different sources into single species files

;which emission to process?
iNOx_surface = 1
iNOx_aircraft = 0
iCO = 1
iHCHO = 1
iC2H6 = 1
iC3H8 = 1
iMe2CO = 1
iMeCHO = 1
iNVOC = 1
iSO2_low = 1
iSO2_high = 1
iSO2_biomass_3d = 1
iSO2_3d = 1
iNH3 = 1
iBC_fossil = 1
iBC_biofuel = 1
iBC_biomass_3d = 1
iOC_fossil = 1
iOC_biofuel = 1
iOC_biomass_3d = 1
iDMS_land = 1
iCH4_wetland = 1
iisoprene = 1
imonoterpene = 1

path_out='/nfs/a107/earkpr/Marcus/PEGASOS/nc_for_ancil/'

;which volcanic emissions to use?
; 1 - AeroCom
; 2 - AeroCom-II - not currently functional
ivolcanic = 1

; load template file (MACCity)
file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_NOx_1960-2010.nc'
ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
NCDF_CLOSE, ncid      ; Close the NetCDF file
nlon_in=n_elements(lon) ; 0.5 degrees
lon_in=lon
nlat_in=n_elements(lat) ; 0.5 degrees
lat_in=lat

nsteps=n_elements(date) ; number of months between 01/1960 and 12/2010
nsteps_out=n_elements(date)+2 ; number of months between 01/1960 and 12/2010, plus a leading and tailing month necessary for UM interpolation
nsteps_in_year=12

date_out=lonarr(nsteps_out)
date_out[0]=date[0] - 31 ; December 1959
date_out[1:n_elements(date)]=date[0:n_elements(date)-1]
date_out[nsteps_out-1]=date[n_elements(date)-1] + 31 ; January 2011

nyears=51 ; 51 years in MACCity data - 01/01/1960 to 31/12/2010


;define output grid, N96
nlon_out=192
nlat_out=145
nlevels_out=63

lon_out=fltarr(nlon_out)
lat_out=fltarr(nlat_out)
hybrid_ht=fltarr(nlevels_out)

lon_out = [0.0, 1.875, 3.75, 5.625, 7.5, 9.375, 11.25, 13.125, 15.0, 16.875, $
    18.75, 20.625, 22.5, 24.375, 26.25, 28.125, 30.0, 31.875, 33.75, 35.625, $
    37.5, 39.375, 41.25, 43.125, 45.0, 46.875, 48.75, 50.625, 52.5, 54.375, $
    56.25, 58.125, 60.0, 61.875, 63.75, 65.625, 67.5, 69.375, 71.25, 73.125, $
    75.0, 76.875, 78.75, 80.625, 82.5, 84.375, 86.25, 88.125, 90.0, 91.875, $
    93.75, 95.625, 97.5, 99.375, 101.25, 103.125, 105.0, 106.875, 108.75, $
    110.625, 112.5, 114.375, 116.25, 118.125, 120.0, 121.875, 123.75, 125.625, $
    127.5, 129.375, 131.25, 133.125, 135.0, 136.875, 138.75, 140.625, 142.5, $
    144.375, 146.25, 148.125, 150.0, 151.875, 153.75, 155.625, 157.5, 159.375, $
    161.25, 163.125, 165.0, 166.875, 168.75, 170.625, 172.5, 174.375, 176.25, $
    178.125, 180.0, 181.875, 183.75, 185.625, 187.5, 189.375, 191.25, 193.125, $
    195.0, 196.875, 198.75, 200.625, 202.5, 204.375, 206.25, 208.125, 210.0, $
    211.875, 213.75, 215.625, 217.5, 219.375, 221.25, 223.125, 225.0, 226.875, $
    228.75, 230.625, 232.5, 234.375, 236.25, 238.125, 240.0, 241.875, 243.75, $
    245.625, 247.5, 249.375, 251.25, 253.125, 255.0, 256.875, 258.75, 260.625, $
    262.5, 264.375, 266.25, 268.125, 270.0, 271.875, 273.75, 275.625, 277.5, $
    279.375, 281.25, 283.125, 285.0, 286.875, 288.75, 290.625, 292.5, 294.375, $
    296.25, 298.125, 300.0, 301.875, 303.75, 305.625, 307.5, 309.375, 311.25, $
    313.125, 315.0, 316.875, 318.75, 320.625, 322.5, 324.375, 326.25, 328.125, $
    330.0, 331.875, 333.75, 335.625, 337.5, 339.375, 341.25, 343.125, 345.0, $
    346.875, 348.75, 350.625, 352.5, 354.375, 356.25, 358.125 ]

lat_out = [-90.0, -88.75, -87.5, -86.25, -85.0, -83.75, -82.5, -81.25, -80.0, $
    -78.75, -77.5, -76.25, -75.0, -73.75, -72.5, -71.25, -70.0, -68.75, -67.5, $
    -66.25, -65.0, -63.75, -62.5, -61.25, -60.0, -58.75, -57.5, -56.25, -55.0, $
    -53.75, -52.5, -51.25, -50.0, -48.75, -47.5, -46.25, -45.0, -43.75, -42.5, $
    -41.25, -40.0, -38.75, -37.5, -36.25, -35.0, -33.75, -32.5, -31.25, -30.0, $
    -28.75, -27.5, -26.25, -25.0, -23.75, -22.5, -21.25, -20.0, -18.75, -17.5, $
    -16.25, -15.0, -13.75, -12.5, -11.25, -10.0, -8.75, -7.5, -6.25, -5.0, -3.75, $
    -2.5, -1.25, 0.0, 1.25, 2.5, 3.75, 5.0, 6.25, 7.5, 8.75, 10.0, 11.25, 12.5, $
    13.75, 15.0, 16.25, 17.5, 18.75, 20.0, 21.25, 22.5, 23.75, 25.0, 26.25, 27.5, $
    28.75, 30.0, 31.25, 32.5, 33.75, 35.0, 36.25, 37.5, 38.75, 40.0, 41.25, 42.5, $
    43.75, 45.0, 46.25, 47.5, 48.75, 50.0, 51.25, 52.5, 53.75, 55.0, 56.25, 57.5, $
    58.75, 60.0, 61.25, 62.5, 63.75, 65.0, 66.25, 67.5, 68.75, 70.0, 71.25, 72.5, $
    73.75, 75.0, 76.25, 77.5, 78.75, 80.0, 81.25, 82.5, 83.75, 85.0, 86.25, 87.5, $
    88.75, 90.0 ]

hybrid_ht = [ 20.000004, 53.33601, 100.0, 160.0, 233.336, 320.0001, 420.0001, 533.3361, $
    660.0001, 800.0001, 953.3362, 1120.0, 1300.0, 1493.336, 1700.0, 1920.0, 2153.336, $
    2400.0, 2660.0, 2933.336, 3220.001, 3520.001, 3833.337, 4160.001, 4500.0, $
    4853.337, 5220.0, 5600.0, 5993.337, 6400.001, 6820.001, 7253.345, 7700.041, $
    8160.137, 8633.706, 9120.906, 9621.962, 10137.23, 10667.25, 11212.74, $
    11774.71, 12354.51, 12953.91, 13575.16, 14221.15, 14895.43, 15602.46, $
    16347.61, 17137.43, 17979.73, 18883.84, 19860.78, 20923.46, 22086.95, $
    23368.76, 24789.05, 26371.03, 28141.21, 30129.78, 32370.99, 34903.55, $
    37771.04, 41022.39 ]

ndaysinmonth=[31,29,31,30,31,30,31,31,30,31,30,31] ;leap year

;calc thickness of each gridbox
d_ht=fltarr(n_elements(hybrid_ht))
d_ht[0]=2.0 * hybrid_ht[0]
for ilevel=0,n_elements(hybrid_ht)-2 do d_ht[ilevel+1]=(hybrid_ht[ilevel+1]-total(d_ht[0:ilevel])) * 2.0


;some constants
NOtoNO2 = 1.53333 ; factor to convert NO to NO2




; ------------------------------ NOx surface emissions -------------------------------------------

if (iNOx_surface eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_NOx_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=MACCity[*,*,*] ; as NO

 ;read MACCity biomass burning file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/biomass_burning/MACCity_from_ECCAD/MACCity_biomassBurning_NOx_1960-2008.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 ;MACCity biomass burning data only goes up to 2008. Recyle 2008 for 2009 and 2010
 species[*,*,0:587] = species[*,*,0:587] + MACCity[*,*,0:587] ; as NO
 species[*,*,588:599] = species[*,*,588:599] + MACCity[*,*,576:587] ; 2009
 species[*,*,600:611] = species[*,*,600:611] + MACCity[*,*,576:587] ; 2010
 
 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)
 
 ; convert NO to NO2 - source data is in NO, output required as NO2
 species_out = species_out * NOtoNO2 ; kg(NO2)/m2/s




 ; read in soil NOx emissions, supplied by Fiona O'Connor
 ; scaled to give 18.4 Tg (NO2)/year

 olon  = 360  ; 1.0x1.0 grid for natural ems
 olat  = 180  ; 1.0x1.0 grid for natural ems
 ntime    = 12
 dir      = '/nfs/foe-data-05_a73/earmtw/Data/emissions/natural_ems_from_Fiona/'
 ems      = fltarr(olon,olat,/nozero)
 soil_nox    = fltarr(olon,olat,ntime,/nozero)

 for i=0,ntime-1 do begin
  cmon     = string(i+1,format = '(i2.2)')
  filename = dir+'soilnox_1x1'+cmon+'.dat'
  openr,1, filename
  readf,1, ems
  close,1
  for j=0,olon-1 do begin
   for k=0,olat-1 do begin
     soil_nox (j,k,i) = ems(j,k)  ; kg(NO??)/gridcell - subsequently scaled anyway so not important to get units correct here
   endfor
  endfor
 endfor
 
 ; Original array goes from -179.5 to + 179.5, shift by -180 deg in longitude
 soil_nox = shift(soil_nox, -180, 0, 0)

 ; adjust units to kg(NO2)/m2/s
 restore,'/nfs/foe-data-05_a73/earmtw/Data/box_area_1x1deg.sav' ; gives box_area
 for imonth=0,ntime-1 do soil_nox[*,*,imonth] = soil_nox[*,*,imonth] * NOtoNO2 / box_area[*,*] / (3600.0*24.0*ndaysinmonth[imonth]) ;kg(NO2)/m2/s

 ;regrid to N96
 soil_nox_n96=congrid(soil_nox,nlon_out,nlat_out,ntime,/center)

 ; rescale emissions to 18.4 Tg(NO2) per year, as per UM approach
 restore,'/nfs/foe-data-05_a73/earmtw/Data/box_area_N96.sav' ; gives area2d
 soil_nox_n96_total=0.0
 for imonth=0,ntime-1 do soil_nox_n96_total=soil_nox_n96_total + total(soil_nox_n96[*,*,imonth] * area2d[*,*] * (3600.0*24.0*ndaysinmonth[imonth])) ; kg / year

 scaling = 18.4*1.0e9/soil_nox_n96_total
 for i=0,ntime-1 do begin
  soil_nox_n96[*,*,i] = soil_nox_n96[*,*,i]*scaling
 endfor

 ;apply emissions cyclically, loop over number of years and fill array
 for i=0,(nsteps/12) do begin 
  species_out[*,*,(12*i)-12:(12*i)-1] = species_out[*,*,(12*i)-12:(12*i)-1] + soil_nox_n96[*,*,0:11]
 endfor





 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ;;id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_NOx.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_NOx.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'NOx surface emissions, MACCity (anthro and wildfire) + soil NOx',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'NOx_ems', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'NOx surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(NO2)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif





; ------------------------------ NOx aircraft emissions -------------------------------------------
; Not available through MACCity - use ACCMIP from 1960 to 2000, then RCP8.5 to 2010.

if (iNOx_aircraft eq 1) then begin

 n_aviation_levs=25
 aviation_in=fltarr(nlon_in,nlat_in,n_aviation_levs,n_elements(date))

 month1=0
 month12=11
 for year=1960,2000 do begin ; load each successive year of aircraft NOx emissions
;  print,'Reading aircraft NOx for ',strtrim(year,2)
  file2='/nfs/foe-data-05_a73/earmtw/Data/emissions/ACCMIP_RCP_from_Juelich/accmip_interpolated_emissions_historic_NOx_aircraft_'+strtrim(year,2)+'_0.5x0.5.nc'
  ncid = NCDF_OPEN(file2)        ; Open The NetCDF file
  NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
  NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
  NCDF_VARGET, ncid,  2, lev      ; Read in variable 'lev'
  NCDF_VARGET, ncid,  3, time      ; Read in variable 'time'
  NCDF_VARGET, ncid,  4, emiss_air      ; Read in variable 'emiss_air'
  NCDF_CLOSE, ncid      ; Close the NetCDF file

  ;put onto same grid as MACCity data
  emiss_air=shift(emiss_air,360,0,0,0) ; shift array 180 degrees to right
  emiss_air=reverse(emiss_air,2) ; reverse latitude

  aviation_in[*,*,*,month1:month12]=aviation_in[*,*,*,month1:month12]+emiss_air[*,*,*,0:11] ; kg(NO)/m3/s at 0.5x0.5
  month1  = month1  + 12 ;increment indices
  month12 = month12 + 12 ;increment indices
 endfor

 for year=2001,2010 do begin ; load each successive year of aircraft NOx emissions
;  print,'Reading aircraft NOx for ',strtrim(year,2)
  file2='/nfs/foe-data-05_a73/earmtw/Data/emissions/ACCMIP_RCP_from_Juelich/accmip_interpolated_emissions_RCP85_NOx_aircraft_'+strtrim(year,2)+'_0.5x0.5.nc'
  ncid = NCDF_OPEN(file2)        ; Open The NetCDF file
  NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
  NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
  NCDF_VARGET, ncid,  2, lev      ; Read in variable 'lev'
  NCDF_VARGET, ncid,  3, time      ; Read in variable 'time'
  NCDF_VARGET, ncid,  4, emiss_air      ; Read in variable 'emiss_air'
  NCDF_CLOSE, ncid      ; Close the NetCDF file

  ;put onto same grid as MACCity data
  emiss_air=shift(emiss_air,360,0,0,0) ; shift array 180 degrees to right
  emiss_air=reverse(emiss_air,2) ; reverse latitude

  aviation_in[*,*,*,month1:month12]=aviation_in[*,*,*,month1:month12]+emiss_air[*,*,*,0:11] ; kg(NO)/m3/s at 0.5x0.5
  month1  = month1  + 12 ;increment indices
  month12 = month12 + 12 ;increment indices
 endfor

 aviation_levels = lev * 1000.0 ; m

  ; calc interfaces of each L63 model level
 d_z=fltarr(nlevels_out)
 l63_bounds=fltarr(nlevels_out+1)
 d_z[0]=hybrid_ht[0] * 2.0
 for ilevel63=1,nlevels_out-1 do d_z[ilevel63]=(hybrid_ht[ilevel63] - total(d_z[0:ilevel63-1])) * 2.0
 for ilevel63=0,nlevels_out-1 do l63_bounds[ilevel63+1]=total(d_z[0:ilevel63])

  ; calc interface of each input level
 d_z_in=fltarr(n_aviation_levs)
 in_bounds=fltarr(n_aviation_levs+1)
 d_z_in[0]=aviation_levels[0] * 2.0
 for ilevel_in=1,n_aviation_levs-1 do d_z_in[ilevel_in]=(aviation_levels[ilevel_in] - total(d_z_in[0:ilevel_in-1])) * 2.0
 for ilevel_in=0,n_aviation_levs-1 do in_bounds[ilevel_in+1]=total(d_z_in[0:ilevel_in])

 ;regrid to N96
 array2d=fltarr(nlon_in,nlat_in)
 aviation_in_n96=fltarr(nlon_out,nlat_out,n_aviation_levs,n_elements(date))
 for idate=0,n_elements(date)-1 do begin
  for ilevel_in=0, n_aviation_levs-1 do begin
   array2d[*,*]=aviation_in[*,*,ilevel_in,idate] * d_z_in[ilevel_in] ; convert to kg(NO)/m2/s
   aviation_in_n96[*,*,ilevel_in,idate]=congrid(array2d,nlon_out,nlat_out,/center)
  endfor
 endfor
 aviation_in_n96=reverse(aviation_in_n96,2) ; reverse latitude
 aviation_in_n96=shift(aviation_in_n96,96,0,0,0) ; shift array 180 degrees to right

 ; regrid onto model L63 vertical grid
 ; laziest method - easy to code but very slow to run
 ; make 1d array with enough elements to divide whole L25 column into 1 m increments, then map onto L63 for each gridbox
 top_in_bound=fix(in_bounds[n_elements(in_bounds)-1])+1
 species_out_3d=fltarr(nlon_out,nlat_out,nlevels_out,n_elements(date))
 for ilon=0,nlon_out-1 do begin
  for ilat=0,nlat_out-1 do begin
   for idate=0,n_elements(date)-1 do begin

    ; fill column array with input data
    ems_column_in=fltarr(top_in_bound)
    for ilevel_in=0,n_aviation_levs-1 do begin
     ems_column_in[fix(in_bounds[ilevel_in]):fix(in_bounds[ilevel_in+1])] = aviation_in_n96[ilon,ilat,ilevel_in,idate] / d_z_in[ilevel_in]
    endfor

    ; apply L25 column data to L63 grid
    for ilevel63=0,nlevels_out-1 do begin
     if (l63_bounds[ilevel63] lt in_bounds[n_elements(in_bounds)-2]) then species_out_3d[ilon,ilat,ilevel63,idate] = $
      mean(ems_column_in[fix(l63_bounds[ilevel63]):fix(l63_bounds[ilevel63+1])]) * d_z[ilevel63] ; kg(NO)/m2/s
    endfor

   endfor
  endfor
 endfor

 ; convert units from kg(NO)/m2/s to kg(NO2)/gridbox/s - units different to all other species...
 restore,'/nfs/foe-data-05_a73/earmtw/Data/box_area_N96.sav' ; gives area2d
 for idate=0,n_elements(date)-1 do begin
  for ilevel63=0, nlevels_out-1 do begin
   species_out_3d[*,*,ilevel63,idate] = species_out_3d[*,*,ilevel63,idate] * area2d[*,*] * NOtoNO2 ; kg(NO2)/box/s at N96
  endfor
 endfor

 ;output yearly 3d field
 month1=0
 month12=11
 for year=1960,2010 do begin ; output 14 months in each file (i.e. include leading and tailing months for each year)

  ;create new .nc file
  ; use 'date' and lon / lat attributes from MACCity input files
  ;id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/ACCMIP_RCP85_NOx_aircraft_'+strtrim(year,2)+'.nc',/CLOBBER)
  id = NCDF_CREATE(string(path_out)+'ACCMIP_RCP85_NOx_aircraft_'+strtrim(year,2)+'.nc',/CLOBBER)
 
  ;add global attributes
  NCDF_ATTPUT, id, 'Title', 'NOx aircraft 3D emissions, from ACCMIP and RCP 8.5',/char, /GLOBAL
  
  ;define dimensions of array
  lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
  lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
  levels_arr = NCDF_DIMDEF(id, 'levels', nlevels_out) ; Define the Z dimension
  date_arr = NCDF_DIMDEF(id, 't', nsteps_in_year+2) ;define t dimension ; include leading and tailing months
 
  ;add variables and associated attributes
  lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
   NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
   NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
  
  latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
   NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
   NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
  
  levelsvid=NCDF_VARDEF(id, 'levels', [levels_arr],/LONG)
   NCDF_ATTPUT, id, levelsvid, 'name', 'level index',/char
  
  datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
   NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
  datavid=NCDF_VARDEF( id, 'NOx_aircraft', [lon_arr,lat_arr,levels_arr,date_arr],/FLOAT)
   NCDF_ATTPUT, id, datavid, 'name', 'NOx aircraft emissions',/char
   NCDF_ATTPUT, id, datavid, 'units', 'kg(NO2)/gridbox/s',/char
  
  ;put the NetCDF file into data mode:
  NCDF_CONTROL, id, /ENDEF
  
  ;put data into NetCDF file
  NCDF_VARPUT, id, lonvid, lon_out
  NCDF_VARPUT, id, latvid, lat_out
  NCDF_VARPUT, id, levelsvid, hybrid_ht
  ; add date:  
  date14=lonarr(14) ; 14 months per file including leading and tailing months
  date14[1:12] = date_out[month1+1:month12+1] ; 12 months of year in question
  date14[0] = date14[1] - 31 ; date of leading month
  date14[13] = date14[12] + 31 ; date of trailing month
  NCDF_VARPUT, id, datevid, date14
  ; add data:
  NCDF_VARPUT, id, datavid, offset=[0,0,0,1], species_out_3d[*,*,*,month1:month12] ; Jan to Dec of year in question

  if (month1 eq 0) then begin ; leading month
   NCDF_VARPUT, id, datavid, offset=[0,0,0,0], species_out_3d[*,*,*,month1] ; use current month if at start of time series
  endif else begin
   NCDF_VARPUT, id, datavid, offset=[0,0,0,0], species_out_3d[*,*,*,month1-1] ; use preceeding month if within time series
  endelse
  
  if (month12 eq nsteps-1) then begin ; tailing month
   NCDF_VARPUT, id, datavid, offset=[0,0,0,13], species_out_3d[*,*,*,month12] ; use current month if at end of time series
  endif else begin
   NCDF_VARPUT, id, datavid, offset=[0,0,0,13], species_out_3d[*,*,*,month12+1] ; use next month if within time series
  endelse
  
  ;close NetCDF file
  NCDF_CLOSE, id

  ;increment months
  month1=month1+12
  month12=month12+12

 endfor

endif










; ------------------------------ CO surface emissions -------------------------------------------

if (iCO eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_CO_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=MACCity[*,*,*]

 ;read MACCity biomass burning file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/biomass_burning/MACCity_from_ECCAD/MACCity_biomassBurning_CO_1960-2008.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 ;MACCity biomass burning data only goes up to 2008. Recyle 2008 for 2009 and 2010
 species[*,*,0:587] = species[*,*,0:587] + MACCity[*,*,0:587]
 species[*,*,588:599] = species[*,*,588:599] + MACCity[*,*,576:587] ; 2009
 species[*,*,600:611] = species[*,*,600:611] + MACCity[*,*,576:587] ; 2010



 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)
 
 
 

 ; read in oceanic (non-shipping) CO emissions for year 2000, supplied by Fiona O'Connor
  ; Non-shipping emissions of CO based on spatial and temporal distribution provided by GEIA (http://www.geiacenter.org/inventories/present.html) and are based on distributions of oceanic VOC emissions from Guenther et al., 1995. The emissions were scaled to give 45 TgCO/year.

 olon  = 360  ; 1.0x1.0 grid for ocean ems
 olat  = 180  ; 1.0x1.0 grid for ocean ems
 ntime    = 12
 dir      = '/nfs/foe-data-05_a73/earmtw/Data/emissions/natural_ems_from_Fiona/'
 ems      = fltarr(olon,olat,/nozero)
 ocean_co    = fltarr(olon,olat,ntime,/nozero)

 for i=0,ntime-1 do begin
  cmon     = string(i+1,format = '(i2.2)')
  filename = dir+'nvoc_ocean_1x1'+cmon+'.dat'
  openr,1, filename
  readf,1, ems
  close,1
  for j=0,olon-1 do begin
   for k=0,olat-1 do begin
     ocean_co (j,k,i) = ems(j,k)             ; kg(CO)/gridcell
   endfor
  endfor
 endfor
 
 ; Original array goes from -179.5 to + 179.5, shift by -180 deg in longitude
 ocean_co = shift(ocean_co, -180, 0, 0)

 ; adjust units to kg(CO)/m2/s
 restore,'/nfs/foe-data-05_a73/earmtw/Data/box_area_1x1deg.sav' ; gives box_area
 for imonth=0,ntime-1 do ocean_co[*,*,imonth] = ocean_co[*,*,imonth] / box_area[*,*] / (3600.0*24.0*ndaysinmonth[imonth]) ;kg(CO)/m2/s

 ;regrid to N96
 ocean_co_n96=congrid(ocean_co,nlon_out,nlat_out,ntime,/center)

 ; rescale oceanic emissions to 45 Tg(CO) per year, as per UM approach
 restore,'/nfs/foe-data-05_a73/earmtw/Data/box_area_N96.sav' ; gives area2d
 ocean_co_n96_total=0.0
 for imonth=0,ntime-1 do ocean_co_n96_total=ocean_co_n96_total + total(ocean_co_n96[*,*,imonth] * area2d[*,*] * (3600.0*24.0*ndaysinmonth[imonth])) ; kg / year

 ocean_scaling = 45.0*1.0e9/ocean_co_n96_total
 for i=0,ntime-1 do begin
  ocean_co_n96[*,*,i] = ocean_co_n96[*,*,i]*ocean_scaling
 endfor

 ;apply emissions cyclically, loop over number of years and fill array
 for i=0,(nsteps/12) do begin 
  species_out[*,*,(12*i)-12:(12*i)-1] = species_out[*,*,(12*i)-12:(12*i)-1] + ocean_co_n96[*,*,0:11] 
 endfor




 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_CO.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_CO.nc',/CLOBBER)

 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'CO surface emissions, MACCity (anthro + wildfire) + ocean NVOC surrogate',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'CO_ems', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'CO surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(CO)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif




; ------------------------------ HCHO surface emissions -------------------------------------------

if (iHCHO eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_formaldehyde_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=MACCity[*,*,*]
 
 ;read MACCity biomass burning file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/biomass_burning/MACCity_from_ECCAD/MACCity_biomassBurning_formaldehyde_1960-2008.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 ;MACCity biomass burning data only goes up to 2008. Recyle 2008 for 2009 and 2010
 species[*,*,0:587] = species[*,*,0:587] + MACCity[*,*,0:587]
 species[*,*,588:599] = species[*,*,588:599] + MACCity[*,*,576:587] ; 2009
 species[*,*,600:611] = species[*,*,600:611] + MACCity[*,*,576:587] ; 2010

 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)
 
 
 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_HCHO.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_HCHO.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'HCHO surface emissions, MACCity (anthro + wildfire)',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'HCHO_ems', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'HCHO surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(HCHO)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif



; ------------------------------ C2H6 surface emissions -------------------------------------------
; UKCA ethane emissions also contains ethene and ethyne (not available from MACCity), lumped together in units of ethane (mm = 30)

if (iC2H6 eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_ethane_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=MACCity[*,*,*]
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_ethene_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+(MACCity[*,*,*] / 28.0 * 30.0) ; converted from mm of ethene (28) to mm of ethane (30)

 ;read MACCity biomass burning file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/biomass_burning/MACCity_from_ECCAD/MACCity_biomassBurning_ethane_1960-2008.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 ;MACCity biomass burning data only goes up to 2008. Recyle 2008 for 2009 and 2010
 species[*,*,0:587] = species[*,*,0:587] + MACCity[*,*,0:587]
 species[*,*,588:599] = species[*,*,588:599] + MACCity[*,*,576:587] ; 2009
 species[*,*,600:611] = species[*,*,600:611] + MACCity[*,*,576:587] ; 2010

 ;read MACCity biomass burning file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/biomass_burning/MACCity_from_ECCAD/MACCity_biomassBurning_ethene_1960-2008.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 ;MACCity biomass burning data only goes up to 2008. Recyle 2008 for 2009 and 2010
 species[*,*,0:587] = species[*,*,0:587] + (MACCity[*,*,0:587] / 28.0 * 30.0) ; converted from mm of ethene (28) to mm of ethane (30)
 species[*,*,588:599] = species[*,*,588:599] + MACCity[*,*,576:587] ; 2009
 species[*,*,600:611] = species[*,*,600:611] + MACCity[*,*,576:587] ; 2010
 
 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)
 
 
 
 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_C2H6.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_C2H6.nc',/CLOBBER)

 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'C2H6 surface emissions, MACCity (anthro + wildfire)',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'C2H6_ems', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'C2H6 surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(C2H6)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif




; ------------------------------ C3H8 surface emissions -------------------------------------------
; UKCA propane emissions also contains propene, lumped together in units of propane (mm = 44)
if (iC3H8 eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_propane_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=MACCity[*,*,*]
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_propene_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+(MACCity[*,*,*] / 42.0 * 44.0) ; converted from mm of propene (42) to mm of propane (44)

 ;read MACCity biomass burning file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/biomass_burning/MACCity_from_ECCAD/MACCity_biomassBurning_propane_1960-2008.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 ;MACCity biomass burning data only goes up to 2008. Recyle 2008 for 2009 and 2010
 species[*,*,0:587] = species[*,*,0:587] + MACCity[*,*,0:587]
 species[*,*,588:599] = species[*,*,588:599] + MACCity[*,*,576:587] ; 2009
 species[*,*,600:611] = species[*,*,600:611] + MACCity[*,*,576:587] ; 2010

 ;read MACCity biomass burning file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/biomass_burning/MACCity_from_ECCAD/MACCity_biomassBurning_propene_1960-2008.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 ;MACCity biomass burning data only goes up to 2008. Recyle 2008 for 2009 and 2010
 species[*,*,0:587] = species[*,*,0:587] + (MACCity[*,*,0:587] / 42.0 * 44.0) ; converted from mm of propene (42) to mm of propane (44)
 species[*,*,588:599] = species[*,*,588:599] + MACCity[*,*,576:587] ; 2009
 species[*,*,600:611] = species[*,*,600:611] + MACCity[*,*,576:587] ; 2010

 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)
 
 
 
 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_C3H8.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_C3H8.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'C3H8 surface emissions, MACCity (anthro + wildfire)',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'C3H8_ems', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'C3H8 surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(C3H8)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif



; ------------------------------ Me2CO surface emissions -------------------------------------------
; UKCA emissions also include 'other ketones'.
if (iMe2CO eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_acetone_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=MACCity[*,*,*]
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_other_ketones_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+(MACCity[*,*,*] / 75.3 * 58.0) ; convert from ketones (assume mm of 73.5 as in UKCA assumptions) to acetone (mm of 58)

 ;read MACCity biomass burning file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/biomass_burning/MACCity_from_ECCAD/MACCity_biomassBurning_total_ketones_1960-2008.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 ;MACCity biomass burning data only goes up to 2008. Recyle 2008 for 2009 and 2010
 species[*,*,0:587] = species[*,*,0:587] + (MACCity[*,*,0:587] / 72.0 * 58.0) ; convert to mm of acetone
 species[*,*,588:599] = species[*,*,588:599] + MACCity[*,*,576:587] ; 2009
 species[*,*,600:611] = species[*,*,600:611] + MACCity[*,*,576:587] ; 2010

 
 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)
 



 ; read in vegetation Me2CO emissions, supplied by Fiona O'Connor
 ; scaled to give 40.0 Tg (NO2)/year

 olon  = 360  ; 1.0x1.0 grid for natural ems
 olat  = 180  ; 1.0x1.0 grid for natural ems
 ntime    = 12
 dir      = '/nfs/foe-data-05_a73/earmtw/Data/emissions/natural_ems_from_Fiona/'
 ems      = fltarr(olon,olat,/nozero)
 Me2CO_veg = fltarr(olon,olat,ntime,/nozero)

 for i=0,ntime-1 do begin
  cmon     = string(i+1,format = '(i2.2)')
  filename = dir+'nvoc_land_1x1'+cmon+'.dat'
  openr,1, filename
  readf,1, ems
  close,1
  for j=0,olon-1 do begin
   for k=0,olat-1 do begin
     Me2CO_veg (j,k,i) = ems(j,k)  ; kg(???)/gridcell - subsequently scaled anyway so not important to get units correct here
   endfor
  endfor
 endfor
 
 ; Original array goes from -179.5 to + 179.5, shift by -180 deg in longitude
 Me2CO_veg = shift(Me2CO_veg, -180, 0, 0)

 ; adjust units to kg(Me2CO)/m2/s
 restore,'/nfs/foe-data-05_a73/earmtw/Data/box_area_1x1deg.sav' ; gives box_area
 for imonth=0,ntime-1 do Me2CO_veg[*,*,imonth] = Me2CO_veg[*,*,imonth] / box_area[*,*] / (3600.0*24.0*ndaysinmonth[imonth]) ;kg(???)/m2/s

 ;regrid to N96
 Me2CO_veg_n96=congrid(Me2CO_veg,nlon_out,nlat_out,ntime,/center)

 ; rescale emissions to 40.0 Tg(Me2CO) per year, as per UM approach
 restore,'/nfs/foe-data-05_a73/earmtw/Data/box_area_N96.sav' ; gives area2d
 Me2CO_veg_n96_total=0.0
 for imonth=0,ntime-1 do Me2CO_veg_n96_total=Me2CO_veg_n96_total + total(Me2CO_veg_n96[*,*,imonth] * area2d[*,*] * (3600.0*24.0*ndaysinmonth[imonth])) ; kg / year

 scaling = 40.0*1.0e9/Me2CO_veg_n96_total
 for i=0,ntime-1 do begin
  Me2CO_veg_n96[*,*,i] = Me2CO_veg_n96[*,*,i]*scaling
 endfor

 ;apply emissions cyclically, loop over number of years and fill array
 for i=0,(nsteps/12) do begin 
  species_out[*,*,(12*i)-12:(12*i)-1] = species_out[*,*,(12*i)-12:(12*i)-1] + Me2CO_veg_n96[*,*,0:11]
 endfor


 
 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_Me2CO.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_Me2CO.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'Me2CO surface emissions, MACCity (anthro + wildfire) + vegetation ems',/char, /GLOBAL
 
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'Me2CO_ems', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'Me2CO surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(Me2CO)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif



; ------------------------------ MeCHO surface emissions -------------------------------------------

if (iMeCHO eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_other_aldehydes_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=MACCity[*,*,*]
 
 ;read MACCity biomass burning file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/biomass_burning/MACCity_from_ECCAD/MACCity_biomassBurning_other_aldehydes_1960-2008.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 ;MACCity biomass burning data only goes up to 2008. Recyle 2008 for 2009 and 2010
 species[*,*,0:587] = species[*,*,0:587] + MACCity[*,*,0:587]
 species[*,*,588:599] = species[*,*,588:599] + MACCity[*,*,576:587] ; 2009
 species[*,*,600:611] = species[*,*,600:611] + MACCity[*,*,576:587] ; 2010
 
 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)
 
 
 
 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_MeCHO.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_MeCHO.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'MeCHO surface emissions, MACCity (anthro + wildfire)',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'MeCHO_ems', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'MeCHO surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(MeCHO)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif



; ------------------------------ NVOC surface emissions -------------------------------------------

if (iNVOC eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_methanol_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=MACCity[*,*,*]

 
 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)
 species_out=species_out/2.0 ; units into C from CH3OH


 ; read in existing NVOC emissions ancillary (from GEIA?).
 ncid = NCDF_OPEN('/nfs/foe-data-05_a73/earmtw/Data/UKCA_ancils/AR5_aero_2000.nc')            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, longitude      ; Read in variable 'longitude'
 NCDF_VARGET, ncid,  1, latitude      ; Read in variable 'latitude'
 NCDF_VARGET, ncid,  2, unspecified      ; Read in variable 'unspecified'
 NCDF_VARGET, ncid,  3, t      ; Read in variable 't'
 NCDF_VARGET, ncid,  4, field531      ; Read in variable 'field531'
 NCDF_VARGET, ncid,  5, field532      ; Read in variable 'field532'
 NCDF_VARGET, ncid,  6, field533      ; Read in variable 'field533'
 NCDF_VARGET, ncid,  7, field534      ; Read in variable 'field534'
 NCDF_VARGET, ncid,  8, field535      ; Read in variable 'field535'
 NCDF_VARGET, ncid,  9, field536      ; Read in variable 'field536'
 NCDF_VARGET, ncid,  10, field537      ; Read in variable 'field537'
 NCDF_VARGET, ncid,  11, field538      ; Read in variable 'field538'
 NCDF_VARGET, ncid,  12, field540      ; Read in variable 'field540'
 NCDF_VARGET, ncid,  13, field541      ; Read in variable 'field541'
 NCDF_VARGET, ncid,  14, field542      ; Read in variable 'field542'
 NCDF_VARGET, ncid,  15, field543      ; Read in variable 'field543'
 NCDF_VARGET, ncid,  16, surface      ; Read in variable 'surface'
 NCDF_VARGET, ncid,  17, field544      ; Read in variable 'field544'
 NCDF_VARGET, ncid,  18, field545      ; Read in variable 'field545'
 NCDF_VARGET, ncid,  19, field546      ; Read in variable 'field546'
 NCDF_CLOSE, ncid      ; Close the NetCDF file


 ;apply emissions cyclically, loop over number of years and fill array
 for i=0,(nsteps/12) do begin
  species_out[*,*,(12*i)-12:(12*i)-1] = species_out[*,*,(12*i)-12:(12*i)-1] + field546[*,*,0,0:11]
 endfor


 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_NVOC.nc',/CLOBBER) 
 id = NCDF_CREATE(string(path_out)+'MACCity_NVOC.nc',/CLOBBER)

 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'NVOC (CH3OH) surface emissions, MACCity (anthro + wildfire) + vegetation',/char, /GLOBAL

 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'NVOC_ems', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'NVOC surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(C)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif




; ------------------------------ SO2 surface ('low level') emissions -------------------------------------------
; note that UKCA separates low-level and high-level emissions separated according to sector here
 ; 

if (iSO2_low eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_SO2_agric_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_SO2_agricwaste_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_SO2_residential_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_SO2_ships_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_SO2_transportation_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_SO2_waste_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_SO2_solvents_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)
 species_out=species_out/2.0 ; units into S from SO2

 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_SO2_low_level.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_SO2_low_level.nc',/CLOBBER)

 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'SO2 surface (low-level) emissions, MACCity (anthro)',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'SO2_ems', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'SO2 surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(S)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif




; ------------------------------ SO2 surface ('high level') emissions -------------------------------------------
; note that UKCA separates low-level and high-level emissions - apparently not separated in MACCity

if (iSO2_high eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_SO2_energy_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_SO2_industries_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]
 
 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)
 species_out=species_out/2.0 ; units into S from SO2
 
 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/emissions/PEGASOS/nc_for_ancil/MACCity_SO2_high_level.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_SO2_high_level.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'SO2 surface (high-level) emissions, MACCity (anthro)',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'SO2_ems', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'SO2 surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(S)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif







; ------------------------------ SO2 3d natural emissions from biomass -------------------------------------------
; emissions distributed over lowermost boxes

if (iSO2_biomass_3d eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 species_out_3d=fltarr(nlon_out,nlat_out,nlevels_out,nsteps)

 ;read MACCity biomass burning file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/biomass_burning/MACCity_from_ECCAD/MACCity_biomassBurning_SO2_1960-2008.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 ;MACCity biomass burning data only goes up to 2008. Recyle 2008 for 2009 and 2010
 species[*,*,0:587] = species[*,*,0:587] + MACCity[*,*,0:587]
 species[*,*,588:599] = species[*,*,588:599] + MACCity[*,*,576:587] ; 2009
 species[*,*,600:611] = species[*,*,600:611] + MACCity[*,*,576:587] ; 2010

 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)
 species_out=species_out/2.0 ; units into S from SO2

 ; distribute emissions vertically
 fraction=fltarr(nlevels_out)
 for ilevel=0, nlevels_out-1 do begin
  ; distribute uniformly over lowermost 3 km (level 19), as per Zak / Colin's approach.
  if (hybrid_ht[ilevel] le hybrid_ht[19]) then fraction[ilevel] = (d_ht[ilevel] / total(d_ht[0:19]))
  species_out_3d[*,*,ilevel,*] = species_out[*,*,*] * fraction[ilevel]
 endfor

 ;output yearly 3d field
 month1=0
 month12=11
 for year=1960,2010 do begin ; output 14 months in each file (i.e. include leading and tailing months for each year)

  ;create new .nc file
  ; use 'date' and lon / lat attributes from MACCity input files
  ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_SO2_biomass_'+strtrim(year,2)+'.nc',/CLOBBER)
  id = NCDF_CREATE(string(path_out)+'MACCity_SO2_biomass_'+strtrim(year,2)+'.nc',/CLOBBER)
 
  ;add global attributes
  NCDF_ATTPUT, id, 'Title', 'SO2 biomass 3D emissions, from MACCity',/char, /GLOBAL
 
  ;define dimensions of array
  lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
  lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
  levels_arr = NCDF_DIMDEF(id, 'levels', nlevels_out) ; Define the Z dimension
  date_arr = NCDF_DIMDEF(id, 't', nsteps_in_year+2) ;define t dimension
 
  ;add variables and associated attributes
  lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
   NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
   NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
  
  latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
   NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
   NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
  
  levelsvid=NCDF_VARDEF(id, 'levels', [levels_arr],/LONG)
   NCDF_ATTPUT, id, levelsvid, 'name', 'level index',/char
  
  datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
   NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
  datavid=NCDF_VARDEF( id, 'SO2_biomass', [lon_arr,lat_arr,levels_arr,date_arr],/FLOAT)
   NCDF_ATTPUT, id, datavid, 'name', 'SO2 biomass emissions',/char
   NCDF_ATTPUT, id, datavid, 'units', 'kg(S)/m2/s',/char
  
  ;put the NetCDF file into data mode:
  NCDF_CONTROL, id, /ENDEF
  
  ;put data into NetCDF file
  NCDF_VARPUT, id, lonvid, lon_out
  NCDF_VARPUT, id, latvid, lat_out
  NCDF_VARPUT, id, levelsvid, hybrid_ht
  ; add date:  
  date14=lonarr(14) ; 14 months per file including leading and tailing months
  date14[1:12] = date_out[month1+1:month12+1] ; 12 months of year in question
  date14[0] = date14[1] - 31 ; date of leading month
  date14[13] = date14[12] + 31 ; date of trailing month
  NCDF_VARPUT, id, datevid, date14
  ; add data:
  NCDF_VARPUT, id, datavid, offset=[0,0,0,1], species_out_3d[*,*,*,month1:month12] ; Jan to Dec of year in question

  if (month1 eq 0) then begin ; leading month
   NCDF_VARPUT, id, datavid, offset=[0,0,0,0], species_out_3d[*,*,*,month1] ; use current month if at start of time series
  endif else begin
   NCDF_VARPUT, id, datavid, offset=[0,0,0,0], species_out_3d[*,*,*,month1-1] ; use preceeding month if within time series
  endelse
  
  if (month12 eq nsteps-1) then begin ; tailing month
   NCDF_VARPUT, id, datavid, offset=[0,0,0,13], species_out_3d[*,*,*,month12] ; use current month if at end of time series
  endif else begin
   NCDF_VARPUT, id, datavid, offset=[0,0,0,13], species_out_3d[*,*,*,month12+1] ; use next month if within time series
  endelse
  
  ;close NetCDF file
  NCDF_CLOSE, id

  ;increment months
  month1=month1+12
  month12=month12+12

 endfor

endif








; ------------------------------ SO2 3d volcanic emissions -------------------------------------------
; contains volcanic emissions data
if (iSO2_3d eq 1) then begin


 if (ivolcanic eq 1) then begin ; AeroCom-I
 ; read AeroCom-I volcanic emissions file (continuous emissions only)
  ; time averaged sporadic emissions excluded
  ; distribute emissions from surface to height_high
  ; cycle emissions over duration of ancillary

  ncid = NCDF_OPEN('/nfs/foe-data-05_a73/earmtw/Data/emissions/contineous_volc.nc')            ; Open The NetCDF file
  NCDF_VARGET, ncid,  0, field      ; Read in variable 'field'
  NCDF_VARGET, ncid,  1, height_low      ; Read in variable 'height_low'
  NCDF_VARGET, ncid,  2, height_high      ; Read in variable 'height_high'
  NCDF_VARGET, ncid,  3, volcano_heigth      ; Read in variable 'volcano_heigth'
  NCDF_VARGET, ncid,  4, gridbox_area      ; Read in variable 'gridbox_area'
  NCDF_VARGET, ncid,  5, time      ; Read in variable 'time'
  NCDF_VARGET, ncid,  6, lon      ; Read in variable 'lon'
  NCDF_VARGET, ncid,  7, lat      ; Read in variable 'lat'
  NCDF_CLOSE, ncid      ; Close the NetCDF file


  ; put onto N96 grid, and distribute emissions vertically
  species_out_3d=fltarr(nlon_out,nlat_out,nlevels_out,nsteps)
  restore,'/nfs/foe-data-05_a73/earmtw/Data/box_area_N96.sav'
  for ilon=0,n_elements(lon)-1 do begin
   for ilat=0,n_elements(lat)-1 do begin ; loop over elements in input field array
    if (field[ilon,ilat] gt 0.0) then begin

     ;look up N96 gridbox
     find_model_gridbox_n96,lon[ilon],lat[ilat],n96_lon_out,n96_lat_out

     ;distribute over the column
     fraction=fltarr(nlevels_out)
     for ilevel=0, nlevels_out-1 do begin

      ; distribute over column (and all time steps)
       ; Following advice in .nc file:
       ; Emissions should be distributed linearly between height_low and height_high. If height_low is below earth surface, emissions should be placed at ground level

      ;determine lowest gridbox
      if (hybrid_ht[ilevel] lt height_low[ilon,ilat]) then box_low = ilevel

      ;determine highest gridbox
      if (hybrid_ht[ilevel] lt height_high[ilon,ilat]) then box_high = ilevel

     endfor

     for ilevel=box_low, box_high do begin
      fraction[ilevel] = (d_ht[ilevel]) / total(d_ht[box_low:box_high])

       ; convert from kg(SO2)/gridbox/yr to kg(S)/m2/s
        ; divide by area to convert from per gridbox to per m2
        ; divide by 3600.*24.*365. to convert from per year to per second
        ; divide by 2 to convert from SO2 to S
      emission=field[ilon,ilat] / area2d[n96_lon_out,n96_lat_out] / 3.15360e+07 / 2.0 ; kg(S)/m2/s
      species_out_3d[n96_lon_out,n96_lat_out,ilevel,*] = emission * fraction[ilevel]

     endfor
    endif
   endfor
  endfor




  ;output yearly 3d field
  month1=0
  month12=11
  for year=1960,2010 do begin ; output 14 months in each file (i.e. include leading and tailing months for each year)

   ;create new .nc file
   ; use 'date' and lon / lat attributes from MACCity input files
   ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/SO2_3D_volcanic_AeroComI_'+strtrim(year,2)+'.nc',/CLOBBER)
   id = NCDF_CREATE(string(path_out)+'SO2_3D_volcanic_AeroComI_'+strtrim(year,2)+'.nc',/CLOBBER)
 
   ;add global attributes
   NCDF_ATTPUT, id, 'Title', 'SO2 natural (volcanic) 3D emissions, from AeroComI',/char, /GLOBAL
 
   ;define dimensions of array
   lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
   lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
   levels_arr = NCDF_DIMDEF(id, 'levels', nlevels_out) ; Define the Z dimension
   date_arr = NCDF_DIMDEF(id, 't', nsteps_in_year+2) ;define t dimension
 
   ;add variables and associated attributes
   lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
    NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
    NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
   latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
    NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
    NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
   levelsvid=NCDF_VARDEF(id, 'levels', [levels_arr],/LONG)
    NCDF_ATTPUT, id, levelsvid, 'name', 'level index',/char
 
   datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
    NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
   datavid=NCDF_VARDEF( id, 'SO2_volcanic', [lon_arr,lat_arr,levels_arr,date_arr],/FLOAT)
    NCDF_ATTPUT, id, datavid, 'name', 'SO2 natural (volcanic) emissions',/char
    NCDF_ATTPUT, id, datavid, 'units', 'kg(S)/m2/s',/char
 
   ;put the NetCDF file into data mode:
   NCDF_CONTROL, id, /ENDEF
 
   ;put data into NetCDF file
   NCDF_VARPUT, id, lonvid, lon_out
   NCDF_VARPUT, id, latvid, lat_out
   NCDF_VARPUT, id, levelsvid, hybrid_ht
  ; add date:  
  date14=lonarr(14) ; 14 months per file including leading and tailing months
  date14[1:12] = date_out[month1+1:month12+1] ; 12 months of year in question
  date14[0] = date14[1] - 31 ; date of leading month
  date14[13] = date14[12] + 31 ; date of trailing month
  NCDF_VARPUT, id, datevid, date14
  ; add data:
  NCDF_VARPUT, id, datavid, offset=[0,0,0,1], species_out_3d[*,*,*,month1:month12] ; Jan to Dec of year in question

  if (month1 eq 0) then begin ; leading month
   NCDF_VARPUT, id, datavid, offset=[0,0,0,0], species_out_3d[*,*,*,month1] ; use current month if at start of time series
  endif else begin
   NCDF_VARPUT, id, datavid, offset=[0,0,0,0], species_out_3d[*,*,*,month1-1] ; use preceeding month if within time series
  endelse
  
  if (month12 eq nsteps-1) then begin ; tailing month
   NCDF_VARPUT, id, datavid, offset=[0,0,0,13], species_out_3d[*,*,*,month12] ; use current month if at end of time series
  endif else begin
   NCDF_VARPUT, id, datavid, offset=[0,0,0,13], species_out_3d[*,*,*,month12+1] ; use next month if within time series
  endelse
 
   ;close NetCDF file
   NCDF_CLOSE, id

   ;increment months
   month1=month1+12
   month12=month12+12

  endfor

 endif ; ivolcanic eq 1






 if (ivolcanic eq 2) then begin ; AeroCom-II
  ; read AeroCom-II file created by Thomas Diehl (continuous and sporadic)
   ; data available for January 1st 1979 to December 31st 2009
   ; distribute emission from surface to column height
  ncid = NCDF_OPEN('/nfs/foe-data-05_a73/earmtw/Data/emissions/volc_ems_AeroComII/volc_so2.nc')     ; Open The NetCDF file
  NCDF_VARGET, ncid,  0, vid      ; Read in variable 'vid'
  NCDF_VARGET, ncid,  1, vname      ; Read in variable 'vname'
  NCDF_VARGET, ncid,  2, jdn      ; Read in variable 'jdn'
  NCDF_VARGET, ncid,  3, date      ; Read in variable 'date'
  NCDF_VARGET, ncid,  4, elevation      ; Read in variable 'elevation'
  NCDF_VARGET, ncid,  5, cloud_column_height      ; Read in variable 'cloud_column_height'
  NCDF_VARGET, ncid,  6, lon      ; Read in variable 'lon'
  NCDF_VARGET, ncid,  7, lat      ; Read in variable 'lat'
  NCDF_VARGET, ncid,  8, so2      ; Read in variable 'so2'
  NCDF_CLOSE, ncid      ; Close the NetCDF file


  ; convert from kt(SO2???)/day to kg(S)/m2/s




  string_date=strtrim(string(date),2)
  year_string=strmid(string_date,0,4) ;extract year
  year_integer=fix(year_string)
  month_string=strmid(string_date,4,2) ;extract month
  month_integer=fix(month_string)
  day_string=strmid(string_date,6,2) ;extract day
  day_integer=fix(day_string)

  ; divide into one year output files - all data in one file is too big to handle
  ; loop over years where data available, assigning each event to correct 3d gridbox and time
  for year=1960,nyears+1960-1 do begin ; loop over each year

   ; determine number of days in year
   ndaysinyear=julday(1, 1, year+1)-julday(1, 1, year) ;i.e. accounts for leap years

   ; calc days since 1960-01-01
   date_out_daily_1year=indgen(ndaysinyear) + (julday(1, 1, year)-julday(1, 1, 1960))

   species_out_3d_daily_1year=fltarr(nlon_out,nlat_out,nlevels_out,ndaysinyear)
   ii=where(year_integer eq year,count) ; years within dataset
   if (count gt 0) then begin ; if year is within AeroCom-II dataset

    for i_event=0, n_elements(ii)-1 do begin

     ; work out which gridbox to apply emission to
     find_model_gridbox_n96,lon[i_event],lat[i_event],model_lon_out,model_lat_out

     ; where to store event in time dimension of 3d array (i.e. which day of year)
     day_of_year_out=julday(month_integer[i_event],day_integer[i_event],year_integer[i_event])-julday(1,1,year_integer[i_event])

     ; which grid box to emit into?
      ; two cases - 1) elevation = cloud_column_height. Inject into gridbox at crater height (note model orography...)
      ;             2) elevation /= cloud_column_height, i,e. plume. Follow GOCART and inject into top 1/3 of plume height



     species_out_3d_daily_1year[model_lon_out,model_lat_out,  0  ,day_of_year_out]=so2[ii[i_event]]

    endfor ; loop over number of events in relevant year

   endif ;if year is within AeroCom-II dataset


   ; where data not available (pre-1979), apply continuous only emissions from Andreae and Kasgnoc, 2000.
    ; ancillary already available for this data?


   ;create new .nc file
   ; use 'date' and lon / lat attributes from MACCity input files
   ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/SO2_3D_volcanic_AeroComII'+'_'+strtrim(year,2)+'.nc',/CLOBBER)
   id = NCDF_CREATE(string(path_out)+'SO2_3D_volcanic_AeroComII'+'_'+strtrim(year,2)+'.nc',/CLOBBER)

   ;add global attributes
   NCDF_ATTPUT, id, 'Title', 'SO2 natural (volcanic) 3D emissions, from AeroComII',/char, /GLOBAL

   ;define dimensions of array
   lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
   lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
   levels_arr = NCDF_DIMDEF(id, 'levels', nlevels_out) ; Define the Z dimension
   date_arr = NCDF_DIMDEF(id, 't', ndaysinyear) ;define t dimension

   ;add variables and associated attributes
   lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
    NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
    NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char

   latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
    NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
    NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char

   levelsvid=NCDF_VARDEF(id, 'levels', [levels_arr],/LONG)
    NCDF_ATTPUT, id, levelsvid, 'name', 'level index',/char

   datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
    NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char

   datavid=NCDF_VARDEF( id, 'SO2_volcanic', [lon_arr,lat_arr,levels_arr,date_arr],/FLOAT)
    NCDF_ATTPUT, id, datavid, 'name', 'SO2 natural (volcanic) emissions',/char
    NCDF_ATTPUT, id, datavid, 'units', 'kg(S)/m2/s',/char

   ;put the NetCDF file into data mode:
   NCDF_CONTROL, id, /ENDEF

   ;put data into NetCDF file
   NCDF_VARPUT, id, lonvid, lon_out
   NCDF_VARPUT, id, latvid, lat_out
   NCDF_VARPUT, id, levelsvid, hybrid_ht
   NCDF_VARPUT, id, datevid, date_out_daily_1year
   NCDF_VARPUT, id, datavid, species_out_3d_daily_1year

   ;close NetCDF file
   NCDF_CLOSE, id

  endfor ; loop over each year - output file for each year

 endif ; ivolcanic eq 2

endif ;iSO2_3d








; ------------------------------ NH3 surface emissions -------------------------------------------

if (iNH3 eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_NH3_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=MACCity[*,*,*]
 
 ;read MACCity biomass burning file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/biomass_burning/MACCity_from_ECCAD/MACCity_biomassBurning_NH3_1960-2008.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 ;MACCity biomass burning data only goes up to 2008. Recyle 2008 for 2009 and 2010
 species[*,*,0:587] = species[*,*,0:587] + MACCity[*,*,0:587]
 species[*,*,588:599] = species[*,*,588:599] + MACCity[*,*,576:587] ; 2009
 species[*,*,600:611] = species[*,*,600:611] + MACCity[*,*,576:587] ; 2010

 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)
 




 ; read (natural) oceanic NH3 file provided by Nicolas Bellouin
 ocean_nh3 = fltarr(360, 180)
 openr, unit, '/nfs/foe-data-05_a73/earmtw/Data/emissions/NH3_from_Nicolas/nh3_davidlee/ocn-nh3.cej', /get_lun
 line=''
 readf, unit, line ; skip column headers
 while (not eof(unit)) do begin
  readf, unit, lon_nh3, lat_nh3, nh3
  ilon = fix(lon_nh3)
  ilat = fix(lat_nh3) +  90
  ocean_nh3[ilon, ilat] = nh3 ; kg[N]/gridbox/year
 endwhile
 free_lun, unit

 ; adjust units to kg(NH3)/m2/s
 restore,'/nfs/foe-data-05_a73/earmtw/Data/box_area_1x1deg.sav' ; gives box_area
 NtoNH3=17.0/14.0
 ocean_nh3[*,*] = ocean_nh3[*,*] / box_area[*,*] / (3600.0*24.0*365.0) * NtoNH3 ;kg(NH3)/m2/s

 ;regrid to N96
 ocean_nh3_n96=congrid(ocean_nh3,nlon_out,nlat_out,/center)

 ;apply emissions to all timesteps - no annual variability in data
 for i=0,nsteps-1 do begin
  species_out[*,*,i] = species_out[*,*,i] + ocean_nh3_n96[*,*]
 endfor




 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_NH3.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_NH3.nc',/CLOBBER)
  
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'NH3 surface emissions, MACCity (anthro + wildfire)',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'NH3_ems', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'NH3 surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(NH3)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif



; ------------------------------ BC fossil surface emissions -------------------------------------------

if (iBC_fossil eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_BC_transportation_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]
 
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_BC_energy_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_BC_solvents_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_BC_industries_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_BC_agric_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_BC_ships_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2) 
 
 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_BC_fossil.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_BC_fossil.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'BC fossil fuel surface emissions, MACCity (anthro)',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'BC_fossil_ems', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'BC fossil fuel surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(C)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif




; ------------------------------ BC biofuel surface emissions -------------------------------------------

if (iBC_biofuel eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_BC_residential_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_BC_agricwaste_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_BC_waste_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)

 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_BC_biofuel.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_BC_biofuel.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'BC biofuel surface emissions, MACCity (anthro)',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'BC_biofuel', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'BC biofuel emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(C)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif





; ------------------------------ BC biomass 3d emissions -------------------------------------------
; emissions distributed over lowermost boxes

if (iBC_biomass_3d eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 species_out_3d=fltarr(nlon_out,nlat_out,nlevels_out,nsteps)

 ;read MACCity biomass burning file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/biomass_burning/MACCity_from_ECCAD/MACCity_biomassBurning_BC_1960-2008.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 ;MACCity biomass burning data only goes up to 2008. Recyle 2008 for 2009 and 2010
 species[*,*,0:587] = species[*,*,0:587] + MACCity[*,*,0:587]
 species[*,*,588:599] = species[*,*,588:599] + MACCity[*,*,576:587] ; 2009
 species[*,*,600:611] = species[*,*,600:611] + MACCity[*,*,576:587] ; 2010

 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)

 ; distribute emissions vertically
 fraction=fltarr(nlevels_out)
 for ilevel=0, nlevels_out-1 do begin
  ; distribute uniformly over lowermost 3 km (level 19), as per Zak / Colin's approach.
  if (hybrid_ht[ilevel] le hybrid_ht[19]) then fraction[ilevel] = (d_ht[ilevel] / total(d_ht[0:19]))
  species_out_3d[*,*,ilevel,*] = species_out[*,*,*] * fraction[ilevel]
 endfor

 ;output yearly 3d field
 month1=0
 month12=11

 for year=1960,2010 do begin ; output 14 months in each file (i.e. include leading and tailing months for each year)
  ;create new .nc file
  ; use 'date' and lon / lat attributes from MACCity input files
 ;  id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_BC_biomass_'+strtrim(year,2)+'.nc',/CLOBBER)
  id = NCDF_CREATE(string(path_out)+'MACCity_BC_biomass_'+strtrim(year,2)+'.nc',/CLOBBER)
 
  ;add global attributes
  NCDF_ATTPUT, id, 'Title', 'BC biomass 3D emissions, from MACCity',/char, /GLOBAL
  
  ;define dimensions of array
  lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
  lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
  levels_arr = NCDF_DIMDEF(id, 'levels', nlevels_out) ; Define the Z dimension
  date_arr = NCDF_DIMDEF(id, 't', nsteps_in_year+2) ;define t dimension
 
  ;add variables and associated attributes
  lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
   NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
   NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
  
  latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
   NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
   NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
  
  levelsvid=NCDF_VARDEF(id, 'levels', [levels_arr],/LONG)
   NCDF_ATTPUT, id, levelsvid, 'name', 'level index',/char
  
  datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
   NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
  datavid=NCDF_VARDEF( id, 'BC_biomass', [lon_arr,lat_arr,levels_arr,date_arr],/FLOAT)
   NCDF_ATTPUT, id, datavid, 'name', 'BC biomass emissions',/char
   NCDF_ATTPUT, id, datavid, 'units', 'kg(C)/m2/s',/char
  
  ;put the NetCDF file into data mode:
  NCDF_CONTROL, id, /ENDEF
  
  ;put data into NetCDF file
  NCDF_VARPUT, id, lonvid, lon_out
  NCDF_VARPUT, id, latvid, lat_out
  NCDF_VARPUT, id, levelsvid, hybrid_ht
  ; add date:  
  date14=lonarr(14) ; 14 months per file including leading and tailing months
  date14[1:12] = date_out[month1+1:month12+1] ; 12 months of year in question
  date14[0] = date14[1] - 31 ; date of leading month
  date14[13] = date14[12] + 31 ; date of trailing month
  NCDF_VARPUT, id, datevid, date14
  ; add data:
  NCDF_VARPUT, id, datavid, offset=[0,0,0,1], species_out_3d[*,*,*,month1:month12] ; Jan to Dec of year in question

  if (month1 eq 0) then begin ; leading month
   NCDF_VARPUT, id, datavid, offset=[0,0,0,0], species_out_3d[*,*,*,month1] ; use current month if at start of time series
  endif else begin
   NCDF_VARPUT, id, datavid, offset=[0,0,0,0], species_out_3d[*,*,*,month1-1] ; use preceeding month if within time series
  endelse
  
  if (month12 eq nsteps-1) then begin ; tailing month
   NCDF_VARPUT, id, datavid, offset=[0,0,0,13], species_out_3d[*,*,*,month12] ; use current month if at end of time series
  endif else begin
   NCDF_VARPUT, id, datavid, offset=[0,0,0,13], species_out_3d[*,*,*,month12+1] ; use next month if within time series
  endelse
  
  ;close NetCDF file
  NCDF_CLOSE, id

  ;increment months
  month1=month1+12
  month12=month12+12

 endfor
 
endif




; ------------------------------ OC fossil surface emissions -------------------------------------------

if (iOC_fossil eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_OC_transportation_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]
 
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_OC_energy_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_OC_solvents_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_OC_industries_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_OC_agric_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_OC_ships_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2) 
 
 ;convert to OM
 species_out=species_out*1.4

 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_OC_fossil.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_OC_fossil.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'OC fossil fuel surface emissions, MACCity (anthro)',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'OC_fossil_ems', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'OC (as OM) fossil fuel surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(OM)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif




; ------------------------------ OC biofuel surface emissions -------------------------------------------

if (iOC_biofuel eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 
 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_OC_residential_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_OC_agricwaste_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;read MACCity anthropogenic file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/MACCity_ems_from_ECCAD/MACCity_anthro_OC_waste_1960-2010.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 species[*,*,*]=species[*,*,*]+MACCity[*,*,*]

 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)

 ;convert to OM
 species_out=species_out*1.4

 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_OC_biofuel.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'MACCity_OC_biofuel.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'OC biofuel surface emissions, MACCity (anthro)',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'OC_biofuel', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'OC (as OM) biofuel emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kg(OM)/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id
 
endif




; ------------------------------ OC biomass 3d emissions -------------------------------------------
; emissions distributed over lowermost boxes

if (iOC_biomass_3d eq 1 ) then begin

 species=fltarr(nlon_in,nlat_in,nsteps)
 species_out_3d=fltarr(nlon_out,nlat_out,nlevels_out,nsteps)

 ;read MACCity biomass burning file
 file1='/nfs/foe-data-05_a73/earmtw/Data/emissions/biomass_burning/MACCity_from_ECCAD/MACCity_biomassBurning_OC_1960-2008.nc'
 ncid = NCDF_OPEN(file1)            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, lon      ; Read in variable 'lon'
 NCDF_VARGET, ncid,  1, lat      ; Read in variable 'lat'
 NCDF_VARGET, ncid,  2, date      ; Read in variable 'date'
 NCDF_VARGET, ncid,  3, MACCity      ; Read in variable 'MACCity'
 NCDF_CLOSE, ncid      ; Close the NetCDF file
 ;MACCity biomass burning data only goes up to 2008. Recyle 2008 for 2009 and 2010
 species[*,*,0:587] = species[*,*,0:587] + MACCity[*,*,0:587]
 species[*,*,588:599] = species[*,*,588:599] + MACCity[*,*,576:587] ; 2009
 species[*,*,600:611] = species[*,*,600:611] + MACCity[*,*,576:587] ; 2010

 ;regrid to N96
 species_out=congrid(species,nlon_out,nlat_out,nsteps,/center)
 species_out=shift(species_out,96,0,0) ; shift array by 180 degrees to right
 species_out=reverse(species_out,2)

 ;convert to OM
 species_out=species_out*1.4

 ; distribute emissions vertically
 fraction=fltarr(nlevels_out)
 for ilevel=0, nlevels_out-1 do begin
  ; distribute uniformly over lowermost 3 km (level 19), as per Zak / Colin's approach.
  if (hybrid_ht[ilevel] le hybrid_ht[19]) then fraction[ilevel] = (d_ht[ilevel] / total(d_ht[0:19]))
  species_out_3d[*,*,ilevel,*] = species_out[*,*,*] * fraction[ilevel]
 endfor

 ;output yearly 3d field
 month1=0
 month12=11
 for year=1960,2010 do begin ; output 14 months in each file (i.e. include leading and tailing months for each year)

  ;create new .nc file
  ; use 'date' and lon / lat attributes from MACCity input files
  ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/MACCity_OC_biomass_'+strtrim(year,2)+'.nc',/CLOBBER)
  id = NCDF_CREATE(string(path_out)+'MACCity_OC_biomass_'+strtrim(year,2)+'.nc',/CLOBBER)
 
  ;add global attributes
  NCDF_ATTPUT, id, 'Title', 'OC biomass 3D emissions, from MACCity',/char, /GLOBAL
 
  ;define dimensions of array
  lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
  lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
  levels_arr = NCDF_DIMDEF(id, 'levels', nlevels_out) ; Define the Z dimension
  date_arr = NCDF_DIMDEF(id, 't', nsteps_in_year+2) ;define t dimension
 
  ;add variables and associated attributes
  lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
   NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
   NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
  
  latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
   NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
   NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
  
  levelsvid=NCDF_VARDEF(id, 'levels', [levels_arr],/LONG)
   NCDF_ATTPUT, id, levelsvid, 'name', 'level index',/char
  
  datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
   NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
  datavid=NCDF_VARDEF( id, 'OC_biomass', [lon_arr,lat_arr,levels_arr,date_arr],/FLOAT)
   NCDF_ATTPUT, id, datavid, 'name', 'OC (as OM) biomass emissions',/char
   NCDF_ATTPUT, id, datavid, 'units', 'kg(OM)/m2/s',/char
  
  ;put the NetCDF file into data mode:
  NCDF_CONTROL, id, /ENDEF
  
  ;put data into NetCDF file
  NCDF_VARPUT, id, lonvid, lon_out
  NCDF_VARPUT, id, latvid, lat_out
  NCDF_VARPUT, id, levelsvid, hybrid_ht
  ; add date:  
  date14=lonarr(14) ; 14 months per file including leading and tailing months
  date14[1:12] = date_out[month1+1:month12+1] ; 12 months of year in question
  date14[0] = date14[1] - 31 ; date of leading month
  date14[13] = date14[12] + 31 ; date of trailing month
  NCDF_VARPUT, id, datevid, date14
  ; add data:
  NCDF_VARPUT, id, datavid, offset=[0,0,0,1], species_out_3d[*,*,*,month1:month12] ; Jan to Dec of year in question

  if (month1 eq 0) then begin ; leading month
   NCDF_VARPUT, id, datavid, offset=[0,0,0,0], species_out_3d[*,*,*,month1] ; use current month if at start of time series
  endif else begin
   NCDF_VARPUT, id, datavid, offset=[0,0,0,0], species_out_3d[*,*,*,month1-1] ; use preceeding month if within time series
  endelse
  
  if (month12 eq nsteps-1) then begin ; tailing month
   NCDF_VARPUT, id, datavid, offset=[0,0,0,13], species_out_3d[*,*,*,month12] ; use current month if at end of time series
  endif else begin
   NCDF_VARPUT, id, datavid, offset=[0,0,0,13], species_out_3d[*,*,*,month12+1] ; use next month if within time series
  endelse
  
  ;close NetCDF file
  NCDF_CLOSE, id

  ;increment months
  month1=month1+12
  month12=month12+12

 endfor

endif



; ------------------------------ DMS land emissions -------------------------------------------
 ; taken from existing ancillary, and applied to full PEGASOS time range - repeating

if (iDMS_land eq 1) then begin

 ; open UM-sourced ancil, relevant for year 2000
 ncid = NCDF_OPEN('/nfs/foe-data-05_a73/earmtw/Data/UKCA_ancils/DMSland_ems_2000_N96.nc')            ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, longitude      ; Read in variable 'longitude'
 NCDF_VARGET, ncid,  1, latitude      ; Read in variable 'latitude'
 NCDF_VARGET, ncid,  2, surface      ; Read in variable 'surface'
 NCDF_VARGET, ncid,  3, t      ; Read in variable 't'
 NCDF_VARGET, ncid,  4, field570      ; Read in variable 'field570'
 NCDF_CLOSE, ncid      ; Close the NetCDF file

 species_out=fltarr(nlon_out,nlat_out,nsteps)
 for i=0,(nsteps/12) do species_out[*,*,(12*i)-12:(12*i)-1]=field570[*,*,0,0:11] ;loop over number of years and fill array

 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/DMS_land.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'DMS_land.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'DMS land surface emissions, from UM ancil',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'DMS_land', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'DMS land surface emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kgS/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id

endif





; ------------------------------ CH4 wetland emissions -------------------------------------------
 ; taken from existing ancillary, and applied to full PEGASOS time range - repeating

if (iCH4_wetland eq 1) then begin

 ; open UM-sourced ancil, relevant for year 2000
 ncid = NCDF_OPEN('/nfs/foe-data-05_a73/earmtw/Data/UKCA_ancils/Ch4_isop_monoterp_srf_2000_N96.nc')   ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, longitude      ; Read in variable 'longitude'
 NCDF_VARGET, ncid,  1, latitude      ; Read in variable 'latitude'
 NCDF_VARGET, ncid,  2, unspecified      ; Read in variable 'unspecified'
 NCDF_VARGET, ncid,  3, t      ; Read in variable 't'
 NCDF_VARGET, ncid,  4, field532      ; Read in variable 'field532'
 NCDF_VARGET, ncid,  5, surface      ; Read in variable 'surface'
 NCDF_VARGET, ncid,  6, field544      ; Read in variable 'field544'
 NCDF_VARGET, ncid,  7, field545      ; Read in variable 'field545'
 NCDF_CLOSE, ncid      ; Close the NetCDF file


 species_out=fltarr(nlon_out,nlat_out,nsteps)
 for i=0,(nsteps/12) do species_out[*,*,(12*i)-12:(12*i)-1]=field532[*,*,0,0:11] ;loop over number of years and fill array

 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/CH4_wetland.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'CH4_wetland.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'CH4 wetland surface emissions, from UM ancil',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'CH4_wetland', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'CH4 wetland emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kgC/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id

endif







; ------------------------------ isoprene emissions -------------------------------------------
 ; taken from existing ancillary, and applied to full PEGASOS time range - repeating

if (iisoprene eq 1) then begin

 ; open UM-sourced ancil, relevant for year 2000
 ncid = NCDF_OPEN('/nfs/foe-data-05_a73/earmtw/Data/UKCA_ancils/Ch4_isop_monoterp_srf_2000_N96.nc')   ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, longitude      ; Read in variable 'longitude'
 NCDF_VARGET, ncid,  1, latitude      ; Read in variable 'latitude'
 NCDF_VARGET, ncid,  2, unspecified      ; Read in variable 'unspecified'
 NCDF_VARGET, ncid,  3, t      ; Read in variable 't'
 NCDF_VARGET, ncid,  4, field532      ; Read in variable 'field532'
 NCDF_VARGET, ncid,  5, surface      ; Read in variable 'surface'
 NCDF_VARGET, ncid,  6, field544      ; Read in variable 'field544'
 NCDF_VARGET, ncid,  7, field545      ; Read in variable 'field545'
 NCDF_CLOSE, ncid      ; Close the NetCDF file


 species_out=fltarr(nlon_out,nlat_out,nsteps)
 for i=0,(nsteps/12) do species_out[*,*,(12*i)-12:(12*i)-1]=field544[*,*,0,0:11] ;loop over number of years and fill array

 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/isoprene.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'isoprene.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'Isoprene emissions, from UM ancil',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'Isoprene', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'Isoprene emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kgC/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id

endif







; ------------------------------ monoterpene emissions -------------------------------------------
 ; taken from existing ancillary, and applied to full PEGASOS time range - repeating

if (imonoterpene eq 1) then begin

 ; open UM-sourced ancil, relevant for year 2000
 ncid = NCDF_OPEN('/nfs/foe-data-05_a73/earmtw/Data/UKCA_ancils/Ch4_isop_monoterp_srf_2000_N96.nc')   ; Open The NetCDF file
 NCDF_VARGET, ncid,  0, longitude      ; Read in variable 'longitude'
 NCDF_VARGET, ncid,  1, latitude      ; Read in variable 'latitude'
 NCDF_VARGET, ncid,  2, unspecified      ; Read in variable 'unspecified'
 NCDF_VARGET, ncid,  3, t      ; Read in variable 't'
 NCDF_VARGET, ncid,  4, field532      ; Read in variable 'field532'
 NCDF_VARGET, ncid,  5, surface      ; Read in variable 'surface'
 NCDF_VARGET, ncid,  6, field544      ; Read in variable 'field544'
 NCDF_VARGET, ncid,  7, field545      ; Read in variable 'field545'
 NCDF_CLOSE, ncid      ; Close the NetCDF file


 species_out=fltarr(nlon_out,nlat_out,nsteps)
 for i=0,(nsteps/12) do species_out[*,*,(12*i)-12:(12*i)-1]=field545[*,*,0,0:11] ;loop over number of years and fill array

 ;create new .nc file
 ; use 'date' and lon / lat attributes from MACCity input files
 ; id = NCDF_CREATE('/nfs/foe-data-05_a73/earmtw/Data/emissions/PEGASOS/nc_for_ancil/monoterpene.nc',/CLOBBER)
 id = NCDF_CREATE(string(path_out)+'monoterpene.nc',/CLOBBER)
 
 ;add global attributes
 NCDF_ATTPUT, id, 'Title', 'Monoterpene emissions, from UM ancil',/char, /GLOBAL
 
 ;define dimensions of array
 lon_arr = NCDF_DIMDEF(id, 'longitude', nlon_out) ; Define the X dimension
 lat_arr = NCDF_DIMDEF(id, 'latitude', nlat_out) ; Define the Y dimension
 date_arr = NCDF_DIMDEF(id, 't', nsteps_out) ;define t dimension
 
 ;add variables and associated attributes
 lonvid=NCDF_VARDEF(id, 'longitude', [lon_arr],/FLOAT)
  NCDF_ATTPUT, id, lonvid, 'name', 'longitude',/char
  NCDF_ATTPUT, id, lonvid, 'units', 'degrees_east',/char
 
 latvid=NCDF_VARDEF(id, 'latitude', [lat_arr],/FLOAT)
  NCDF_ATTPUT, id, latvid, 'name', 'latitude',/char
  NCDF_ATTPUT, id, latvid, 'units', 'degrees_north',/char
 
 datevid=NCDF_VARDEF(id, 't', [date_arr],/FLOAT)
  NCDF_ATTPUT, id, datevid, 'units', 'days since 1960-01-01',/char
 
 datavid=NCDF_VARDEF( id, 'Monoterpene', [lon_arr,lat_arr,date_arr],/FLOAT)
  NCDF_ATTPUT, id, datavid, 'name', 'Monoterpene emissions',/char
  NCDF_ATTPUT, id, datavid, 'units', 'kgC/m2/s',/char
 
 ;put the NetCDF file into data mode:
 NCDF_CONTROL, id, /ENDEF
 
 ;put data into NetCDF file
 NCDF_VARPUT, id, lonvid, lon_out
 NCDF_VARPUT, id, latvid, lat_out
 NCDF_VARPUT, id, datevid, date_out
 NCDF_VARPUT, id, datavid, offset=[0,0,1], species_out[*,*,0:nsteps-1] ; add main data
 NCDF_VARPUT, id, datavid, offset=[0,0,0], species_out[*,*,0] ; add leading month - repeat first month
 NCDF_VARPUT, id, datavid, offset=[0,0,nsteps_out-1], species_out[*,*,nsteps-1] ; add tailing month - repeat final month
 
 ;close NetCDF file
 NCDF_CLOSE, id

endif


end
