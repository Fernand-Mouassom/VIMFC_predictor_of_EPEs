lat_S  = -5
lat_N  =  5
lon_W  =  5
lon_E  =  35
;seas = (/"MAM","SON"/)

;---------------- open and read
;---------------- open and read
;---------------- open and read



      guess     = 1                ; use zonal means
      is_cyclic = True             ; cyclic [global]
      nscan     = 1500             ; usually much less than this
      eps       = 1.e-2            ; variable dependent
      relc      = 0.6              ; relaxation coefficient
      opt       = 0                ; not used


      fera5_u   = addfile("/home/owner/Documents/Memorial_Project/Project_2/data/CA_1984-2023_daily_u.nc","r")
             u_era5  = dble2flt(fera5_u->u(:, {1000:500},  {lat_S:lat_N}, {lon_W:lon_E}))
             poisson_grid_fill( u_era5, is_cyclic, guess, nscan, eps, relc, opt)

      fps_era5  = addfile("/home/owner/Documents/Memorial_Project/Project_2/data/CA_1984-2023_daily_sp.nc","r")
             ps_era5 = dble2flt(fps_era5->sp(:, {lat_S:lat_N}, {lon_W:lon_E}))

   u_era5!0 = "time"
   u_era5!1 = "lev"
   u_era5!2 = "lat"
   u_era5!3 = "lon"

   ps_era5!0 = "time"
   ps_era5!1 = "lat"
   ps_era5!2 = "lon"


   p_era5 = (/100*(u_era5&lev )/)


   u_lat_mean_era5  = dim_avg_n_Wrap(u_era5(:,::-1,:,:),2)

   stream_func_era5 = new(dimsizes(u_lat_mean_era5), float)

   g     = 9.80655          ; gravitational constant.
   Rt    = 6.37122e06       ; radius of the earth 6378388
   PI    = 3.14159265358979

  p_era5@units = "Pa"            ; Pa   =  kg/(m s2) (Pascal)

  dp_era5          = dpres_plevel_Wrap(p_era5, ps_era5 , min(p_era5), 0)

  dp_lat_mean_era5 = dim_avg_n_Wrap(dp_era5(:,::-1,:,:),2)

  do k =  0, dimsizes(p_era5)-1

      stream_func_era5(:,k,:) = ( ( 2*PI*Rt )/g )*wgt_vertical_n( u_lat_mean_era5(:, k:dimsizes(p_era5)-1, :), -dp_lat_mean_era5(:, k:dimsizes(p_era5)-1, :), 1, 1)*10e-11

  end do

  copy_VarCoords(u_lat_mean_era5, stream_func_era5)


f = addfile("/home/owner/Documents/Memorial_Project/Project_2/data/stream_func_eqq.nc","c")

f->siz     = stream_func_era5 ;(time|:, level|:,longitude|:)
f->u     = u_lat_mean_era5 ;(time|:, level|:,longitude|:)
